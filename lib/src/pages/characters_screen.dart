import 'package:flutter/material.dart';

class Characters extends StatefulWidget {
  const Characters({super.key});

  @override
  State<Characters> createState() => _CharactersState();
}

class _CharactersState extends State<Characters>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.80);
  int _currentPage = 0;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  final List<Map<String, String>> characters = [
    {
      'name': 'Iker',
      'image': 'assets/images/iker.jpeg',
      'role': 'Exiliado Valiente',
      'desc':
          'Lucha por su redención y liderazgo en las estrellas con valentía inigualable.',
    },
    {
      'name': 'Kovu',
      'image': 'assets/images/kovu.jpeg',
      'role': 'Guerrero Estelar',
      'desc':
          'Domina las artes del combate galáctico con una fuerza ancestral única.',
    },
    {
      'name': 'Horus',
      'image': 'assets/images/horus.jpeg',
      'role': 'Maestro Cuántico',
      'desc':
          'Guerrero de una antigua raza alienígena, maestro del combate cuántico.',
    },
    {
      'name': 'Matias',
      'image': 'assets/images/perroblanco.png',
      'role': 'Navegante Neural',
      'desc':
          'Experto en portales galácticos y hackeo neural de sistemas estelares.',
    },
    {
      'name': 'Molly',
      'image': 'assets/images/molly.jpeg',
      'role': 'Renegada Oscura',
      'desc':
          'Domina la manipulación de energía oscura con poderes sin igual.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() => _currentPage = newPage);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    // Altura disponible real (descontando status bar y bottom bar)
    final availableHeight = size.height - padding.top - padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0714),
      body: Stack(
        children: [
          // ── Fondo galáctico ──────────────────────────────────────
          _GalacticBackground(screenSize: size),

          // ── Contenido principal ──────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Espacio para el botón volver
                const SizedBox(height: 56),

                // Título
                _buildTitle(availableHeight),

                SizedBox(height: availableHeight * 0.025),

                // Carrusel — ocupa el espacio restante
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Reservamos espacio fijo para: nombre + role + desc + dots + padding
                      // El resto se lo damos a la imagen
                      const textAreaH = 160.0; // nombre~44 + role~32 + desc~60 + gaps~24
                      const dotsAreaH = 36.0;  // dots + su padding
                      final imageH = (constraints.maxHeight - textAreaH - dotsAreaH).clamp(120.0, 420.0);
                      final imageW = imageH * 0.78;

                      return Column(
                        children: [
                          // PageView ocupa exactamente imageH + textAreaH
                          SizedBox(
                            height: imageH + textAreaH,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: characters.length,
                              itemBuilder: (ctx, index) {
                                final char = characters[index];
                                final isCurrent = index == _currentPage;

                                return AnimatedScale(
                                  scale: isCurrent ? 1.0 : 0.88,
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeInOutCubic,
                                  child: AnimatedOpacity(
                                    opacity: isCurrent ? 1.0 : 0.55,
                                    duration: const Duration(milliseconds: 350),
                                    child: _CharacterCard(
                                      char: char,
                                      isCurrent: isCurrent,
                                      imageH: imageH,
                                      imageW: imageW,
                                      glowAnimation: _glowAnimation,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const Spacer(),

                          // Dots
                          _buildDots(),

                          const SizedBox(height: 12),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ── Botón volver ─────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: _BackButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(double availableHeight) {
    final fontSize = (availableHeight * 0.038).clamp(20.0, 34.0);
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (_, _) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: const Color(0xFFB47FFF).withValues(alpha: 0.7),
            width: 1.5,
          ),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2D1B69).withValues(alpha: 0.6),
              const Color(0xFF1A0E3D).withValues(alpha: 0.6),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFB47FFF)
                  .withValues(alpha: 0.35 * _glowAnimation.value),
              blurRadius: 25,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ShaderMask(
          shaderCallback: (rect) => const LinearGradient(
            colors: [Color(0xFFE0C3FF), Color(0xFFB47FFF), Color(0xFF7C3AED)],
          ).createShader(rect),
          child: Text(
            'PERSONAJES',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 5,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(characters.length, (i) {
        final isActive = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFFB47FFF)
                : Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(4),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFFB47FFF).withValues(alpha: 0.8),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

// ── Card de personaje ──────────────────────────────────────────────────────────
class _CharacterCard extends StatelessWidget {
  final Map<String, String> char;
  final bool isCurrent;
  final double imageH;
  final double imageW;
  final Animation<double> glowAnimation;

  const _CharacterCard({
    required this.char,
    required this.isCurrent,
    required this.imageH,
    required this.imageW,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    const nameSize = 28.0;
    const roleSize = 13.0;
    const descSize = 13.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Imagen
        AnimatedBuilder(
          animation: glowAnimation,
          builder: (_, child) => Container(
            width: imageW,
            height: imageH,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isCurrent
                    ? const Color(0xFFB47FFF)
                    : Colors.white.withValues(alpha: 0.15),
                width: isCurrent ? 2.5 : 1.5,
              ),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: const Color(0xFF7C3AED)
                            .withValues(alpha: 0.6 * glowAnimation.value),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                      BoxShadow(
                        color: const Color(0xFFB47FFF)
                            .withValues(alpha: 0.3 * glowAnimation.value),
                        blurRadius: 50,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: child,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  char['image']!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: const Color(0xFF1A0E3D),
                    child: const Center(
                      child: Icon(Icons.person, size: 64, color: Colors.white24),
                    ),
                  ),
                ),
                // Overlay sutil en la parte inferior
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: imageH * 0.3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          const Color(0xFF0A0714).withValues(alpha: 0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Nombre
        ShaderMask(
          shaderCallback: (rect) => const LinearGradient(
            colors: [Color(0xFFE0C3FF), Color(0xFFB47FFF)],
          ).createShader(rect),
          child: Text(
            char['name']!,
            style: TextStyle(
              fontSize: nameSize,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),

        const SizedBox(height: 4),

        // Role badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFB47FFF).withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Text(
            char['role']!,
            style: TextStyle(
              fontSize: roleSize,
              color: const Color(0xFFD8B4FE),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Descripción
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            char['desc']!,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: descSize,
              color: Colors.white.withValues(alpha: 0.6),
              height: 1.5,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Botón volver ───────────────────────────────────────────────────────────────
class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withValues(alpha: 0.07),
          border: Border.all(
            color: const Color(0xFFB47FFF).withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

// ── Fondo galáctico ────────────────────────────────────────────────────────────
class _GalacticBackground extends StatelessWidget {
  final Size screenSize;
  const _GalacticBackground({required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradiente base
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0A0714),
                Color(0xFF12093A),
                Color(0xFF0E0828),
                Color(0xFF0A0714),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        ),
        // Nebulosa izquierda
        Positioned(
          left: -60,
          top: screenSize.height * 0.1,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF7C3AED).withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Nebulosa derecha
        Positioned(
          right: -80,
          top: screenSize.height * 0.4,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF4C1D95).withValues(alpha: 0.25),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Nebulosa inferior
        Positioned(
          left: screenSize.width * 0.2,
          bottom: -40,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF6D28D9).withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Estrellas
        ...List.generate(30, (i) {
          final x = (i * 73.1 + 17) % screenSize.width;
          final y = (i * 51.7 + 31) % screenSize.height;
          final size = 1.0 + (i % 3) * 0.8;
          final opacity = 0.2 + (i % 6) * 0.08;
          return Positioned(
            left: x,
            top: y,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: opacity),
                boxShadow: i % 5 == 0
                    ? [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.4),
                          blurRadius: 3,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
            ),
          );
        }),
      ],
    );
  }
}