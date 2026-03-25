import 'package:flutter/material.dart';

class Characters extends StatelessWidget {
  const Characters({super.key});

  @override
  Widget build(BuildContext context) {
    // === TUS 5 PERSONAJES (cambia lo que necesites) ===
    final List<Map<String, String>> characters = [
      {
        'name': 'Iker',
        'image': 'assets/images/iker.jpeg', // cambia por tu imagen real
        'desc': 'Iker valiente exiliado que lucha por su redención y liderazgo en las estrellas.',
      },
      {
        'name': 'Kovu',
        'image': 'assets/images/kovu.jpeg', // cambia por tu imagen real
        'desc': 'Kovu valiente exiliado que lucha por su redención y liderazgo en las estrellas.',
      },
      {
        'name': 'Horus',
        'image': 'assets/images/horus.jpeg',
        'desc': 'Guerrero de una antigua raza alienígena, maestro del combate cuántico.',
      },
      {
        'name': 'Matias',
        'image': 'assets/images/perroblanco.jpeg',
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
          // Fondo personalizado desde assets (cámbialo por la ruta que quieras)
          // Ejemplos recomendados: 'assets/images/galaxy_background.jpg' o 'assets/images/space_nebula.png'
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/galaxy_background.jpg'), // ← CAMBIA ESTA RUTA
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Capa de overlay sutil para que las cartas resalten (efecto futurista)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.75),
                ],
              ),
            ),
          ),

          // Contenido principal
          SafeArea(
            child: Column(
              children: [
                // Header futurista
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'PERSONAJES',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF00F5FF), // cyan neón futurista
                            letterSpacing: 4,
                            shadows: [
                              Shadow(
                                blurRadius: 12,
                                color: Color(0xFF00F5FF),
                                offset: Offset(0, 0),
                              ),
                              Shadow(
                                blurRadius: 20,
                                color: Colors.white24,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // Grid de cartas estilo galáctico / futurista
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.82,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        final char = characters[index];
                        return GestureDetector(
                          onTap: () {
                            // Aquí puedes agregar navegación a detalle si quieres
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Seleccionaste a ${char['name']}'),
                                backgroundColor: const Color(0xFF00F5FF),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A1A2F).withOpacity(0.95), // fondo semi-transparente oscuro
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFF00F5FF), // borde neón cyan
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00F5FF).withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.7),
                                  blurRadius: 15,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Imagen del personaje con efecto futurista
                                  Expanded(
                                    flex: 6,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.asset(
                                          char['image']!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            color: const Color(0xFF112233),
                                            child: const Icon(Icons.person_off, size: 60, color: Colors.white54),
                                          ),
                                        ),
                                        // Overlay sutil con líneas neón
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(0.4),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Estrella / indicador neón en esquina
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.6),
                                              shape: BoxShape.circle,
                                              border: Border.all(color: const Color(0xFFFFD700), width: 2),
                                            ),
                                            child: const Icon(
                                              Icons.star,
                                              color: Color(0xFFFFD700),
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Información del personaje
                                  Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          char['name']!,
                                          style: const TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFFD700), // dorado neón
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          char['desc']!,
                                          style: const TextStyle(
                                            fontSize: 13.5,
                                            height: 1.4,
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
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}