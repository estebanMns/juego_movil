import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'level_detail.dart'; // Importante para acceder a levelDetailsList

// ============================================================
// LÓGICA DE NIVELES (DIFERENCIACIÓN Y FONDO)
// ============================================================
class LevelGameData {
  final String targetObject;
  final double timeLimit; // en segundos
  final bool isHard;
  final String backgroundImage; // Ruta del asset de fondo para este nivel

  LevelGameData({
    required this.targetObject,
    required this.timeLimit,
    this.isHard = false,
    required this.backgroundImage, // Ahora es obligatorio
  });
}

// Mapa de configuración para los 20 niveles (Actualizado con Fondos)
final Map<int, LevelGameData> gameLevelConfigs = {
  0: LevelGameData(
    targetObject: "Molly (Tutorial)", 
    timeLimit: 120, 
    backgroundImage: 'assets/images/fondomolly.png', // Ejemplo
  ),
  1: LevelGameData(
    targetObject: "Ball", 
    timeLimit: 60, 
    backgroundImage: 'assets/images/fondogame_level1.png', // Ejemplo
  ),
  2: LevelGameData(
    targetObject: "Bowl", 
    timeLimit: 55, 
    backgroundImage: 'assets/images/fondogame_level2.png', // Ejemplo
  ),
  3: LevelGameData(
    targetObject: "Key (Story)", 
    timeLimit: 50, 
    backgroundImage: 'assets/images/fondogame_story.png', // Nivel de Historia
  ), 
  4: LevelGameData(
    targetObject: "Collar", 
    timeLimit: 45, 
    backgroundImage: 'assets/images/fondogame_level1.png', // Reutilizando fondo
  ),
  5: LevelGameData(
    targetObject: "Big Bone", 
    timeLimit: 40, 
    isHard: true, 
    backgroundImage: 'assets/images/fondogame_boss.png', // Boss
  ), 
  // ... sigue personalizando para los 20 niveles. 
  // Asegúrate de que las imágenes existan en tus assets.
};

// Función de utilidad para obtener config por defecto (Actualizada con Fondo)
LevelGameData getLevelConfig(int id) {
  return gameLevelConfigs[id] ?? LevelGameData(
    targetObject: "Hidden Item", 
    timeLimit: (60 - id).clamp(20, 60).toDouble(),
    isHard: id % 5 == 0,
    // Fondo genérico si no se define uno específico
    backgroundImage: 'assets/images/fondogame_generic.png', 
  );
}

// ============================================================
// PANTALLA DE JUEGO PRINCIPAL
// ============================================================
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  CameraController? _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(cameras[0], ResolutionPreset.high);
    await _controller!.initialize();
    if (!mounted) return;
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int levelId = args['levelId'];
    
    // Obtenemos info general y específica del nivel
    final detail = levelDetailsList.firstWhere((l) => l.id == levelId);
    final config = getLevelConfig(levelId);

    return Scaffold(
      backgroundColor: Colors.black, // Color de fondo base
      body: Stack( // Usamos Stack para poner el fondo detrás de todo
        children: [
          // 1. FONDO DESDE ASSETS (NUEVO)
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(config.backgroundImage), // Usa la imagen definida para el nivel
                fit: BoxFit.cover, // Cubre toda la pantalla
              ),
            ),
          ),
          
          // Opcional: Una capa semi-transparente para asegurar la legibilidad de la UI
          Container(color: Colors.black.withValues(alpha: 0.3)),

          // 2. CONTENIDO DEL JUEGO (SafeArea para evitar muescas)
          SafeArea(
            child: Column(
              children: [
                // BARRA SUPERIOR
                _buildTopBar(detail, config),

                // ÁREA DE CÁMARA (Visión del juego)
                Expanded(
                  flex: 7,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildCameraPreview(),
                      _buildObjectTarget(config.targetObject, config.isHard),
                    ],
                  ),
                ),

                // BOTONES INFERIORES
                Expanded(
                  flex: 2,
                  child: _buildBottomControls(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(LevelDetailInfo detail, LevelGameData config) {
    return Container(
      // Añadimos un fondo ligero a la barra superior para legibilidad
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          // Barra de Tiempo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.8, // Esto debería animarse con un Timer después
                    child: Container(
                      decoration: BoxDecoration(
                        color: config.isHard ? Colors.redAccent : Colors.cyanAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          _buildTopIcon(Icons.category_rounded, "${detail.itemsToCollect}"),
          const SizedBox(width: 10),
          _buildTopIcon(Icons.monetization_on_rounded, "${detail.coinsReward}"),
        ],
      ),
    );
  }

  Widget _buildTopIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber, size: 20),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCameraPreview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        // Añadimos una sombra ligera para separar la cámara del fondo
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 15,
            spreadRadius: -5,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: (_isCameraInitialized)
          ? CameraPreview(_controller!)
          : const Center(child: CircularProgressIndicator(color: Colors.cyanAccent)),
    );
  }

  Widget _buildObjectTarget(String name, bool isHard) {
    return Positioned(
      top: 30,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isHard ? Colors.redAccent : Colors.cyanAccent.withValues(alpha: 0.5),
          ),
        ),
        child: Text(
          name.toUpperCase(),
          style: TextStyle(
            color: isHard ? Colors.redAccent : Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      // Añadimos un fondo ligero a los controles inferiores para legibilidad
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCircleButton(Icons.help_outline_rounded, () {}),
          
          // Botón central de captura
          GestureDetector(
            onTap: () {
              // Acción de capturar objeto
              debugPrint("Object captured!"); 
            },
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
                border: Border.all(color: Colors.cyanAccent, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withValues(alpha: 0.3), 
                    blurRadius: 15
                  ),
                ],
              ),
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 38),
            ),
          ),

          _buildCircleButton(Icons.location_on_rounded, () {}),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white70, size: 32),
    );
  }
}