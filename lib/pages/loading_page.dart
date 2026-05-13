import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/app_colors.dart';
import '../models/dolar_model.dart';
import 'home_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  
  Map<String, DolarModel>? rates;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    
    // Configurar animaciones
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Iniciar animación
    _animationController.forward();

    // Iniciar carga de datos
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      // Esperar un poco para mostrar la animación
      await Future.delayed(const Duration(seconds: 2));

      // Obtener tasas
      final response = await http.get(
        Uri.parse('https://ve.dolarapi.com/v1/dolares'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        Map<String, DolarModel> loadedRates = {};
        
        for (var item in jsonList) {
          loadedRates[item['fuente']] = DolarModel.fromJson(item);
        }
        
        if (mounted) {
          // Transición suave a la página principal
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => 
                HomePage(rates: loadedRates),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 600),
            ),
          );
        }
      } else {
        _showError('Error al cargar las tasas');
      }
    } catch (e) {
      _showError('Error de conexión: ${e.toString()}');
    }
  }

  void _showError(String message) {
    if (mounted) {
      setState(() => _hasError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: AppColors.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          action: SnackBarAction(
            label: 'Reintentar',
            textColor: Colors.white,
            onPressed: () {
              setState(() => _hasError = false);
              _initApp();
            },
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.secondaryColor,
              Color(0xFF00332E),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Círculos decorativos
            Positioned(
              top: -80,
              right: -80,
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            
            Positioned(
              bottom: -40,
              left: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                    width: 2,
                  ),
                ),
              ),
            ),

            // Líneas decorativas
            Positioned(
              top: 30.0,
              left: -20,
              child: Container(
                width: 100,
                height: 1,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            
            Positioned(
              bottom: 35.0,
              right: -20,
              child: Container(
                width: 80,
                height: 1,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            
            // Contenido principal
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo animado
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.currency_exchange,
                          size: 55,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Título animado
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        const Text(
                          'ExchangeRate',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 50,
                          height: 2,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'TASAS DE CAMBIO EN TIEMPO REAL',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Indicador de carga o error
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _hasError
                        ? Column(
                            children: [
                              Icon(
                                Icons.signal_wifi_off,
                                color: Colors.white.withOpacity(0.8),
                                size: 30,
                              ),
                              const SizedBox(height: 12),
                              TextButton.icon(
                                onPressed: () {
                                  setState(() => _hasError = false);
                                  _initApp();
                                },
                                icon: const Icon(Icons.refresh, color: Colors.white),
                                label: const Text(
                                  'Reintentar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                width: 35,
                                height: 35,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white.withOpacity(0.9),
                                  ),
                                  strokeWidth: 3,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'Obteniendo tasas actualizadas...',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 13,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            
            // Footer
            Positioned(
              bottom: 35,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified_user,
                          color: Colors.white.withOpacity(0.4),
                          size: 12,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Datos actualizados en tiempo real',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 11,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'v1.0.0',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.25),
                        fontSize: 10,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}