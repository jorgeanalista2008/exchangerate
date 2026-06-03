import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../database/alert_database.dart';
import '../models/alert_model.dart';

class BackgroundService {
  static const String checkPriceAlertsTask = "com.exchangerate.checkPriceAlertsTask";

  // Inicializar notificaciones para segundo plano
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  // Lógica principal de chequeo de alertas
  static Future<bool> checkAlerts() async {
    try {
      // 1. Obtener tasas actuales de la API
      final response = await http
          .get(Uri.parse('https://ve.dolarapi.com/v1/dolares'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return false;

      final List<dynamic> jsonList = jsonDecode(response.body);
      final Map<String, double> currentRates = {};
      for (var item in jsonList) {
        final fuente = item['fuente'] as String;
        final promedio = (item['promedio'] as num).toDouble();
        currentRates[fuente] = promedio;
      }

      // 2. Obtener alertas activas de la base de datos
      final db = AlertDatabase();
      final activeAlerts = await db.getAlerts(soloActivas: true);

      if (activeAlerts.isEmpty) return true;

      await initNotifications();

      // 3. Evaluar cada alerta
      for (var alert in activeAlerts) {
        final currentPrice = currentRates[alert.moneda];
        if (currentPrice == null) continue;

        bool isTriggered = false;
        if (alert.esMayor && currentPrice >= alert.precioObjetivo) {
          isTriggered = true;
        } else if (!alert.esMayor && currentPrice <= alert.precioObjetivo) {
          isTriggered = true;
        }

        if (isTriggered) {
          // Disparar notificación
          await _showNotification(alert, currentPrice);

          // Desactivar alerta y registrar la última notificación
          alert.activa = false;
          alert.ultimaNotificacion = DateTime.now();
          await db.updateAlert(alert);
        }
      }
      return true;
    } catch (e) {
      print("Error en tarea de segundo plano checkAlerts: $e");
      return false;
    }
  }

  static Future<void> _showNotification(PriceAlert alert, double currentPrice) async {
    final String condition = alert.esMayor ? "superó" : "bajó de";
    final String monedaName = alert.moneda == 'oficial' ? 'Dólar BCV' : 'Dólar Paralelo';

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'price_alerts_channel',
      'Alertas de Precio',
      channelDescription: 'Canal para las alertas de precio de tasas de cambio',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      alert.id ?? 100,
      '📈 Alerta de Precio Alcanzada',
      'El $monedaName $condition el precio objetivo de Bs. ${alert.precioObjetivo.toStringAsFixed(2)}. Precio actual: Bs. ${currentPrice.toStringAsFixed(2)}.',
      platformDetails,
    );
  }
}
