import 'package:flutter/material.dart';
import 'dart:math';

// ============================================================
// MODELO DE DATOS
// ============================================================

enum LevelStatus { locked, available, completed, tutorial }

class LevelData {
  final int id;
  final String name;
  final LevelStatus status;
  final bool isBossLevel;
  final int row;
  final int col;

  LevelData({
    required this.id,
    required this.name,
    required this.status,
    this.isBossLevel = false,
    required this.row,
    required this.col,
  });
}

// ============================================================
// WIDGET PRINCIPAL
// ============================================================

class Levelmap extends StatefulWidget {
  const Levelmap({super.key});

  @override
  State<Levelmap> createState() => _LevelmapState();
}

class _LevelmapState extends State<Levelmap> with TickerProviderStateMixin {
  late List<LevelData> levels;
  final ScrollController _scrollController = ScrollController();

  // Animaciones
  late AnimationController _characterController;
  late Animation<double> _characterBounce;
  late AnimationController _glowController;
  late Animation<double> _glowAnim;

  int _currentLevelIndex = 0; // Ahora empieza en el nivel 0

  @override
  void initState() {
    super.initState();
    _initializeLevels();

    _characterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _characterBounce = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _characterController, curve: Curves.easeInOut),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _glowAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Scroll automático al nivel tutorial (nivel 0)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentLevel();
    });
  }

  @override
  void dispose() {
    _characterController.dispose();
    _glowController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentLevel() {
    if (_currentLevelIndex >= 0 && _currentLevelIndex < levels.length) {
      final screenHeight = MediaQuery.of(context).size.height;
      final scrollPosition = (_currentLevelIndex * 120.0) - (screenHeight / 4);
      
      _scrollController.animateTo(
        scrollPosition.clamp(0.0, double.infinity),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  void _initializeLevels() {
    // Creamos 21 niveles: 0 (tutorial) + 1 al 20
    levels = List.generate(21, (index) {
      LevelStatus status;
      
      if (index == 0) {
        // Nivel 0: Tutorial (disponible pero diferente)
        status = LevelStatus.tutorial;
      } else if (index == 1) {
        // Nivel 1: Completado
        status = LevelStatus.completed;
      } else if (index == 2) {
        // Nivel 2: Disponible (azul)
        status = LevelStatus.available;
      } else {
        // Nivel 3-20: Bloqueados
        status = LevelStatus.locked;
      }
      
      // Calcular fila y columna para distribución en grid
      final row = (index / 3).floor(); // 3 columnas
      final col = index % 3;
      
      return LevelData(
        id: index,
        name: index == 0 ? 'Tutorial' : 'Nivel $index',
        status: status,
        isBossLevel: index > 0 && index % 5 == 0,
        row: row,
        col: col,
      );
    });

    _currentLevelIndex = 0; // Personaje en nivel tutorial
  }

  // ============================================================
  // CALCULAR POSICIÓN DE CADA NIVEL
  // ============================================================

  Offset _getLevelPosition(LevelData level, double screenWidth) {
    final double horizontalPadding = screenWidth * 0.12; // 12% a cada lado
    final double availableWidth = screenWidth - (horizontalPadding * 2);
    final double columnWidth = availableWidth / 3;
    
    // Posición X con patrón zigzag
    double xPos;
    if (level.row.isEven) {
      // Fila par: izquierda a derecha
      xPos = horizontalPadding + (level.col * columnWidth) + (columnWidth / 2);
    } else {
      // Fila impar: derecha a izquierda
      xPos = horizontalPadding + ((2 - level.col) * columnWidth) + (columnWidth / 2);
    }
    
    // Posición Y: espaciado vertical generoso
    final double yPos = 200 + (level.row * 140.0);
    
    return Offset(xPos, yPos);
  }

  // ============================================================
  // BUILD PRINCIPAL
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // IMAGEN DE FONDO
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondolevels.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Overlay oscuro
          Container(color: Colors.black.withOpacity(0.25)),

          // SCROLL VIEW CON LOS NIVELES
          _buildScrollView(size),

          // Header fijo
          _buildHeader(),

          // Botón regresar
          _buildBackButton(),
        ],
      ),
    );
  }

  // ============================================================
  // SCROLL VIEW
  // ============================================================

  Widget _buildScrollView(Size screenSize) {
    // Calcular altura total necesaria
    final totalHeight = 200 + ((levels.length / 3).ceil() * 140.0) + 200;

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: screenSize.width,
        height: totalHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Camino entre nodos
            CustomPaint(
              size: Size(screenSize.width, totalHeight),
              painter: _PathPainter(
                levels: levels,
                getLevelPosition: _getLevelPosition,
                screenWidth: screenSize.width,
              ),
            ),

            // Niveles
            ...levels.map((level) {
              final position = _getLevelPosition(level, screenSize.width);
              return _buildLevelNode(level, position);
            }).toList(),

            // Personaje
            if (_currentLevelIndex >= 0)
              _buildCharacter(
                _getLevelPosition(levels[_currentLevelIndex], screenSize.width),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelNode(LevelData level, Offset position) {
    final double nodeSize = level.isBossLevel ? 75.0 : 65.0;

    return Positioned(
      left: position.dx - nodeSize / 2,
      top: position.dy - nodeSize / 2,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 300 + (level.id * 50)),
        curve: Curves.elasticOut,
        builder: (_, value, child) => Transform.scale(scale: value, child: child),
        child: GestureDetector(
          onTap: () => _onLevelTap(level),
          child: _LevelNode(
            level: level,
            size: nodeSize,
            glowAnim: _glowAnim,
          ),
        ),
      ),
    );
  }

  Widget _buildCharacter(Offset levelPos) {
    const double characterSize = 55.0;
    const double floatAbove = 70.0;

    return AnimatedBuilder(
      animation: _characterBounce,
      builder: (_, child) {
        return Positioned(
          left: levelPos.dx - characterSize / 2,
          top: levelPos.dy - floatAbove + _characterBounce.value,
          child: child!,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: characterSize,
            height: characterSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.cyanAccent, width: 3.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.7),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/yoongi.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 30);
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withOpacity(0.95),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Text(
              'Tú',
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER Y BOTONES
  // ============================================================

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 12,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.purpleAccent.withOpacity(0.6),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purpleAccent.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Text(
              'Mapa de Niveles',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.3,
                shadows: [
                  Shadow(
                    color: Colors.purpleAccent,
                    blurRadius: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  void _onLevelTap(LevelData level) {
    if (level.status == LevelStatus.locked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.lock_outline, color: Colors.white),
              SizedBox(width: 10),
              Text('Completa el nivel anterior para desbloquear'),
            ],
          ),
          backgroundColor: Colors.purple[900],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    
    Navigator.pushNamed(
      context,
      '/level-detail',
      arguments: {'levelId': level.id, 'levelName': level.name},
    );
  }
}

// ============================================================
// WIDGET: NODO DE NIVEL
// ============================================================

class _LevelNode extends StatelessWidget {
  final LevelData level;
  final double size;
  final Animation<double> glowAnim;

  const _LevelNode({
    required this.level,
    required this.size,
    required this.glowAnim,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnim,
      builder: (_, __) {
        final glow = (level.status == LevelStatus.available || 
                      level.status == LevelStatus.tutorial) 
            ? glowAnim.value 
            : 1.0;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _gradient(),
            boxShadow: _shadow(glow),
            border: Border.all(
              color: _borderColor(),
              width: (level.status == LevelStatus.available || 
                      level.status == LevelStatus.tutorial) ? 3.5 : 2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _centerIcon(),
              if (level.isBossLevel) _bossBadge(),
            ],
          ),
        );
      },
    );
  }

  Widget _centerIcon() {
    switch (level.status) {
      case LevelStatus.locked:
        return Icon(
          Icons.lock_rounded,
          color: Colors.white.withOpacity(0.6),
          size: size * 0.42,
        );
      case LevelStatus.completed:
        return Icon(
          Icons.star_rounded,
          color: Colors.amber[300],
          size: size * 0.52,
        );
      case LevelStatus.tutorial:
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 28,
            ),
            SizedBox(height: 2),
            Text(
              '0',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      case LevelStatus.available:
        return Text(
          '${level.id}',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.42,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: Colors.black45, blurRadius: 4),
            ],
          ),
        );
    }
  }

  Widget _bossBadge() => Positioned(
        top: -2,
        right: -2,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            color: Color(0xFFFF3B30),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.red, blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: const Icon(
            Icons.emoji_events_rounded,
            color: Colors.amber,
            size: 16,
          ),
        ),
      );

  Gradient _gradient() {
    switch (level.status) {
      case LevelStatus.locked:
        return const LinearGradient(
          colors: [Color(0xFF4a4a5a), Color(0xFF2a2a3a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case LevelStatus.tutorial:
        // Nivel 0: Morado brillante
        return const LinearGradient(
          colors: [Color(0xFFB794F6), Color(0xFF805AD5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case LevelStatus.available:
        // Nivel 2+: Azul brillante
        return const LinearGradient(
          colors: [Color(0xFF00d2ff), Color(0xFF0070f3)],
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

  List<BoxShadow> _shadow(double glow) {
    switch (level.status) {
      case LevelStatus.locked:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ];
      case LevelStatus.tutorial:
        // Sombra morada para el tutorial
        return [
          BoxShadow(
            color: const Color(0xFF805AD5).withOpacity(0.7 * glow),
            blurRadius: 30 * glow,
            spreadRadius: 5 * glow,
          ),
        ];
      case LevelStatus.available:
        return [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.7 * glow),
            blurRadius: 30 * glow,
            spreadRadius: 5 * glow,
          ),
        ];
      case LevelStatus.completed:
        return [
          BoxShadow(
            color: Colors.pinkAccent.withOpacity(0.5),
            blurRadius: 18,
            spreadRadius: 3,
          ),
        ];
    }
  }

  Color _borderColor() {
    switch (level.status) {
      case LevelStatus.locked:
        return Colors.white24;
      case LevelStatus.tutorial:
        return const Color(0xFFD6BCFA); // Morado claro
      case LevelStatus.available:
        return Colors.cyanAccent;
      case LevelStatus.completed:
        return Colors.amber[300]!;
    }
  }
}

// ============================================================
// CUSTOM PAINTER: CAMINO
// ============================================================

class _PathPainter extends CustomPainter {
  final List<LevelData> levels;
  final Function(LevelData, double) getLevelPosition;
  final double screenWidth;

  const _PathPainter({
    required this.levels,
    required this.getLevelPosition,
    required this.screenWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (levels.length < 2) return;

    final paintCompleted = Paint()
      ..color = Colors.amber.withOpacity(0.6)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintLocked = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < levels.length - 1; i++) {
      final currentLevel = levels[i];
      final nextLevel = levels[i + 1];

      final p0 = getLevelPosition(currentLevel, screenWidth);
      final p1 = getLevelPosition(nextLevel, screenWidth);

      // Crear camino curvo
      final path = Path()..moveTo(p0.dx, p0.dy);
      
      // Punto de control para curva suave
      final cp = Offset(
        (p0.dx + p1.dx) / 2,
        (p0.dy + p1.dy) / 2 + 20,
      );
      
      path.quadraticBezierTo(cp.dx, cp.dy, p1.dx, p1.dy);

      canvas.drawPath(
        path,
        currentLevel.status == LevelStatus.completed || 
        currentLevel.status == LevelStatus.tutorial
            ? paintCompleted 
            : paintLocked,
      );
    }

    // Partículas brillantes en el camino
    _drawParticles(canvas);
  }

  void _drawParticles(Canvas canvas) {
    final rand = Random(123);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < levels.length - 1; i++) {
      final p0 = getLevelPosition(levels[i], screenWidth);
      final p1 = getLevelPosition(levels[i + 1], screenWidth);
      
      for (int j = 0; j < 4; j++) {
        final t = rand.nextDouble();
        final x = p0.dx + (p1.dx - p0.dx) * t + (rand.nextDouble() - 0.5) * 40;
        final y = p0.dy + (p1.dy - p0.dy) * t + (rand.nextDouble() - 0.5) * 20;
        final radius = rand.nextDouble() * 4 + 2;
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PathPainter old) =>
      old.levels != levels || old.screenWidth != screenWidth;
}