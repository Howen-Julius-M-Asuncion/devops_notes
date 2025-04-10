import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/main.dart';

class NotePage extends StatefulWidget {
  final dynamic hiveKey;
  final Map<String, dynamic>? initialData;
  const NotePage({
    super.key,
    this.hiveKey,
    this.initialData,
  });

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  // late final QuillController _contentController;
  bool _isSaving = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    box = Hive.box('notes');
    _initializeControllers();
  }

  void _initializeControllers() {
    _titleController = TextEditingController(
        text: widget.initialData?['title'] ?? ''
    )..addListener(_markChanges);

    _contentController = TextEditingController(
        text: widget.initialData?['content'] ?? ''
    )..addListener(_markChanges);

    // _contentController = QuillController(
    //     document: Document.fromJson(
    //         widget.initialData?['content'] ?? [{'insert': '\n'}]
    //     ),
    //     selection: const TextSelection.collapsed(offset: 0)
    // )..addListener(_markChanges);
  }

  void _markChanges() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  bool _isEmptyNote() {
    final titleEmpty = _titleController.text.trim().isEmpty;
    final contentEmpty = _contentController.text.trim().isEmpty;
    // final contentEmpty = _contentController.document.toPlainText().trim().isEmpty;
    return titleEmpty && contentEmpty;
  }

  Future<void> _saveNote() async {
    if (_isSaving || (!_hasChanges && widget.hiveKey != null)) return;
    if (_isEmptyNote() && widget.hiveKey == null) return;

    _isSaving = true;

    final note = {
      'title': _titleController.text,
      'content': _contentController.text,
      // 'content': _contentController.document.toDelta().toJson(),
      'updatedAt': DateTime.now().toString(),
      'createdAt': widget.initialData?['createdAt'] ?? DateTime.now().toString(),
    };

    try {
      if (widget.hiveKey != null) {
        await box.put(widget.hiveKey, note);
      } else if (!_isEmptyNote()) {
        await box.add(note);
      }
    } finally {
      _isSaving = false;
    }
  }


  void _confirmDelete() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Note'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () {
              if (widget.hiveKey != null) box.delete(widget.hiveKey);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.removeListener(_markChanges);
    _contentController.removeListener(_markChanges);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.hiveKey == null ? 'New Note' : 'Edit Note'),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () async {
            await _saveNote();
            if (mounted) Navigator.pop(context);
          },
        ),
        trailing: widget.hiveKey != null ? CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.delete),
          onPressed: _confirmDelete,
        ) : null,
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CupertinoTextField(
                controller: _titleController,
                placeholder: 'Title',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                decoration: null,
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CupertinoTextField(
                  controller: _contentController,
                  placeholder: 'Start typing...',
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top, // Aligns text to top
                  padding: const EdgeInsets.only(
                    left: 0,
                    right: 0,
                    top: 8,    // Add some top padding
                    bottom: 8,  // Add some bottom padding
                  ),
                  decoration: null, // Remove default decoration
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4, // Adjust line height if needed
                  ),
                ),
              ),
            ),

            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 18),
            //     child: QuillEditor.basic(
            //       controller: _contentController,
            //       scrollController: ScrollController(),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}