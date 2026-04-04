import 'package:get/get.dart';

class SettingsController extends GetxController {
  var isSoundOn = true.obs;
  var isMusicOn = true.obs;
  var currentLanguage = 'Español'.obs;

  void toggleSound() => isSoundOn.value = !isSoundOn.value;
  void toggleMusic() => isMusicOn.value = !isMusicOn.value;
  
  void changeLanguage(String lang) {
    currentLanguage.value = lang;
    // Aquí podrías agregar la lógica de Get.updateLocale más adelante
  }
}