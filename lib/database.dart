import 'dart:io';
import 'package:database/database.dart';
import 'package:database/productmodel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseIn {
  final String table = 'contacts';
  Database? _db;

  Future<Database> database() async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationCacheDirectory();
    String path = join(dir.path, 'contacs.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT,
            phone TEXT
          )
        ''');
      },
    );
  }
  Future<int> insert(ContactModel data) async {
    final db = await database();
    return await db.insert(table, data.toMap());
  }

  Future<List<ContactModel>> getAll() async{
    final db = await database();
    final result = await db.query(table);
    return result.map((e) => ContactModel.fromMap(e)).toList();
  }

  Future<int> update(ContactModel data) async {
    final db = await database();
    return await db.update(
      table,
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database();
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}