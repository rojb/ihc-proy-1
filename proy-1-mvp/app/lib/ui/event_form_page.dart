import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../api/event.dart';
import '../api/zones.dart';
import '../state/organizer_controller.dart';
import 'format.dart';
import 'spacing.dart';
import 'theme.dart';

/// FR-10 · Publicar (y FR-12 · editar) con un formulario corto.
///
/// Obligatorios: nombre, cuándo, precio y dónde. Nada más. El objetivo es
/// publicar completo en ≤ 120 s (KR7), y cada campo que se vuelve obligatorio
/// juega en contra. Lo opcional está plegado para que no compita por atención.
class EventFormPage extends StatefulWidget {
  const EventFormPage({super.key, this.event});

  /// Si viene un evento, es una edición (FR-12).
  final Event? event;

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _price;
  late final TextEditingController _location;
  late final TextEditingController _reference;
  late final TextEditingController _description;

  DateTime? _startsAt;
  String? _zone;
  bool _isFree = false;
  bool _showOptional = false;
  bool _saving = false;

  bool get _isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    final Event? event = widget.event;

    _name = TextEditingController(text: event?.name ?? '');
    _price = TextEditingController(
      text: event == null || event.isFree
          ? ''
          : (event.priceCents / 100).toStringAsFixed(0),
    );
    _location = TextEditingController(text: event?.locationName ?? '');
    _reference = TextEditingController(text: event?.reference ?? '');
    _description = TextEditingController(text: event?.description ?? '');

    _startsAt = event?.startsAt;
    _zone = event?.zone;
    _isFree = event?.isFree ?? false;
    _showOptional = (event?.reference?.isNotEmpty ?? false) ||
        (event?.description?.isNotEmpty ?? false);
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _location.dispose();
    _reference.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickWhen() async {
    final DateTime now = DateTime.now();
    final DateTime initial = _startsAt ?? now.add(const Duration(days: 1));

    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
      locale: const Locale('es'),
    );
    if (date == null || !mounted) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null || !mounted) return;

    setState(() {
      _startsAt =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startsAt == null) {
      _showError('Falta la fecha y hora del evento.');
      return;
    }
    if (_zone == null) {
      _showError('Falta la zona.');
      return;
    }

    setState(() => _saving = true);

    final Map<String, dynamic> body = <String, dynamic>{
      'name': _name.text.trim(),
      'startsAt': _startsAt!.toUtc().toIso8601String(),
      'priceCents': _isFree ? 0 : (int.parse(_price.text.trim()) * 100),
      'locationName': _location.text.trim(),
      'zone': _zone,
      'description':
          _description.text.trim().isEmpty ? null : _description.text.trim(),
      'reference':
          _reference.text.trim().isEmpty ? null : _reference.text.trim(),
    };
    // El backend rechaza claves nulas no declaradas: se limpian antes de enviar.
    body.removeWhere((String key, dynamic value) => value == null);

    final OrganizerController controller = context.read<OrganizerController>();
    final String? error = _isEditing
        ? await controller.edit(widget.event!.id, body)
        : await controller.publish(body);

    if (!mounted) return;
    setState(() => _saving = false);

    if (error != null) {
      _showError(error);
      return;
    }

    Navigator.of(context).pop();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar evento' : 'Publicar evento'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
          AppSpacing.s2,
          AppSpacing.s2,
          AppSpacing.s2,
          AppSpacing.s3,
        ),
          children: <Widget>[
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Nombre del evento',
                hintText: 'Peña folclórica con banda en vivo',
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (String? value) =>
                  (value == null || value.trim().length < 3)
                      ? 'Escribí un nombre de al menos 3 letras.'
                      : null,
            ),
            const SizedBox(height: AppSpacing.s2),

            _FieldLabel('Cuándo empieza'),
            OutlinedButton.icon(
              onPressed: _pickWhen,
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              label: Text(
                _startsAt == null
                    ? 'Elegir fecha y hora'
                    : formatFullDayTime(_startsAt!),
              ),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                foregroundColor: AppColors.ink,
                side: const BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            const SizedBox(height: AppSpacing.s2),

            // FR-02 · el precio nunca queda vacío: o hay número, o es Gratis.
            _FieldLabel('Precio'),
            SwitchListTile.adaptive(
              value: _isFree,
              onChanged: (bool value) => setState(() => _isFree = value),
              title: const Text('Es gratis'),
              contentPadding: EdgeInsets.zero,
              activeThumbColor: AppColors.green,
            ),
            if (!_isFree)
              TextFormField(
                controller: _price,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: 'Cuánto cuesta',
                  prefixText: 'Bs ',
                ),
                validator: (String? value) {
                  if (_isFree) return null;
                  final int? parsed = int.tryParse((value ?? '').trim());
                  if (parsed == null) {
                    return 'Poné el precio, o marcá "Es gratis".';
                  }
                  return null;
                },
              ),
            const SizedBox(height: AppSpacing.s2),

            TextFormField(
              controller: _location,
              decoration: const InputDecoration(
                labelText: 'Dónde es',
                hintText: 'Casa del Camba',
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (String? value) =>
                  (value == null || value.trim().length < 3)
                      ? 'Escribí dónde es.'
                      : null,
            ),
            const SizedBox(height: AppSpacing.s2),

            DropdownButtonFormField<String>(
              initialValue: _zone,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Zona'),
              items: <DropdownMenuItem<String>>[
                for (final String zone in kZones)
                  DropdownMenuItem<String>(value: zone, child: Text(zone)),
              ],
              onChanged: (String? zone) => setState(() => _zone = zone),
            ),

            const SizedBox(height: AppSpacing.s3),
            // Lo opcional, plegado: que exista no puede costarle tiempo a quien
            // solo quiere publicar rápido.
            if (!_showOptional)
              TextButton.icon(
                onPressed: () => setState(() => _showOptional = true),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Agregar descripción o referencia'),
              ),
            if (_showOptional) ...<Widget>[
              TextFormField(
                controller: _reference,
                decoration: const InputDecoration(
                  labelText: 'Cómo ubicarlo (opcional)',
                  hintText: 'Frente a la plaza principal',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: AppSpacing.s2),
              TextFormField(
                controller: _description,
                maxLines: 3,
                maxLength: 500,
                decoration: const InputDecoration(
                  labelText: 'Descripción breve (opcional)',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
          AppSpacing.s2,
          AppSpacing.s1,
          AppSpacing.s2,
          AppSpacing.s2,
        ),
          child: FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(
              _saving
                  ? 'Guardando…'
                  : _isEditing
                      ? 'Guardar cambios'
                      : 'Publicar',
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s1),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}
