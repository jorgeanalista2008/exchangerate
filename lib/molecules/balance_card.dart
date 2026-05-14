import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';
import '../models/finance_model.dart';

class BalanceCard extends StatelessWidget {
  final FinancialSummary summary;
  final bool isDark;
  final Map<String, double>? expensesByCategory; // NUEVO: Recibir gastos por categoría

  const BalanceCard({
    super.key,
    required this.summary,
    required this.isDark,
    this.expensesByCategory, // Opcional
  });

  String _formatMoney(double amount, String currency) {
    final locale = WidgetsBinding.instance.platformDispatcher.locale.toString();
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: currency == 'USD' ? '\$ ' : 'Bs. ',
      decimalDigits: 2,
    );
    return formatter.format(amount).replaceAll('\u00A0', ' ');
  }

  // Obtener la categoría con mayor gasto
  String get _topCategory {
    if (expensesByCategory == null || expensesByCategory!.isEmpty) {
      return 'Sin datos';
    }
    
    String topCat = '';
    double maxAmount = 0;
    
    expensesByCategory!.forEach((category, amount) {
      if (amount > maxAmount) {
        maxAmount = amount;
        topCat = category;
      }
    });
    
    return '$topCat (${_formatMoney(maxAmount, 'USD')})';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Balance USD
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryColor, AppColors.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text('Balance USD', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 8),
              Text(
                _formatMoney(summary.balanceUSD, 'USD'),
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMiniStat('Ingresos', summary.totalIngresosUSD, Colors.greenAccent),
                  _buildMiniStat('Egresos', summary.totalEgresosUSD, Colors.redAccent),
                ],
              ),
              // Categoría con mayor gasto
              if (expensesByCategory != null && expensesByCategory!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildTopCategory(),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Balance VES
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Text('Balance VES', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[600], fontSize: 14)),
              const SizedBox(height: 8),
              Text(
                _formatMoney(summary.balanceVES, 'VES'),
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.primaryColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMiniStat('Ingresos', summary.totalIngresosVES, Colors.green),
                  _buildMiniStat('Egresos', summary.totalEgresosVES, Colors.red),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopCategory() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pie_chart_outline, color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          Column(
            children: [
              const Text(
                'Mayor gasto',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                _topCategory,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, double amount, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color.withOpacity(0.8), fontSize: 11)),
        Text(amount.toStringAsFixed(2), 
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}