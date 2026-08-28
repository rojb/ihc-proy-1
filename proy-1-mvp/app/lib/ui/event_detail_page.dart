import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api_client.dart';
import '../api/event.dart';
import '../share_message.dart';
import '../state/events_controller.dart';
import 'format.dart';
import 'spacing.dart';
import 'theme.dart';
import 'widgets/anillos_glyph.dart';
import 'widgets/validity_badge.dart';

/// FR-05 · Detalle del evento, con las dos acciones que cierran la tarea:
/// marcar interés (FR-08) y compartir al grupo (FR-06).
class EventDetailPage extends StatefulWidget {
  const EventDetailPage({super.key, required this.eventId});

  final String eventId;

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  Event? _event;
  String? _error;
  bool _loading = true;
  bool _togglingInterest = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ApiClient api = context.read<EventsController>().api;

    try {
      final Event event = await api.getEvent(widget.eventId);
      if (!mounted) return;
      setState(() {
        _event = event;
        _loading = false;
      });
    } on OfflineException {
      // El contenido ya cargado tiene que seguir siendo recorrible sin
      // conexión: se cae a la copia que la lista tiene en memoria.
      final EventsController controller = context.read<EventsController>();
      final int index = controller.items
          .indexWhere((Event event) => event.id == widget.eventId);

      if (!mounted) return;
      setState(() {
        _loading = false;
        if (index == -1) {
          _error = 'Sin conexión y este evento no está guardado.';
        } else {
          _event = controller.items[index];
        }
      });
    } on ApiException catch (exception) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = exception.message;
      });
    }
  }

  Future<void> _toggleInterest() async {
    final Event? event = _event;
    if (event == null || _togglingInterest) {
      return;
    }

    setState(() => _togglingInterest = true);

    try {
      final InterestState state =
          await context.read<EventsController>().setInterest(
                event.id,
                !event.interested,
                currentCount: event.interestCount,
              );

      if (!mounted) return;
      setState(() {
        _event = event.copyWith(
          interested: state.interested,
          interestCount: state.interestCount,
        );
      });
    } on ApiException catch (exception) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(exception.message)),
      );
    } finally {
      if (mounted) {
        setState(() => _togglingInterest = false);
      }
    }
  }

  /// FR-06 · Un toque abre el share sheet nativo con el mensaje ya armado.
  /// La persona no escribe ni copia nada.
  Future<void> _share() async {
    final Event? event = _event;
    if (event == null) return;

    await Share.share(
      buildShareMessage(event),
      subject: event.name,
    );
  }

  /// FR-05 · El mapa se delega a la app externa del dispositivo. La app no
  /// dibuja mapas ni navega: FR-W08 lo deja fuera a propósito.
  Future<void> _openMap() async {
    final Event? event = _event;
    if (event == null) return;

    // El esquema geo: es lo que abre la app de mapas nativa, pero un navegador
    // no sabe qué hacer con él: en web hay que caer siempre a una URL http.
    final Uri uri;
    if (event.hasCoordinates && !kIsWeb) {
      uri = Uri.parse(
        'geo:${event.latitude},${event.longitude}'
        '?q=${event.latitude},${event.longitude}'
        '(${Uri.encodeComponent(event.locationName)})',
      );
    } else if (event.hasCoordinates) {
      uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1'
        '&query=${event.latitude},${event.longitude}',
      );
    } else {
      uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1'
        '&query=${Uri.encodeComponent('${event.locationName}, Santa Cruz de la Sierra')}',
      );
    }

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la app de mapas.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final EventsController controller = context.watch<EventsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle')),
      body: _buildBody(),
      bottomNavigationBar: _event == null
          ? null
          : _ActionBar(
              event: _event!,
              busy: _togglingInterest,
              pending: controller.isPending(_event!.id),
              onInterest: _toggleInterest,
              onShare: _share,
            ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s4),
          child: Text(_error!, textAlign: TextAlign.center),
        ),
      );
    }

    final Event event = _event!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s2,
        AppSpacing.s1,
        AppSpacing.s2,
        AppSpacing.s3,
      ),
      children: <Widget>[
        ValidityBadge(validity: event.validity),
        const SizedBox(height: AppSpacing.s1),
        Text(
          event.name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        const SizedBox(height: AppSpacing.s3),

        // Los cuatro datos, juntos y en el mismo orden que en la tarjeta.
        // Es lo que se copia al mensaje del grupo (KR5).
        _DataRow(
          icon: Icons.calendar_today_outlined,
          label: 'Cuándo',
          value: formatFullDayTime(event.startsAt),
        ),
        _DataRow(
          icon: Icons.sell_outlined,
          label: 'Precio',
          value: formatPrice(event),
          emphasise: true,
        ),
        _DataRow(
          icon: Icons.place_outlined,
          label: 'Dónde',
          value: <String?>[
            event.locationName,
            event.zone,
            formatDistance(event.distanceKm).isEmpty
                ? null
                : 'a ${formatDistance(event.distanceKm)}',
          ].whereType<String>().join(' · '),
        ),
        if (event.reference != null && event.reference!.isNotEmpty)
          _DataRow(
            icon: Icons.explore_outlined,
            label: 'Cómo ubicarlo',
            value: event.reference!,
          ),

        if (event.lastEditedAt != null) ...<Widget>[
          const SizedBox(height: AppSpacing.half),
          Text(
            // FR-14 · el sello de cuándo cambió, para que "actualizado" no sea
            // una etiqueta sin fecha.
            'Actualizado ${formatTimeAgo(event.lastEditedAt!)}',
            style: const TextStyle(color: AppColors.amber, fontSize: 13),
          ),
        ],

        const SizedBox(height: AppSpacing.s3),
        OutlinedButton.icon(
          onPressed: _openMap,
          icon: const Icon(Icons.map_outlined),
          label: const Text('Ver en el mapa'),
        ),

        if (event.description != null && event.description!.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.s3),
          Text(event.description!, style: const TextStyle(fontSize: 15, height: 1.45)),
        ],

        const SizedBox(height: AppSpacing.s3),
        _InterestSummary(event: event),
      ],
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.icon,
    required this.label,
    required this.value,
    this.emphasise = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool emphasise;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 20, color: AppColors.inkSoft),
          const SizedBox(width: AppSpacing.s1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: AppSpacing.half),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: emphasise ? 22 : 16,
                    fontWeight: emphasise ? FontWeight.w700 : FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// FR-09 + FR-13 · El contador con su explicación al lado.
///
/// La leyenda no es adorno: el riesgo R-3 del PRD es que "Me interesa" se lea
/// como "Voy" y el organizador dimensione mal la convocatoria. Decirlo una vez,
/// donde se toma la decisión, es la mitigación.
class _InterestSummary extends StatelessWidget {
  const _InterestSummary({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s2),
      decoration: BoxDecoration(
        color: AppColors.greenSoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const AnillosGlyph(size: 18),
          const SizedBox(width: AppSpacing.s1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${event.interestCount} personas marcaron interés',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.green,
                  ),
                ),
                const SizedBox(height: AppSpacing.half),
                const Text(
                  'Marcar interés no confirma que vas a asistir, y podés '
                  'sacarlo cuando quieras.',
                  style: TextStyle(fontSize: 13, height: 1.35, color: AppColors.ink),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// NFR de uso a una mano · las dos acciones primarias, en el tercio inferior.
class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.event,
    required this.busy,
    required this.pending,
    required this.onInterest,
    required this.onShare,
  });

  final Event event;
  final bool busy;
  final bool pending;
  final VoidCallback onInterest;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s2,
          AppSpacing.s1,
          AppSpacing.s2,
          AppSpacing.s1,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (pending)
              const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.s1),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.cloud_off, size: 16, color: AppColors.amber),
                    SizedBox(width: AppSpacing.s1),
                    Text(
                      'Pendiente de sincronizar',
                      style: TextStyle(
                        color: AppColors.amber,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: <Widget>[
                Expanded(
                  // FR-13 · nunca dice "Voy" ni "Asistiré": la app no puede
                  // verificar asistencia y prometerlo rompe la confianza.
                  // El estado marcado se ve (ícono y fondo) y se dice en voz
                  // alta para lector de pantalla, junto con cómo revertirlo.
                  child: Semantics(
                    button: true,
                    label: event.interested
                        ? 'Te interesa. Tocá para quitar el interés.'
                        : 'Me interesa. Tocá para marcar interés.',
                    excludeSemantics: true,
                    child: OutlinedButton.icon(
                      onPressed: busy ? null : onInterest,
                      icon: Icon(
                        event.interested ? Icons.check : Icons.add,
                        size: 20,
                      ),
                      label: Text(
                        event.interested ? 'Te interesa' : 'Me interesa',
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            event.interested ? AppColors.greenSoft : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s2),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.ios_share, size: 20),
                    label: const Text('Compartir'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
