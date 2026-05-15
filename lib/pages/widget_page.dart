import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../services/home_screen_widget.dart';

class WidgetPage extends StatefulWidget {
  const WidgetPage({super.key});

  @override
  State<WidgetPage> createState() => _WidgetPageState();
}

class _WidgetPageState extends State<WidgetPage> {
  Map<String, String> _widgetData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    // Guardar datos actualizados
    await HomeScreenWidgetService.saveRatesForWidget();
    // Cargar datos
    final data = await HomeScreenWidgetService.getWidgetData();
    setState(() {
      _widgetData = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pantalla de Inicio')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: AppColors.primaryColor),
                          SizedBox(width: 8),
                          Text('Pantalla de Inicio Rápida',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('Deja esta pantalla abierta para ver las tasas actualizadas.',
                        style: TextStyle(fontSize: 13, color: AppColors.primaryColor)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Widget preview
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryColor, AppColors.secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.currency_exchange, color: Colors.white, size: 24),
                          SizedBox(width: 10),
                          Text('ExchangeRate',
                            style: TextStyle(color: Colors.white70, fontSize: 16, letterSpacing: 2)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildRateRow('Paralelo:', _widgetData['paralelo'] ?? '---', true),
                      const SizedBox(height: 12),
                      Container(height: 1, color: Colors.white.withOpacity(0.2)),
                      const SizedBox(height: 12),
                      _buildRateRow('Oficial:', _widgetData['oficial'] ?? '---', false),
                      const SizedBox(height: 16),
                      Text('Actualizado: ${_widgetData['fecha'] ?? '---'}',
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Botón actualizar
                ElevatedButton.icon(
                  onPressed: _loadData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Actualizar Tasas'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),

                const SizedBox(height: 16),

                // Instrucciones
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                          SizedBox(width: 8),
                          Text('Tip', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('Para un acceso rápido, puedes:\n'
                           '1. Dejar esta pantalla abierta\n'
                           '2. Agregar la app a tu pantalla de inicio\n'
                           '3. Usar la opción "Pantalla dividida"',
                        style: TextStyle(fontSize: 13, color: AppColors.primaryColor)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildRateRow(String label, String value, bool highlight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 15)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: highlight ? Colors.white.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('Bs. $value',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),
        ),
      ],
    );
  }
}