import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/theme_provider.dart';
import '../models/dolar_model.dart';
import '../molecules/rate_card.dart';
import '../molecules/calculator_widget.dart';
import '../molecules/power_quote_widget.dart';
import 'finance_page.dart';

class HomePage extends StatelessWidget {
  final Map<String, DolarModel> rates;

  const HomePage({
    super.key,
    required this.rates,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.currency_exchange, size: 24),
            SizedBox(width: 8),
            Text("ExchangeRate"),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [AppColors.darkSurface, AppColors.darkSurface]
                  : [AppColors.primaryColor, AppColors.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
           IconButton(
              icon: const Icon(Icons.account_balance_wallet),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FinancePage()),
                );
              },
              tooltip: 'Mis Finanzas',
            ),
          // Botón de tema oscuro/claro
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: isDark ? 'Modo Claro' : 'Modo Oscuro',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            
            const SizedBox(height: 20),
            
            // Tarjetas de tasas
            if (rates['oficial'] != null && rates['paralelo'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: RateCard(
                        dolar: rates['oficial']!,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: RateCard(
                        dolar: rates['paralelo']!,
                        color: isDark ? const Color(0xFF4DB6AC) : AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),

            // Ley del poder
            const PowerQuoteWidget(),
            
            const SizedBox(height: 24),
            
            // Calculadora
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? AppColors.shadowColorDark : AppColors.shadowColorLight,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.calculate,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Calculadora Rápida",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CalculatorWidget(rates: rates),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Footer
            Center(
              child: Text(
                "Datos actualizados en tiempo real",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[isDark ? 600 : 400],
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}