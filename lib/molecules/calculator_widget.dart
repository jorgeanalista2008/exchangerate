import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';
import '../core/theme_provider.dart';
import '../models/dolar_model.dart';

class CalculatorWidget extends StatefulWidget {
  final Map<String, DolarModel> rates;

  const CalculatorWidget({
    super.key,
    required this.rates,
  });

  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  final _controller = TextEditingController();
  String _selectedCurrency = 'oficial';
  double _result = 0;
  bool _isReversed = false;

  // Obtener el locale del dispositivo
  String _getDeviceLocale() {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    return '${locale.languageCode}_${locale.countryCode}';
  }

  void _calculate() {
    // Limpiar el texto de entrada (acepta coma o punto)
    final cleanText = _controller.text
        .replaceAll('.', '')  // Quitar puntos de miles
        .replaceAll(',', '.') // Cambiar coma decimal por punto
        .replaceAll(' ', ''); // Quitar espacios
    
    final amount = double.tryParse(cleanText) ?? 0;
    final rate = widget.rates[_selectedCurrency]?.promedio ?? 0;
    
    setState(() {
      _result = rate > 0 ? (_isReversed ? amount / rate : amount * rate) : 0;
    });
  }

  // Formatear número según la región
  String _formatCurrency(double number, {String symbol = '', bool isDecimal = true}) {
    final locale = _getDeviceLocale();
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 2,
    );
    
    String formatted = formatter.format(number);
    
    // Limpiar espacios extra que pueda agregar el formateador
    formatted = formatted.replaceAll('\u00A0', ' ').trim();
    
    return formatted;
  }

  // Formatear entrada del usuario según va escribiendo
  String _formatInput(String value) {
    if (value.isEmpty) return '';
    
    // Si el usuario escribe coma, la convertimos a punto para el cálculo interno
    // pero mostramos con el formato local
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final locale = _getDeviceLocale();
    
    return Column(
      children: [
        // Selector de moneda
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
           
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCurrency = 'oficial';
                      _calculate();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _selectedCurrency == 'oficial'
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Oficial',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _selectedCurrency == 'oficial'
                            ? Colors.white
                            : textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
                 Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCurrency = 'paralelo';
                      _calculate();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _selectedCurrency == 'paralelo'
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Otra tasa',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _selectedCurrency == 'paralelo'
                            ? Colors.white
                            : textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Información de formato regional
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            children: [
              Icon(
                Icons.language,
                size: 12,
                color: textSecondary.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                'Formato: ${locale.contains('VE') ? 'Venezuela (1.000,00)' : locale.contains('US') ? 'EE.UU. (1,000.00)' : 'Automático'}',
                style: TextStyle(
                  fontSize: 10,
                  color: textSecondary.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Campo de entrada
        TextField(
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (value) {
            // Formatear mientras escribe (opcional)
            _calculate();
          },
          decoration: InputDecoration(
            labelText: _isReversed ? 'Cantidad en Bs.' : 'Cantidad en USD',
            hintText: locale.contains('VE') ? '1.000,00' : '1,000.00',
            labelStyle: TextStyle(color: textSecondary),
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
            prefixIcon: Icon(
              _isReversed ? Icons.monetization_on : Icons.attach_money,
              color: AppColors.primaryColor,
            ),
            suffixIcon: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.swap_horiz,
                  color: AppColors.primaryColor,
                ),
              ),
              onPressed: () {
                setState(() {
                  _isReversed = !_isReversed;
                  _calculate();
                });
              },
              tooltip: 'Invertir conversión',
            ),
            helperText: _isReversed 
                ? 'Ingresa el monto en Bolívares' 
                : 'Ingresa el monto en Dólares',
            helperStyle: TextStyle(
              fontSize: 11,
              color: textSecondary.withOpacity(0.6),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Resultado
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      AppColors.primaryColor.withOpacity(0.2),
                      AppColors.primaryColor.withOpacity(0.05),
                    ]
                  : [
                      AppColors.primaryColor.withOpacity(0.08),
                      AppColors.primaryColor.withOpacity(0.02),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(isDark ? 0.3 : 0.15),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isReversed ? Icons.arrow_downward : Icons.arrow_upward,
                    size: 16,
                    color: textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isReversed ? 'Equivalente en USD' : 'Equivalente en Bs.',
                    style: TextStyle(
                      fontSize: 12,
                      color: textSecondary,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _result > 0
                    ? (_isReversed 
                        ? _formatCurrency(_result, symbol: '\$ ')
                        : _formatCurrency(_result, symbol: 'Bs. '))
                    : _formatCurrency(0, symbol: _isReversed ? '\$ ' : 'Bs. '),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  letterSpacing: 0.5,
                ),
              ),
              if (_result > 0) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Tasa: ${_formatCurrency(widget.rates[_selectedCurrency]?.promedio ?? 0, symbol: 'Bs. ')}',
                    style: TextStyle(
                      fontSize: 11,
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}