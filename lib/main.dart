import 'package:flutter/cupertino.dart';
import 'package:notes/pages/notelist.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('database');

  runApp(const CupertinoApp(
    debugShowCheckedModeBanner: false,
    theme: CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: CupertinoColors.systemOrange,
    ),
    home: NotelistPage(),
  ));
}