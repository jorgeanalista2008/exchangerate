import 'package:flutter/material.dart';

class AppColors {
  // Colores principales - Modo Claro
  static const primaryColor = Color(0xFF009688);
  static const secondaryColor = Color(0xFF004D40);
  static const accentColor = Color(0xFFE0F2F1);
  
  // Fondos - Modo Claro
  static const lightBackground = Color(0xFFF5F7FA);
  static const lightCard = Colors.white;
  static const lightSurface = Color(0xFFF8FAFB);
  
  // Textos - Modo Claro
  static const lightTextPrimary = Color(0xFF1A2332);
  static const lightTextSecondary = Color(0xFF546E7A);
  
  // Fondos - Modo Oscuro
  static const darkBackground = Color(0xFF121212);
  static const darkCard = Color(0xFF1E1E1E);
  static const darkSurface = Color(0xFF2C2C2C);
  
  // Textos - Modo Oscuro
  static const darkTextPrimary = Color(0xFFE8EAED);
  static const darkTextSecondary = Color(0xFF9AA0A6);
  
  // Estados (compartidos)
  static const successColor = Color(0xFF4CAF50);
  static const errorColor = Color(0xFFE53935);
  static const warningColor = Color(0xFFFFA726);
  static const infoColor = Color(0xFF42A5F5);
  
  // Sombras
  static Color shadowColorLight = Colors.black.withOpacity(0.08);
  static Color shadowColorDark = Colors.black.withOpacity(0.3);
}