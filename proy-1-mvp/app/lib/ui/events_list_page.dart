import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/event.dart';
import '../api/api_client.dart';
import '../state/events_controller.dart';
import 'event_detail_page.dart';
import 'format.dart';
import 'my_events_page.dart';
import 'spacing.dart';
import 'theme.dart';
import 'widgets/event_card.dart';
import 'widgets/filter_sheet.dart';

/// FR-01 · La pantalla de inicio es la lista. No hay buscador ni onboarding:
/// la evidencia dice que el problema es comparar, no encontrar.
class EventsListPage extends StatefulWidget {
  const EventsListPage({super.key});

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventsController>().initialise();
    });
  }

  @override
  Widget build(BuildContext context) {
    final EventsController controller = context.watch<EventsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Qué hay en Santa Cruz',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const MyEventsPage()),
            ),
            icon: const Icon(Icons.campaign_outlined),
            tooltip: 'Mis eventos',
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          if (controller.servedFromCache) const _OfflineBanner(),
          if (!controller.filters.isEmpty) const _ActiveFilters(),
          Expanded(child: _Results(controller: controller)),
        ],
      ),
      // NFR de uso a una mano · la acción primaria vive abajo.
      bottomNavigationBar: _BottomBar(controller: controller),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.controller});

  final EventsController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.loading && controller.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.error != null && controller.items.isEmpty) {
      return _Message(
        title: 'No se pudo cargar la lista',
        body: controller.error!,
        actionLabel: 'Reintentar',
        onAction: controller.load,
      );
    }

    if (controller.items.isEmpty) {
      return _Message(
        title: 'Ningún evento con estos filtros',
        // FR-04 · el estado vacío tiene que decir qué aflojar, no solo que no
        // hay nada: si no, la persona no sabe qué tocar para volver a ver algo.
        body: _relaxSuggestion(controller.filters),
        actionLabel: 'Quitar filtros',
        onAction: controller.clearFilters,
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.load(showSpinner: false),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s2,
          AppSpacing.s1,
          AppSpacing.s2,
          AppSpacing.s3,
        ),
        itemCount: controller.items.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s2),
        itemBuilder: (BuildContext context, int index) {
          final Event event = controller.items[index];
          return EventCard(
            event: event,
            interestPending: controller.isPending(event.id),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => EventDetailPage(eventId: event.id),
              ),
            ),
          );
        },
      ),
    );
  }

  String _relaxSuggestion(EventFilters filters) {
    if (filters.maxPriceCents != null) {
      return 'Probá subir el tope de precio.';
    }
    if (filters.radiusKm != null) {
      return 'Probá ampliar la distancia.';
    }
    if (filters.when != null) {
      return 'Probá mirar otros días, no solo los que elegiste.';
    }
    return 'Probá quitar algún filtro.';
  }
}

/// FR-04 · Cada filtro activo se ve y se saca de un toque.
class _ActiveFilters extends StatelessWidget {
  const _ActiveFilters();

  @override
  Widget build(BuildContext context) {
    final EventsController controller = context.watch<EventsController>();
    final EventFilters filters = controller.filters;

    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
        children: <Widget>[
          if (filters.when != null)
            _RemovableChip(
              label: filters.when == 'today' ? 'Hoy' : 'Este finde',
              onRemove: () => controller.setWhen(null),
            ),
          if (filters.maxPriceCents != null)
            _RemovableChip(
              label: filters.maxPriceCents == 0
                  ? 'Gratis'
                  : 'Hasta Bs ${filters.maxPriceCents! ~/ 100}',
              onRemove: () => controller.setMaxPriceCents(null),
            ),
          if (filters.nearZone != null)
            _RemovableChip(
              label: filters.radiusKm == null
                  ? 'Desde ${filters.nearZone}'
                  : 'A ${filters.radiusKm!.toInt()} km de ${filters.nearZone}',
              onRemove: () => controller.setNear(null, null),
            ),
        ],
      ),
    );
  }
}

class _RemovableChip extends StatelessWidget {
  const _RemovableChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.s1),
      child: Center(
        child: InputChip(
          label: Text(label),
          onDeleted: onRemove,
          deleteIcon: const Icon(Icons.close, size: 18),
          deleteButtonTooltipMessage: 'Quitar filtro',
          backgroundColor: AppColors.greenSoft,
          side: const BorderSide(color: AppColors.green),
          labelStyle: const TextStyle(
            color: AppColors.green,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// NFR de red inestable · lo que se ve salió de la caché. Se dice cuándo se
/// cargó, porque un dato viejo sin fecha es peor que no tener dato.
class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    final EventsController controller = context.watch<EventsController>();
    final DateTime? at = controller.cachedAt;

    return Container(
      width: double.infinity,
      color: AppColors.amberSoft,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s2,
        vertical: AppSpacing.s1,
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.cloud_off, size: 18, color: AppColors.amber),
          const SizedBox(width: AppSpacing.s1),
          Expanded(
            child: Text(
              at == null
                  ? 'Sin conexión. Estás viendo lo último que se cargó.'
                  : 'Sin conexión. Lista cargada ${formatTimeAgo(at)}.',
              style: const TextStyle(
                color: AppColors.amber,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.controller});

  final EventsController controller;

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
        child: Row(
          children: <Widget>[
            Expanded(
              // FR-04 · el número de resultados siempre visible.
              child: Text(
                controller.loading
                    ? 'Buscando…'
                    : '${controller.count} ${controller.count == 1 ? 'evento' : 'eventos'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            FilledButton.icon(
              onPressed: () => FilterSheet.show(context),
              icon: const Icon(Icons.tune, size: 20),
              label: const Text('Filtros'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(144, kMinTapTarget),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.s1),
            Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.s3),
            OutlinedButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
