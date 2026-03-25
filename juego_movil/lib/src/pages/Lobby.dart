import 'package:flutter/material.dart';
import 'dart:math' as math;

class Lobby extends StatefulWidget {
  const Lobby({super.key});

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _starsController;
  late AnimationController _planetsController;
  late AnimationController _pulseController;
  
  late Animation<double> _bgAnimation;
  late Animation<double> _starsAnimation;
  late Animation<double> _planetsAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat(reverse: true);
    _starsController = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat();
    _planetsController = AnimationController(vsync: this, duration: const Duration(seconds: 25))..repeat(reverse: true);
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    
    _bgAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_bgController);
    _starsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_starsController);
    _planetsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_planetsController);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _bgController.dispose();
    _starsController.dispose();
    _planetsController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          // Fondo galaxia animado
          _buildGalaxyBackground(size),
          
          // Partículas de estrellas flotantes
          AnimatedBuilder(
            animation: _starsAnimation,
            builder: (context, child) => _buildFloatingStars(size),
          ),
          
          // Planetas flotantes decorativos
          AnimatedBuilder(
            animation: _planetsAnimation,
            builder: (context, child) => _buildFloatingPlanets(size),
          ),
          
          // Interfaz principal centrada
          SafeArea(
            child: Column(
              children: [
                // Header con perfil y stats
                _buildHeader(size),
                const Spacer(flex: 2),
                
                // Niveles principales (5 niveles visibles, sin scroll)
                _buildMainLevels(size),
                
                const Spacer(),
                
                // Botones de navegación principales
                _buildMainMenuButtons(size),
                const Spacer(flex: 1),
              ],
            ),
          ),
          
          // Efectos mágicos overlay
          _buildMagicOverlay(),
        ],
      ),
    );
  }

  Widget _buildGalaxyBackground(Size size) {
    return AnimatedBuilder(
      animation: _bgAnimation,
      builder: (context, child) {
        return Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              colors: [
                Color(0xFF0A0A23),
                Color(0xFF1A0A3A),
                Color(0xFF2A0A5A),
                Color(0xFF0A1A4A),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: CustomPaint(
            painter: GalaxyPainter(_bgAnimation.value),
            size: Size.infinite,
          ),
        );
      },
    );
  }

  Widget _buildFloatingStars(Size size) {
    return CustomPaint(
      painter: StarsPainter(_starsAnimation.value),
      size: Size.infinite,
    );
  }

  Widget _buildFloatingPlanets(Size size) {
    return Stack(
      children: [
        // Planeta grande izquierda
        Positioned(
          left: size.width * 0.1,
          top: size.height * 0.3,
          child: Transform.scale(
            scale: 0.6 + 0.2 * _planetsAnimation.value,
            child: Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.6),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
        // Planeta grande derecha
        Positioned(
          right: size.width * 0.15,
          top: size.height * 0.6,
          child: Transform.scale(
            scale: 0.5 + 0.3 * (1 - _planetsAnimation.value),
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFFE879F9), Color(0xFFF59E0B)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
                    blurRadius: 35,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Size size) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withValues(alpha: 0.7), 
            Colors.purple.withValues(alpha: 0.4)
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar con efecto mágico
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) => Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.cyan,
                    width: 3.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withValues(alpha: 0.6),
                      blurRadius: 15,
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage('assets/images/yoongi.jpg'), // player avatar
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          
          // Info del jugador
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Evie ✨',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(color: Colors.purple, offset: Offset(0, 2), blurRadius: 4),
                    ],
                  ),
                ),
                Text(
                  'Cosmic Explorer',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Stats
          _buildStatItem('assets/images/yoongi.jpg', '⭐ 120', Colors.amber), // coin icon
          const SizedBox(width: 15),
          _buildStatItem('assets/images/yoongi.jpg', '🌟 Lv.3', Colors.cyan), // level icon
        ],
      ),
    );
  }

  Widget _buildMainLevels(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Text(
            'GALACTIC QUESTS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              shadows: [
                Shadow(color: Colors.purple, offset: Offset(0, 2), blurRadius: 8),
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          // 5 niveles principales en layout circular
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMagicLevelButton(1, true),
              _buildMagicLevelButton(2, true),
              _buildMagicLevelButton(3, true),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMagicLevelButton(4, true),
              _buildMagicLevelButton(5, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMagicLevelButton(int level, bool unlocked) {
    return GestureDetector(
      onTap: unlocked ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Placeholder())) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.diagonal3Values(unlocked ? 1.0 : 0.9, unlocked ? 1.0 : 0.9, 1.0),
        child: Container(
          width: 90.0,
          height: 90.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: unlocked 
                ? const RadialGradient(colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)])
                : LinearGradient(colors: [Colors.grey.shade800, Colors.grey.shade900]),
            boxShadow: [
              BoxShadow(
                color: unlocked ? Colors.purple.withValues(alpha: 0.6) : Colors.black45,
                blurRadius: unlocked ? 25 : 10,
                spreadRadius: 5,
              ),
            ],
            border: unlocked 
                ? Border.all(color: Colors.cyan.withValues(alpha: 0.8), width: 3.0)
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!unlocked) Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
              ),
              Text(
                '$level',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 4),
                  ],
                ),
              ),
              if (!unlocked)
                const Icon(Icons.lock_outline, color: Colors.white54, size: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainMenuButtons(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Text(
            'COMMAND CENTER',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGameButton('Story', 'assets/images/yoongi.jpg'), // story icon
              _buildGameButton('Shop', 'assets/images/yoongi.jpg'), // shop icon
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGameButton('Profile', 'assets/images/yoongi.jpg'), // profile icon
              _buildGameButton('Settings', 'assets/images/yoongi.jpg'), // settings icon
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameButton(String label, String iconPath) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Placeholder())),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withValues(alpha: 0.4),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 45.0,
                height: 45.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(iconPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String iconPath, String label, Color glowColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withValues(alpha: 0.5), 
            glowColor.withValues(alpha: 0.2)
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28.0,
            height: 28.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(iconPath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMagicOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) => CustomPaint(
            painter: MagicOverlayPainter(_pulseAnimation.value),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

// Custom Painters para efectos mágicos
class GalaxyPainter extends CustomPainter {
  final double animation;
  GalaxyPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          Colors.purple.withValues(alpha: 0.1),
          Colors.purple.withValues(alpha: 0.3),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(size.width/2, size.height/2), radius: 300));
    
    canvas.save();
    canvas.translate(size.width/2 + 50 * math.sin(animation * math.pi), size.height/2);
    canvas.drawCircle(const Offset(0, 0), 250 * (0.8 + 0.2 * 0.5), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class StarsPainter extends CustomPainter {
  final double animation;
  StarsPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.8);
    
    for (int i = 0; i < 30; i++) {
      final x = (i * 123.45 + animation * 200) % size.width;
      final y = (i * 67.89 + animation * 100) % size.height;
      final sizeStar = 2 + (i % 3);
      canvas.drawCircle(Offset(x, y), sizeStar.toDouble(), starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MagicOverlayPainter extends CustomPainter {
  final double animation;
  MagicOverlayPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.cyan.withValues(alpha: 0.03),
          Colors.purple.withValues(alpha: 0.02),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}