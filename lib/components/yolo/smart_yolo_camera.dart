// lib/components/yolo/smart_yolo_camera.dart
// Responsabilidad: Alternar automáticamente entre YOLOView (dispositivo real)
// y CameraPreview estándar con inferencia manual (emuladores/otros).

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'yolo_manual_inference_service.dart';
import 'package:juego_movil/auth/service/yolo_service.dart';

typedef DetectionCallback = void Function(List<YOLOResult> results);

class SmartYoloCamera extends StatefulWidget {
  final DetectionCallback onResult;
  const SmartYoloCamera({super.key, required this.onResult});

  @override
  State<SmartYoloCamera> createState() => _SmartYoloCameraState();
}

class _SmartYoloCameraState extends State<SmartYoloCamera> {
  CameraController? _cameraController;
  final YoloManualInferenceService _manualInference = YoloManualInferenceService();
  bool _isUsingFallback = false;
  bool _isCameraInitialized = false;
  Timer? _inferenceTimer;
  bool _isProcessingFrame = false;

  @override
  void initState() {
    super.initState();
    _checkPlatformAndInit();
  }

  void _checkPlatformAndInit() {
    // Detectamos si estamos en un entorno que probablemente NO soporte YOLOView
    // (Emuladores o plataformas no móviles)
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      _initFallbackCamera();
    } else {
      // En Android/iOS intentamos usar YOLOView, pero permitimos el cambio si falla
      // Nota: YOLOView no permite capturar su error fácilmente, así que 
      // por ahora asumimos soporte en móvil real, pero puedes forzar fallback si sabes
      // que es un emulador.
      
      // DEBUG: Si quieres probar el fallback en dispositivo real, cambia esto a true.
      _isUsingFallback = false; 
    }
  }

  Future<void> _initFallbackCamera() async {
    setState(() => _isUsingFallback = true);
    
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras[0], 
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      await _manualInference.init();
      
      if (mounted) {
        setState(() => _isCameraInitialized = true);
        _startManualInferenceLoop();
      }
    } catch (e) {
      print("Error inicializando cámara de respaldo: $e");
    }
  }

  void _startManualInferenceLoop() {
    // Escaneamos cada 1.5 segundos en emuladores para no saturar
    _inferenceTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) async {
      if (_isProcessingFrame || !mounted || _cameraController == null || !_cameraController!.value.isInitialized) return;

      _isProcessingFrame = true;
      try {
        // Capturamos una imagen (esto nos da bytes JPEG compatibles directamente con YOLO.predict)
        final XFile file = await _cameraController!.takePicture();
        final bytes = await file.readAsBytes();
        
        final results = await _manualInference.predict(bytes);
        widget.onResult(results);
      } catch (e) {
        print("Error en loop de inferencia manual: $e");
      } finally {
        _isProcessingFrame = false;
      }
    });
  }

  @override
  void dispose() {
    _inferenceTimer?.cancel();
    _cameraController?.dispose();
    _manualInference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isUsingFallback) {
      return _buildFallbackView();
    }

    // MODO REAL: YOLOView nativo
    return YOLOView(
      modelPath: YoloService.modelPath,
      task: YOLOTask.detect,
      onResult: widget.onResult,
    );
  }

  Widget _buildFallbackView() {
    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_cameraController!),
        const Positioned(
          bottom: 10,
          right: 10,
          child: Text(
            "MODO COMPATIBILIDAD (EMULADOR)",
            style: TextStyle(color: Colors.white54, fontSize: 8),
          ),
        ),
      ],
    );
  }
}
