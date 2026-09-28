import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/queue_person.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static const _databaseName = 'queue_management.db';
  static const _tableName = 'queue_person';

  Future<Database>? _database;

  Future<Database> get database async {
    _database ??= _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final databasePath = join(await getDatabasesPath(), _databaseName);
    return openDatabase(
      databasePath,
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            queueNumber INTEGER NOT NULL,
            status TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            servedAt TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertPerson(String name) async {
    final cleanedName = name.trim();
    if (cleanedName.isEmpty) {
      throw const FormatException('Please enter a name.');
    }

    final db = await database;
    return db.transaction((transaction) async {
      final highestQueueResult = await transaction.rawQuery(
        'SELECT MAX(queueNumber) AS highest FROM $_tableName',
      );
      final highestQueueNumber =
          highestQueueResult.first['highest'] as int? ?? 0;

      final sequenceResult = await transaction.rawQuery(
        'SELECT seq FROM sqlite_sequence WHERE name = ?',
        [_tableName],
      );
      final highestRecordId = sequenceResult.isEmpty
          ? 0
          : sequenceResult.first['seq'] as int? ?? 0;
      final lastNumber = highestQueueNumber > highestRecordId
          ? highestQueueNumber
          : highestRecordId;

      return transaction.insert(_tableName, {
        'name': cleanedName,
        'queueNumber': lastNumber + 1,
        'status': 'Waiting',
        'createdAt': DateTime.now().toIso8601String(),
        'servedAt': null,
      });
    });
  }

  Future<List<QueuePerson>> getWaitingPeople() async {
    final db = await database;
    final rows = await db.query(
      _tableName,
      where: 'status = ?',
      whereArgs: ['Waiting'],
      orderBy: 'queueNumber ASC',
    );
    return rows.map(QueuePerson.fromMap).toList();
  }

  Future<List<QueuePerson>> getAllPeople() async {
    final db = await database;
    final rows = await db.query(_tableName, orderBy: 'queueNumber ASC');
    return rows.map(QueuePerson.fromMap).toList();
  }

  Future<QueuePerson?> getNextWaitingPerson() async {
    final db = await database;
    final rows = await db.query(
      _tableName,
      where: 'status = ?',
      whereArgs: ['Waiting'],
      orderBy: 'queueNumber ASC',
      limit: 1,
    );
    return rows.isEmpty ? null : QueuePerson.fromMap(rows.first);
  }

  Future<int> servePerson(int id) async {
    final db = await database;
    return db.update(
      _tableName,
      {
        'status': 'Served',
        'servedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ? AND status = ?',
      whereArgs: [id, 'Waiting'],
    );
  }

  Future<QueuePerson?> getLastServedPerson() async {
    final db = await database;
    final rows = await db.query(
      _tableName,
      where: 'status = ?',
      whereArgs: ['Served'],
      orderBy: 'servedAt DESC, queueNumber DESC',
      limit: 1,
    );
    return rows.isEmpty ? null : QueuePerson.fromMap(rows.first);
  }

  Future<int> deleteServedPeople() async {
    final db = await database;
    return db.delete(
      _tableName,
      where: 'status = ?',
      whereArgs: ['Served'],
    );
  }

  Future<QueueStatistics> getStatistics() async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT
        COUNT(*) AS total,
        COALESCE(SUM(CASE WHEN status = ? THEN 1 ELSE 0 END), 0) AS served,
        COALESCE(SUM(CASE WHEN status = ? THEN 1 ELSE 0 END), 0) AS waiting
      FROM $_tableName
    ''', ['Served', 'Waiting']);
    final row = rows.first;
    return QueueStatistics(
      total: row['total']! as int,
      served: row['served']! as int,
      waiting: row['waiting']! as int,
    );
  }
}