// lib/components/yolo/yolo_manual_inference_service.dart
// Responsabilidad: Cargar y gestionar una instancia manual de YOLO 
// para realizar inferencia sobre imágenes o frames individuales.

import 'dart:typed_data';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:juego_movil/auth/service/yolo_service.dart';

class YoloManualInferenceService {
  YOLO? _yolo;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  /// Carga el modelo si no ha sido cargado.
  Future<void> init() async {
    if (_isLoaded) return;
    
    _yolo = YOLO(modelPath: YoloService.modelPath);
    await _yolo!.loadModel();
    _isLoaded = true;
  }

  /// Realiza la predicción sobre un buffer de bytes (JPEG).
  Future<List<YOLOResult>> predict(Uint8List imageBytes) async {
    if (!_isLoaded || _yolo == null) {
      await init();
    }
    
    try {
      // El analizador indica que predict devuelve un Map<String, dynamic>
      // Intentamos extraer la lista de resultados de forma segura.
      final dynamic response = await _yolo!.predict(imageBytes);
      
      if (response is List) {
        return response.cast<YOLOResult>();
      } else if (response is Map && response.containsKey('results')) {
        final List results = response['results'];
        return results.cast<YOLOResult>();
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Libera los recursos del modelo.
  Future<void> dispose() async {
    _yolo = null;
    _isLoaded = false;
  }
}
