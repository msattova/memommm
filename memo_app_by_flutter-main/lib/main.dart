import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'memo_db.dart';

import 'pages/home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //データベース関連（webアプリとして動作確認する場合はコメントアウトしておく）
  final database = getDatabase();
  final cmd = ControlMemoDatabase(database: database);

  runApp(MyApp(cmd));
}
