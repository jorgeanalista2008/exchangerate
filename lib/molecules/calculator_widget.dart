import 'package:flutter/material.dart';
import '../core/app_colors.dart';
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
  String _selectedCurrency = 'paralelo';
  double _result = 0;
  bool _isReversed = false;

  void _calculate() {
    final amount = double.tryParse(_controller.text) ?? 0;
    final rate = widget.rates[_selectedCurrency]?.promedio ?? 0;
    
    setState(() {
      _result = _isReversed ? amount / rate : amount * rate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Selector de moneda
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedCurrency = 'paralelo'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _selectedCurrency == 'paralelo'
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Paralelo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _selectedCurrency == 'paralelo'
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedCurrency = 'oficial'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Campo de entrada
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          onChanged: (_) => _calculate(),
          decoration: InputDecoration(
            labelText: _isReversed ? 'Cantidad en Bs.' : 'Cantidad en USD',
            hintText: '0.00',
            prefixIcon: Icon(
              _isReversed ? Icons.monetization_on : Icons.attach_money,
              color: AppColors.primaryColor,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.swap_horiz,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                setState(() {
                  _isReversed = !_isReversed;
                  _calculate();
                });
              },
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Resultado
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.15),
            ),
          ),
          child: Column(
            children: [
              Text(
                _isReversed ? 'Equivalente en USD' : 'Equivalente en Bs.',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _isReversed 
                    ? '\$ ${_result.toStringAsFixed(2)}'
                    : 'Bs. ${_result.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
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