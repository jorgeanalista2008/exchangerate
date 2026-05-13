import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/app_colors.dart';
import 'core/app_theme.dart';
import 'pages/loading_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExchangeRate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoadingPage(),
    );
  }
}