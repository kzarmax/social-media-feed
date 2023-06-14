import 'package:feed/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

  late Database _database;

  Future<Database> get database async {
    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();
    return await openDatabase(join(dbPath, Constants.DB_NAME), version: 1, onCreate: (Database database, int version) async {
      if (kDebugMode) {
        print("Database Create Database. Version: $version");
      }
      // 1. Create post table
      await database.execute("CREATE TABLE posts("
          "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
          "title TEXT(255) NOT NULL, "
          "description TEXT NOT NULL, "
          "url TEXT NOT NULL, "
          "image TEXT NOT NULL, "
          "author TEXT(255) NOT NULL, "
          "favorite INTEGER(20) NOT NULL DEFAULT 0, "
          "comment INTEGER(20) NOT NULL DEFAULT 0, "
          "created_at TEXT NOT NULL"
          ")");
      // 2. Create comment table
      await database.execute("CREATE TABLE comments("
          "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
          "post_id INTEGER(20) NOT NULL, "
          "content TEXT NOT NULL, "
          "created_at TIMESTAMP DEFAULT (DATETIME(CURRENT_TIMESTAMP, 'LOCALTIME'))"
          ")");
    }, onUpgrade: (Database database, int oldVersion, int newVersion) async {
      if (kDebugMode) {
        print("Database Upgrade from $oldVersion to $newVersion");
      }
    });
  }

  Future<bool> insertPost(Map<String, dynamic> item) async {
    try {
      final Database db = await database;
      await db.insert('posts', item, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (err) {
      if (kDebugMode) {
        print("Error: $err");
      }
      return false;
    }
    return true;
  }

  Future<Map<String, dynamic>> getPosts(int page, String keyword, int filter) async {
    bool hasNext = false;
    const pageSize = 5;
    final Database db = await database;
    Map<String, dynamic> result = {};
    String orderBy = "created_at DESC";
    switch (filter) {
      case 1:
        orderBy = "created_at DESC";
        break;
      case 2:
        orderBy = "author DESC";
        break;
      case 3:
        orderBy = "favorite DESC";
        break;
    }
    String? where;
    List<Object?>? whereArgs;
    if (keyword != "") {
      where = "title LIKE ?";
      whereArgs = ['%$keyword%'];
    }
    var items = await db.query(
      'posts',
      limit: pageSize + 1,
      offset: (page - 1) * pageSize,
      orderBy: orderBy,
      where: where,
      whereArgs: whereArgs,
    );
    if (items.length > pageSize) {
      hasNext = true;
    }
    result['hasNext'] = hasNext;
    if (items.length >= pageSize) {
      result['items'] = items.sublist(0, pageSize);
    } else {
      result['items'] = items;
    }

    return result;
  }

  Future<Map<String, dynamic>?> getPost(int id) async {
    final Database db = await database;
    try {
      var items = await db.query("posts", where: "id = ?", whereArgs: [id]);
      if (items.isNotEmpty) {
        return items[0];
      }
      return null;
    } catch (err) {
      if (kDebugMode) {
        print("Error: $err");
      }
      return null;
    }
  }

  Future<bool> updatePost(Map<String, dynamic> item, int id) async {
    final Database db = await database;
    try {
      await db.update(
        "posts",
        item,
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (err) {
      if (kDebugMode) {
        print("Error: $err");
      }
      return false;
    }
    return true;
  }

  Future<Map<String, dynamic>> getComments(int post_id) async {
    final Database db = await database;
    Map<String, dynamic> result = {};
    var items = await db.query(
      "comments",
      orderBy: 'id ASC',
      where: "post_id = ?",
      whereArgs: [post_id],
    );
    result["items"] = items;
    return result;
  }

  Future<int> insertComment(Map<String, dynamic> item) async {
    final Database db = await database;
    try {
      int id = await db.insert("comments", item, conflictAlgorithm: ConflictAlgorithm.replace);
      var post = await getPost(item["post_id"]);
      if (post != null) {
        Map<String, dynamic> update = {
          "comment": post["comment"] + 1,
        };
        await updatePost(update, item["post_id"]);
      }
      return id;
    } catch (err) {
      if (kDebugMode) {
        print("Error: $err");
      }
      return -1;
    }
  }

  Future<Map<String, dynamic>?> getComment(int id) async {
    final Database db = await database;
    try {
      var items = await db.query("comments", where: "id = ?", whereArgs: [id]);
      if (items.isNotEmpty) {
        return items[0];
      }
      return null;
    } catch (err) {
      if (kDebugMode) {
        print("Error: $err");
      }
      return null;
    }
  }
}
