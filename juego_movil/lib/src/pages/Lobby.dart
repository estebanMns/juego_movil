import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  LOBBY  –  Space Adventure Game Screen
// ─────────────────────────────────────────────

class Lobby extends StatefulWidget {
  const Lobby({super.key});

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> with TickerProviderStateMixin {
  // Ambient floating animation
  late AnimationController _floatController;
  late Animation<double> _floatAnim;

  // Star twinkle
  late AnimationController _twinkleController;

  // Title glow pulse
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Background ──────────────────────────────
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo_espacio.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Dark overlay for readability
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

          // ── Star particles ───────────────────────────
          ...List.generate(28, (i) => _StarParticle(index: i, controller: _twinkleController)),

          // ── Top HUD ─────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: _TopHud(floatAnim: _floatAnim),
          ),

          // ── Floating rocket / hero center ───────────
          Positioned(
            top: size.height * 0.20,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _floatAnim,
              builder: (_, __) => Transform.translate(
                offset: Offset(0, _floatAnim.value),
                child: _HeroRocket(),
              ),
            ),
          ),

          // ── PLAY button (giant, center) ──────────────
          Positioned(
            bottom: size.height * 0.22,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _glowAnim,
                builder: (_, __) => _PlayButton(glowRadius: _glowAnim.value),
              ),
            ),
          ),

          // ── Side-menu buttons (left) ─────────────────
          Positioned(
            left: 14,
            bottom: size.height * 0.14,
            child: _SideMenu(
              buttons: const ['Story', 'Characters', 'Achievements'],
              onTaps: [() {}, () {}, () {}],
            ),
          ),

          // ── Side-menu buttons (right) ────────────────
          Positioned(
            right: 14,
            bottom: size.height * 0.14,
            child: _SideMenu(
              buttons: const ['Rewards', 'Shop', 'Collection'],
              onTaps: [() {}, () {}, () {}],
              alignRight: true,
            ),
          ),

          // ── Bottom bar ───────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomBar(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TOP HUD
// ─────────────────────────────────────────────
class _TopHud extends StatelessWidget {
  final Animation<double> floatAnim;
  const _TopHud({required this.floatAnim});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE040FB), width: 2.5),
            boxShadow: [
              BoxShadow(color: const Color(0xFFE040FB).withValues(alpha: 0.6), blurRadius: 12, spreadRadius: 2),
            ],
          ),
          child: const CircleAvatar(
            radius: 26,
            backgroundImage: AssetImage('assets/images/avatar.jpg'),
          ),
        ),
        const SizedBox(width: 10),
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
        _HudBadge(icon: Icons.stars_rounded, value: '120', color: const Color(0xFFFFD740)),
        const SizedBox(width: 10),
        // Level
        _HudBadge(icon: Icons.rocket_launch_rounded, value: 'Lv.3', color: const Color(0xFF69F0AE)),
      ],
    );
  }
}

class _HudBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  const _HudBadge({required this.icon, required this.value, required this.color});

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
class _HeroRocket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Glow ring around the rocket
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: const Color(0xFF7C4DFF).withValues(alpha: 0.55), blurRadius: 40, spreadRadius: 10),
                BoxShadow(color: const Color(0xFFE040FB).withValues(alpha: 0.30), blurRadius: 60, spreadRadius: 20),
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
          // Planet / title subtitle
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
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BIG PLAY BUTTON
// ─────────────────────────────────────────────
class _PlayButton extends StatefulWidget {
  final double glowRadius;
  const _PlayButton({required this.glowRadius});

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton> with SingleTickerProviderStateMixin {
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Placeholder()),
      ),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
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
//  SIDE MENU
// ─────────────────────────────────────────────
class _SideMenu extends StatelessWidget {
  final List<String> buttons;
  final List<VoidCallback> onTaps;
  final bool alignRight;

  const _SideMenu({
    required this.buttons,
    required this.onTaps,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(buttons.length, (i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _SideButton(label: buttons[i], onTap: onTaps[i], alignRight: alignRight),
        );
      }),
    );
  }
}

class _SideButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool alignRight;

  const _SideButton({required this.label, required this.onTap, this.alignRight = false});

  @override
  State<_SideButton> createState() => _SideButtonState();
}

class _SideButtonState extends State<_SideButton> with SingleTickerProviderStateMixin {
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

  static const _icons = {
    'Story': Icons.auto_stories_rounded,
    'Characters': Icons.people_rounded,
    'Achievements': Icons.emoji_events_rounded,
    'Rewards': Icons.card_giftcard_rounded,
    'Shop': Icons.storefront_rounded,
    'Collection': Icons.collections_bookmark_rounded,
  };

  static const _colors = {
    'Story': Color(0xFF40C4FF),
    'Characters': Color(0xFFE040FB),
    'Achievements': Color(0xFFFFD740),
    'Rewards': Color(0xFF69F0AE),
    'Shop': Color(0xFFFF6D00),
    'Collection': Color(0xFFEA80FC),
  };

  @override
  Widget build(BuildContext context) {
    final color = _colors[widget.label] ?? Colors.white;
    final icon = _icons[widget.label] ?? Icons.star;

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.black.withValues(alpha: 0.50),
            border: Border.all(color: color.withValues(alpha: 0.55), width: 1.5),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 12)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 5),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
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
//  BOTTOM BAR
// ─────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 10,
        top: 12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.80),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _BottomBarItem(icon: Icons.settings_rounded, label: 'Settings', onTap: () {}),
          _BottomBarItem(icon: Icons.person_rounded, label: 'Profile', onTap: () {}),
          _BottomBarItem(icon: Icons.help_rounded, label: 'Help', onTap: () {}),
        ],
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomBarItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 10, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  STAR PARTICLES
// ─────────────────────────────────────────────
class _StarParticle extends StatelessWidget {
  final int index;
  final AnimationController controller;

  const _StarParticle({required this.index, required this.controller});

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