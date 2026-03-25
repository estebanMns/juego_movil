import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Characters extends StatefulWidget {
  const Characters({super.key});

  @override
  State<Characters> createState() => _CharactersState();
}

class _CharactersState extends State<Characters> {
  final ScrollController _scrollController = ScrollController();
  double _headerOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      // Empieza a difuminarse desde 0px hasta 80px de scroll
      final opacity = (1.0 - (offset / 80.0)).clamp(0.0, 1.0);
      setState(() => _headerOpacity = opacity);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> characters = [
      {
        'name': 'IKER',
        'image': 'assets/images/iker.jpeg',
        'role': 'Líder',
        'tagColor': const Color(0xFF7DD8FF),
        'tagBg': const Color(0x330064B4),
        'desc':
            'Iker, valiente exiliado que lucha por su redención y liderazgo en las estrellas.',
        'glowColor': const Color(0x2200B4FF),
      },
      {
        'name': 'KOVU',
        'image': 'assets/images/kovu.jpeg',
        'role': 'Aliado',
        'tagColor': const Color(0xFFC8A8FF),
        'tagBg': const Color(0x33643CB4),
        'desc':
            'Kovu, valiente exiliado que lucha por su redención y liderazgo en las estrellas.',
        'glowColor': const Color(0x22B464FF),
      },
      {
        'name': 'HORUS',
        'image': 'assets/images/horus.jpeg',
        'role': 'Antiguo',
        'tagColor': const Color(0xFFFFCC70),
        'tagBg': const Color(0x33B47814),
        'desc':
            'Guerrero de una antigua raza alienígena, maestro del combate cuántico.',
        'glowColor': const Color(0x22C88200),
      },
      {
        'name': 'MATIAS',
        'image': 'assets/images/perroblanco.png',
        'role': 'Experta',
        'tagColor': const Color(0xFF70F0C0),
        'tagBg': const Color(0x2214A064),
        'desc':
            'Navegante experta en portales galácticos y experta en hackeo neural.',
        'glowColor': const Color(0x2214A064),
      },
      {
        'name': 'MOLLY',
        'image': 'assets/images/molly.jpeg',
        'role': 'Renegada',
        'tagColor': const Color(0xFFFF9988),
        'tagBg': const Color(0x33B43C32),
        'desc':
            'Villano renegado que domina la manipulación de la energía oscura.',
        'glowColor': const Color(0x22FF3020),
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          // ── Fondo galáctico ──────────────────────────────────────────
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondolevels.png',
              fit: BoxFit.cover,
            ),
          ),

          // ── Overlay oscuro ───────────────────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF060E1E).withOpacity(0.72),
                    const Color(0xFF0C1A35).withOpacity(0.55),
                    const Color(0xFF081428).withOpacity(0.65),
                    const Color(0xFF0A0F1E).withOpacity(0.75),
                  ],
                ),
              ),
            ),
          ),

          // ── Lista scrollable ─────────────────────────────────────────
          SafeArea(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Espaciador para que el header fijo no tape el contenido
                const SliverToBoxAdapter(child: SizedBox(height: 90)),

                // Tarjetas
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _CharacterCard(char: characters[index]),
                        );
                      },
                      childCount: characters.length,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),

          // ── Header fijo con fade ─────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Opacity(
                opacity: _headerOpacity,
                child: Container(
                  height: 90,
                  // Degradado que tapa el borde inferior suavemente
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF060E1E).withOpacity(0.85),
                        const Color(0xFF060E1E).withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      // Botón volver
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFB8860B).withOpacity(0.12),
                            border: Border.all(
                              color: const Color(0xFFB8860B).withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xFFD4A94A),
                            size: 16,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: _TitleWidget(),
                        ),
                      ),
                      const SizedBox(width: 50), // balance del botón
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Título con brillo dorado ────────────────────────────────────────────────

class _TitleWidget extends StatelessWidget {
  const _TitleWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'PERSONAJES',
          style: TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: 7,
            color: const Color(0xFFD4A94A),
            shadows: [
              Shadow(
                blurRadius: 24,
                color: const Color(0xFFD4A94A).withOpacity(0.6),
                offset: Offset.zero,
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        ShaderMask(
          shaderCallback: (rect) => const LinearGradient(
            colors: [Colors.transparent, Color(0xFFD4A94A), Colors.transparent],
          ).createShader(rect),
          child: Container(height: 1, width: 130, color: Colors.white),
        ),
      ],
    );
  }
}

// ─── Tarjeta de personaje ────────────────────────────────────────────────────

class _CharacterCard extends StatelessWidget {
  final Map<String, dynamic> char;
  const _CharacterCard({required this.char});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Altura de imagen proporcional al ancho de pantalla
    final imageHeight = (screenWidth - 32) * 0.62;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFB8860B).withOpacity(0.4),
          width: 1.5,
        ),
        color: const Color(0xFF08122A).withOpacity(0.88),
        boxShadow: [
          BoxShadow(
            color: char['glowColor'] as Color,
            blurRadius: 22,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Imagen ─────────────────────────────────────────────────
            SizedBox(
              height: imageHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    char['image'] as String,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF0D2046), Color(0xFF1A3A6E)],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.person,
                            size: 60, color: Colors.white24),
                      ),
                    ),
                  ),

                  // Degradado inferior que fusiona con la tarjeta
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF08122A).withOpacity(0.98),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Badge estrella
                  Positioned(
                    top: 12, right: 12,
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.6),
                        border: Border.all(
                          color: const Color(0xFFD4A94A),
                          width: 1.8,
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.star,
                            color: Color(0xFFD4A94A), size: 17),
                      ),
                    ),
                  ),

                  // Tag de rol
                  Positioned(
                    bottom: 14, left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: char['tagBg'] as Color,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color:
                              (char['tagColor'] as Color).withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        char['role'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: char['tagColor'] as Color,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    char['name'] as String,
                    style: const TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFD4A94A),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Línea divisora dorada
                  ShaderMask(
                    shaderCallback: (rect) => const LinearGradient(
                      colors: [
                        Color(0xFFD4A94A),
                        Colors.transparent,
                      ],
                    ).createShader(rect),
                    child: Container(
                        height: 1, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    char['desc'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.55,
                      color: Color(0xCCC8D7F0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}