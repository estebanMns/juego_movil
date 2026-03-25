// =============================================================================
// MODELO: PlayerModel
// Ubicación: lib/models/player_model.dart
// =============================================================================

class PlayerModel {
  final String uid;
  final String username;
  final String avatarUrl;
  final int coins;
  final int level;
  final int xp;
  final int xpToNextLevel;
  final String rank;
  final double scanAccuracy;
  final int totalScans;
  final int dogsCollected;

  const PlayerModel({
    required this.uid,
    required this.username,
    required this.avatarUrl,
    required this.coins,
    required this.level,
    required this.xp,
    required this.xpToNextLevel,
    required this.rank,
    required this.scanAccuracy,
    required this.totalScans,
    required this.dogsCollected,
  });

  // Este método te servirá cuando conectes el juego a un backend o JSON
  factory PlayerModel.fromJson(Map<String, dynamic> json) => PlayerModel(
        uid: json['uid'] as String,
        username: json['username'] as String,
        avatarUrl: json['avatarUrl'] as String,
        coins: json['coins'] as int,
        level: json['level'] as int,
        xp: json['xp'] as int,
        xpToNextLevel: json['xpToNextLevel'] as int,
        rank: json['rank'] as String,
        scanAccuracy: (json['scanAccuracy'] as num).toDouble(),
        totalScans: json['totalScans'] as int,
        dogsCollected: json['dogsCollected'] as int,
      );

  // Útil para guardar los datos localmente si usas SharedPreferences o Sqflite
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'avatarUrl': avatarUrl,
        'coins': coins,
        'level': level,
        'xp': xp,
        'xpToNextLevel': xpToNextLevel,
        'rank': rank,
        'scanAccuracy': scanAccuracy,
        'totalScans': totalScans,
        'dogsCollected': dogsCollected,
      };
}
