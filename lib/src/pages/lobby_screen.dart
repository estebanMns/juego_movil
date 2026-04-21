import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'player_profile_screen.dart';
import 'level_map.dart';
import 'characters_screen.dart' as local_characters;
import 'settings_screen.dart'; 
import 'shop_screen.dart';
import 'rewards_screen.dart';
import 'achievements.dart'; // Importamos Logros
import 'story_screen.dart';  // Importamos Story

class Lobby extends StatefulWidget {
  const Lobby({super.key});

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnim;
  late AnimationController _twinkleController;
  late AnimationController _glowController;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _twinkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 6, end: 22).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _twinkleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  // --- FUNCIONES DE NAVEGACIÓN ---

  void _navigateToPlayerProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerProfileScreen()));
  }

  void _navigateToLevelMap() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const Levelmap()));
  }

  void _navigateToCharacters() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const local_characters.Characters()));
  }

  void _navigateToSettings() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
  }

  void _navigateToShop() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen()));
  }

  void _navigateToRewards() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const RewardsScreen()));
  }

  // NUEVA: Navegar a Logros
  void _navigateToAchievements() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementsScreen()));
  }

  // NUEVA: Navegar a Story
  void _navigateToStory() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const StoryScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/FondoLobby.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x55000033), Color(0x22000000), Color(0x88000033)],
                ),
              ),
            ),
          ),
          ...List.generate(28, (i) => StarParticle(index: i, controller: _twinkleController)),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: TopHud(
              floatAnim: _floatAnim,
              onAvatarTap: _navigateToPlayerProfile,
            ),
          ),
          Positioned(
            top: size.height * 0.12,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _floatAnim,
              builder: (_, _) => Transform.translate(
                offset: Offset(0, _floatAnim.value),
                child: const HeroRocket(),
              ),
            ),
          ),
          // MENU CENTRAL ACTUALIZADO
          Positioned(
            top: size.height * 0.45, 
            left: 0,
            right: 0,
            child: CenterMenuIcons(
              onCharacterTap: _navigateToCharacters,
              onShopTap: _navigateToShop,
              onRewardsTap: _navigateToRewards,
              onAchievementsTap: _navigateToAchievements,
              onStoryTap: _navigateToStory,
            ),
          ),
          Positioned(
            bottom: size.height * 0.18,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _glowAnim,
                builder: (_, _) => PlayButton(
                  glowRadius: _glowAnim.value,
                  onTap: _navigateToLevelMap,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavigationBarCustom(onSettingsTap: _navigateToSettings),
          ),
        ],
      ),
    );
  }
}

// --- WIDGETS DE APOYO ACTUALIZADOS ---

class CenterMenuIcons extends StatelessWidget {
  final VoidCallback onCharacterTap;
  final VoidCallback onShopTap;
  final VoidCallback onRewardsTap;
  final VoidCallback onAchievementsTap;
  final VoidCallback onStoryTap;

  const CenterMenuIcons({
    super.key, 
    required this.onCharacterTap, 
    required this.onShopTap,
    required this.onRewardsTap,
    required this.onAchievementsTap,
    required this.onStoryTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = (screenWidth - 48) / 3;
    
    final menuItems = [
      MenuItemData(label: 'Story', icon: Icons.auto_stories_rounded, color: const Color(0xFF40C4FF), onTap: onStoryTap),
      MenuItemData(label: 'Characters', icon: Icons.people_rounded, color: const Color(0xFFE040FB), onTap: onCharacterTap),
      MenuItemData(label: 'Achievements', icon: Icons.emoji_events_rounded, color: const Color(0xFFFFD740), onTap: onAchievementsTap),
      MenuItemData(label: 'Rewards', icon: Icons.card_giftcard_rounded, color: const Color(0xFF69F0AE), onTap: onRewardsTap),
      MenuItemData(label: 'Shop', icon: Icons.storefront_rounded, color: const Color(0xFFFF6D00), onTap: onShopTap),
      MenuItemData(label: 'Collection', icon: Icons.collections_bookmark_rounded, color: const Color(0xFFEA80FC), onTap: () {}),
    ];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12, runSpacing: 12,
        children: menuItems.map((item) => 
          SizedBox(
            width: buttonWidth > 100 ? 100 : buttonWidth,
            child: MenuIconButton(item: item),
          )
        ).toList(),
      ),
    );
  }
}

// --- LOS DEMÁS WIDGETS SE MANTIENEN IGUAL (TopHud, HudBadge, MenuIconButton, etc.) ---
// (He omitido el resto del código repetitivo para que sea más fácil de leer, 
// pero asegúrate de mantener tus clases StarParticle, PlayButton, etc. en el archivo)

class MenuItemData {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const MenuItemData({required this.label, required this.icon, required this.color, required this.onTap});
}

class MenuIconButton extends StatefulWidget {
  final MenuItemData item;
  const MenuIconButton({super.key, required this.item});
  @override
  State<MenuIconButton> createState() => _MenuIconButtonState();
}

class _MenuIconButtonState extends State<MenuIconButton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(_ctrl);
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) => _ctrl.reverse(),
      onTap: widget.item.onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: 85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.black.withValues(alpha: 0.6), 
            border: Border.all(color: widget.item.color.withValues(alpha: 0.7), width: 2),
            boxShadow: [BoxShadow(color: widget.item.color.withValues(alpha: 0.2), blurRadius: 8)]
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.item.icon, color: widget.item.color, size: 28),
              const SizedBox(height: 4),
              Text(widget.item.label.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ],
          ),
        ),
      ),
    );
  }
}

// (Sigue el resto de tu código de TopHud, PlayButton, etc. hasta el final)
// ...
class TopHud extends StatelessWidget {
  final Animation<double> floatAnim;
  final VoidCallback onAvatarTap;
  const TopHud({super.key, required this.floatAnim, required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedBuilder(
          animation: floatAnim,
          builder: (_, _) => Transform.translate(
            offset: Offset(0, floatAnim.value * 0.3),
            child: GestureDetector(
              onTap: onAvatarTap,
              child: Container(
                width: 60, height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE040FB), width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE040FB).withValues(alpha: 0.6),
                      blurRadius: 12, spreadRadius: 2,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage('assets/images/kovuIcon.png'),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EVIE', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 2)),
            Text('SPACE EXPLORER', style: TextStyle(color: Color(0xFFCE93D8), fontSize: 10, letterSpacing: 1.5)),
          ],
        ),
        const Spacer(),
        const HudBadge(icon: Icons.stars_rounded, value: '120', color: Color(0xFFFFD740)),
        const SizedBox(width: 10),
        const HudBadge(icon: Icons.rocket_launch_rounded, value: 'Lv.3', color: Color(0xFF69F0AE)),
      ],
    );
  }
}

class HudBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  const HudBadge({super.key, required this.icon, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withValues(alpha: 0.45),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 1.3),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 17),
          const SizedBox(width: 5),
          Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class HeroRocket extends StatelessWidget {
  const HeroRocket({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 130, height: 130,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(child: Image.asset('assets/images/kovuIcon.png', fit: BoxFit.cover)),
        ),
        const SizedBox(height: 10),
        const Text('El Robo De Molly', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 5)),
      ],
    );
  }
}

class PlayButton extends StatefulWidget {
  final double glowRadius;
  final VoidCallback onTap;
  const PlayButton({super.key, required this.glowRadius, required this.onTap});
  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with SingleTickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late Animation<double> _scaleAnim;
  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.90).animate(_scaleCtrl);
  }
  @override
  void dispose() { _scaleCtrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleCtrl.forward(),
      onTapUp: (_) => _scaleCtrl.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          width: 200, height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(colors: [Color(0xFFE040FB), Color(0xFF7C4DFF)]),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE040FB).withValues(alpha: 0.65),
                blurRadius: widget.glowRadius, spreadRadius: 2,
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.rocket_launch, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Text('PLAY', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 4)),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavigationBarCustom extends StatelessWidget {
  final VoidCallback onSettingsTap;
  const BottomNavigationBarCustom({super.key, required this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16, top: 16, left: 40, right: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BottomNavItem(
            icon: Icons.settings_rounded, 
            label: 'Settings', 
            color: const Color(0xFF69F0AE), 
            onTap: onSettingsTap, 
          ),
          BottomNavItem(icon: Icons.help_outline_rounded, label: 'Help', color: const Color(0xFF40C4FF), onTap: () {}),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const BottomNavItem({super.key, required this.icon, required this.label, required this.color, required this.onTap});
  @override
  State<BottomNavItem> createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<BottomNavItem> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scale = Tween<double>(begin: 1.0, end: 0.90).animate(_ctrl);
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) => _ctrl.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color.withValues(alpha: 0.15)),
              child: Icon(widget.icon, color: widget.color, size: 26),
            ),
            Text(widget.label, style: TextStyle(color: widget.color, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class StarParticle extends StatelessWidget {
  final int index;
  final AnimationController controller;
  const StarParticle({super.key, required this.index, required this.controller});
  @override
  Widget build(BuildContext context) {
    final rng = math.Random(index * 7919);
    final size = MediaQuery.of(context).size;
    final x = rng.nextDouble() * size.width;
    final y = rng.nextDouble() * size.height;
    final starSize = 1.5 + rng.nextDouble() * 2.5;
    return Positioned(
      left: x, top: y,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, _) {
          final opacity = (math.sin(controller.value * math.pi)).clamp(0.1, 1.0);
          return Opacity(opacity: opacity, child: Container(width: starSize, height: starSize, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)));
        },
      ),
    );
  }
}