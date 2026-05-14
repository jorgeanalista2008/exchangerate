import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/finance_model.dart';

class FinanceDatabase {
  static final FinanceDatabase _instance = FinanceDatabase._internal();
  factory FinanceDatabase() => _instance;
  FinanceDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'finance.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT NOT NULL,
        concepto TEXT NOT NULL,
        monto REAL NOT NULL,
        moneda TEXT NOT NULL,
        categoria TEXT NOT NULL,
        fecha TEXT NOT NULL,
        nota TEXT
      )
    ''');
  }

  // Insertar transacción
  Future<int> insertTransaction(FinanceTransaction transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  // Actualizar transacción
  Future<void> updateTransaction(FinanceTransaction transaction) async {
    final db = await database;
    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // Eliminar transacción
  Future<void> deleteTransaction(int id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  // Obtener todas las transacciones
  Future<List<FinanceTransaction>> getTransactions({
    String? tipo,
    String? moneda,
    String? categoria,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    int limit = 100,
  }) async {
    final db = await database;
    
    List<String> where = [];
    List<dynamic> whereArgs = [];
    
    if (tipo != null) {
      where.add('tipo = ?');
      whereArgs.add(tipo);
    }
    if (moneda != null) {
      where.add('moneda = ?');
      whereArgs.add(moneda);
    }
    if (categoria != null) {
      where.add('categoria = ?');
      whereArgs.add(categoria);
    }
    if (fechaInicio != null) {
      where.add('fecha >= ?');
      whereArgs.add(fechaInicio.toIso8601String());
    }
    if (fechaFin != null) {
      where.add('fecha <= ?');
      whereArgs.add(fechaFin.toIso8601String());
    }
    
    final whereClause = where.isNotEmpty ? where.join(' AND ') : null;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: whereClause,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'fecha DESC',
      limit: limit,
    );
    
    return List.generate(maps.length, (i) => FinanceTransaction.fromMap(maps[i]));
  }

  // Obtener resumen financiero
  Future<FinancialSummary> getSummary({
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    final db = await database;
    
    String dateFilter = '';
    List<dynamic> dateArgs = [];
    
    if (fechaInicio != null && fechaFin != null) {
      dateFilter = 'AND fecha BETWEEN ? AND ?';
      dateArgs = [fechaInicio.toIso8601String(), fechaFin.toIso8601String()];
    }
    
    // Ingresos USD
    final ingresosUSD = await db.rawQuery(
      'SELECT COALESCE(SUM(monto), 0) as total FROM transactions WHERE tipo = "ingreso" AND moneda = "USD" $dateFilter',
      dateArgs,
    );
    
    // Ingresos VES
    final ingresosVES = await db.rawQuery(
      'SELECT COALESCE(SUM(monto), 0) as total FROM transactions WHERE tipo = "ingreso" AND moneda = "VES" $dateFilter',
      dateArgs,
    );
    
    // Egresos USD
    final egresosUSD = await db.rawQuery(
      'SELECT COALESCE(SUM(monto), 0) as total FROM transactions WHERE tipo = "egreso" AND moneda = "USD" $dateFilter',
      dateArgs,
    );
    
    // Egresos VES
    final egresosVES = await db.rawQuery(
      'SELECT COALESCE(SUM(monto), 0) as total FROM transactions WHERE tipo = "egreso" AND moneda = "VES" $dateFilter',
      dateArgs,
    );
    
    double ingresosUSDT = (ingresosUSD.first['total'] as num).toDouble();
    double ingresosVEST = (ingresosVES.first['total'] as num).toDouble();
    double egresosUSDT = (egresosUSD.first['total'] as num).toDouble();
    double egresosVEST = (egresosVES.first['total'] as num).toDouble();
    
    return FinancialSummary(
      totalIngresosUSD: ingresosUSDT,
      totalIngresosVES: ingresosVEST,
      totalEgresosUSD: egresosUSDT,
      totalEgresosVES: egresosVEST,
      balanceUSD: ingresosUSDT - egresosUSDT,
      balanceVES: ingresosVEST - egresosVEST,
    );
  }

  // Obtener categorías únicas
  Future<List<String>> getCategories() async {
    final db = await database;
    final result = await db.rawQuery('SELECT DISTINCT categoria FROM transactions ORDER BY categoria');
    return result.map((row) => row['categoria'] as String).toList();
  }

  // Agrega estos métodos a la clase FinanceDatabase:

    // Obtener gastos agrupados por categoría
    Future<Map<String, double>> getExpensesByCategory({
      DateTime? fechaInicio,
      DateTime? fechaFin,
      String moneda = 'USD',
    }) async {
      final db = await database;
      
      String dateFilter = '';
      List<dynamic> args = [moneda];
      
      if (fechaInicio != null && fechaFin != null) {
        dateFilter = 'AND fecha BETWEEN ? AND ?';
        args.addAll([fechaInicio.toIso8601String(), fechaFin.toIso8601String()]);
      }
      
      final result = await db.rawQuery(
        'SELECT categoria, SUM(monto) as total FROM transactions WHERE tipo = "egreso" AND moneda = ? $dateFilter GROUP BY categoria ORDER BY total DESC',
        args,
      );
      
      Map<String, double> expenses = {};
      for (var row in result) {
        expenses[row['categoria'] as String] = (row['total'] as num).toDouble();
      }
      
      return expenses;
    }

}