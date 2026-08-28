import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'api/api_client.dart';
import 'device_identity.dart';
import 'state/events_controller.dart';
import 'state/organizer_controller.dart';
import 'ui/events_list_page.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fechas en español antes de que se pinte la primera pantalla.
  await initializeDateFormatting('es');

  // FR-07 · El identificador se genera al primer uso, sin registro ni onboarding.
  // Es lo único que la app necesita saber de la persona para arrancar.
  final String deviceId = await DeviceIdentity.loadOrCreate();

  runApp(EventosApp(deviceId: deviceId));
}

class EventosApp extends StatelessWidget {
  const EventosApp({super.key, required this.deviceId});

  final String deviceId;

  @override
  Widget build(BuildContext context) {
    final ApiClient api = ApiClient(deviceId: deviceId);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventsController>(
          create: (_) => EventsController(api: api),
        ),
        ChangeNotifierProvider<OrganizerController>(
          create: (_) => OrganizerController(api: api),
        ),
      ],
      child: MaterialApp(
        title: 'Eventos Santa Cruz',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        locale: const Locale('es'),
        supportedLocales: const <Locale>[Locale('es'), Locale('en')],
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (BuildContext context, Widget? child) {
          // NFR de accesibilidad · legible hasta 200 % sin recortes. Se acota
          // ahí y no antes: por debajo de ese tope la app tiene que escalar.
          final MediaQueryData media = MediaQuery.of(context);
          return MediaQuery(
            data: media.copyWith(
              textScaler: media.textScaler.clamp(maxScaleFactor: 2.0),
            ),
            child: child!,
          );
        },
        // FR-01 · La lista es lo primero que se ve.
        home: const EventsListPage(),
      ),
    );
  }
}
