import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/theme_provider.dart';
import '../models/quote_model.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage>
    with SingleTickerProviderStateMixin {
  
   final List<Quote> quotes = [
      // Las 48 Leyes del Poder - Robert Greene (completas)
    const Quote(texto: "Nunca le hagas sombra a tu superior.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 1"),
    const Quote(texto: "Nunca confíes demasiado en tus amigos; aprende a utilizar a tus enemigos.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 2"),
    const Quote(texto: "Disimula tus intenciones.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 3"),
    const Quote(texto: "Di siempre menos de lo necesario.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 4"),
    const Quote(texto: "Casi todo depende de tu prestigio; defiéndelo a muerte.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 5"),
    const Quote(texto: "Busca llamar la atención a cualquier precio.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 6"),
    const Quote(texto: "Logra que otros trabajen por ti, pero no dejes de llevarte los laureles.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 7"),
    const Quote(texto: "Haz que la gente vaya hacia ti y, de ser necesario, utiliza la carnada más adecuada.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 8"),
    const Quote(texto: "Gana a través de tus acciones, nunca por medio de argumentos.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 9"),
    const Quote(texto: "Peligro de contagio: evita a los perdedores y los desdichados.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 10"),
    const Quote(texto: "Haz que la gente dependa de ti.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 11"),
    const Quote(texto: "Para desarmar a tu víctima, utiliza la franqueza y la generosidad en forma selectiva.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 12"),
    const Quote(texto: "Cuando pidas ayuda, no apeles a la compasión o a la gratitud de la gente, sino a su propio interés.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 13"),
    const Quote(texto: "Muéstrate como un amigo pero actúa como un espía.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 14"),
    const Quote(texto: "Aplasta por completo a tu enemigo.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 15"),
    const Quote(texto: "Utiliza la ausencia para incrementar el respeto y el honor.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 16"),
    const Quote(texto: "Mantén el suspenso. Maneja el arte de lo impredecible.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 17"),
    const Quote(texto: "No construyas fortalezas para protegerte: el aislamiento es peligroso.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 18"),
    const Quote(texto: "Averigua con quién estás tratando: no ofendas a la persona equivocada.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 19"),
    const Quote(texto: "No te comprometas con nadie.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 20"),
    const Quote(texto: "Finge inferioridad para convencer a los demás: hazlos sentir más inteligentes.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 21"),
    const Quote(texto: "Transforma la debilidad en poder: utiliza la táctica de la capitulación.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 22"),
    const Quote(texto: "Concentra tus fuerzas.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 23"),
    const Quote(texto: "Desempeña el papel del cortesano perfecto.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 24"),
    const Quote(texto: "Procura recrearte permanentemente.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 25"),
    const Quote(texto: "Mantén tus manos limpias.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 26"),
    const Quote(texto: "Juega con la necesidad de la gente de tener fe en algo, para conseguir seguidores incondicionales.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 27"),
    const Quote(texto: "Entra en acción con decisión.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 28"),
    const Quote(texto: "Planifica tus acciones de principio a fin.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 29"),
    const Quote(texto: "Haz que tus logros parezcan no requerir esfuerzos.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 30"),
    const Quote(texto: "Controla las opciones de los demás: haz que jueguen con las cartas que repartes.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 31"),
    const Quote(texto: "Juega con las fantasías de la gente.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 32"),
    const Quote(texto: "Descubre el talón de Aquiles de los demás.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 33"),
    const Quote(texto: "Actúa como un rey para ser tratado como tal.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 34"),
    const Quote(texto: "Domina el arte de la oportunidad.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 35"),
    const Quote(texto: "Menosprecia las cosas que no puedes obtener: ignorarlas es la mejor de las venganzas.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 36"),
    const Quote(texto: "Arma espectáculos imponentes.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 37"),
    const Quote(texto: "Piensa como quieras, pero compórtate como los demás.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 38"),
    const Quote(texto: "Revuelve las aguas para asegurarte una buena pesca.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 39"),
    const Quote(texto: "Menosprecia lo que es gratuito.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 40"),
    const Quote(texto: "Evita ocupar el lugar de un grande.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 41"),
    const Quote(texto: "Golpea al pastor y las ovejas se dispersarán.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 42"),
    const Quote(texto: "Conquista los corazones y las mentes de los demás.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 43"),
    const Quote(texto: "Desarma y enfurece con el efecto espejo.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 44"),
    const Quote(texto: "Predica la necesidad de introducir cambios, pero nunca modifiques demasiado a la vez.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 45"),
    const Quote(texto: "Nunca te muestres demasiado perfecto.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 46"),
    const Quote(texto: "No vayas más allá de tu objetivo original; al triunfar, aprende cuándo detenerte.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 47"),
    const Quote(texto: "Sé cambiante en tu forma.", autor: "Robert Greene", libro: "Las 48 Leyes del Poder - Ley 48"),
        
    // El Arte de la Guerra - Sun Tzu
    const Quote(texto: "El arte supremo de la guerra es someter al enemigo sin luchar.", autor: "Sun Tzu", libro: "El Arte de la Guerra"),
    const Quote(texto: "Si conoces al enemigo y te conoces a ti mismo, no debes temer el resultado de cien batallas.", autor: "Sun Tzu", libro: "El Arte de la Guerra"),
    const Quote(texto: "La mejor victoria es vencer sin combatir.", autor: "Sun Tzu", libro: "El Arte de la Guerra"),
    const Quote(texto: "En el caos, hay oportunidad.", autor: "Sun Tzu", libro: "El Arte de la Guerra"),
    const Quote(texto: "La rapidez es la esencia de la guerra.", autor: "Sun Tzu", libro: "El Arte de la Guerra"),
    
    // Padre Rico, Padre Pobre - Robert Kiyosaki
    const Quote(texto: "Los ricos no trabajan por dinero, hacen que el dinero trabaje para ellos.", autor: "Robert Kiyosaki", libro: "Padre Rico, Padre Pobre"),
    const Quote(texto: "La principal razón por la que la gente lucha financieramente es porque han pasado años en la escuela pero no aprendieron nada sobre el dinero.", autor: "Robert Kiyosaki", libro: "Padre Rico, Padre Pobre"),
    const Quote(texto: "No es cuánto dinero ganas, sino cuánto dinero guardas.", autor: "Robert Kiyosaki", libro: "Padre Rico, Padre Pobre"),
    
    // Piense y Hágase Rico - Napoleon Hill
    const Quote(texto: "Cualquier cosa que la mente pueda concebir y creer, puede lograrse.", autor: "Napoleon Hill", libro: "Piense y Hágase Rico"),
    const Quote(texto: "La fortuna favorece a los audaces.", autor: "Napoleon Hill", libro: "Piense y Hágase Rico"),
    
    // El Principito - Antoine de Saint-Exupéry
    const Quote(texto: "Lo esencial es invisible a los ojos.", autor: "Antoine de Saint-Exupéry", libro: "El Principito"),
    const Quote(texto: "Solo con el corazón se puede ver bien.", autor: "Antoine de Saint-Exupéry", libro: "El Principito"),
    const Quote(texto: "Eres responsable para siempre de lo que has domesticado.", autor: "Antoine de Saint-Exupéry", libro: "El Principito"),
    
    // Steve Jobs
    const Quote(texto: "Tu tiempo es limitado, no lo desperdicies viviendo la vida de otra persona.", autor: "Steve Jobs", libro: "Discurso en Stanford"),
    const Quote(texto: "La innovación distingue a un líder de un seguidor.", autor: "Steve Jobs", libro: "Pensamientos"),
    
    // Frases financieras
    const Quote(texto: "No ahorres lo que te queda después de gastar, gasta lo que te queda después de ahorrar.", autor: "Warren Buffett", libro: "Enseñanzas financieras"),
    const Quote(texto: "El dinero es un terrible amo, pero un excelente sirviente.", autor: "P.T. Barnum", libro: "Reflexiones"),

    // Después de las frases existentes, agrega:

    // El Alquimista - Paulo Coelho
    const Quote(texto: "Cuando realmente deseas algo, el universo entero conspira para que realices tu deseo.", autor: "Paulo Coelho", libro: "El Alquimista"),
    const Quote(texto: "Cada persona en la Tierra tiene un tesoro que lo está esperando.", autor: "Paulo Coelho", libro: "El Alquimista"),
    const Quote(texto: "El miedo al sufrimiento es peor que el sufrimiento mismo.", autor: "Paulo Coelho", libro: "El Alquimista"),

    // Hábitos Atómicos - James Clear
    const Quote(texto: "No te elevas al nivel de tus metas, caes al nivel de tus sistemas.", autor: "James Clear", libro: "Hábitos Atómicos"),
    const Quote(texto: "Cada acción que tomas es un voto por el tipo de persona en la que quieres convertirte.", autor: "James Clear", libro: "Hábitos Atómicos"),
    const Quote(texto: "El éxito es producto de los hábitos diarios, no de transformaciones únicas.", autor: "James Clear", libro: "Hábitos Atómicos"),

    // El Poder del Ahora - Eckhart Tolle
    const Quote(texto: "El pasado ya no tiene poder sobre el momento presente.", autor: "Eckhart Tolle", libro: "El Poder del Ahora"),
    const Quote(texto: "La vida es ahora. Nunca hubo un momento en que tu vida no fuera ahora.", autor: "Eckhart Tolle", libro: "El Poder del Ahora"),

    // 7 Hábitos de la Gente Altamente Efectiva - Stephen Covey
    const Quote(texto: "Comienza con un fin en mente.", autor: "Stephen Covey", libro: "7 Hábitos de la Gente Altamente Efectiva"),
    const Quote(texto: "Primero lo primero.", autor: "Stephen Covey", libro: "7 Hábitos de la Gente Altamente Efectiva"),
    const Quote(texto: "Busca primero entender, luego ser entendido.", autor: "Stephen Covey", libro: "7 Hábitos de la Gente Altamente Efectiva"),

    // Cómo Ganar Amigos - Dale Carnegie
    const Quote(texto: "Puedes hacer más amigos en dos meses interesándote en los demás que en dos años intentando que se interesen en ti.", autor: "Dale Carnegie", libro: "Cómo Ganar Amigos"),
    const Quote(texto: "El nombre de una persona es el sonido más dulce en cualquier idioma.", autor: "Dale Carnegie", libro: "Cómo Ganar Amigos"),
    const Quote(texto: "Habla sobre tus propios errores antes de criticar a los demás.", autor: "Dale Carnegie", libro: "Cómo Ganar Amigos"),

    // El Monje que Vendió su Ferrari - Robin Sharma
    const Quote(texto: "La mente es un jardín. Si plantas flores, obtendrás flores.", autor: "Robin Sharma", libro: "El Monje que Vendió su Ferrari"),
    const Quote(texto: "El propósito de la vida es una vida con propósito.", autor: "Robin Sharma", libro: "El Monje que Vendió su Ferrari"),
    const Quote(texto: "Invierte en ti mismo. Es la mejor inversión que harás.", autor: "Robin Sharma", libro: "El Monje que Vendió su Ferrari"),

    // Más frases financieras
    const Quote(texto: "El dinero no compra la felicidad, pero prefiero llorar en un Ferrari.", autor: "Anónimo", libro: "Refranes populares"),
    const Quote(texto: "No es tu salario lo que te hace rico, son tus hábitos de gasto.", autor: "Charles A. Jaffe", libro: "Sabiduría financiera"),
    const Quote(texto: "Invertir en conocimiento produce los mejores intereses.", autor: "Benjamin Franklin", libro: "Enseñanzas"),
    const Quote(texto: "El dinero es como el amor; mata lentamente al que lo niega.", autor: "Kahlil Gibran", libro: "Reflexiones"),
    const Quote(texto: "Nunca dependas de un solo ingreso. Invierte para crear una segunda fuente.", autor: "Warren Buffett", libro: "Consejos financieros"),
    const Quote(texto: "El ahorro es la base de la fortuna.", autor: "Proverbio chino", libro: "Sabiduría antigua"),

    // Estoicismo
    const Quote(texto: "No son las cosas las que nos perturban, sino la opinión que tenemos de ellas.", autor: "Epicteto", libro: "Enquiridión"),
    const Quote(texto: "La felicidad de tu vida depende de la calidad de tus pensamientos.", autor: "Marco Aurelio", libro: "Meditaciones"),
    const Quote(texto: "Aprende a ser indiferente a lo que no hace diferencia.", autor: "Marco Aurelio", libro: "Meditaciones"),
    const Quote(texto: "No es que tengamos poco tiempo, es que perdemos mucho.", autor: "Séneca", libro: "Sobre la Brevedad de la Vida"),
    const Quote(texto: "La dificultad es lo que despierta al genio.", autor: "Séneca", libro: "Cartas a Lucilio"),

    // Liderazgo y Éxito
    const Quote(texto: "Un líder es aquel que conoce el camino, recorre el camino y muestra el camino.", autor: "John C. Maxwell", libro: "Las 21 Leyes del Liderazgo"),
    const Quote(texto: "No encuentres la falta, encuentra el remedio.", autor: "Henry Ford", libro: "Filosofía empresarial"),
    const Quote(texto: "El éxito es ir de fracaso en fracaso sin perder el entusiasmo.", autor: "Winston Churchill", libro: "Discursos"),
    const Quote(texto: "La disciplina es el puente entre las metas y los logros.", autor: "Jim Rohn", libro: "Desarrollo personal"),
    const Quote(texto: "No puedes cambiar tu destino de la noche a la mañana, pero puedes cambiar tu dirección.", autor: "Jim Rohn", libro: "Desarrollo personal"),
    const Quote(texto: "Eres el promedio de las cinco personas con las que pasas más tiempo.", autor: "Jim Rohn", libro: "Desarrollo personal"),
    const Quote(texto: "Si no te gusta algo, cámbialo. Si no puedes cambiarlo, cambia tu actitud.", autor: "Maya Angelou", libro: "Poesía y vida"),
    const Quote(texto: "La mejor manera de predecir el futuro es crearlo.", autor: "Peter Drucker", libro: "Management"),
    const Quote(texto: "La excelencia no es un acto, es un hábito.", autor: "Aristóteles", libro: "Filosofía"),
    const Quote(texto: "Lo que no te mata, te hace más fuerte.", autor: "Friedrich Nietzsche", libro: "El Crepúsculo de los Ídolos"),

    // Más frases variadas
    const Quote(texto: "La imaginación es más importante que el conocimiento.", autor: "Albert Einstein", libro: "Pensamientos"),
    const Quote(texto: "Locura es hacer lo mismo una y otra vez esperando resultados diferentes.", autor: "Albert Einstein", libro: "Pensamientos"),
    const Quote(texto: "La educación es el arma más poderosa para cambiar el mundo.", autor: "Nelson Mandela", libro: "Discursos"),
    const Quote(texto: "Sé el cambio que quieres ver en el mundo.", autor: "Mahatma Gandhi", libro: "Enseñanzas"),
    const Quote(texto: "La vida es como montar en bicicleta. Para mantener el equilibrio debes seguir adelante.", autor: "Albert Einstein", libro: "Cartas"),
    const Quote(texto: "El éxito no es definitivo, el fracaso no es fatal: lo que cuenta es el valor para continuar.", autor: "Winston Churchill", libro: "Discursos"),
    const Quote(texto: "El mejor momento para plantar un árbol era hace 20 años. El segundo mejor momento es ahora.", autor: "Proverbio chino", libro: "Sabiduría antigua"),
    const Quote(texto: "No cuentes los días, haz que los días cuenten.", autor: "Muhammad Ali", libro: "Biografía"),
    const Quote(texto: "La felicidad no es algo hecho. Viene de tus propias acciones.", autor: "Dalai Lama", libro: "Enseñanzas"),
    const Quote(texto: "Apunta a la luna. Si fallas, al menos estarás entre las estrellas.", autor: "W. Clement Stone", libro: "Éxito"),

    // Más emprendimiento
    const Quote(texto: "El emprendimiento es vivir unos años como nadie quiere, para vivir el resto como nadie puede.", autor: "Anónimo", libro: "Emprendimiento"),
    const Quote(texto: "Si no construyes tu sueño, alguien te contratará para que ayudes a construir el suyo.", autor: "Tony Gaskins", libro: "Desarrollo personal"),
    const Quote(texto: "El 80% del éxito es presentarse.", autor: "Woody Allen", libro: "Citas"),
    const Quote(texto: "No importa lo lento que vayas, siempre y cuando no te pares.", autor: "Confucio", libro: "Analectas"),
    const Quote(texto: "La constancia vence lo que la dicha no alcanza.", autor: "Refrán popular", libro: "Sabiduría popular"),
    const Quote(texto: "El único modo de hacer un gran trabajo es amar lo que haces.", autor: "Steve Jobs", libro: "Discursos"),

    // Superación personal
    const Quote(texto: "Cree que puedes y ya estás a medio camino.", autor: "Theodore Roosevelt", libro: "Discursos"),
    const Quote(texto: "El hombre que mueve montañas comienza cargando pequeñas piedras.", autor: "Confucio", libro: "Analectas"),
    const Quote(texto: "Nunca es demasiado tarde para ser lo que podrías haber sido.", autor: "George Eliot", libro: "Literatura"),
    const Quote(texto: "El fracaso es la oportunidad de empezar de nuevo con más inteligencia.", autor: "Henry Ford", libro: "Autobiografía"),
    const Quote(texto: "No hay atajos a ningún lugar que valga la pena.", autor: "Beverly Sills", libro: "Entrevistas"),
    const Quote(texto: "La paciencia es amarga, pero su fruto es dulce.", autor: "Jean-Jacques Rousseau", libro: "Filosofía"),
    const Quote(texto: "El carácter no se desarrolla en la calma, sino en la tormenta.", autor: "Helen Keller", libro: "Biografía"),
    const Quote(texto: "Aprende como si fueras a vivir para siempre; vive como si fueras a morir mañana.", autor: "Mahatma Gandhi", libro: "Enseñanzas"),
    const Quote(texto: "La mente lo es todo. En lo que piensas, te conviertes.", autor: "Buda", libro: "Enseñanzas"),
    const Quote(texto: "La vida es 10% lo que te sucede y 90% cómo reaccionas.", autor: "Charles R. Swindoll", libro: "Desarrollo personal"),
    const Quote(texto: "El optimismo es la fe que conduce al logro.", autor: "Helen Keller", libro: "Escritos"),
    const Quote(texto: "Todo lo que puedas imaginar es real.", autor: "Pablo Picasso", libro: "Arte y vida"),
    const Quote(texto: "No tengas miedo de renunciar a lo bueno para ir a por lo grandioso.", autor: "John D. Rockefeller", libro: "Negocios"),
    const Quote(texto: "La diferencia entre lo posible y lo imposible está en la determinación.", autor: "Tommy Lasorda", libro: "Deportes"),
    const Quote(texto: "Si quieres volar, renuncia a todo lo que te pesa.", autor: "Toni Morrison", libro: "Literatura"),
    const Quote(texto: "El éxito no es cuánto dinero tienes, es la diferencia que marcas en la vida de las personas.", autor: "Michelle Obama", libro: "Becoming"),
    const Quote(texto: "Nunca dejes que el miedo decida tu futuro.", autor: "Anónimo", libro: "Motivación"),
    const Quote(texto: "La mejor venganza es un éxito masivo.", autor: "Frank Sinatra", libro: "Música y vida"),
    const Quote(texto: "No esperes. El tiempo nunca será justo.", autor: "Napoleon Hill", libro: "Piense y Hágase Rico"),
    const Quote(texto: "Eres más valiente de lo que crees, más fuerte de lo que pareces y más inteligente de lo que piensas.", autor: "A.A. Milne", libro: "Winnie the Pooh"),
    const Quote(texto: "La verdadera riqueza no se mide en dinero, sino en tiempo y libertad.", autor: "Anónimo", libro: "Finanzas personales"),
    const Quote(texto: "Rodéate de personas que tengan metas, que te inspiren y te desafíen.", autor: "Anónimo", libro: "Crecimiento personal"),
    const Quote(texto: "El precio de la disciplina siempre es menor que el costo del arrepentimiento.", autor: "Anónimo", libro: "Disciplina"),
    const Quote(texto: "Si buscas resultados distintos, no hagas siempre lo mismo.", autor: "Albert Einstein", libro: "Ciencia y vida"),
    const Quote(texto: "Un barco está seguro en el puerto, pero no fue para eso que se construyó.", autor: "John A. Shedd", libro: "Reflexiones"),
    const Quote(texto: "No puedes cambiar lo que no estás dispuesto a enfrentar.", autor: "James Baldwin", libro: "Literatura"),
    const Quote(texto: "Cada día es una nueva oportunidad para cambiar tu vida.", autor: "Anónimo", libro: "Motivación diaria"),
    const Quote(texto: "Lo importante no es lo que se promete, sino lo que se cumple.", autor: "Refrán popular", libro: "Sabiduría popular"),
    const Quote(texto: "Haz hoy lo que otros no quieren, haz mañana lo que otros no pueden.", autor: "Jerry Rice", libro: "Deportes"),
  ];

  late int _currentIndex;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _currentIndex = _random.nextInt(quotes.length);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  void _nextQuote() {
    _animationController.reverse().then((_) {
      setState(() {
        int newIndex;
        do {
          newIndex = _random.nextInt(quotes.length);
        } while (newIndex == _currentIndex && quotes.length > 1);
        _currentIndex = newIndex;
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
    final quote = quotes[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Frases & Reflexiones'),
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
      body: GestureDetector(
        onTap: _nextQuote,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icono
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.format_quote,
                      size: 50,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Frase
                  Text(
                    '"${quote.texto}"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: textPrimary,
                      height: 1.5,
                      letterSpacing: 0.3,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Autor
                  Text(
                    '— ${quote.autor}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  
                  const SizedBox(height: 6),
                  
                  // Libro
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      quote.libro,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Indicador
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.touch_app_outlined, size: 16, color: Colors.grey[400]),
                      const SizedBox(width: 6),
                      Text(
                        'Toca para otra frase',
                        style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Contador
                  Text(
                    '${_currentIndex + 1} de ${quotes.length}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}