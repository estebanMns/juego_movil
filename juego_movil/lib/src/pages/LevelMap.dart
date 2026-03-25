import 'package:flutter/material.dart';
import 'dart:math';

// Modelo de datos para cada nivel
class LevelData {
  final int id;
  final String name;
  final LevelStatus status;
  final Offset position;
  final bool isBossLevel;

  LevelData({
    required this.id,
    required this.name,
    required this.status,
    required this.position,
    this.isBossLevel = false,
  });
}

enum LevelStatus { locked, available, completed }

// Widget principal del mapa de niveles
class Levelmap extends StatefulWidget {
  const Levelmap({super.key});

  @override
  State<Levelmap> createState() => _LevelmapState();
}

class _LevelmapState extends State<Levelmap> with TickerProviderStateMixin {
  late List<LevelData> levels;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    _initializeLevels();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeLevels() {
    levels = List.generate(20, (index) {
      final levelNumber = index + 1;
      // Crear patrón serpenteante (zig-zag)
      final row = (index / 5).floor();
      final col = index % 5;
      
      // Calcular posición en patrón serpenteante
      double xPos;
      if (row.isEven) {
        xPos = 0.15 + (col * 0.17); // Izquierda a derecha
      } else {
        xPos = 0.85 - (col * 0.17); // Derecha a izquierda
      }
      
      final yPos = 0.08 + (index * 0.048);
      
      // Determinar estado del nivel
      LevelStatus status;
      if (levelNumber == 1) {
        status = LevelStatus.completed;
      } else if (levelNumber == 2) {
        status = LevelStatus.available;
      } else if (levelNumber <= 5) {
        status = LevelStatus.locked;
      } else {
        status = LevelStatus.locked;
      }

      return LevelData(
        id: levelNumber,
        name: 'Nivel $levelNumber',
        status: status,
        position: Offset(xPos, yPos),
        isBossLevel: levelNumber % 5 == 0,
      );
    });
  }

  void _onLevelTap(LevelData level) {
    if (level.status != LevelStatus.locked) {
      Navigator.pushNamed(
        context,
        '/level-detail',
        arguments: {'levelId': level.id, 'levelName': level.name},
      );
    } else {
      // Feedback visual para nivel bloqueado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Completa el nivel anterior para desbloquear'),
          backgroundColor: Colors.grey[800],
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a0b2e),
              Color(0xFF2d1b4e),
              Color(0xFF0f0c29),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Fondo de estrellas
            _buildStarField(),
            
            // Título
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.purple.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: const Text(
                    'Mapa de Niveles',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
            
            // Scroll de niveles
            Positioned(
              top: 130,
              bottom: 40,
              left: 0,
              right: 0,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  height: 1200, // Altura suficiente para 20 niveles
                  child: Stack(
                    children: [
                      // Línea de conexión (camino de asteroides)
                      _buildPathConnection(),
                      
                      // Niveles
                      ...levels.map((level) => _buildLevelNode(level)),
                    ],
                  ),
                ),
              ),
            ),
            
            // Botón de regreso
            Positioned(
              top: 50,
              left: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarField() {
    return Stack(
      children: List.generate(50, (index) {
        final random = Random(index);
        return Positioned(
          left: random.nextDouble() * MediaQuery.of(context).size.width,
          top: random.nextDouble() * MediaQuery.of(context).size.height,
          child: AnimatedOpacity(
            opacity: random.nextDouble() * 0.8 + 0.2,
            duration: Duration(
              milliseconds: random.nextInt(2000) + 1000,
            ),
            child: Container(
              width: random.nextDouble() * 3 + 1,
              height: random.nextDouble() * 3 + 1,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPathConnection() {
    return CustomPaint(
      size: Size.infinite,
      painter: PathPainter(levels: levels),
    );
  }

  Widget _buildLevelNode(LevelData level) {
    return Positioned(
      left: level.position.dx * MediaQuery.of(context).size.width,
      top: level.position.dy * 1200,
      child: GestureDetector(
        onTap: () => _onLevelTap(level),
        child: AnimatedScale(
          scale: level.status == LevelStatus.available ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: _buildLevelWidget(level),
        ),
      ),
    );
  }

  Widget _buildLevelWidget(LevelData level) {
    final size = level.isBossLevel ? 70.0 : 60.0;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: _getLevelGradient(level),
        boxShadow: _getLevelShadow(level),
        border: Border.all(
          color: _getLevelBorderColor(level),
          width: level.status == LevelStatus.available ? 3 : 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Icono o número
          if (level.status == LevelStatus.locked)
            const Icon(Icons.lock, color: Colors.white70, size: 24)
          else if (level.status == LevelStatus.completed)
            const Icon(Icons.star, color: Colors.amber, size: 28)
          else
            Text(
              '${level.id}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          
          // Indicador de nivel jefe
          if (level.isBossLevel)
            Positioned(
              top: -5,
              right: -5,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.yellow,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Gradient _getLevelGradient(LevelData level) {
    switch (level.status) {
      case LevelStatus.locked:
        return const LinearGradient(
          colors: [Color(0xFF4a4a4a), Color(0xFF2a2a2a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case LevelStatus.available:
        return const LinearGradient(
          colors: [Color(0xFF00d2ff), Color(0xFF3a7bd5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case LevelStatus.completed:
        return const LinearGradient(
          colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  List<BoxShadow> _getLevelShadow(LevelData level) {
    if (level.status == LevelStatus.locked) {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ];
    } else if (level.status == LevelStatus.available) {
      return [
        BoxShadow(
          color: Colors.blue.withOpacity(0.6),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];
    } else {
      return [
        BoxShadow(
          color: Colors.pink.withOpacity(0.6),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];
    }
  }

  Color _getLevelBorderColor(LevelData level) {
    switch (level.status) {
      case LevelStatus.locked:
        return Colors.white30;
      case LevelStatus.available:
        return Colors.cyanAccent;
      case LevelStatus.completed:
        return Colors.amber;
    }
  }
}

// Pintor personalizado para la línea de conexión entre niveles
class PathPainter extends CustomPainter {
  final List<LevelData> levels;
  
  PathPainter({required this.levels});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    if (levels.isNotEmpty) {
      final firstLevel = levels.first;
      path.moveTo(
        firstLevel.position.dx * size.width + 30,
        firstLevel.position.dy * 1200 + 30,
      );

      for (int i = 1; i < levels.length; i++) {
        final level = levels[i];
        final prevLevel = levels[i - 1];
        
        // Crear curva suave entre niveles
        final midX = (prevLevel.position.dx + level.position.dx) * size.width / 2;
        final midY = (prevLevel.position.dy + level.position.dy) * 1200 / 2;
        
        path.quadraticBezierTo(
          midX,
          prevLevel.position.dy * 1200 + 30,
          level.position.dx * size.width + 30,
          level.position.dy * 1200 + 30,
        );
      }
    }

    canvas.drawPath(path, paint);

    // Dibujar asteroides pequeños en el camino
    _drawAsteroids(canvas, size);
  }

  void _drawAsteroids(Canvas canvas, Size size) {
    final random = Random(42);
    final asteroidPaint = Paint()
      ..color = Colors.grey.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 4 + 2;
      
      canvas.drawCircle(Offset(x, y), radius, asteroidPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}