import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';
import '../api/event.dart';

/// Estado de la lista de eventos: filtros, resultados, caché y cola de interés.
///
/// Es un ChangeNotifier y no algo más elaborado porque el MVP no lo necesita:
/// hay una lista, unos filtros y una acción. Meter capas acá sería costo sin
/// beneficio.
class EventsController extends ChangeNotifier {
  EventsController({required this.api});

  final ApiClient api;

  static const String _cacheKey = 'cached_events';
  static const String _cacheStampKey = 'cached_events_at';
  static const String _pendingKey = 'pending_interest';

  EventFilters filters = const EventFilters();
  List<Event> items = <Event>[];
  int count = 0;
  bool loading = false;
  String? error;

  /// NFR de red inestable · lo que se ve salió de la caché, no del servidor.
  bool servedFromCache = false;
  DateTime? cachedAt;

  /// FR-08 offline · marcas que todavía no llegaron al servidor.
  /// eventId -> si la persona quiere quedar marcada o no.
  final Map<String, bool> _pendingInterest = <String, bool>{};

  bool get hasPendingInterest => _pendingInterest.isNotEmpty;
  bool isPending(String eventId) => _pendingInterest.containsKey(eventId);

  Future<void> initialise() async {
    await _loadPendingFromDisk();
    await load();
  }

  /// FR-01 · Carga la lista. Ante un fallo de red recurre a lo último cargado
  /// en vez de mostrar una pantalla de error: el contenido ya visto tiene que
  /// seguir siendo recorrible sin conexión.
  Future<void> load({bool showSpinner = true}) async {
    if (showSpinner) {
      loading = true;
      error = null;
      notifyListeners();
    }

    try {
      await _flushPendingInterest();

      final EventPage page = await api.listEvents(filters);
      items = page.items;
      count = page.count;
      servedFromCache = false;
      error = null;

      // Solo se cachea la lista sin filtros: es la que se muestra al volver
      // sin conexión, y guardar una lista filtrada haría creer que eso es todo
      // lo que hay.
      if (filters.isEmpty) {
        await _saveCache(page.items);
      }
    } on OfflineException {
      final bool recovered = await _loadCache();
      error = recovered
          ? null
          : 'Sin conexión y todavía no hay nada guardado. Probá de nuevo cuando tengas señal.';
    } on ApiException catch (exception) {
      error = exception.message;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // --- Filtros (FR-04) ---------------------------------------------------

  Future<void> setWhen(String? when) =>
      _applyFilters(filters.copyWith(when: when));

  Future<void> setMaxPriceCents(int? maxPriceCents) =>
      _applyFilters(filters.copyWith(maxPriceCents: maxPriceCents));

  Future<void> setZone(String? zone) =>
      _applyFilters(filters.copyWith(zone: zone));

  Future<void> setNear(String? zone, double? radiusKm) =>
      _applyFilters(filters.copyWith(nearZone: zone, radiusKm: radiusKm));

  /// FR-04 · Reversible en un toque.
  Future<void> clearFilters() => _applyFilters(const EventFilters());

  Future<void> _applyFilters(EventFilters next) {
    filters = next;
    notifyListeners();
    return load();
  }

  // --- Interés (FR-08 / FR-09) -------------------------------------------

  /// Marca o desmarca interés. La llama el detalle, no la tarjeta: FR-08 pone
  /// la acción en el detalle porque marcar interés supone haber verificado los
  /// datos, y en la tarjeta la señal se abarata.
  ///
  /// Sin red la marca queda encolada y se devuelve igual el estado que la
  /// persona quiso: el toque tiene que verse aplicado, con su aviso de que
  /// todavía no se sincronizó.
  Future<InterestState> setInterest(
    String eventId,
    bool wanted, {
    required int currentCount,
  }) async {
    try {
      final InterestState state = wanted
          ? await api.markInterest(eventId)
          : await api.removeInterest(eventId);

      _pendingInterest.remove(eventId);
      await _savePendingToDisk();
      _syncListItem(state);
      notifyListeners();
      return state;
    } on OfflineException {
      _pendingInterest[eventId] = wanted;
      await _savePendingToDisk();

      final InterestState optimistic = InterestState(
        eventId: eventId,
        interestCount: currentCount + (wanted ? 1 : -1),
        interested: wanted,
      );
      _syncListItem(optimistic);
      notifyListeners();
      return optimistic;
    }
  }

  /// Mantiene la lista al día para que el contador no cambie al volver atrás.
  void _syncListItem(InterestState state) {
    final int index =
        items.indexWhere((Event event) => event.id == state.eventId);
    if (index == -1) {
      return;
    }

    items[index] = items[index].copyWith(
      interested: state.interested,
      interestCount: state.interestCount,
    );
  }

  /// Reintenta las marcas encoladas. Si sigue sin haber red, quedan para la
  /// próxima: no se pierden ni se avisa dos veces.
  Future<void> _flushPendingInterest() async {
    if (_pendingInterest.isEmpty) {
      return;
    }

    final Map<String, bool> queue = Map<String, bool>.from(_pendingInterest);

    for (final MapEntry<String, bool> entry in queue.entries) {
      try {
        if (entry.value) {
          await api.markInterest(entry.key);
        } else {
          await api.removeInterest(entry.key);
        }
        _pendingInterest.remove(entry.key);
      } on OfflineException {
        return;
      } on ApiException {
        // El evento ya no existe o fue rechazado: se descarta la marca.
        _pendingInterest.remove(entry.key);
      }
    }

    await _savePendingToDisk();
  }

  // --- Persistencia local -------------------------------------------------

  Future<void> _saveCache(List<Event> events) async {
    final prefs = await SharedPreferences.getInstance();
    final String payload = jsonEncode(
      events.map((Event event) => event.toJson()).toList(),
    );
    await prefs.setString(_cacheKey, payload);
    await prefs.setString(_cacheStampKey, DateTime.now().toIso8601String());
  }

  Future<bool> _loadCache() async {
    final prefs = await SharedPreferences.getInstance();
    final String? payload = prefs.getString(_cacheKey);
    if (payload == null) {
      return false;
    }

    final List<dynamic> raw = jsonDecode(payload) as List<dynamic>;
    items = raw
        .map((dynamic item) => Event.fromJson(item as Map<String, dynamic>))
        .toList();
    count = items.length;
    servedFromCache = true;

    final String? stamp = prefs.getString(_cacheStampKey);
    cachedAt = stamp == null ? null : DateTime.tryParse(stamp);

    return true;
  }

  Future<void> _loadPendingFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final String? payload = prefs.getString(_pendingKey);
    if (payload == null) {
      return;
    }

    final Map<String, dynamic> raw =
        jsonDecode(payload) as Map<String, dynamic>;
    _pendingInterest
      ..clear()
      ..addAll(raw.map((String key, dynamic value) =>
          MapEntry<String, bool>(key, value as bool)));
  }

  Future<void> _savePendingToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pendingKey, jsonEncode(_pendingInterest));
  }
}
