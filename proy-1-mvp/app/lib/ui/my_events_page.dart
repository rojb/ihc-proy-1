import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/event.dart';
import '../state/organizer_controller.dart';
import 'event_form_page.dart';
import 'format.dart';
import 'spacing.dart';
import 'theme.dart';
import 'widgets/validity_badge.dart';

/// FR-11 · "Mis eventos": donde el organizador ya administra sus eventos ve
/// cuánta gente marcó interés. No es una sección nueva ni un panel de métricas:
/// la evidencia dice que el organizador prioriza velocidad, no analítica.
class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});

  @override
  State<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrganizerController>().load();
    });
  }

  Future<void> _openForm({Event? event}) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => EventFormPage(event: event)),
    );
    if (mounted) {
      await context.read<OrganizerController>().load();
    }
  }

  Future<void> _confirmCancel(Event event) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('¿Cancelar el evento?'),
        content: const Text(
          'Queda visible en la lista marcado como cancelado, para que nadie '
          'lo comparta creyendo que sigue en pie.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Volver'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancelar evento'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    final String? error =
        await context.read<OrganizerController>().cancel(event.id);

    if (error != null && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final OrganizerController controller = context.watch<OrganizerController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mis eventos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Publicar evento'),
      ),
      body: Column(
        children: <Widget>[
          const _AttendanceDisclaimer(),
          Expanded(child: _buildBody(controller)),
        ],
      ),
    );
  }

  Widget _buildBody(OrganizerController controller) {
    if (controller.loading && controller.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.error != null && controller.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s4),
          child: Text(controller.error!, textAlign: TextAlign.center),
        ),
      );
    }

    if (controller.items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.s4),
          child: Text(
            'Todavía no publicaste ningún evento.\n'
            'Publicar uno toma menos de dos minutos.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.s2,
          AppSpacing.s2,
          AppSpacing.s2,
          AppSpacing.s4 * 3,
        ),
      itemCount: controller.items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s1),
      itemBuilder: (BuildContext context, int index) {
        final Event event = controller.items[index];
        return _OwnEventCard(
          event: event,
          onEdit: () => _openForm(event: event),
          onCancel: event.validity == Validity.cancelado
              ? null
              : () => _confirmCancel(event),
        );
      },
    );
  }
}

/// FR-11 · Leyenda fija. Está siempre, no solo la primera vez: es la mitigación
/// del riesgo R-3 (que el organizador lea el interés como asistencia).
class _AttendanceDisclaimer extends StatelessWidget {
  const _AttendanceDisclaimer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.greenSoft,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s2,
        vertical: AppSpacing.s2,
      ),
      child: const Text(
        'El número de interesados no es una confirmación de asistencia.',
        style: TextStyle(
          color: AppColors.green,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _OwnEventCard extends StatelessWidget {
  const _OwnEventCard({
    required this.event,
    required this.onEdit,
    required this.onCancel,
  });

  final Event event;
  final VoidCallback onEdit;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  formatDayTime(event.startsAt).toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              ValidityBadge(validity: event.validity),
            ],
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(event.name, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s1),
          Row(
            children: <Widget>[
              const Icon(Icons.people_outline, size: 16, color: AppColors.green),
              const SizedBox(width: AppSpacing.s1),
              Text(
                '${event.interestCount} interesados',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.green,
                ),
              ),
              const Spacer(),
              Text(formatPrice(event),
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Editar'),
                ),
              ),
              const SizedBox(width: AppSpacing.s1),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.block, size: 18),
                  label: const Text('Cancelar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.urucu,
                    side: const BorderSide(color: AppColors.urucu, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
