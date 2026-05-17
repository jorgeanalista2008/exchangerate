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
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    
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

    _animationController.forward();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      final response = await http.get(
        Uri.parse('https://ve.dolarapi.com/v1/dolares'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        Map<String, DolarModel> loadedRates = {};
        
        for (var item in jsonList) {
          // Cambiar nombres
          if (item['fuente'] == 'paralelo') {
            item['nombre'] = 'Otra Tasa';
          }
          if (item['fuente'] == 'oficial') {
            item['nombre'] = 'BCV';
          }
          loadedRates[item['fuente']] = DolarModel.fromJson(item);
        }
        
        if (mounted) {
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
        _showError('Error al cargar las tasas.\nCódigo: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Sin conexión a internet.\nVerifica tu conexión e intenta de nuevo.');
    }
  }

  void _showError(String message) {
    if (mounted) {
      setState(() {
        _hasError = true;
        _errorMessage = message;
      });
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

            // Contenido principal
            Center(
              child: _hasError ? _buildErrorView() : _buildLoadingView(),
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

  // Vista de carga normal
  Widget _buildLoadingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
                ),
              ),
              const SizedBox(height: 8),
              Container(width: 50, height: 2, color: Colors.white.withOpacity(0.6)),
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
        FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
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
    );
  }

  // Vista de error
  Widget _buildErrorView() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wifi_off,
              color: Colors.white,
              size: 60,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Sin conexión',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _hasError = false;
                _errorMessage = '';
              });
              _initApp();
            },
            icon: const Icon(Icons.refresh, color: AppColors.primaryColor),
            label: const Text(
              'Reintentar',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}