/// FR-03 · Los tres estados que la tarjeta tiene que poder mostrar.
enum Validity {
  vigente,
  actualizadoReciente,
  cancelado;

  static Validity parse(String raw) {
    switch (raw) {
      case 'CANCELADO':
        return Validity.cancelado;
      case 'ACTUALIZADO_RECIENTE':
        return Validity.actualizadoReciente;
      default:
        return Validity.vigente;
    }
  }
}

/// Un evento tal como lo devuelve la API.
///
/// Es el único lugar de la app que conoce la forma del JSON. Las pantallas
/// hablan con esta clase, así que cambiar un campo del contrato se arregla acá
/// y no en cada widget.
class Event {
  const Event({
    required this.id,
    required this.name,
    required this.startsAt,
    required this.priceCents,
    required this.currency,
    required this.isFree,
    required this.locationName,
    required this.zone,
    required this.validity,
    required this.interestCount,
    required this.interested,
    this.description,
    this.endsAt,
    this.reference,
    this.latitude,
    this.longitude,
    this.imageUrl,
    this.lastEditedAt,
    this.distanceKm,
  });

  final String id;
  final String name;
  final String? description;
  final DateTime startsAt;
  final DateTime? endsAt;
  final int priceCents;
  final String currency;
  final bool isFree;
  final String locationName;
  final String? reference;
  final String zone;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;
  final Validity validity;
  final DateTime? lastEditedAt;
  final int interestCount;
  final bool interested;
  final double? distanceKm;

  bool get hasCoordinates => latitude != null && longitude != null;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      startsAt: DateTime.parse(json['startsAt'] as String).toLocal(),
      endsAt: json['endsAt'] == null
          ? null
          : DateTime.parse(json['endsAt'] as String).toLocal(),
      priceCents: json['priceCents'] as int,
      currency: json['currency'] as String,
      isFree: json['isFree'] as bool,
      locationName: json['locationName'] as String,
      reference: json['reference'] as String?,
      zone: json['zone'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
      validity: Validity.parse(json['validity'] as String),
      lastEditedAt: json['lastEditedAt'] == null
          ? null
          : DateTime.parse(json['lastEditedAt'] as String).toLocal(),
      interestCount: json['interestCount'] as int,
      interested: json['interested'] as bool,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
    );
  }

  /// Se guarda tal cual para la caché offline (NFR de red inestable).
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'startsAt': startsAt.toUtc().toIso8601String(),
        'endsAt': endsAt?.toUtc().toIso8601String(),
        'priceCents': priceCents,
        'currency': currency,
        'isFree': isFree,
        'locationName': locationName,
        'reference': reference,
        'zone': zone,
        'latitude': latitude,
        'longitude': longitude,
        'imageUrl': imageUrl,
        'validity': switch (validity) {
          Validity.cancelado => 'CANCELADO',
          Validity.actualizadoReciente => 'ACTUALIZADO_RECIENTE',
          Validity.vigente => 'VIGENTE',
        },
        'lastEditedAt': lastEditedAt?.toUtc().toIso8601String(),
        'interestCount': interestCount,
        'interested': interested,
        'distanceKm': distanceKm,
      };

  /// Para pintar el cambio de "Me interesa" antes de que responda el servidor.
  Event copyWith({int? interestCount, bool? interested}) {
    return Event(
      id: id,
      name: name,
      description: description,
      startsAt: startsAt,
      endsAt: endsAt,
      priceCents: priceCents,
      currency: currency,
      isFree: isFree,
      locationName: locationName,
      reference: reference,
      zone: zone,
      latitude: latitude,
      longitude: longitude,
      imageUrl: imageUrl,
      validity: validity,
      lastEditedAt: lastEditedAt,
      interestCount: interestCount ?? this.interestCount,
      interested: interested ?? this.interested,
      distanceKm: distanceKm,
    );
  }
}

/// Respuesta de lista: FR-04 pide que el número de resultados sea visible.
class EventPage {
  const EventPage({required this.count, required this.items});

  final int count;
  final List<Event> items;

  factory EventPage.fromJson(Map<String, dynamic> json) {
    return EventPage(
      count: json['count'] as int,
      items: (json['items'] as List<dynamic>)
          .map((dynamic item) => Event.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// FR-09 · Lo que devuelve marcar o desmarcar interés: siempre un número.
class InterestState {
  const InterestState({
    required this.eventId,
    required this.interestCount,
    required this.interested,
  });

  final String eventId;
  final int interestCount;
  final bool interested;

  factory InterestState.fromJson(Map<String, dynamic> json) {
    return InterestState(
      eventId: json['eventId'] as String,
      interestCount: json['interestCount'] as int,
      interested: json['interested'] as bool,
    );
  }
}
