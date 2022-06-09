import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  final path = join(await getDatabasesPath(), 'memo.db');
  final db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE memos(id INTEGER PRIMARY KEY, title TEXT, content TEXT)'
      );
      await db.insert(
        'memos',
        const Memo(
          id: 0,
          title: 'Sample Memo',
          content: 'This is a Sample Memo!'
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  return db;
}

class ControlMemoDatabase {

  Future<Database> database;
  ControlMemoDatabase({required this.database});

  Future<void> insertMemo(Memo memo) async {
    final db = await database;
    await db.insert(
      'memos',
      memo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<int>> memoIds(List<Memo> memoList) async { //idだけを取り出す
    final List<int> ids = [];
    for (var elem in memoList) {
      ids.add(elem.id);
    }
    return ids;
  }

  Future<List<Memo>> memos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('memos');
    return List.generate(maps.length, (i) {
      return Memo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
      );
    });
  }

  Future<void> updateMemo(Memo memo) async {
    final db = await database;
    await db.update(
      'memos',
      memo.toMap(),
      where: 'id = ?',
      whereArgs: [memo.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> deleteMemo(int id) async {
    final db = await database;
    await db.delete(
      'memos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class Memo {
  final int id;
  final String title;
  final String content;

  const Memo({
    required this.id,
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }
  @override
  String toString() {
    return 'Memo{id: $id, title: $title, content: $content}';
  }
}
