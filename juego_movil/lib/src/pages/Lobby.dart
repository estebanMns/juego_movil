import 'dart:math' as math;
import 'package:flutter/material.dart';
// TODO: Descomenta esta línea cuando tengas el archivo PlayerProfileScreen
// import 'player_profile_screen.dart';

// ─────────────────────────────────────────────
//  LOBBY  –  Space Adventure Game Screen
// ─────────────────────────────────────────────

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

  // Método para navegar al perfil del jugador
  void _navigateToPlayerProfile() {
    // TODO: Descomenta la siguiente línea cuando tengas PlayerProfileScreen.dart
    // Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerProfileScreen()));
    
    // Línea temporal para pruebas (ELIMINAR cuando integres el backend)
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => const Scaffold(
        body: Center(child: Text('Player Profile Screen', style: TextStyle(fontSize: 24))),
      ))
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo_espacio.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Dark overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x55000033),
                    Color(0x22000000),
                    Color(0x88000033),
                  ],
                ),
              ),
            ),
          ),

          // Star particles
          ...List.generate(28, (i) => StarParticle(index: i, controller: _twinkleController)),

          // Top HUD
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: TopHud(
              floatAnim: _floatAnim,
              onAvatarTap: _navigateToPlayerProfile,
            ),
          ),

          // Floating rocket
          Positioned(
            top: size.height * 0.12,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _floatAnim,
              builder: (_, __) => Transform.translate(
                offset: Offset(0, _floatAnim.value),
                child: const HeroRocket(),
              ),
            ),
          ),

          // Center menu icons
          Positioned(
            top: size.height * 0.38,
            left: 0,
            right: 0,
            child: const CenterMenuIcons(),
          ),

          // PLAY button
          Positioned(
            bottom: size.height * 0.18,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _glowAnim,
                builder: (_, __) => PlayButton(glowRadius: _glowAnim.value),
              ),
            ),
          ),

          // Bottom navigation bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const BottomNavigationBarCustom(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TOP HUD - CORREGIDO
// ─────────────────────────────────────────────
class TopHud extends StatelessWidget {
  final Animation<double> floatAnim;
  final VoidCallback onAvatarTap;

  const TopHud({
    super.key,
    required this.floatAnim,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar clicable - CORREGIDO CON HitTestBehavior
        AnimatedBuilder(
          animation: floatAnim,
          builder: (_, __) => Transform.translate(
            offset: Offset(0, floatAnim.value * 0.3),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque, // ESTO PERMITE DETECTAR TOQUES
              onTap: () {
                // Debug para verificar que funciona
                // ignore: avoid_print
                print('✅ Avatar touched! Navigating to profile...');
                onAvatarTap();
              },
              child: Container(
                width: 60, // Tamaño explícito
                height: 60, // Tamaño explícito
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE040FB), width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE040FB).withValues(alpha: 0.6),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage('assets/images/avatar.jpg'),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Texto de usuario (NO clicable)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'EVIE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            Text(
              'SPACE EXPLORER',
              style: TextStyle(
                color: Color(0xFFCE93D8),
                fontSize: 10,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const Spacer(),
        // Coins
        HudBadge(icon: Icons.stars_rounded, value: '120', color: const Color(0xFFFFD740)),
        const SizedBox(width: 10),
        // Level
        HudBadge(icon: Icons.rocket_launch_rounded, value: 'Lv.3', color: const Color(0xFF69F0AE)),
      ],
    );
  }
}

class HudBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const HudBadge({
    super.key,
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withValues(alpha: 0.45),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 1.3),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 8)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 17),
          const SizedBox(width: 5),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HERO ROCKET
// ─────────────────────────────────────────────
class HeroRocket extends StatelessWidget {
  const HeroRocket({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C4DFF).withValues(alpha: 0.55),
                blurRadius: 40,
                spreadRadius: 10,
              ),
              BoxShadow(
                color: const Color(0xFFE040FB).withValues(alpha: 0.30),
                blurRadius: 60,
                spreadRadius: 20,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/yoongi.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFE040FB), Color(0xFF7C4DFF), Color(0xFF40C4FF)],
          ).createShader(bounds),
          child: const Text(
            'STAR QUEST',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 5,
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'GALAXY ADVENTURE',
          style: TextStyle(
            color: Color(0xFFCE93D8),
            fontSize: 11,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  CENTER MENU ICONS
// ─────────────────────────────────────────────
class CenterMenuIcons extends StatelessWidget {
  const CenterMenuIcons({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = const [
      MenuItemData(label: 'Story', icon: Icons.auto_stories_rounded, color: Color(0xFF40C4FF)),
      MenuItemData(label: 'Characters', icon: Icons.people_rounded, color: Color(0xFFE040FB)),
      MenuItemData(label: 'Achievements', icon: Icons.emoji_events_rounded, color: Color(0xFFFFD740)),
      MenuItemData(label: 'Rewards', icon: Icons.card_giftcard_rounded, color: Color(0xFF69F0AE)),
      MenuItemData(label: 'Shop', icon: Icons.storefront_rounded, color: Color(0xFFFF6D00)),
      MenuItemData(label: 'Collection', icon: Icons.collections_bookmark_rounded, color: Color(0xFFEA80FC)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: menuItems.map((item) {
          return MenuIconButton(item: item);
        }).toList(),
      ),
    );
  }
}

class MenuItemData {
  final String label;
  final IconData icon;
  final Color color;

  const MenuItemData({
    required this.label,
    required this.icon,
    required this.color,
  });
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
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      onTap: () {
        // TODO: Implementar navegación real para cada ítem del menú
      },
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 75,
          height: 85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.black.withValues(alpha: 0.50),
            border: Border.all(color: widget.item.color.withValues(alpha: 0.55), width: 1.5),
            boxShadow: [BoxShadow(color: widget.item.color.withValues(alpha: 0.25), blurRadius: 12)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.item.icon, color: widget.item.color, size: 28),
              const SizedBox(height: 6),
              Text(
                widget.item.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.item.color,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PLAY BUTTON
// ─────────────────────────────────────────────
class PlayButton extends StatefulWidget {
  final double glowRadius;

  const PlayButton({super.key, required this.glowRadius});

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
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleCtrl.forward(),
      onTapUp: (_) => _scaleCtrl.reverse(),
      onTapCancel: () => _scaleCtrl.reverse(),
      onTap: () {
        // TODO: Navegar a la pantalla del juego
      },
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          width: 200,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              colors: [Color(0xFFE040FB), Color(0xFF7C4DFF)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE040FB).withValues(alpha: 0.65),
                blurRadius: widget.glowRadius,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.rocket_launch, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Text(
                'PLAY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BOTTOM NAVIGATION BAR
// ─────────────────────────────────────────────
class BottomNavigationBarCustom extends StatelessWidget {
  const BottomNavigationBarCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 16,
        top: 16,
        left: 40,
        right: 40,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.90),
            Colors.black.withValues(alpha: 0.40),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BottomNavItem(
            icon: Icons.settings_rounded,
            label: 'Settings',
            color: const Color(0xFF69F0AE),
            onTap: () {
              // TODO: Implementar navegación a Settings
            },
          ),
          BottomNavItem(
            icon: Icons.help_outline_rounded,
            label: 'Help',
            color: const Color(0xFF40C4FF),
            onTap: () {
              // TODO: Implementar navegación a Help
            },
          ),
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

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

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
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withValues(alpha: 0.15),
                border: Border.all(color: widget.color.withValues(alpha: 0.5), width: 1.5),
              ),
              child: Icon(widget.icon, color: widget.color, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              widget.label,
              style: TextStyle(
                color: widget.color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  STAR PARTICLES
// ─────────────────────────────────────────────
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
    final delay = rng.nextDouble();

    return Positioned(
      left: x,
      top: y,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final t = (controller.value + delay) % 1.0;
          final opacity = (math.sin(t * math.pi)).clamp(0.1, 1.0);
          return Opacity(
            opacity: opacity,
            child: Container(
              width: starSize,
              height: starSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}