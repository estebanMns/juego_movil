import 'package:flutter/material.dart';

class Characters extends StatefulWidget {
  const Characters({super.key});

  @override
  State<Characters> createState() => _CharactersState();
}

class _CharactersState extends State<Characters> {
  final PageController _pageController = PageController(viewportFraction: 0.75);
  int _currentPage = 0;

  final List<Map<String, String>> characters = [
    {
      'name': 'Iker',
      'image': 'assets/images/iker.jpeg',
      'desc': 'Iker valiente exiliado que lucha por su redención y liderazgo en las estrellas.',
    },
    {
      'name': 'Kovu',
      'image': 'assets/images/kovu.jpeg',
      'desc': 'Kovu valiente exiliado que lucha por su redención y liderazgo en las estrellas.',
    },
    {
      'name': 'Horus',
      'image': 'assets/images/horus.jpeg',
      'desc': 'Guerrero de una antigua raza alienígena, maestro del combate cuántico.',
    },
    {
      'name': 'Matias',
      'image': 'assets/images/perroblanco.png',
      'desc': 'Navegante experta en portales galácticos y experta en hackeo neural.',
    },
    {
      'name': 'Molly',
      'image': 'assets/images/molly.jpeg',
      'desc': 'Villano renegado que domina la manipulación de la energía oscura.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < characters.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener altura de pantalla para hacerla responsive
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    
    // Ajustar tamaños según la pantalla
    final titleSize = isSmallScreen ? 24.0 : 32.0;
    final nameSize = isSmallScreen ? 28.0 : 36.0;
    final descSize = isSmallScreen ? 13.0 : 16.0;
    final cardWidth = isSmallScreen ? 220.0 : 250.0;
    final cardHeight = isSmallScreen ? 300.0 : 350.0;
    final topPadding = isSmallScreen ? 10.0 : 20.0;
    final bottomPadding = isSmallScreen ? 15.0 : 30.0;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo galáctico animado con gradientes mágicos
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F0C29),
                  Color(0xFF302B63),
                  Color(0xFF24243E),
                  Color(0xFF1A1A2E),
                ],
              ),
            ),
          ),
          
          // Capa adicional de estrellas/brillo
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  const Color(0xFF6B1B9A).withValues(alpha: 0.3),
                  const Color(0xFF0F0C29).withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Estrellas decorativas
          ...List.generate(20, (index) {
            return Positioned(
              left: (index * 57.7) % screenWidth,
              top: (index * 37.3) % screenHeight,
              child: Container(
                width: 2 + (index % 3),
                height: 2 + (index % 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3 + (index % 5) * 0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.5),
                      blurRadius: 4 + (index % 4),
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            );
          }),

          SafeArea(
            child: Column(
              children: [
                // Título "PERSONAJES" con efecto mágico
                Padding(
                  padding: EdgeInsets.only(top: topPadding, bottom: isSmallScreen ? 20.0 : 30.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 20.0 : 30.0, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF00D9FF),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D9FF).withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: const Color(0xFFEC4899).withValues(alpha: 0.3),
                          blurRadius: 30,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(
                      'PERSONAJES',
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w900,
                        letterSpacing: isSmallScreen ? 2 : 4,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [
                              Color(0xFF00D9FF),
                              Color(0xFFEC4899),
                              Color(0xFFA855F7),
                            ],
                          ).createShader(const Rect.fromLTWH(0, 0, 200, 50)),
                        shadows: const [
                          Shadow(
                            blurRadius: 10,
                            color: Color(0xFF00D9FF),
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Carrusel de personajes - Usando Flexible para evitar overflow
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // PageView con las imágenes
                        SizedBox(
                          height: cardHeight + 150, // Espacio para imagen + texto
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: characters.length,
                            itemBuilder: (context, index) {
                              final char = characters[index];
                              final isCurrent = index == _currentPage;
                              
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Imagen del personaje
                                    Container(
                                      width: isCurrent ? cardWidth : cardWidth - 50,
                                      height: isCurrent ? cardHeight : cardHeight - 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: isCurrent 
                                              ? const Color(0xFF00D9FF)
                                              : Colors.white.withValues(alpha: 0.3),
                                          width: isCurrent ? 4 : 2,
                                        ),
                                        boxShadow: [
                                          if (isCurrent) ...[
                                            BoxShadow(
                                              color: const Color(0xFF00D9FF).withValues(alpha: 0.6),
                                              blurRadius: 30,
                                              spreadRadius: 5,
                                            ),
                                            BoxShadow(
                                              color: const Color(0xFFEC4899).withValues(alpha: 0.4),
                                              blurRadius: 40,
                                              spreadRadius: 2,
                                            ),
                                            BoxShadow(
                                              color: const Color(0xFFA855F7).withValues(alpha: 0.3),
                                              blurRadius: 50,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(28),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.asset(
                                              char['image']!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[900],
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 80,
                                                      color: Colors.white54,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            // Overlay gradiente
                                            Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.transparent,
                                                    Colors.black.withValues(alpha: 0.4),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    
                                    SizedBox(height: isSmallScreen ? 20 : 30),
                                    
                                    // Nombre del personaje
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      child: Text(
                                        char['name']!,
                                        key: ValueKey('name_$index'),
                                        style: TextStyle(
                                          fontSize: isCurrent ? nameSize : nameSize - 8,
                                          fontWeight: FontWeight.w900,
                                          foreground: Paint()
                                            ..shader = const LinearGradient(
                                              colors: [
                                                Color(0xFF00D9FF),
                                                Color(0xFFA855F7),
                                              ],
                                            ).createShader(const Rect.fromLTWH(0, 0, 200, 50)),
                                          shadows: [
                                            Shadow(
                                              blurRadius: 15,
                                              color: const Color(0xFF00D9FF).withValues(alpha: 0.8),
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    
                                    SizedBox(height: isSmallScreen ? 10 : 15),
                                    
                                    // Descripción - Con maxLines y overflow controlado
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      child: Container(
                                        key: ValueKey('desc_$index'),
                                        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 15.0 : 20.0),
                                        child: Text(
                                          char['desc']!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: descSize,
                                            height: 1.4,
                                            color: Colors.white70,
                                            letterSpacing: 0.5,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: isSmallScreen ? 15 : 20),

                        // Indicadores de página (dots)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            characters.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              width: _currentPage == index ? (isSmallScreen ? 25 : 30) : (isSmallScreen ? 8 : 10),
                              height: isSmallScreen ? 8 : 10,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? const Color(0xFF00D9FF)
                                    : Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: _currentPage == index
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF00D9FF).withValues(alpha: 0.8),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: isSmallScreen ? 20 : 25),

                        // Flechas de navegación
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Flecha izquierda
                            _buildNavigationArrow(
                              icon: Icons.arrow_back_ios_new,
                              onPressed: _currentPage > 0 ? _previousPage : null,
                              isLeft: true,
                              isSmallScreen: isSmallScreen,
                            ),
                            
                            SizedBox(width: isSmallScreen ? 30 : 40),
                            
                            // Flecha derecha
                            _buildNavigationArrow(
                              icon: Icons.arrow_forward_ios,
                              onPressed: _currentPage < characters.length - 1 ? _nextPage : null,
                              isLeft: false,
                              isSmallScreen: isSmallScreen,
                            ),
                          ],
                        ),

                        SizedBox(height: bottomPadding),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Botón volver (arriba a la izquierda) - Reposicionado para no interferir
          Positioned(
            top: 10,
            left: 10,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFF00D9FF).withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00D9FF).withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: isSmallScreen ? 18 : 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationArrow({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isLeft,
    required bool isSmallScreen,
  }) {
    final bool isEnabled = onPressed != null;
    
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(isSmallScreen ? 14 : 18),
        decoration: BoxDecoration(
          color: isEnabled 
              ? Colors.black.withValues(alpha: 0.6)
              : Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isEnabled
                ? const Color(0xFF00D9FF)
                : Colors.white.withValues(alpha: 0.2),
            width: 2,
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: const Color(0xFF00D9FF).withValues(alpha: 0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: const Color(0xFFEC4899).withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: isEnabled ? const Color(0xFF00D9FF) : Colors.white54,
          size: isSmallScreen ? 22 : 28,
        ),
      ),
    );
  }
}