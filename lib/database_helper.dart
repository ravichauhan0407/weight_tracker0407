import 'weight.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;
  String weightTable = 'weightTable';
  String colID = 'id';
  String colWeight = 'weight';
  String colDate = 'date';
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'weight.db';
    var weightDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return weightDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $weightTable($colID INTEGER PRIMARY KEY AUTOINCREMENT,$colWeight INTEGER,$colDate  TEXT)');
  }

  Future<List<Map<String, dynamic>>> get getWeightMapList async {
    Database db = await this.database;
    var result = await db.query(weightTable);
    return result;
  }

  Future<int> insertWeight(Weight weight) async {
    Database db = await this.database;
    var result = await db.insert(weightTable, weight.toMap());
    return result;
  }

  Future<int> updateWeight(Weight weight) async {
    Database db = await this.database;
    var result = await db.update(weightTable, weight.toMap(),
        where: '$colID=?', whereArgs: [weight.id]);
    return result;
  }

  Future<int> deleteWeight(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $weightTable where $colID=$id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $weightTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Weight>> getWeightList() async {
    var weightMapList = await getWeightMapList;
    int count = weightMapList.length;
    List<Weight> noteList = List<Weight>();
    for (var i = 0; i < count; i++) {
      noteList.add(Weight.fromMapObject(weightMapList[i]));
    }
    return noteList;
  }
}
