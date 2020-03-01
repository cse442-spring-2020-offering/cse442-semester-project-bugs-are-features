import 'dart:developer' as dev;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:ghost_app/db/debug.dart';

import 'constants.dart' as Constants;

/// The database class, which is our point of contact for all database transactions.
///
/// This class will also create the schema for the database if the database is not
/// yet created yet. The close() method must be called
class DB {
  /// The database path.
  String _path;

  /// The database singleton instance.
  Database _pool;

  /// Some debugging utilities in a DbDebug class for the database.
  DbDebug _debug;

  DB() {
    _init();
  }

  /// Opens the database connection, storing to the pool.
  _init() async {
    dev.log("Called _init", name: "db.db");
    // These aren't in the constructor because they're asynchronous
    var databasesPath = await getDatabasesPath();
    _path = join(databasesPath, Constants.DB_NAME);
    _pool = await openDatabase(_path, version: 1, onCreate: _seed);
    _debug = DbDebug(this);
  }

  /// Returns the database connection singleton.
  get pool {
    return _pool;
  }

  /// Returns the debugging class for the database.
  get debug {
    return _debug;
  }

  /// Sets a particular ghost id as chosen and active.
  Future<int> setGhost(int id) async {
    if (id < 0 || id > 9) {
      throw ArgumentError('The `id` passed is likely invalid.');
    }

    Map<String, dynamic> row = {
      Constants.GHOST_PROGRESS: 0,
      Constants.GHOST_SCORE: 1,
      Constants.GHOST_ACTIVE: true
    };

    dev.log("Set ghost id $id", name: "db.db");
    // Return the ID that was updated.
    int res = await _pool.update(
        Constants.GHOST_TABLE, row,
        where: '${Constants.GHOST_ID} = ?',
        whereArgs: [id]
    );

    return res;
  }

  /// Unsets a particular ghost id as chosen and active.
  ///
  /// This resets the ghost's data to the default.
  Future<int> unsetGhost(int id) async {
    if (id < 0 || id > 9) {
      throw ArgumentError('The `id` passed is likely invalid.');
    }

    Map<String, dynamic> row = {
      Constants.GHOST_TEMPERAMENT: 1,
      Constants.GHOST_DIFFICULTY: id ~/ 3,
      Constants.GHOST_PROGRESS: 0,
      Constants.GHOST_SCORE: 0,
      Constants.GHOST_ACTIVE: false
    };

    dev.log("Unset ghost id $id", name: "db.db");
    // Return the ID that was updated.
    int res = await _pool.update(
        Constants.GHOST_TABLE, row,
        where: '${Constants.GHOST_ID} = ?',
        whereArgs: [id]
    );

    return res;
  }

  /// Closes the database connection. Should only be called when app is killed.
  close() async {
    dev.log("Closed DB Connection", name: "db.db");
    await _pool.close();
    _pool = null;
  }

  /// Deletes the database and creates a new one. THIS DELETES ALL DATA!
  delete() async {
    close();
    dev.log("Deleted DB", name: "db.db");
    await deleteDatabase(_path);
    _init();
  }

  /// Creates the database tables and initializes the data.
  _seed(Database db, int version) async {
    dev.log("Seeding DB", name: "db.db");
    await db.execute(
        "CREATE TABLE ${Constants.GHOST_TABLE} ("
            "${Constants.GHOST_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
            // 0 = Angry, 1 = Neutral, 2 = Friendly
            "${Constants.GHOST_TEMPERAMENT} INTEGER NOT NULL,"
            // Difficulty 0 - 2, 2 being hardest
            "${Constants.GHOST_DIFFICULTY} INTEGER NOT NULL,"
            // 0-10 Story Progress
            "${Constants.GHOST_PROGRESS} INTEGER NOT NULL,"
            // Accumulated Points
            "${Constants.GHOST_SCORE} INTEGER NOT NULL,"
            // If the ghost is "assigned" to user
            "${Constants.GHOST_ACTIVE} BOOLEAN NOT NULL"
        ")");

    // Insert a default row for each ghost
    for (var i = 0; i < 9; i++) {
      Map<String, dynamic> row = {
        Constants.GHOST_TEMPERAMENT: 1,
        Constants.GHOST_DIFFICULTY: i ~/ 3,
        Constants.GHOST_PROGRESS: 0,
        Constants.GHOST_SCORE: 0,
        Constants.GHOST_ACTIVE: false
      };
      dev.log("Inserted ghost id ${i + 1}", name: "db.db");
      await db.insert(Constants.GHOST_TABLE, row);
    }
  }
}