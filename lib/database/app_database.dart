import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }  

  Future<bool> isDatabaseCreated() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pos_app.db');
    return File(path).existsSync();
  }

  static Future<String> getDatabasePath() async {
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, 'pos_app.db');
    return dbPath;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pos_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,   // 👈 runs ONLY first time
    );
  }

  static Future<List<String>> getTablesUsingPragma(Database db) async {
    final tables = <String>[];
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'"
    );
    
    for (var row in result) {
      tables.add(row['name'] as String);
    }
    return tables;
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
    CREATE TABLE customers(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_code TEXT UNIQUE,
      name TEXT NOT NULL,
      customer_type TEXT,
      phone TEXT,
      email TEXT,
      tax_number TEXT,
      credit_limit REAL DEFAULT 0,
      current_balance REAL DEFAULT 0,
      loyalty_points INTEGER DEFAULT 0,
      price_level TEXT,
      is_active INTEGER DEFAULT 1,
      notes TEXT,
      created_at TEXT,
      updated_at TEXT
    )
    ''');
    await db.execute('''
    CREATE TABLE customer_addresses(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_id INTEGER NOT NULL,
      type TEXT,
      address_line TEXT,
      city TEXT,
      state TEXT,
      country TEXT,
      postal_code TEXT,
      is_default INTEGER DEFAULT 0,
      FOREIGN KEY(customer_id) REFERENCES customers(id)
    )
    ''');
    await db.execute('''
    CREATE TABLE customer_contacts(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_id INTEGER NOT NULL,
      name TEXT,
      phone TEXT,
      email TEXT,
      position TEXT,
      FOREIGN KEY(customer_id) REFERENCES customers(id)
    )
    ''');
  }
}