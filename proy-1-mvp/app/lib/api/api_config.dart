import 'package:flutter/foundation.dart';

/// Dónde vive la API según dónde corre la app.
///
/// El emulador de Android no ve `localhost` del equipo anfitrión: lo expone en
/// 10.0.2.2. Para un dispositivo físico hay que pasar la IP de la máquina:
///
///     flutter run --dart-define=API_BASE_URL=http://192.168.0.10:3000/api
String resolveApiBaseUrl() {
  const fromEnvironment = String.fromEnvironment('API_BASE_URL');
  if (fromEnvironment.isNotEmpty) {
    return fromEnvironment;
  }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:3000/api';
  }

  return 'http://localhost:3000/api';
}

/// FR-06 · Enlace que viaja en el mensaje compartido.
///
/// Es un marcador de posición: el MVP corre con datos de prueba y todavía no
/// tiene dominio propio (PRD §9). Lo que se evalúa es que el mensaje llegue
/// completo al grupo, no que el enlace resuelva.
const String kEventLinkBase = 'https://eventos-scz.app/e';
