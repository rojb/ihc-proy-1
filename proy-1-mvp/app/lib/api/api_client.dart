import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'event.dart';
import 'zones.dart';

/// La API respondió, pero con un error. El mensaje ya viene redactado para
/// mostrarse: el backend escribe los errores en español.
class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// No hubo respuesta. Es el caso que el NFR de red inestable obliga a tratar
/// distinto: acá se recurre a la caché en vez de mostrar un error.
class OfflineException implements Exception {
  const OfflineException();

  @override
  String toString() => 'Sin conexión';
}

/// Filtros de la lista (FR-04). Todos opcionales y combinables.
class EventFilters {
  const EventFilters({
    this.when,
    this.maxPriceCents,
    this.zone,
    this.nearZone,
    this.radiusKm,
  });

  /// 'today' u 'weekend'.
  final String? when;
  final int? maxPriceCents;
  final String? zone;

  /// Zona desde la que se mide la distancia (reemplaza al GPS, ver zones.dart).
  final String? nearZone;
  final double? radiusKm;

  bool get isEmpty =>
      when == null && maxPriceCents == null && zone == null && nearZone == null;

  EventFilters copyWith({
    Object? when = _unset,
    Object? maxPriceCents = _unset,
    Object? zone = _unset,
    Object? nearZone = _unset,
    Object? radiusKm = _unset,
  }) {
    return EventFilters(
      when: when == _unset ? this.when : when as String?,
      maxPriceCents:
          maxPriceCents == _unset ? this.maxPriceCents : maxPriceCents as int?,
      zone: zone == _unset ? this.zone : zone as String?,
      nearZone: nearZone == _unset ? this.nearZone : nearZone as String?,
      radiusKm: radiusKm == _unset ? this.radiusKm : radiusKm as double?,
    );
  }

  static const Object _unset = Object();
}

/// Único punto de la app que habla HTTP.
///
/// Las pantallas nunca arman una URL ni leen un JSON: si el contrato cambia,
/// se toca este archivo y `event.dart`, no doce widgets.
class ApiClient {
  ApiClient({required this.deviceId, String? baseUrl, http.Client? httpClient})
      : baseUrl = baseUrl ?? resolveApiBaseUrl(),
        _http = httpClient ?? http.Client();

  final String baseUrl;

  /// FR-07 · Viaja en cada pedido. Es todo lo que la app sabe de la persona.
  final String deviceId;

  final http.Client _http;

  Map<String, String> get _headers => <String, String>{
        'X-Device-Id': deviceId,
        'Content-Type': 'application/json',
      };

  Future<EventPage> listEvents(EventFilters filters) async {
    final Map<String, String> query = <String, String>{};

    if (filters.when != null) {
      query['when'] = filters.when!;
    }
    if (filters.maxPriceCents != null) {
      query['maxPriceCents'] = filters.maxPriceCents.toString();
    }
    if (filters.zone != null) {
      query['zone'] = filters.zone!;
    }

    final center = filters.nearZone == null ? null : kZoneCenterOf(filters.nearZone!);
    if (center != null && filters.radiusKm != null) {
      query['latitude'] = center.latitude.toString();
      query['longitude'] = center.longitude.toString();
      query['radiusKm'] = filters.radiusKm.toString();
    }

    final json = await _get('/events', query) as Map<String, dynamic>;
    return EventPage.fromJson(json);
  }

  Future<Event> getEvent(String id) async {
    final json = await _get('/events/$id', const <String, String>{})
        as Map<String, dynamic>;
    return Event.fromJson(json);
  }

  /// FR-11 · Los eventos de este dispositivo, con su número de interesados.
  Future<EventPage> myEvents() async {
    final json = await _get('/events/mine', const <String, String>{})
        as Map<String, dynamic>;
    return EventPage.fromJson(json);
  }

  /// FR-08 · Marcar es idempotente; el servidor no cuenta dos veces.
  Future<InterestState> markInterest(String eventId) async {
    final json = await _send('PUT', '/events/$eventId/interest')
        as Map<String, dynamic>;
    return InterestState.fromJson(json);
  }

  Future<InterestState> removeInterest(String eventId) async {
    final json = await _send('DELETE', '/events/$eventId/interest')
        as Map<String, dynamic>;
    return InterestState.fromJson(json);
  }

  /// FR-10 · Publicar.
  Future<Event> createEvent(Map<String, dynamic> body) async {
    final json = await _send('POST', '/events', body) as Map<String, dynamic>;
    return Event.fromJson(json);
  }

  /// FR-12 · Editar.
  Future<Event> updateEvent(String id, Map<String, dynamic> body) async {
    final json =
        await _send('PATCH', '/events/$id', body) as Map<String, dynamic>;
    return Event.fromJson(json);
  }

  /// FR-12 · Cancelar marca el evento; no lo borra.
  Future<Event> cancelEvent(String id) async {
    final json =
        await _send('POST', '/events/$id/cancel') as Map<String, dynamic>;
    return Event.fromJson(json);
  }

  Future<Object?> _get(String path, Map<String, String> query) async {
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: query.isEmpty ? null : query,
    );

    try {
      final response = await _http.get(uri, headers: _headers);
      return _decode(response);
    } on ApiException {
      rethrow;
    } catch (_) {
      // Todo lo que no sea una respuesta de la API se trata como falta de red.
      // No se discrimina por tipo a propósito: dart:io no existe en web y el
      // NFR de red inestable solo necesita saber si hay respuesta o no.
      throw const OfflineException();
    }
  }

  Future<Object?> _send(
    String method,
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    final uri = Uri.parse('$baseUrl$path');
    final request = http.Request(method, uri)..headers.addAll(_headers);
    if (body != null) {
      request.body = jsonEncode(body);
    }

    try {
      final streamed = await _http.send(request);
      final response = await http.Response.fromStream(streamed);
      return _decode(response);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const OfflineException();
    }
  }

  Object? _decode(http.Response response) {
    final Object? payload =
        response.body.isEmpty ? null : jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return payload;
    }

    throw ApiException(_messageOf(payload, response.statusCode));
  }

  String _messageOf(Object? payload, int statusCode) {
    if (payload is Map<String, dynamic>) {
      final Object? message = payload['message'];
      if (message is String) {
        return message;
      }
      // class-validator devuelve una lista con un mensaje por campo.
      if (message is List && message.isNotEmpty) {
        return message.join('\n');
      }
    }
    return 'No se pudo completar la operación (error $statusCode).';
  }
}
