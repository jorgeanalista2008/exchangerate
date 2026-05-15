import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/alert_model.dart';

class AlertDatabase {
  static final AlertDatabase _instance = AlertDatabase._internal();
  factory AlertDatabase() => _instance;
  AlertDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'alerts.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE price_alerts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        moneda TEXT NOT NULL,
        precioObjetivo REAL NOT NULL,
        esMayor INTEGER NOT NULL,
        activa INTEGER NOT NULL DEFAULT 1,
        fechaCreacion TEXT NOT NULL,
        ultimaNotificacion TEXT
      )
    ''');
  }

  // Insertar alerta
  Future<int> insertAlert(PriceAlert alert) async {
    final db = await database;
    return await db.insert('price_alerts', alert.toMap());
  }

  // Obtener todas las alertas
  Future<List<PriceAlert>> getAlerts({bool soloActivas = false}) async {
    final db = await database;
    final where = soloActivas ? 'activa = 1' : null;
    final maps = await db.query('price_alerts', where: where, orderBy: 'fechaCreacion DESC');
    return List.generate(maps.length, (i) => PriceAlert.fromMap(maps[i]));
  }

  // Actualizar alerta
  Future<void> updateAlert(PriceAlert alert) async {
    final db = await database;
    await db.update('price_alerts', alert.toMap(), where: 'id = ?', whereArgs: [alert.id]);
  }

  // Eliminar alerta
  Future<void> deleteAlert(int id) async {
    final db = await database;
    await db.delete('price_alerts', where: 'id = ?', whereArgs: [id]);
  }

  // Alternar activar/desactivar
  Future<void> toggleAlert(int id, bool activa) async {
    final db = await database;
    await db.update('price_alerts', {'activa': activa ? 1 : 0}, where: 'id = ?', whereArgs: [id]);
  }
}