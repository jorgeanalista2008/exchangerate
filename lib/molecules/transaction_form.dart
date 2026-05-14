import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/finance_model.dart';

class TransactionForm extends StatefulWidget {
  final Function(FinanceTransaction) onSave;

  const TransactionForm({super.key, required this.onSave});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _conceptoController = TextEditingController();
  final _montoController = TextEditingController();
  final _notaController = TextEditingController();
  
  String _tipo = 'egreso';
  String _moneda = 'USD';
  String _categoria = 'Otros';
  
  final List<String> _categorias = [
    'Alimentación', 'Transporte', 'Servicios', 'Salud',
    'Educación', 'Entretenimiento', 'Trabajo', 'Vivienda', 'Otros'
  ];

  void _save() {
    if (_formKey.currentState!.validate()) {
      final transaction = FinanceTransaction(
        tipo: _tipo,
        concepto: _conceptoController.text.trim(),
        monto: double.parse(_montoController.text.replaceAll(',', '.')),
        moneda: _moneda,
        categoria: _categoria,
        fecha: DateTime.now(),
        nota: _notaController.text.trim().isNotEmpty ? _notaController.text.trim() : null,
      );
      widget.onSave(transaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'egreso', label: Text('Egreso'), icon: Icon(Icons.arrow_upward)),
              ButtonSegment(value: 'ingreso', label: Text('Ingreso'), icon: Icon(Icons.arrow_downward)),
            ],
            selected: {_tipo},
            onSelectionChanged: (v) => setState(() => _tipo = v.first),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _conceptoController,
            decoration: const InputDecoration(labelText: 'Concepto', prefixIcon: Icon(Icons.description)),
            validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _montoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Monto', prefixIcon: Icon(Icons.attach_money)),
            validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _moneda,
            decoration: const InputDecoration(labelText: 'Moneda'),
            items: const [
              DropdownMenuItem(value: 'USD', child: Text('💵 USD')),
              DropdownMenuItem(value: 'VES', child: Text('🇻🇪 VES')),
            ],
            onChanged: (v) => setState(() => _moneda = v!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _categoria,
            decoration: const InputDecoration(labelText: 'Categoría'),
            items: _categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _categoria = v!),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _notaController,
            decoration: const InputDecoration(labelText: 'Nota (opcional)', prefixIcon: Icon(Icons.note)),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Guardar Transacción'),
          ),
        ],
      ),
    );
  }
}