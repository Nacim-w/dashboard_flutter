import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'contacts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        nickname TEXT UNIQUE,
        phone TEXT UNIQUE
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getContacts() async {
    final db = await database;
    return await db.query('contacts', orderBy: 'name');
  }

  Future<int> addContact(String name, String nickname, String phone) async {
    final db = await database;
    return await db.insert(
      'contacts',
      {'name': name, 'nickname': nickname, 'phone': phone},
    );
  }

  Future<int> updateContact(int id, String name, String nickname, String phone) async {
    final db = await database;
    return await db.update(
      'contacts',
      {'name': name, 'nickname': nickname, 'phone': phone},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
