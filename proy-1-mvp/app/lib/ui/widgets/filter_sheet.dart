import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/zones.dart';
import '../../state/events_controller.dart';
import '../spacing.dart';
import '../theme.dart';

/// FR-04 · Filtros básicos: fecha, precio y distancia/zona.
///
/// Va en una hoja inferior para que todo quede en el tercio de abajo, alcanzable
/// con el pulgar (NFR de uso a una mano). Cada filtro se aplica al instante y
/// el número de resultados se actualiza a la vista, así la persona ve el efecto
/// antes de cerrar.
///
/// La ubicación se resuelve con una sola pregunta —"¿desde qué zona?"— en vez
/// de pedir permiso de GPS. Dos controles de ubicación separados (zona exacta y
/// distancia) se pisan entre sí y confunden en una prueba de usabilidad.
class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusM)),
      ),
      builder: (_) => const FilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsController>(
      builder: (BuildContext context, EventsController controller, _) {
        final filters = controller.filters;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
          AppSpacing.s2,
          AppSpacing.s2,
          AppSpacing.s2,
          AppSpacing.s2,
        ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s2),

                  const _GroupTitle('Cuándo'),
                  Wrap(
                    spacing: 8,
                    children: <Widget>[
                      _Choice(
                        label: 'Hoy',
                        selected: filters.when == 'today',
                        onSelected: (bool value) =>
                            controller.setWhen(value ? 'today' : null),
                      ),
                      _Choice(
                        label: 'Este finde',
                        selected: filters.when == 'weekend',
                        onSelected: (bool value) =>
                            controller.setWhen(value ? 'weekend' : null),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s3),

                  const _GroupTitle('Cuánto, como máximo'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      for (final ({String label, int cents}) option
                          in _priceOptions)
                        _Choice(
                          label: option.label,
                          selected: filters.maxPriceCents == option.cents,
                          onSelected: (bool value) => controller
                              .setMaxPriceCents(value ? option.cents : null),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s3),

                  const _GroupTitle('Desde qué zona salís'),
                  DropdownButtonFormField<String>(
                    initialValue: filters.nearZone,
                    isExpanded: true,
                    hint: const Text('Elegí tu zona'),
                    items: <DropdownMenuItem<String>>[
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Cualquier zona'),
                      ),
                      for (final String zone in kZones)
                        DropdownMenuItem<String>(
                          value: zone,
                          child: Text(zone),
                        ),
                    ],
                    onChanged: (String? zone) => controller.setNear(
                      zone,
                      zone == null ? null : (filters.radiusKm ?? 5),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s2),
                  Opacity(
                    // La distancia no se puede aplicar sin punto de partida.
                    opacity: filters.nearZone == null ? 0.4 : 1,
                    child: IgnorePointer(
                      ignoring: filters.nearZone == null,
                      child: Wrap(
                        spacing: 8,
                        children: <Widget>[
                          for (final double km in <double>[2, 5, 10])
                            _Choice(
                              label: 'Hasta ${km.toInt()} km',
                              selected: filters.radiusKm == km,
                              onSelected: (bool value) => controller.setNear(
                                filters.nearZone,
                                value ? km : null,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s3),

                  Row(
                    children: <Widget>[
                      if (!filters.isEmpty)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: controller.clearFilters,
                            child: const Text('Quitar filtros'),
                          ),
                        ),
                      if (!filters.isEmpty) const SizedBox(width: AppSpacing.s2),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            controller.loading
                                ? 'Buscando…'
                                : 'Ver ${controller.count} resultados',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static const List<({String label, int cents})> _priceOptions =
      <({String label, int cents})>[
    (label: 'Gratis', cents: 0),
    (label: 'Bs 30', cents: 3000),
    (label: 'Bs 50', cents: 5000),
    (label: 'Bs 100', cents: 10000),
  ];
}

class _GroupTitle extends StatelessWidget {
  const _GroupTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s1),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      // NFR de uso a una mano · área táctil mínima.
      constraints: const BoxConstraints(minHeight: kMinTapTarget),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        showCheckmark: true,
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.greenSoft,
        side: BorderSide(
          color: selected ? AppColors.green : AppColors.border,
          width: selected ? 1.5 : 1,
        ),
        labelStyle: TextStyle(
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          color: selected ? AppColors.green : AppColors.ink,
        ),
      ),
    );
  }
}
