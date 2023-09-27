import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _dbName = 'myDatabase.db';
  static final _dbVersion = 1;
  static final _tableName = 'myTable';

  static final columnId = '_id';
  static final userId = 'userId';
  static final lessonNo = 'lessonNo';
  static final questionNo = 'questionNo';
  static final answer = 'answer';
  static final timer = 'timer';

  // making it a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initiateDatabase();
    return _database!;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE $_tableName( 
      $columnId INTEGER PRIMARY KEY,
      $userId TEXT NOT NULL,
      $lessonNo INTEGER NOT NULL,
      $questionNo INTEGER NOT NULL,
      $answer TEXT NOT NULL,
      $timer INTEGER NOT NULL )
      ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<List<Map<String, dynamic>>> querySome(
      String id, int lessonNumber, int questionNumber) async {
    Database db = await instance.database;
    // get single row
    return await db.query(
      _tableName,
      where: '$userId = ? and $lessonNo = ? and $questionNo = ?',
      whereArgs: [id, lessonNumber, questionNumber],
    );
  }

  Future<List<Map<String, dynamic>>> queryLesson(
      String id, int lessonNumber) async {
    Database db = await instance.database;
    // get single row
    return await db.query(
      _tableName,
      where: '$userId = ? and $lessonNo = ? ORDER BY $questionNo ASC',
      whereArgs: [id, lessonNumber],
    );
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteLesson(String id, int lessonNumber) async {
    Database db = await instance.database;
    return await db.delete(
      _tableName,
      where: '$userId = ? and $lessonNo = ?',
      whereArgs: [id, lessonNumber],
    );
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(
      _tableName,
    );
  }
}
