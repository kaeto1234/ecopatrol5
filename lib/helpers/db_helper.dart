import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/report_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'ecopatrol.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE reports (
id INTEGER PRIMARY KEY AUTOINCREMENT,
title TEXT,
description TEXT,
imagePath TEXT,
latitude REAL,
longitude REAL,
status TEXT,
createdAt TEXT,
doneNote TEXT,
doneImagePath TEXT
)
''');
      },
    );
  }

  Future<int> insertReport(ReportModel report) async {
    final database = await db;
    return await database.insert('reports', report.toMap());
  }

  Future<List<ReportModel>> getAllReports() async {
    final database = await db;
    final maps = await database.query('reports', orderBy: 'id DESC');
    return maps.map((m) => ReportModel.fromMap(m)).toList();
  }

  Future<int> updateReport(ReportModel report) async {
    final database = await db;
    return await database.update(
      'reports',
      report.toMap(),
      where: 'id = ?',
      whereArgs: [report.id],
    );
  }

  Future<int> deleteReport(int id) async {
    final database = await db;
    return await database.delete('reports', where: 'id = ?', whereArgs: [id]);
  }
}
