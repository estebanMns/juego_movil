// lib/components/yolo/detection_validator.dart
// Responsabilidad ÚNICA: Validar si los objetos detectados por la IA
// contienen el objeto objetivo del juego con un umbral de confianza.

import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class DetectionValidator {
  /// Umbral mínimo de confianza para aceptar una detección (0.0 a 1.0)
  final double confidenceThreshold;

  DetectionValidator({this.confidenceThreshold = 0.45});

  /// Comprueba si el [target] está presente en la lista de [detecciones].
  /// [target] debe coincidir con el 'className' devuelto por el modelo.
  bool isTargetDetected(List<YOLOResult> detections, String target) {
    if (detections.isEmpty) return false;

    // Buscamos si alguna detección coincide con el nombre y supera el umbral
    return detections.any((d) =>
        d.className.toLowerCase() == target.toLowerCase() &&
        d.confidence >= confidenceThreshold);
  }

  /// Devuelve la mejor detección encontrada para el objetivo, si existe.
  YOLOResult? getBestTargetDetection(List<YOLOResult> detections, String target) {
    YOLOResult? best;
    double maxConf = 0.0;

    for (final d in detections) {
      final conf = d.confidence;
      final name = d.className.toLowerCase();
      
      if (name == target.toLowerCase() &&
          conf >= confidenceThreshold &&
          conf > maxConf) {
        maxConf = conf;
        best = d;
      }
    }
    return best;
  }
}
