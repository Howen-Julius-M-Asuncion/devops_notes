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
    //     "title" : "Buy on SM",
    //     "content" : "I want this one though",
    //     "status" : false,
    //     "pinned" : false,
    //   },
    // );
    // //
    // noteList.add({
    //   "title" : "Buy this one",
    //   "content" : "No",
    //   "status" : false,
    //   "pinned" : false,
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
        // middle: Text('Notes', style: TextStyle(color: CupertinoTheme.of(context).primaryColor),), // TO BE REMOVED FOR MORE IOS-ESQUE LOOK
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
                  padding: EdgeInsets.only(left: 25, top: 15),
                  child: Text(
                    'Notes',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              child: CupertinoSearchTextField(),
            ),

            // NOTE LIST
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8,vertical: 12),
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
                    return GestureDetector(
                      onTap: (){
                        print('Tapped Item $index, Titled: \"${item[index]['title']}\"');
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => NotePage()));
                      },
                      onLongPress: () {
                        print('LongPressed Item $index, Titled: \"${item[index]['title']}\"');
                        showCupertinoDialog(
                          context: context, 
                          builder: (context) => CupertinoAlertDialog(
                            title: Text('Delete this note?'),
                            content: Text('\"${item[index]['title']}\"'),
                            actions: [
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: Text('No', style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.bold),)
                              ),
                              CupertinoDialogAction(
                                onPressed: (){
                                  Navigator.pop(context);
                                  print('Deleted Item $index, Titled: \"${item[index]['title']}\"');
                                },
                                child: Text('Yes', style: TextStyle(color: CupertinoColors.destructiveRed,),)
                              ),
                            ],  
                          )
                        );
                      },

                      // Note ITEM
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18,),
                        child: Container(
                          decoration: BoxDecoration(
                            color: CupertinoColors.secondarySystemGroupedBackground,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: Column(
                            children: [
                              CupertinoListTile.notched(
                                leading: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: item[index]['pinned'] == true ? Icon(CupertinoIcons.pin_fill) : Icon(CupertinoIcons.pin),
                                  onPressed: (){
                                    // PIN LOGIC
                                    // DISABLED, PIN ONLY ON PAGE

                                    // setState(() {
                                    //   item[index]['pinned'] = !item[index]['pinned'];
                                    // });
                                    // print('Note \"${item[index]['title']}\", Pinnned? ${item[index]['pinned']}');
                                  },
                                ),
                                title: Text(noteList.isNotEmpty ? item[index]['title'] : ''),
                                subtitle: Text(noteList.isNotEmpty ? item[index]['content'] : ''),
                              ),
                              noteList.isNotEmpty ? Divider(indent: 25,endIndent: 25,height: 2,) : Text('')
                            ],
                          ),
                        ),
                      ),

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
                  Text(noteList.isEmpty ? '0 Notes' : '${noteList.length} Notes'),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(CupertinoIcons.square_pencil),
                    onPressed: (){
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => NotePage()));

                      // showCupertinoDialog(
                      //   context: context,
                      //   builder: (context) => CupertinoAlertDialog(
                      //     title: Text('Create New Note'),
                      //     content: Text('Are you sure?'),
                      //     actions: [
                      //       CupertinoDialogAction(
                      //         isDefaultAction: true,
                      //         onPressed: (){
                      //           Navigator.pop(context);
                      //         },
                      //         child: Text('No', style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.bold),)
                      //       ),
                      //       CupertinoDialogAction(
                      //         onPressed: (){
                      //           // Navigator.pop(context);
                      //           Navigator.push(context, CupertinoPageRoute(builder: (context) => NotePage()));
                      //         },
                      //         child: Text('Yes', style: TextStyle(color: CupertinoColors.destructiveRed,),)
                      //       ),
                      //     ],
                      //   )
                      //
                      // );


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
