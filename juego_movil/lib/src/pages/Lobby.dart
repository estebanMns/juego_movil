import 'package:flutter/material.dart';

class _LevelButton extends StatefulWidget {
  final int level;
  final bool isUnlocked;
  final VoidCallback onTap;

  const _LevelButton({
    required this.level,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  State<_LevelButton> createState() => _LevelButtonState();
}

class _LevelButtonState extends State<_LevelButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween<double>(begin: 1.0, end: 0.85).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: widget.isUnlocked
                ? [BoxShadow(color: Colors.amber.withValues(alpha: 0.5), blurRadius: 18, spreadRadius: 3)]
                : [],
            image: const DecorationImage(
              image: AssetImage('assets/images/yoongi.jpg'), // level icon
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!widget.isUnlocked)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.55),
                  ),
                ),
              Text(
                widget.level.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!widget.isUnlocked)
                const Icon(
                  Icons.lock,
                  color: Colors.white70,
                  size: 34,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _MenuButton({
    required this.label,
    required this.onTap,
  });

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _animation = Tween<double>(begin: 1.0, end: 0.88).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _animation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white24,
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage('assets/images/yoongi.jpg'), // menu button icon
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Lobby extends StatefulWidget {
  const Lobby({super.key});

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> with TickerProviderStateMixin {
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.8 + 0.2 * _bgController.value,
                  child: Image.asset(
                    'assets/images/yoongi.jpg', // background image
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: size.height * 0.13,
            left: size.width * 0.06,
            right: size.width * 0.06,
            bottom: size.height * 0.17,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: List.generate(20, (index) {
                  final levelNum = index + 1;
                  final isUnlocked = levelNum <= 10;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 38),
                    child: Row(
                      mainAxisAlignment: levelNum % 2 == 1 ? MainAxisAlignment.start : MainAxisAlignment.end,
                      children: [
                        _LevelButton(
                          level: levelNum,
                          isUnlocked: isUnlocked,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Placeholder(), // Replace with LevelDetail() when created
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.04,
            left: size.width * 0.05,
            right: size.width * 0.05,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: const AssetImage('assets/images/yoongi.jpg'), // player avatar
                ),
                const SizedBox(width: 14),
                const Text(
                  'Evie',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/yoongi.jpg', // coin icon
                      width: 34,
                      height: 34,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '120',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 28),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/yoongi.jpg', // player level icon
                      width: 34,
                      height: 34,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: size.width * 0.04,
            top: size.height * 0.24,
            child: Column(
              children: [
                _MenuButton(
                  label: 'Story',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Placeholder(), // Replace with Story() when created
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _MenuButton(
                  label: 'Characters',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Placeholder(), // Replace with Characters() when created
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _MenuButton(
                  label: 'Achievements',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Placeholder(), // Replace with Rewards() when created
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: size.width * 0.04,
            top: size.height * 0.24,
            child: Column(
              children: [
                _MenuButton(
                  label: 'Rewards',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Placeholder(), // Replace with Rewards() when created
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _MenuButton(
                  label: 'Shop',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Placeholder(), // Replace with Shop() when created
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _MenuButton(
                  label: 'Collection',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Placeholder(), // Replace with Collection() when created
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: size.height * 0.05,
            left: size.width * 0.05,
            right: size.width * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MenuButton(
                  label: 'Settings',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Placeholder(), // Replace with Settings() when created
                    ),
                  ),
                ),
                _MenuButton(
                  label: 'Profile',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Placeholder(), // Replace with PlayerProfileScreen() when created
                    ),
                  ),
                ),
                _MenuButton(
                  label: 'Help',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}