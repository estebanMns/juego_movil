import 'package:flutter/material.dart';
import '../src/pages/player_profile_screen.dart';
import '../src/pages/level_map.dart';
import '../src/pages/characters_screen.dart';
import '../src/pages/settings_screen.dart'; 
import '../src/pages/shop_screen.dart';
import '../src/pages/rewards_screen.dart';
import '../src/pages/achievements.dart';
import '../src/pages/story_screen.dart';

class NavigationService {
  final BuildContext context;
  NavigationService({required this.context});

  void navigateToPlayerProfile() => _push(const PlayerProfileScreen());
  void navigateToLevelMap() => _push(const Levelmap());
  void navigateToCharacters() => _push(const CharactersScreen());
  void navigateToSettings() => _push(const SettingsScreen());
  void navigateToShop() => _push(const ShopScreen());
  void navigateToRewards() => _push(const RewardsScreen());
  void navigateToAchievements() => _push(const AchievementsScreen());
  void navigateToStory() => _push(const StoryScreen());

  void _push(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}