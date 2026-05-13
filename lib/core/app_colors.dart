import 'package:flutter/material.dart';

class AppColors {
  // Colores principales
  static const primaryColor = Color(0xFF009688); // Verde Esmeralda
  static const secondaryColor = Color(0xFF004D40); // Verde oscuro
  static const accentColor = Color(0xFFE0F2F1); // Verde claro
  
  // Fondos
  static const backgroundColor = Color(0xFFF5F7FA);
  static const cardColor = Colors.white;
  static const surfaceColor = Color(0xFFF8FAFB);
  
  // Textos
  static const textPrimary = Color(0xFF1A2332);
  static const textSecondary = Color(0xFF546E7A);
  static const textHint = Color(0xFF90A4AE);
  
  // Estados
  static const successColor = Color(0xFF4CAF50);
  static const errorColor = Color(0xFFE53935);
  static const warningColor = Color(0xFFFFA726);
  static const infoColor = Color(0xFF42A5F5);
  
  // Gradientes
  static const gradientStart = primaryColor;
  static const gradientEnd = secondaryColor;
  
  // Sombras
  static Color shadowColor = Colors.black.withOpacity(0.08);
  static Color shadowColorDark = Colors.black.withOpacity(0.15);
}