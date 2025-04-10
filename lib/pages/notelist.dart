import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/main.dart';
import 'package:notes/pages/notepage.dart';

class NotelistPage extends StatefulWidget {
  const NotelistPage({super.key});

  @override
  State<NotelistPage> createState() => _NotelistPageState();
}

class _NotelistPageState extends State<NotelistPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      // navigationBar: const CupertinoNavigationBar(
      //   // middle: Text('Notes'),
      //   trailing: null,
      // ),
      child: SafeArea(
        child: Column(
          children: [

            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25, top: 24),
                  child: Text(
                    'Notes',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10, top: 26),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(CupertinoIcons.info_circle, size: 24),
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: Text('About Us'),
                          content: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        ClipOval(
                                          child: Image.asset('assets/images/devs/howen.jpg',
                                            height: 75,
                                            width: 75,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Text('Howen Julius Asuncion'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        ClipOval(
                                          child: Image.asset('assets/images/devs/goco.jpg',
                                            height: 75,
                                            width: 75,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Text('John Michael Goco'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        ClipOval(
                                          child: Image.asset('assets/images/devs/renz.jpg',
                                            height: 75,
                                            width: 75,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Text('Renz Gabriel Salas'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          actions: [
                            CupertinoButton(
                              child: Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed)),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
            //   child: CupertinoSearchTextField(),
            // ),

            // ITEM LIST
            SizedBox(height: 10,),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, Box box, _) {
                  final notes = box.keys.toList(); // Get all keys

                  if (notes.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final key = notes[index];
                      final note = box.get(key); // Get by key
                      return _buildNoteItem(context, key, note, index);
                    },
                  );
                },
              ),
            ),

            // FOOTER
            ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box box, _) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemFill.withOpacity(0.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(null),
                      Text('${box.length} ${box.length == 1 ? 'Note' : 'Notes'}'),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.square_pencil),
                        onPressed: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const NotePage(),
                            settings: const RouteSettings(name: '/new-note'),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'No notes yet',
            style: TextStyle(
              fontSize: 16,
              color: CupertinoTheme.of(context).textTheme.textStyle.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteItem(BuildContext context, dynamic key, Map note, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => NotePage(
            key: ValueKey(key), // Use key as unique identifier
            initialData: Map<String, dynamic>.from(note),
            hiveKey: key, // Pass the Hive key instead of index
          ),
        ),
      ),
      onLongPress: () => _deleteNote(key, context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18,),
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoColors.secondarySystemGroupedBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              CupertinoListTile.notched(
                title: Text(
                  note['title']?.toString() ?? 'Untitled',
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  note['content']?.toString() ?? '',
                  // _getNotePreview(note['content']),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const Divider(indent: 25, endIndent: 25, height: 1,),
            ],
          ),
        ),
      ),
    );
  }

  String _getNotePreview(List<dynamic> content) {
    try {
      return content
          .map((op) => op['insert']?.toString() ?? '')
          .join()
          .replaceAll('\n', ' ')
          .trim();
    } catch (e) {
      return 'Note content';
    }
  }

  void _deleteNote(dynamic key, BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Note'),
        content: Text('Delete "${box.get(key)['title']}"?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () {
              box.delete(key); // Delete by key
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
