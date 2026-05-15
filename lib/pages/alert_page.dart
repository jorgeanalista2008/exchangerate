import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/theme_provider.dart';
import '../database/alert_database.dart';
import '../models/alert_model.dart';
import '../molecules/alert_form.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  final AlertDatabase _db = AlertDatabase();
  List<PriceAlert> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    setState(() => _isLoading = true);
    final alerts = await _db.getAlerts();
    setState(() {
      _alerts = alerts;
      _isLoading = false;
    });
  }

  Future<void> _addAlert(PriceAlert alert) async {
    await _db.insertAlert(alert);
    Navigator.pop(context);
    _loadAlerts();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Alerta creada'), backgroundColor: Colors.green),
    );
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
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Alertas de Precio')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _alerts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text('No hay alertas configuradas', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _alerts.length,
                  itemBuilder: (context, index) {
                    final alert = _alerts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(
                          Icons.notifications_active,
                          color: alert.activa ? AppColors.primaryColor : Colors.grey,
                        ),
                        title: Text('${alert.monedaTexto} ${alert.condicionTexto} Bs. ${alert.precioObjetivo}'),
                        subtitle: Text(alert.activa ? 'Activa' : 'Desactivada'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: alert.activa,
                              onChanged: (_) => _toggleAlert(alert),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteAlert(alert),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Nueva Alerta')),
                body: AlertForm(onSave: _addAlert),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}