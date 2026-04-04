import 'package:flutter/material.dart';

class Characters extends StatelessWidget {
  const Characters({super.key});

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      body: Stack(
        children: [
          // Fondo galáctico (la imagen que me mostraste)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondolevels.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay suave para mejorar legibilidad
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.35),
                  Colors.black.withOpacity(0.65),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Título "PERSONAJES"
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    'PERSONAJES',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 6,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 15,
                          color: const Color(0xFF00E5FF).withOpacity(0.8),
                          offset: const Offset(0, 0),
                        ),
                        const Shadow(
                          blurRadius: 25,
                          color: Color(0xFF8A2BE2),
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),

                // Grid de personajes
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.78,   // Más espacio para la foto
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        final char = characters[index];

                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F1B2E).withOpacity(0.92),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF00E5FF),
                              width: 3.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00E5FF).withOpacity(0.4),
                                blurRadius: 18,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                blurRadius: 12,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Foto más grande y visible
                                Expanded(
                                  flex: 7,
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
                                              child: Icon(Icons.image_not_supported,
                                                  size: 50, color: Colors.white54),
                                            ),
                                          );
                                        },
                                      ),
                                      // Brillo sutil en la parte superior de la foto
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 80,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.white12,
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Estrella dorada en la esquina
                                      Positioned(
                                        top: 12,
                                        right: 12,
                                        child: Container(
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.65),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: const Color(0xFFFFD700),
                                              width: 2.5,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.star,
                                            color: Color(0xFFFFD700),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Nombre y descripción
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        char['name']!,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFFD700),
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Text(
                                        char['desc']!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          height: 1.35,
                                          color: Colors.white70,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Flecha para volver atrás
          Positioned(
            top: 18,
            left: 12,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}