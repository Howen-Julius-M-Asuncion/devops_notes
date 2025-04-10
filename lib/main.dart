import 'package:flutter/cupertino.dart';
import 'package:notes/pages/notelist.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Box box;

void main() async {
  await Hive.initFlutter();
  box = await Hive.openBox('notes');

  runApp(const CupertinoApp(
    debugShowCheckedModeBanner: false,
    theme: CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: CupertinoColors.systemOrange,
    ),
    home: NotelistPage(),
  ));
}
