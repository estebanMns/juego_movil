import 'package:flutter/material.dart';
import 'dart:math';

// ============================================================
// MODELO DE DATOS
// ============================================================

enum LevelStatus { locked, available, completed }

class LevelData {
  final int id;
  final String name;
  final LevelStatus status;
  final bool isBossLevel;

  LevelData({
    required this.id,
    required this.name,
    required this.status,
    this.isBossLevel = false,
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

  // Controlador de scroll
  final ScrollController _scrollController = ScrollController();

  // Animación de rebote del personaje
  late AnimationController _characterController;
  late Animation<double> _characterBounce;

  // Animación de glow pulsante del nivel disponible
  late AnimationController _glowController;
  late Animation<double> _glowAnim;

  // Animación de parpadeo de estrellas de fondo
  late AnimationController _starController;

  // Índice del nivel "available" (donde se posiciona el personaje)
  int _currentLevelIndex = 1;

  @override
  void initState() {
    super.initState();
    _initializeLevels();

    // Personaje: rebote suave arriba/abajo
    _characterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _characterBounce = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _characterController, curve: Curves.easeInOut),
    );

    // Glow pulsante del nodo disponible
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _glowAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Parpadeo de estrellas
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _characterController.dispose();
    _glowController.dispose();
    _starController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeLevels() {
    levels = List.generate(20, (index) {
      final n = index + 1;
      LevelStatus status;
      if (n == 1) {
        status = LevelStatus.completed;
      } else if (n == 2) {
        status = LevelStatus.available;
      } else {
        status = LevelStatus.locked;
      }
      return LevelData(
        id: n,
        name: 'Nivel $n',
        status: status,
        isBossLevel: n % 5 == 0,
      );
    });

    _currentLevelIndex = levels.indexWhere(
      (l) => l.status == LevelStatus.available,
    );
  }

  // ============================================================
  // CALCULAR POSICIONES EN PATRÓN SERPENTINE RESPONSIVO
  // ============================================================

  /// Genera posiciones absolutas para cada nodo adaptadas al ancho disponible.
  /// Usa 4 columnas en patrón zig-zag (izq→der / der→izq).
  List<Offset> _computeNodePositions(double availableWidth) {
    const int columns = 4;
    const double nodeSpacingY = 100.0;
    const double topPadding = 130.0;

    // Márgenes laterales: 12% del ancho a cada lado
    final double margin = availableWidth * 0.12;
    final double usable = availableWidth - margin * 2;
    final double stepX = columns > 1 ? usable / (columns - 1) : 0;

    return List.generate(levels.length, (i) {
      final row = i ~/ columns;
      final col = i % columns;

      final double x = row.isEven
          ? margin + col * stepX        // izquierda → derecha
          : margin + (columns - 1 - col) * stepX; // derecha → izquierda

      final double y = topPadding + i * nodeSpacingY;
      return Offset(x, y);
    });
  }

  // ============================================================
  // BUILD PRINCIPAL
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0d0821),
              Color(0xFF1a0b2e),
              Color(0xFF0f0c29),
              Color(0xFF06040f),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Estrellas parpadeantes de fondo
            _buildStarField(size),

            // Manchas de nebulosa decorativas
            _buildNebula(size),

            // Contenido scrolleable (camino + nodos + personaje)
            _buildScrollContent(),

            // Header fijo (con degradado para no tapar el contenido)
            _buildHeader(),

            // Botón regresar
            _buildBackButton(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FONDO: ESTRELLAS PARPADEANTES
  // ============================================================

  Widget _buildStarField(Size size) {
    final rand = Random(77);
    return Stack(
      children: List.generate(55, (i) {
        final x = rand.nextDouble() * size.width;
        final y = rand.nextDouble() * size.height;
        final r = rand.nextDouble() * 1.6 + 0.4;
        final base = rand.nextDouble() * 0.6 + 0.2;
        return Positioned(
          left: x,
          top: y,
          child: AnimatedBuilder(
            animation: _starController,
            builder: (_, _twinkleUnused) {
              final twinkle =
                  0.4 + 0.6 * ((sin(_starController.value * 2 * pi + i * 0.9) + 1) / 2);
              return Opacity(
                opacity: base * twinkle,
                child: Container(
                  width: r * 2,
                  height: r * 2,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // ============================================================
  // FONDO: NEBULOSA
  // ============================================================

  Widget _buildNebula(Size size) {
    return Stack(
      children: [
        Positioned(
          left: -90,
          top: size.height * 0.05,
          child: _nebulaBlob(280, Colors.purple, 0.10),
        ),
        Positioned(
          right: -60,
          top: size.height * 0.45,
          child: _nebulaBlob(240, Colors.blue, 0.09),
        ),
        Positioned(
          left: size.width * 0.15,
          bottom: 0,
          child: _nebulaBlob(200, Colors.pink, 0.07),
        ),
      ],
    );
  }

  Widget _nebulaBlob(double size, Color color, double opacity) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: opacity), Color(0x00000000)],
          ),
        ),
      );

  // ============================================================
  // HEADER FIJO
  // ============================================================

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0d0821),
              const Color(0xFF0d0821).withValues(alpha: 0.0),
            ],
          ),
        ),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          bottom: 20,
          left: 60,
          right: 20,
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.purpleAccent.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purpleAccent.withValues(alpha: 0.12),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Text(
              'Mapa de Niveles',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BOTÓN REGRESAR
  // ============================================================

  Widget _buildBackButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CONTENIDO SCROLLEABLE
  // ============================================================

  Widget _buildScrollContent() {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final availableWidth = constraints.maxWidth;
          final positions = _computeNodePositions(availableWidth);

          // Altura total: posición del último nodo + padding inferior
          final totalHeight = positions.last.dy + 100.0;

          return SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: availableWidth,
              height: totalHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Camino entre nodos
                  CustomPaint(
                    size: Size(availableWidth, totalHeight),
                    painter: _PathPainter(
                      positions: positions,
                      levels: levels,
                    ),
                  ),

                  // Nodos con animación de entrada escalonada
                  ...List.generate(levels.length, (i) {
                    return _buildAnimatedNode(i, positions[i], levels[i]);
                  }),

                  // Personaje flotando sobre el nivel disponible
                  if (_currentLevelIndex >= 0 &&
                      _currentLevelIndex < positions.length)
                    _buildCharacter(positions[_currentLevelIndex]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // NODO ANIMADO
  // ============================================================

  Widget _buildAnimatedNode(int index, Offset pos, LevelData level) {
    final double nodeSize = level.isBossLevel ? 68.0 : 58.0;

    return Positioned(
      left: pos.dx - nodeSize / 2,
      top: pos.dy - nodeSize / 2,
      child: TweenAnimationBuilder<double>(
        // Entrada escalonada con efecto elástico
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 400 + index * 55),
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

  // ============================================================
  // PERSONAJE (flota sobre el nivel disponible)
  // ============================================================

  Widget _buildCharacter(Offset levelPos) {
    const double characterSize = 44.0;
    const double floatAbove = 56.0; // distancia sobre el centro del nodo

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
          // ----------------------------------------------------------
          // IMAGEN DEL PERSONAJE
          // Coloca aquí la imagen del personaje que acompaña al jugador.
          // Ruta del asset: assets/image/yoongi.jpg
          // Si necesitas cambiar el personaje, actualiza solo esta ruta.
          // ----------------------------------------------------------
          Container(
            width: characterSize,
            height: characterSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.cyanAccent, width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withValues(alpha: 0.55),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/kovuIcon.jpeg', // <- imagen del personaje
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 3),
          // Flecha indicadora apuntando al nodo
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.cyanAccent.withValues(alpha: 0.9),
            size: 18,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LÓGICA DE TAP EN NIVEL
  // ============================================================

  void _onLevelTap(LevelData level) {
    if (level.status == LevelStatus.locked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('🔒 Completa el nivel anterior para desbloquear'),
          backgroundColor: const Color(0xFF1a0b2e),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.purple.withValues(alpha: 0.4)),
          ),
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
      builder: (_, _glowUnused) {
        final glow = level.status == LevelStatus.available ? glowAnim.value : 1.0;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _gradient(),
            boxShadow: _shadow(glow),
            border: Border.all(
              color: _borderColor(),
              width: level.status == LevelStatus.available ? 2.5 : 1.5,
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
          color: Colors.white.withValues(alpha: 0.5),
          size: size * 0.38,
        );
      case LevelStatus.completed:
        return Icon(
          Icons.star_rounded,
          color: Colors.amber,
          size: size * 0.46,
        );
      case LevelStatus.available:
        return Text(
          '${level.id}',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.38,
            fontWeight: FontWeight.bold,
          ),
        );
    }
  }

  Widget _bossBadge() => Positioned(
        top: -2,
        right: -2,
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            color: Color(0xFFFF3B30),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 13),
        ),
      );

  Gradient _gradient() {
    switch (level.status) {
      case LevelStatus.locked:
        return const LinearGradient(
          colors: [Color(0xFF3a3a4a), Color(0xFF1e1e2e)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case LevelStatus.available:
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
        return [BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 8, offset: const Offset(0, 4))];
      case LevelStatus.available:
        return [BoxShadow(color: Colors.cyanAccent.withValues(alpha: 0.5 * glow), blurRadius: 20 * glow, spreadRadius: 3 * glow)];
      case LevelStatus.completed:
        return [BoxShadow(color: Colors.pinkAccent.withValues(alpha: 0.4), blurRadius: 14, spreadRadius: 1)];
    }
  }

  Color _borderColor() {
    switch (level.status) {
      case LevelStatus.locked:    return Colors.white12;
      case LevelStatus.available: return Colors.cyanAccent;
      case LevelStatus.completed: return Colors.amber;
    }
  }
}

// ============================================================
// CUSTOM PAINTER: CAMINO ENTRE NODOS
// ============================================================

class _PathPainter extends CustomPainter {
  final List<Offset> positions;
  final List<LevelData> levels;

  const _PathPainter({required this.positions, required this.levels});

  @override
  void paint(Canvas canvas, Size size) {
    if (positions.length < 2) return;

    final paintDone = Paint()
      ..color = Colors.amber.withValues(alpha: 0.45)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintPending = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < positions.length - 1; i++) {
      final p0 = positions[i];
      final p1 = positions[i + 1];

      // Punto de control cuadrático para curvas suaves
      final cp = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      final seg = Path()
        ..moveTo(p0.dx, p0.dy)
        ..quadraticBezierTo(cp.dx, p0.dy, p1.dx, p1.dy);

      canvas.drawPath(
        seg,
        levels[i].status == LevelStatus.completed ? paintDone : paintPending,
      );
    }

    // Asteroides decorativos entre nodos
    _drawAsteroids(canvas);
  }

  void _drawAsteroids(Canvas canvas) {
    final rand = Random(13);
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.16)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < positions.length - 1; i++) {
      final p0 = positions[i];
      final p1 = positions[i + 1];
      for (int j = 0; j < 2; j++) {
        final t = rand.nextDouble();
        final x = p0.dx + (p1.dx - p0.dx) * t + (rand.nextDouble() - 0.5) * 28;
        final y = p0.dy + (p1.dy - p0.dy) * t;
        canvas.drawCircle(Offset(x, y), rand.nextDouble() * 3 + 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PathPainter old) =>
      old.positions != positions || old.levels != levels;
}