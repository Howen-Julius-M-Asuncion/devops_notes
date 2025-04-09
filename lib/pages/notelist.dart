import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:notes/pages/notepage.dart';

class NotelistPage extends StatefulWidget {
  const NotelistPage({super.key});

  @override
  State<NotelistPage> createState() => _NotelistPageState();
}

class _NotelistPageState extends State<NotelistPage> {
  List<dynamic> noteList = [];
  late final Box box;

  @override
  void initState() {
    box = Hive.box('database');

    // box.put(
    //   'Notes', {
    //     "Task" : "Buy some food",
    //     "status" : false,
    //     "pinned" : false,
    //     "new" : false,
    //   },
    // );
    //
    // noteList.add({
    //   "Task" : "Buy this one",
    //   "status" : false,
    //   "pinned" : false,
    //   "new" : true
    // });
    //
    // noteList.add({
    //   "Task" : "Buy this two",
    //   "status" : false,
    //   "pinned" : false,
    //   "new" : true
    // });

    // box.delete('Notes');
    // noteList.add(box.get('Notes'));
    print(noteList);


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text('Tasks'), // TO BE REMOVED FOR MORE IOS-ESQUE LOOK
        trailing: null, // TO BE ADDED FOR MEMBERS INFO BUTTON
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // HEADER
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25, top: 25),
                  child: Text(
                    'Notes',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              child: CupertinoSearchTextField(
                // borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),

            // NOTE LIST
            // Expanded(
            //   child: ListView.builder(
            //     // itemCount: noteBox.length,
            //     itemCount: box.length,
            //     itemBuilder: (context, int index){
            //       final item = noteList;
            //       return CupertinoListSection.insetGrouped(
            //         header: Text('All'),
            //         children: [
            //           CupertinoListTile(title: Text(item[index]['Task'])),
            //         ],
            //       );
            //     }
            //   ),
            // ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8,),
                child:
                noteList.isEmpty ?
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text('No notes found')
                  ],
                )
                : ListView.builder(
                  itemCount: noteList.length,
                  itemBuilder: (context, int index){
                    final item = noteList;
                    return CupertinoListTile(
                      title: Text(item[index]['Task']),
                      subtitle: Divider(thickness: 1,),
                      trailing: CupertinoListTileChevron(),
                    );
                  }
                ),
              ),
            ),

            // FOOTER
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4),
              color: CupertinoColors.systemFill.withOpacity(0.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(null),
                  Text(noteList.isNotEmpty ? '0 Notes' : '${noteList.length} Notes'),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(CupertinoIcons.square_pencil),
                    onPressed: (){

                    }
                  )
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}