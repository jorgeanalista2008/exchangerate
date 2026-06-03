import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';
import '../core/theme_provider.dart';
import '../models/dolar_model.dart';
import '../molecules/rate_card.dart';
import '../molecules/calculator_widget.dart';
import '../molecules/power_quote_widget.dart';
import 'finance_page.dart';
import 'widget_page.dart';
import 'security_page.dart';
import 'about_page.dart';
import 'quotes_page.dart';
// Necesitas importar estas clases
import '../database/alert_database.dart';
import '../molecules/alert_list.dart';
import '../molecules/alert_form.dart';

class HomePage extends StatefulWidget {
  final Map<String, DolarModel> rates;
  final bool isOffline;
  final DateTime? cacheTimestamp;

  const HomePage({
    super.key,
    required this.rates,
    this.isOffline = false,
    this.cacheTimestamp,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      
      // Drawer lateral
      drawer: _buildDrawer(isDark),
      
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.currency_exchange, size: 24),
            SizedBox(width: 8),
            Text("ExchangeRate"),
          ],
        ),
        centerTitle: true, // Centrar título
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
        // Solo el botón de menú a la izquierda
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        // Solo el botón de tema a la derecha
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
            tooltip: isDark ? 'Modo Claro' : 'Modo Oscuro',
          ),
        ],
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isOffline) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.amber.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.amber, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Modo Offline",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.cacheTimestamp != null
                                ? "Tasas actualizadas por última vez: ${DateFormat('dd/MM/yyyy HH:mm').format(widget.cacheTimestamp!)}"
                                : "Mostrando tasas guardadas en caché.",
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Encabezado de bienvenida
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withOpacity(isDark ? 0.15 : 0.05),
                    AppColors.secondaryColor.withOpacity(isDark ? 0.08 : 0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tasas de Cambio",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Venezuela",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('EEEE d \'de\' MMMM', 'es').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Tarjetas de tasas
            if (widget.rates['oficial'] != null && widget.rates['paralelo'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: RateCard(
                        dolar: widget.rates['oficial']!,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: RateCard(
                        dolar: widget.rates['paralelo']!,
                        color: isDark ? const Color(0xFF4DB6AC) : AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),

            // Ley del poder
         
            
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
                  CalculatorWidget(rates: widget.rates),
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

  // Menú lateral (Drawer)
  Widget _buildDrawer(bool isDark) {
    return Drawer(
      child: Container(
        color: isDark ? AppColors.darkBackground : Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              // Encabezado del Drawer
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryColor, AppColors.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.currency_exchange,
                        size: 40,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'ExchangeRate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tasas de cambio en tiempo real',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Opciones del menú
              _buildDrawerItem(
                icon: Icons.home,
                title: 'Inicio',
                isDark: isDark,
              ),
              
              _buildDrawerItem(
                icon: Icons.account_balance_wallet,
                title: 'Mis Finanzas',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FinancePage()),
                  );
                },
                isDark: isDark,
              ),
              _buildDrawerItem(
                icon: Icons.format_quote,
                title: 'Frases & Reflexiones',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuotesPage()),
                  );
                },
                isDark: isDark,
              ),
              
              _buildDrawerItem(
                icon: Icons.notifications_outlined,
                title: 'Alertas de Precio',
                onTap: () {
                  Navigator.pop(context);
                  _showAlertsDialog(context);
                },
                isDark: isDark,
              ),
              
              _buildDrawerItem(
                icon: Icons.widgets_outlined,
                title: 'Pantalla de Inicio',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WidgetPage()),
                  );
                },
                isDark: isDark,
              ),


                  _buildDrawerItem(
              icon: Icons.info_outline,
              title: 'Acerca de',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
              isDark: isDark,
            ),
              
              const Divider(),
              
              _buildDrawerItem(
                icon: Icons.security,
                title: 'Seguridad',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SecurityPage()),
                  );
                },
                isDark: isDark,
              ),

          

              const Spacer(),

              // Versión
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    required bool isDark,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : AppColors.lightTextPrimary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap ?? () => Navigator.pop(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  // Diálogos de alertas
  void _showAlertsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.notifications_active, color: AppColors.primaryColor),
            SizedBox(width: 8),
            Text('Alertas de Precio'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: AlertList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              _showAddAlertDialog(context);
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Nueva Alerta'),
          ),
        ],
      ),
    );
  }

  void _showAddAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva Alerta'),
        content: SizedBox(
          width: double.maxFinite,
          height: 350,
          child: AlertForm(
            onSave: (alert) async {
              await AlertDatabase().insertAlert(alert);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Alerta creada'), backgroundColor: Colors.green),
              );
            },
          ),
        ),
      ),
    );
  }
}

