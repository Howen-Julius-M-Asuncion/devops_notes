import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/main.dart';

class NotePage extends StatefulWidget {
  final int? index;
  const NotePage({super.key, this.index});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List<dynamic> noteData = [];

  late final TextEditingController _titleController;
  late final QuillController _contentController;
  bool _isPinned = false;

  @override
  void initState() {
    super.initState();
    box = Hive.box('notes');

    _titleController = TextEditingController();
    _contentController = QuillController.basic();

  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Edit Note'),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                _isPinned ? CupertinoIcons.pin_fill : CupertinoIcons.pin,
                color: _isPinned ? CupertinoColors.systemOrange : null,
              ),
              onPressed: () {
                setState(() {
                  _isPinned = !_isPinned;
                });
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.ellipsis_circle),
              onPressed: (){},
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CupertinoTextField(
                controller: _titleController,
                placeholder: 'Title',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: CupertinoTheme.of(context).textTheme.textStyle.color,
                ),
                decoration: null,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: QuillEditor.basic(
                  controller: _contentController,
                  scrollController: ScrollController(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
