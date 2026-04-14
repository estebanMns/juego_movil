import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:juego_movil/models/player_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('game_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Creamos la tabla basada en tu PlayerModel
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE player (
        uid TEXT PRIMARY KEY,
        username TEXT,
        avatarUrl TEXT,
        coins INTEGER,
        level INTEGER,
        xp INTEGER,
        xpToNextLevel INTEGER,
        rank TEXT,
        scanAccuracy REAL,
        totalScans INTEGER,
        dogsCollected INTEGER
      )
    ''');
  }

  // === OPERACIONES CRUD ===

  // Guardar o actualizar jugador
  Future<void> savePlayer(PlayerModel player) async {
    final db = await instance.database;
    await db.insert(
      'player',
      player.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Si existe, lo actualiza
    );
  }

  // Obtener los datos del jugador
  Future<PlayerModel?> getPlayer() async {
    final db = await instance.database;
    final maps = await db.query('player', limit: 1);

    if (maps.isNotEmpty) {
      return PlayerModel.fromJson(maps.first);
    }
    return null;
  }

  // Actualizar solo las monedas (ejemplo rápido)
  Future<void> updateCoins(String uid, int newCoins) async {
    final db = await instance.database;
    await db.update(
      'player',
      {'coins': newCoins},
      where: 'uid = ?',
      whereArgs: [uid],
    );
  }
}