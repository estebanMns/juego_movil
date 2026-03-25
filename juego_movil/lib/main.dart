import 'package:flutter/material.dart';
import 'package:juego_movil/service/database_helper.dart';
import 'package:juego_movil/components/PlayerProfileController.dart';
import 'package:juego_movil/models/PlayerModel.dart';
import './src/app.dart';
import 'package:get/get.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Inyectamos el controlador para que esté disponible en toda el app
  Get.put(PlayerProfileController());

  try {
    // Solo inicializamos la base de datos
    await DatabaseHelper.instance.database;
    print("✅ Base de datos vinculada correctamente");
  } catch (e) {
    print("❌ Error al iniciar DB: $e");
  }


  runApp(const MyApp());
}

