import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/theme_provider.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Logo y nombre
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, AppColors.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.currency_exchange,
                    size: 50,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'ExchangeRate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ¿Qué es ExchangeRate?
          _buildSection(
            icon: Icons.info_outline,
            title: '¿Qué es ExchangeRate?',
            content: 'ExchangeRate es una aplicación informativa diseñada para mostrar '
                'las tasas de cambio de moneda de referencia en Venezuela. '
                'La app recopila datos de fuentes públicas y los presenta de manera '
                'clara y sencilla para mantenerte informado.',
            isDark: isDark,
            textSecondary: textSecondary,
          ),

          const SizedBox(height: 16),

          // ¿Para qué se usa?
          _buildSection(
            icon: Icons.touch_app,
            title: '¿Para qué se usa?',
            content: '• Consultar tasas de cambio de referencia.\n'
                '• Realizar cálculos de conversión.\n'
                '• Gestionar finanzas personales.\n'
                '• Configurar alertas de precio.\n'
                '• Leer frases inspiradoras.',
            isDark: isDark,
            textSecondary: textSecondary,
          ),

          const SizedBox(height: 16),

          // Fuente de datos
          _buildSection(
            icon: Icons.cloud_download,
            title: 'Fuente de datos',
            content: 'Las tasas mostradas en esta aplicación provienen de APIs '
                'públicas que recopilan datos de diversas fuentes. '
                'ExchangeRate no genera, modifica ni establece los valores mostrados.',
            isDark: isDark,
            textSecondary: textSecondary,
          ),

          const SizedBox(height: 16),

          // ⚠️ DESCARGO IMPORTANTE
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning_amber, color: Colors.amber, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Descargo de Responsabilidad',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.amber[200] : Colors.amber[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'El autor de esta aplicación NO tiene influencia alguna sobre '
                  'el precio de la moneda, NO ajusta el valor ni estipula un monto.\n\n'
                  'Los valores mostrados son ÚNICAMENTE de carácter informativo y '
                  'provienen de fuentes públicas de terceros.\n\n'
                  'Esta aplicación NO representa ninguna entidad gubernamental, '
                  'banco central, ni institución financiera oficial.\n\n'
                  'El usuario es responsable del uso que dé a la información '
                  'presentada en esta aplicación.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.amber[100] : Colors.amber[900],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Características
          _buildSection(
            icon: Icons.star,
            title: 'Características',
            content: '• Tasas de cambio en tiempo real.\n'
                '• Calculadora con formato regional.\n'
                '• Gestor de finanzas personales.\n'
                '• Alertas de precio configurables.\n'
                '• Más de 130 frases inspiradoras.\n'
                '• Modo oscuro para vista nocturna.\n'
                '• Bloqueo de seguridad por PIN o huella.',
            isDark: isDark,
            textSecondary: textSecondary,
          ),

          const SizedBox(height: 16),

          // Privacidad
          _buildSection(
            icon: Icons.shield,
            title: 'Privacidad',
            content: 'ExchangeRate respeta tu privacidad. Todos tus datos financieros '
                'se almacenan localmente en tu dispositivo. '
                'No compartimos información con terceros.',
            isDark: isDark,
            textSecondary: textSecondary,
          ),

          const SizedBox(height: 24),

          // Footer
          Center(
            child: Text(
              'Desarrollado con ❤️\n© 2026 ExchangeRate - Todos los derechos reservados',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
    required bool isDark,
    required Color textSecondary,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
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
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primaryColor, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}