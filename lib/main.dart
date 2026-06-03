import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:workmanager/workmanager.dart';
import 'core/theme_provider.dart';
import 'core/app_theme.dart';
import 'pages/loading_page.dart';
import 'pages/lock_screen.dart';
import 'services/background_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case BackgroundService.checkPriceAlertsTask:
        return await BackgroundService.checkAlerts();
      default:
        return true;
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  
  // Inicializar Workmanager para tareas en segundo plano
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  // Registrar la tarea periódica (ejecución mínima cada 15 minutos en Android)
  await Workmanager().registerPeriodicTask(
    "check_price_alerts_task_id",
    BackgroundService.checkPriceAlertsTask,
    frequency: const Duration(minutes: 15),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'ExchangeRate',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const LockScreen(
            requireAuth: true,
            child: LoadingPage(),
          ),
        );
      },
    );
  }
}