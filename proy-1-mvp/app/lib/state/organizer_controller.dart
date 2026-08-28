import 'package:flutter/foundation.dart';

import '../api/api_client.dart';
import '../api/event.dart';

/// FR-10 a FR-12 · Lo que el organizador puede hacer: publicar, editar,
/// cancelar y ver cuánta gente marcó interés en cada evento suyo.
class OrganizerController extends ChangeNotifier {
  OrganizerController({required this.api});

  final ApiClient api;

  List<Event> items = <Event>[];
  bool loading = false;
  String? error;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final EventPage page = await api.myEvents();
      items = page.items;
    } on OfflineException {
      error = 'Sin conexión. No se pudieron cargar tus eventos.';
    } on ApiException catch (exception) {
      error = exception.message;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Devuelve `null` si salió bien, o el mensaje de error para mostrar.
  Future<String?> publish(Map<String, dynamic> body) =>
      _write(() => api.createEvent(body));

  Future<String?> edit(String id, Map<String, dynamic> body) =>
      _write(() => api.updateEvent(id, body));

  Future<String?> cancel(String id) => _write(() => api.cancelEvent(id));

  Future<String?> _write(Future<Event> Function() action) async {
    try {
      await action();
      await load();
      return null;
    } on OfflineException {
      // Publicar sí necesita servidor: a diferencia de "Me interesa", encolar
      // un evento sin confirmar dejaría al organizador creyendo que publicó.
      return 'Sin conexión. Volvé a intentar cuando tengas señal.';
    } on ApiException catch (exception) {
      return exception.message;
    }
  }
}
