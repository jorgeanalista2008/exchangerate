import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreenWidgetService {
  static const String _keyParalelo = 'widget_paralelo';
  static const String _keyOficial = 'widget_oficial';
  static const String _keyFecha = 'widget_fecha';

  // Guardar tasas para el widget
  static Future<void> saveRatesForWidget() async {
    try {
      final response = await http.get(
        Uri.parse('https://ve.dolarapi.com/v1/dolares'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        
        for (var item in data) {
          if (item['fuente'] == 'paralelo') {
            await prefs.setString(_keyParalelo, (item['promedio'] as num).toStringAsFixed(2));
          }
          if (item['fuente'] == 'oficial') {
            await prefs.setString(_keyOficial, (item['promedio'] as num).toStringAsFixed(2));
          }
        }
        
        final now = DateTime.now();
        await prefs.setString(_keyFecha, '${now.day}/${now.month} ${now.hour}:${now.minute.toString().padLeft(2, '0')}');
      }
    } catch (e) {
      print('Error guardando datos del widget: $e');
    }
  }

  // Obtener datos para mostrar
  static Future<Map<String, String>> getWidgetData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'paralelo': prefs.getString(_keyParalelo) ?? '---',
      'oficial': prefs.getString(_keyOficial) ?? '---',
      'fecha': prefs.getString(_keyFecha) ?? 'Sin datos',
    };
  }
}