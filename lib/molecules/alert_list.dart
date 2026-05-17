import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../database/alert_database.dart';
import '../models/alert_model.dart';

class AlertList extends StatefulWidget {
  const AlertList({super.key});

  @override
  State<AlertList> createState() => _AlertListState();
}

class _AlertListState extends State<AlertList> {
  final AlertDatabase _db = AlertDatabase();
  List<PriceAlert> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    final alerts = await _db.getAlerts();
    if (mounted) {
      setState(() {
        _alerts = alerts;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleAlert(PriceAlert alert) async {
    await _db.toggleAlert(alert.id!, !alert.activa);
    _loadAlerts();
  }

  Future<void> _deleteAlert(PriceAlert alert) async {
    await _db.deleteAlert(alert.id!);
    _loadAlerts();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    
    if (_alerts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text('No hay alertas configuradas', 
              style: TextStyle(color: Colors.grey[500], fontSize: 14)),
            const SizedBox(height: 4),
            Text('Toca "Nueva Alerta" para crear una',
              style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _alerts.length,
      itemBuilder: (context, index) {
        final alert = _alerts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: alert.activa 
                    ? AppColors.primaryColor.withOpacity(0.1) 
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                alert.activa ? Icons.notifications_active : Icons.notifications_off,
                color: alert.activa ? AppColors.primaryColor : Colors.grey,
                size: 20,
              ),
            ),
            title: Text(
              '${alert.monedaTexto}: ${alert.condicionTexto} Bs. ${alert.precioObjetivo.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14),
            ),
            subtitle: Text(
              alert.activa ? 'Activa' : 'Desactivada',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: alert.activa,
                  onChanged: (_) => _toggleAlert(alert),
                  activeColor: AppColors.primaryColor,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  onPressed: () => _deleteAlert(alert),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}