import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/theme_provider.dart';
import '../models/dolar_model.dart';

class RateCard extends StatelessWidget {
  final DolarModel dolar;
  final Color color;
  final String? label;  // ← AGREGAR ESTO

  const RateCard({
    super.key,
    required this.dolar,
    required this.color,
    this.label,  // ← AGREGAR ESTO
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isDark ? 0.3 : 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(isDark ? 0.3 : 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  dolar.fuente == 'bcv' || dolar.fuente == 'oficial'
                      ? Icons.account_balance 
                      : Icons.trending_up,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label ?? (dolar.fuente == 'oficial' || dolar.fuente == 'bcv' ? 'BCV' : 'Otra Tasa'),  // ← USAR label
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            "Bs. ${dolar.promedio.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              // CAMBIO AQUÍ: BCV u Otra Tasa
              dolar.fuente == 'oficial' || dolar.fuente == 'bcv' 
                  ? 'BCV' 
                  : 'Otra Tasa',
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}