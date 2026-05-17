import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/alert_model.dart';

class AlertForm extends StatefulWidget {
  final Function(PriceAlert) onSave;

  const AlertForm({super.key, required this.onSave});

  @override
  State<AlertForm> createState() => _AlertFormState();
}

class _AlertFormState extends State<AlertForm> {
  final _formKey = GlobalKey<FormState>();
  final _precioController = TextEditingController();
  
  String _moneda = 'paralelo';
  bool _esMayor = true;

  void _save() {
    if (_formKey.currentState!.validate()) {
      final alert = PriceAlert(
        moneda: _moneda,
        precioObjetivo: double.parse(_precioController.text.replaceAll(',', '.')),
        esMayor: _esMayor,
        fechaCreacion: DateTime.now(),
      );
      widget.onSave(alert);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Tipo de moneda
          const Text('Moneda', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'paralelo', label: Text('Paralelo')),
              ButtonSegment(value: 'oficial', label: Text('Oficial')),
            ],
            selected: {_moneda},
            onSelectionChanged: (v) => setState(() => _moneda = v.first),
          ),
          
          const SizedBox(height: 20),
          
          // Condición
          const Text('Notificarme cuando...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Suba de'), icon: Icon(Icons.trending_up, size: 18)),
              ButtonSegment(value: false, label: Text('Baje de'), icon: Icon(Icons.trending_down, size: 18)),
            ],
            selected: {_esMayor},
            onSelectionChanged: (v) => setState(() => _esMayor = v.first),
          ),
          
          const SizedBox(height: 20),
          
          // Precio objetivo
          TextFormField(
            controller: _precioController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Precio objetivo (Bs.)',
              prefixIcon: Icon(Icons.flag),
              helperText: 'Ingresa el monto en Bolívares',
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Requerido';
              final n = double.tryParse(v.replaceAll(',', '.'));
              if (n == null || n <= 0) return 'Ingresa un monto válido';
              return null;
            },
          ),
          
          const SizedBox(height: 24),
          
          // Resumen
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primaryColor, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Te avisaremos cuando el dólar ${_moneda == 'paralelo' ? 'paralelo' : 'oficial'} '
                    '${_esMayor ? 'suba de' : 'baje de'} '
                    'Bs. ${_precioController.text.isNotEmpty ? _precioController.text : '___'}',
                    style: const TextStyle(color: AppColors.primaryColor, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.notifications_active),
            label: const Text('Crear Alerta'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _precioController.dispose();
    super.dispose();
  }
}