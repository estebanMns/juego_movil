import 'package:flutter/material.dart';
// import 'lobby.dart'; // ← Descomenta esta línea si quieres navegar explícitamente a Lobby (y la clase se llama Lobby)

class Characters extends StatelessWidget {
  const Characters({super.key});

  @override
  Widget build(BuildContext context) {
    // === AQUÍ ESTÁN TUS 5 PERSONAJES ===
    // Cambia los nombres, rutas de imágenes y descripciones con los tuyos reales.
    // Las fotos deben estar en assets/images/ (no olvides agregarlas en pubspec.yaml)
    final List<Map<String, String>> characters = [
      {
        'name': 'Kovu',
        'image': 'assets/images/kovu.jpg',
        'desc': 'León valiente exiliado que lucha por su redención y liderazgo.',
      },
      {
        'name': 'Personaje 2',
        'image': 'assets/images/personaje2.jpg',
        'desc': 'Descripción corta y épica del segundo personaje.',
      },
      {
        'name': 'Personaje 3',
        'image': 'assets/images/personaje3.jpg',
        'desc': 'Descripción corta y épica del tercer personaje.',
      },
      {
        'name': 'Personaje 4',
        'image': 'assets/images/personaje4.jpg',
        'desc': 'Descripción corta y épica del cuarto personaje.',
      },
      {
        'name': 'Personaje 5',
        'image': 'assets/images/personaje5.jpg',
        'desc': 'Descripción corta y épica del quinto personaje.',
      },
    ];

    return Scaffold(
      // Fondo oscuro con degradado nocturno (estilo fantasía / videojuego)
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A1428), // azul noche profundo
              Color(0xFF1F2E4F), // azul más claro con toque púrpura
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar personalizado con flecha de atrás
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
                      onPressed: () {
                        // Te lleva de vuelta a lobby.dart (si venías de ahí con push)
                        Navigator.pop(context);

                        // Si prefieres forzar la pantalla Lobby aunque no sea la anterior:
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (_) => const Lobby()),
                        // );
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'PERSONAJES',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD4A017), // oro brillante
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black87,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // equilibrio visual
                  ],
                ),
              ),

              // Área de las cartas
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78, // forma de carta vertical
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                    ),
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      final char = characters[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C2B4A), // fondo carta oscuro
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFD4A017), // marco dorado como la imagen
                            width: 6,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 12,
                              spreadRadius: 2,
                              offset: const Offset(0, 8),
                            ),
                            // brillo interior dorado sutil
                            const BoxShadow(
                              color: Color(0x33D4A017),
                              blurRadius: 20,
                              spreadRadius: -8,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Imagen del personaje (ocupa la mayor parte como en cartas Pokémon)
                              Expanded(
                                flex: 7,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      char['image']!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: Colors.grey[800],
                                        child: const Center(
                                          child: Icon(Icons.image_not_supported, size: 50, color: Colors.white54),
                                        ),
                                      ),
                                    ),
                                    // Brillo sutil en la esquina superior (estilo videojuego)
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.star,
                                          color: Color(0xFFD4A017),
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Información del personaje
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      char['name']!,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFD4A017),
                                        height: 1.1,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      char['desc']!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                        height: 1.3,
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
      ),
    );
  }
}