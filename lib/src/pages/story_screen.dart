import 'package:flutter/material.dart';
import 'dart:ui';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo Galáctico
          Positioned.fill(
            child: Image.asset(
              'assets/images/FondoLobby.jpg', 
              fit: BoxFit.cover,
            ),
          ),
          
          // Overlay para mejorar legibilidad
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      _buildCircularButton(context, Icons.arrow_back_ios_new, () => Navigator.pop(context)),
                      const Expanded(
                        child: Text(
                          'BITÁCORA ESTELAR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 22, 
                            fontWeight: FontWeight.bold, 
                            letterSpacing: 3
                          ),
                        ),
                      ),
                      const SizedBox(width: 45),
                    ],
                  ),
                ),

                const Text(
                  "REGISTRO DE LA MISIÓN MOLLY",
                  style: TextStyle(color: Color(0xFFCE93D8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                ),

                const SizedBox(height: 20),

                // Lista de Capítulos
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    children: [
                      _buildStoryChapter(
                        "CAPÍTULO 1", "El Descubrimiento", 
                        "Algo no anda bien en el sector orbital. Las señales de Molly han desaparecido.", 
                        "2 Imágenes", Icons.blur_on, const Color(0xFF40C4FF)
                      ),
                      _buildStoryChapter(
                        "CAPÍTULO 2", "Exploración Inicial", 
                        "Rastros de energía desconocida nos guían hacia el cinturón de asteroides.", 
                        "2 Imágenes", Icons.explore_rounded, const Color(0xFF69F0AE)
                      ),
                      _buildStoryChapter(
                        "CAPÍTULO 3", "Objetos de Poder", 
                        "La tensión aumenta. Hemos encontrado artefactos que alteran la gravedad.", 
                        "3 Imágenes", Icons.thunderstorm_rounded, const Color(0xFFFFD740) // CORREGIDO: t minúscula
                      ),
                      _buildStoryChapter(
                        "CAPÍTULO 4", "El Encuentro", 
                        "Cara a cara con Molly. La traición tiene un rostro conocido.", 
                        "3 Imágenes", Icons.visibility_rounded, const Color(0xFFFF5252)
                      ),
                      _buildStoryChapter(
                        "CAPÍTULO 5", "Duda Emocional", 
                        "¿Es Molly realmente el enemigo? Un momento de calma antes de la tormenta.", 
                        "2 Imágenes", Icons.favorite_rounded, const Color(0xFFEA80FC) // CORREGIDO: f minúscula
                      ),
                      _buildStoryChapter(
                        "CAPÍTULO 6", "El Destino Final", 
                        "Caos global. Es hora de tomar la decisión que cambiará el universo.", 
                        "3 Imágenes", Icons.auto_awesome_rounded, Colors.white
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildStoryChapter(String cap, String title, String desc, String imgs, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80, width: 60,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(cap, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          Text(imgs, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(
                        desc, 
                        style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}