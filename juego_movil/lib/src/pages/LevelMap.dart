import 'package:flutter/material.dart';
import 'dart:math';

class LevelData {
  final int id;
  final String name;
  final LevelStatus status;
  final double xFactor; // Posición horizontal (0.0 a 1.0)
  final bool isBossLevel;

  LevelData({
    required this.id,
    required this.name,
    required this.status,
    required this.xFactor,
    this.isBossLevel = false,
  });
}

enum LevelStatus { locked, available, completed }

class Levelmap extends StatefulWidget {
  const Levelmap({super.key});

  @override
  State<Levelmap> createState() => _LevelmapState();
}

class _LevelmapState extends State<Levelmap> with TickerProviderStateMixin {
  late List<LevelData> levels;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  final double itemHeight = 120.0; // Espacio vertical entre niveles

  @override
  void initState() {
    super.initState();
    _initializeLevels();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeLevels() {
    levels = List.generate(20, (index) {
      final levelNumber = index + 1;
      // Lógica de zig-zag simplificada
      double xPos = 0.5 + (0.3 * sin(index * 0.8)); 
      
      LevelStatus status;
      if (levelNumber < 2) {
        status = LevelStatus.completed;
      } else if (levelNumber == 2) {
        status = LevelStatus.available;
      } else {
        status = LevelStatus.locked;
      }

      return LevelData(
        id: levelNumber,
        name: 'Nivel $levelNumber',
        status: status,
        xFactor: xPos,
        isBossLevel: levelNumber % 5 == 0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final totalHeight = levels.length * itemHeight + 200;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a0b2e), Color(0xFF0f0c29)],
          ),
        ),
        child: Stack(
          children: [
            _buildStarField(size),
            
            // Título fijo
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: _buildHeader(),
              ),
            ),

            // Mapa con Scroll
            SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: size.width,
                height: totalHeight,
                child: Stack(
                  children: [
                    // Línea de conexión dinámica
                    CustomPaint(
                      size: Size(size.width, totalHeight),
                      painter: PathPainter(levels: levels, itemHeight: itemHeight),
                    ),
                    
                    // Render de niveles
                    ...levels.asMap().entries.map((entry) {
                      return _buildAnimatedLevel(entry.value, entry.key, size);
                    }),

                    // Icono del personaje (Yoongi)
                    _buildPlayerAvatar(size),
                  ],
                ),
              ),
            ),

            // Botón Regresar
            Positioned(
              top: 50,
              left: 20,
              child: FloatingActionButton.small(
                backgroundColor: Colors.white10,
                onPressed: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.purpleAccent.withOpacity(0.5)),
      ),
      child: const Text(
        'Mapa de Niveles',
        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPlayerAvatar(Size size) {
    // Buscamos el nivel actual para poner el avatar encima
    final currentLevelIndex = levels.indexWhere((l) => l.status == LevelStatus.available);
    if (currentLevelIndex == -1) return const SizedBox();

    final level = levels[currentLevelIndex];
    final topPos = (currentLevelIndex * itemHeight) + 150;
    final leftPos = level.xFactor * size.width - 25;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      top: topPos - 45, // Un poco arriba del nivel
      left: leftPos + 5,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.cyanAccent, width: 2),
              boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.5), blurRadius: 10)],
            ),
            child: const CircleAvatar(
              radius: 20,
              // IMAGEN DE YOONGI AQUÍ
              backgroundImage: AssetImage('assets/image/yoongi.jpg'),
            ),
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.cyanAccent),
        ],
      ),
    );
  }

  Widget _buildAnimatedLevel(LevelData level, int index, Size size) {
    final topPosition = (index * itemHeight) + 150;
    
    // Lógica de animación al hacer scroll
    final distanceToCenter = (topPosition - _scrollOffset - size.height / 2).abs();
    final scale = (1.2 - (distanceToCenter / size.height)).clamp(0.8, 1.2);
    final opacity = (1.0 - (distanceToCenter / size.height)).clamp(0.4, 1.0);

    return Positioned(
      top: topPosition,
      left: level.xFactor * size.width - 30,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: _buildLevelNode(level),
        ),
      ),
    );
  }

  Widget _buildLevelNode(LevelData level) {
    return GestureDetector(
      onTap: () {
        if (level.status != LevelStatus.locked) {
          print("Nivel ${level.id} seleccionado");
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: _getGradient(level.status),
          boxShadow: [
            if (level.status != LevelStatus.locked)
              BoxShadow(
                color: level.status == LevelStatus.available ? Colors.blue : Colors.pinkAccent,
                blurRadius: 15,
              )
          ],
          border: Border.all(color: Colors.white24, width: 2),
        ),
        child: Center(
          child: level.status == LevelStatus.locked
              ? const Icon(Icons.lock, color: Colors.white30, size: 20)
              : Text(
                  '${level.id}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
        ),
      ),
    );
  }

  Gradient _getGradient(LevelStatus status) {
    if (status == LevelStatus.locked) {
      return const LinearGradient(colors: [Colors.grey, Color(0xFF2A2A2A)]);
    }
    if (status == LevelStatus.available) {
      return const LinearGradient(colors: [Color(0xFF00D2FF), Color(0xFF3A7BD5)]);
    }
    return const LinearGradient(colors: [Color(0xFFF093FB), Color(0xFFF5576C)]);
  }

  Widget _buildStarField(Size size) {
    return Stack(
      children: List.generate(30, (i) => Positioned(
        top: Random(i).nextDouble() * size.height,
        left: Random(i).nextDouble() * size.width,
        child: const Icon(Icons.star, size: 2, color: Colors.white24),
      )),
    );
  }
}

class PathPainter extends CustomPainter {
  final List<LevelData> levels;
  final double itemHeight;

  PathPainter({required this.levels, required this.itemHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (levels.isEmpty) return;

    for (int i = 0; i < levels.length - 1; i++) {
      final p1 = Offset(levels[i].xFactor * size.width, (i * itemHeight) + 180);
      final p2 = Offset(levels[i+1].xFactor * size.width, ((i + 1) * itemHeight) + 180);
      
      path.moveTo(p1.dx, p1.dy);
      // Curva suave entre niveles
      path.cubicTo(
        p1.dx, p1.dy + itemHeight / 2,
        p2.dx, p2.dy - itemHeight / 2,
        p2.dx, p2.dy,
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) => false;
}