import 'dart:math';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

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
      duration: const Duration(milliseconds: 500),
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
    return GestureDetector(
      onTap: _nextLaw,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor.withOpacity(0.1),
                AppColors.secondaryColor.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: AppColors.primaryColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Las 48 Leyes del Poder",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Ley ${_currentLawIndex + 1}",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.touch_app,
                          size: 14,
                          color: AppColors.primaryColor.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Ley actual
              Text(
                '"${laws[_currentLawIndex]}"',
                style: const TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Indicador
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.tap_and_play,
                    size: 14,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Toca para cambiar",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[400],
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