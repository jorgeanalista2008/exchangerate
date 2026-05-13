import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/dolar_model.dart';
import '../molecules/rate_card.dart';
import '../molecules/calculator_widget.dart';
import '../molecules/power_quote_widget.dart';

class HomePage extends StatelessWidget {
  final Map<String, DolarModel> rates;

  const HomePage({
    super.key,
    required this.rates,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado de bienvenida
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withOpacity(0.05),
                    AppColors.secondaryColor.withOpacity(0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.1),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tasas de Cambio",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Venezuela",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            
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
                        color: AppColors.secondaryColor,
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
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
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
                      const Text(
                        "Calculadora Rápida",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
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
                  color: Colors.grey[400],
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