import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:mysys/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mysys/database/warehouse_data.dart';
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
      onCreate: _onCreate, 
      onOpen: (db) async {
      // Enable foreign key constraints
        await db.execute('PRAGMA foreign_keys = ON');
      },  // 👈 runs ONLY first time
    );
  } 

  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
    CREATE TABLE customers(
      id INTEGER PRIMARY KEY AUTOINCREMENT,      
      name TEXT NOT NULL,
      name2 TEXT,
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
      latitude REAL,
      longitude REAL,
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
  // 1️⃣ Categories
    await db.execute('''
    CREATE TABLE product_categories(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      parent_id INTEGER,
      is_active INTEGER DEFAULT 1
    )
    ''');
  // 2️⃣ Brands
    await db.execute('''
    CREATE TABLE product_brands(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      is_active INTEGER DEFAULT 1
    )
    ''');
  // 3️⃣ Products
    await db.execute('''
    CREATE TABLE products(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      sku TEXT UNIQUE,
      name TEXT NOT NULL,
      name2 TEXT,
      category_id INTEGER,
      brand_id INTEGER,
      description TEXT,
      cost_price REAL DEFAULT 0,
      selling_price REAL DEFAULT 0,
      stock_tracking INTEGER DEFAULT 1,
      is_active INTEGER DEFAULT 1,
      created_at TEXT,
      updated_at TEXT,
      FOREIGN KEY(category_id) REFERENCES product_categories(id),
      FOREIGN KEY(brand_id) REFERENCES product_brands(id)
    )
    ''');
  // 4️⃣ Variants (Size, Color, etc.)
    await db.execute('''
    CREATE TABLE product_variants(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER NOT NULL,
      variant_name TEXT,
      sku TEXT UNIQUE,
      cost_price REAL,
      selling_price REAL,
      FOREIGN KEY(product_id) REFERENCES products(id)
    )
    ''');
  // 5️⃣ Barcodes
    await db.execute('''
    CREATE TABLE product_barcodes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER NOT NULL,
      barcode TEXT UNIQUE,
      FOREIGN KEY(product_id) REFERENCES products(id)
    )
    ''');
  // 6️⃣ Units
    await db.execute('''
    CREATE TABLE units(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      short_name TEXT
    )
    ''');
  // 7️⃣ Product Units (Piece / Box / Carton)
    await db.execute('''
    CREATE TABLE product_units(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER,
      unit_id INTEGER,
      conversion_factor REAL DEFAULT 1,
      FOREIGN KEY(product_id) REFERENCES products(id),
      FOREIGN KEY(unit_id) REFERENCES units(id)
    )
    ''');
  // 8️⃣ Price Levels (Retail, Wholesale)
    await db.execute('''
    CREATE TABLE price_levels(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    )
    ''');
  // 9️⃣ Product Prices
    await db.execute('''
    CREATE TABLE product_prices(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER,
      price_level_id INTEGER,
      price REAL,
      FOREIGN KEY(product_id) REFERENCES products(id),
      FOREIGN KEY(price_level_id) REFERENCES price_levels(id)
    )
    ''');
  // 🔟 Warehouses
    await db.execute('''
    CREATE TABLE warehouses(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      location TEXT
    )
    ''');
  
  // 1️⃣1️⃣ Inventory
    await db.execute('''
    CREATE TABLE inventory(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER,
      warehouse_id INTEGER,
      quantity REAL DEFAULT 0,
      FOREIGN KEY(product_id) REFERENCES products(id),
      FOREIGN KEY(warehouse_id) REFERENCES warehouses(id)
    )
    ''');
  // 1️⃣2️⃣ Taxes
    await db.execute('''
    CREATE TABLE taxes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      rate REAL
    )
    ''');
  // 1️⃣3️⃣ Product Taxes
    await db.execute('''
    CREATE TABLE product_taxes(
      product_id INTEGER,
      tax_id INTEGER,
      PRIMARY KEY(product_id, tax_id),
      FOREIGN KEY(product_id) REFERENCES products(id),
      FOREIGN KEY(tax_id) REFERENCES taxes(id)
    )
    ''');
  // 1️⃣4️⃣ Images
  
    await db.execute('''
    CREATE INDEX idx_products_category ON products(category_id);    
    ''');  
    await db.execute('''    
    CREATE INDEX idx_products_brand ON products(brand_id);    
    ''');      
    await db.execute('''
    CREATE INDEX idx_inventory_warehouse ON inventory(warehouse_id);
    ''');  
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


  Future<void> insertLocalizedWarehouses(String warehouseName, String location) async {
    final db = await database;
    
    // Check if data already exists to avoid duplicates
    final existing = await db.query('warehouses');    
    if (existing.isNotEmpty)return;
    await db.insert('warehouses', {
      'name': warehouseName,
      'location': location,
    });    
  }

  Future<List<Warehouse>> getWarehouses() async {
    final db = await database;
    final maps = await db.query('warehouses');
    return List<Warehouse>.from(maps.map((map) => Warehouse.fromMap(map)));
  }
}