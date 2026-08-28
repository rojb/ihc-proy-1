import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// FR-07 · Identificación liviana.
///
/// Se genera un identificador al primer uso y se guarda en el dispositivo. No
/// hay registro, correo ni dato personal: su único fin es no contar dos veces
/// a la misma persona en el contador de interés.
///
/// Límite conocido y aceptado (riesgo R-6 del PRD): reinstalar la app o cambiar
/// de dispositivo genera un identificador nuevo, así que el contador se puede
/// inflar. En un MVP evaluado en laboratorio no importa; en producción sí.
class DeviceIdentity {
  static const String _storageKey = 'device_id';

  static Future<String> loadOrCreate() async {
    final prefs = await SharedPreferences.getInstance();

    final String? existing = prefs.getString(_storageKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final String created = const Uuid().v4();
    await prefs.setString(_storageKey, created);
    return created;
  }
}
