import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/theme_provider.dart';

class PowerQuoteWidget extends StatefulWidget {
  const PowerQuoteWidget({super.key});

  @override
  State<PowerQuoteWidget> createState() => _PowerQuoteWidgetState();
}

class _PowerQuoteWidgetState extends State<PowerQuoteWidget>
    with SingleTickerProviderStateMixin {
  
  final List<String> laws = [
    "Nunca le hagas sombra a tu superior.",
    "Nunca confíes demasiado en tus amigos; aprende a utilizar a tus enemigos.",
    "Disimula tus intenciones.",
    "Di siempre menos de lo necesario.",
    "Casi todo depende de tu prestigio; defiéndelo a muerte.",
    "Busca llamar la atención a cualquier precio.",
    "Logra que otros trabajen por ti y llévate los laureles.",
    "Haz que la gente vaya hacia ti.",
    "Gana a través de tus acciones, nunca por medio de argumentos.",
    "Evita a los perdedores y los desdichados.",
    "Haz que la gente dependa de ti.",
    "Utiliza la franqueza y generosidad en forma selectiva para desarmar.",
    "Apela al interés propio de la gente, no a su compasión.",
    "Muéstrate como un amigo pero actúa como un espía.",
    "Aplasta por completo a tu enemigo.",
    "Utiliza la ausencia para incrementar el respeto y el honor.",
    "Mantén el suspenso, maneja el arte de lo impredecible.",
    "El aislamiento es peligroso, no construyas fortalezas.",
    "Averigua con quién estás tratando, no ofendas a la persona equivocada.",
    "No te comprometas con nadie.",
    "Finge inferioridad, hazlos sentir más inteligentes.",
    "Transforma la debilidad en poder: utiliza la capitulación.",
    "Concentra tus fuerzas.",
    "Desempeña el papel del cortesano perfecto.",
    "Procura recrearte permanentemente.",
    "Mantén tus manos limpias.",
    "Juega con la necesidad de la gente de tener fe en algo.",
    "Entra en acción con decisión.",
    "Planifica tus acciones de principio a fin.",
    "Haz que tus logros parezcan no requerir esfuerzos.",
    "Controla las opciones de los demás.",
    "Juega con las fantasías de la gente.",
    "Descubre el talón de Aquiles de los demás.",
    "Actúa como un rey para ser tratado como tal.",
    "Domina el arte de la oportunidad.",
    "Menosprecia las cosas que no puedes obtener.",
    "Arma espectáculos imponentes.",
    "Piensa como quieras, pero compórtate como los demás.",
    "Revuelve las aguas para asegurarte una buena pesca.",
    "Menosprecia lo que es gratuito.",
    "Evita ocupar el lugar de un grande.",
    "Golpea al pastor y las ovejas se dispersarán.",
    "Conquista los corazones y las mentes de los demás.",
    "Desarma y enfurece con el efecto espejo.",
    "Predica la necesidad de cambios, pero no modifiques demasiado a la vez.",
    "Nunca te muestres demasiado perfecto.",
    "Al triunfar, aprende cuándo detenerte.",
    "Sé cambiante en tu forma.",
  ];

  late int _currentLawIndex;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    
    _currentLawIndex = _random.nextInt(laws.length);
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  void _nextLaw() {
    // Efecto de vibración o feedback táctil
    _animationController.reverse().then((_) {
      setState(() {
        int newIndex;
        do {
          newIndex = _random.nextInt(laws.length);
        } while (newIndex == _currentLawIndex && laws.length > 1);
        
        _currentLawIndex = newIndex;
      });
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    
    return GestureDetector(
      onTap: _nextLaw,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    AppColors.primaryColor.withOpacity(0.15),
                    AppColors.secondaryColor.withOpacity(0.05),
                  ]
                : [
                    AppColors.primaryColor.withOpacity(0.08),
                    AppColors.secondaryColor.withOpacity(0.03),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(isDark ? 0.3 : 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(isDark ? 0.1 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: isDark ? const Color(0xFF4DB6AC) : AppColors.primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Las 48 Leyes del Poder",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: textPrimary,
                      ),
                    ),
                  ),
                  // Badge de número de ley
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Ley ${_currentLawIndex + 1}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? const Color(0xFF4DB6AC) : AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.shuffle,
                          size: 14,
                          color: isDark ? const Color(0xFF4DB6AC) : AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Línea decorativa
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor.withOpacity(0.0),
                      AppColors.primaryColor.withOpacity(isDark ? 0.3 : 0.15),
                      AppColors.primaryColor.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 14),
              
              // Ley actual con comillas decorativas
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"',
                    style: TextStyle(
                      fontSize: 40,
                      color: AppColors.primaryColor.withOpacity(0.5),
                      height: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        laws[_currentLawIndex],
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: textSecondary,
                          height: 1.5,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Indicador de interacción
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app_outlined,
                    size: 13,
                    color: isDark ? Colors.grey[500] : Colors.grey[400],
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Toca para descubrir otra ley",
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}