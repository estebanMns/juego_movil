import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:juego_movil/config/AppColors.dart';
import 'package:juego_movil/components/SettingsController.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Fondo (Usa la misma imagen de fondo que el perfil para consistencia)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/perfilFondo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _buildSettingSection('AUDIO'),
                      _buildSwitchTile('Efectos de Sonido', controller.isSoundOn, controller.toggleSound),
                      _buildSwitchTile('Música de Fondo', controller.isMusicOn, controller.toggleMusic),
                      
                      const SizedBox(height: 30),
                      
                      _buildSettingSection('SISTEMA'),
                      _buildLanguageTile(controller),
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

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          const Text(
            'AJUSTES',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 3),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 10),
      child: Text(title, style: const TextStyle(color: AppColors.cyan, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
    );
  }

  Widget _buildSwitchTile(String title, RxBool value, VoidCallback onTap) {
    return Obx(() => Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: Switch(
          value: value.value,
          onChanged: (_) => onTap(),
          activeColor: AppColors.cyan,
        ),
      ),
    ));
  }

  Widget _buildLanguageTile(SettingsController controller) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        title: const Text('Idioma', style: TextStyle(color: Colors.white)),
        trailing: Obx(() => Text(controller.currentLanguage.value, style: const TextStyle(color: AppColors.cyan))),
        onTap: () {
          // Aquí podrías abrir un Dialog para elegir idioma
          controller.changeLanguage(controller.currentLanguage.value == 'Español' ? 'English' : 'Español');
        },
      ),
    );
  }
}