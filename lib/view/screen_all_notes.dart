import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/view/screen_add_note.dart';

class ScreenAllNotes extends StatelessWidget {
  ScreenAllNotes({super.key});
  final CollectionReference noteapp =
      FirebaseFirestore.instance.collection("noteapp");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Notes'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: noteapp.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                return GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: List.generate(
                    // final DocumentSnapshot note =snapshot.data.docs.[index];
                    snapshot.data.docs.length,
                    (index) {
                      final DocumentSnapshot note = snapshot.data.docs[index];
                      return NoteItem(
                        id: note.id,
                        title: note['title'],
                        content: note['content'],
                      );
                    },
                  ),
                );
              }
              return const Center(
                child: Text("No data"),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => ScreenAddNote(
                    type: ActionType.addNote,
                  )));
        },
        label: const Text('New'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class NoteItem extends StatelessWidget {
  final String id;
  final String title;
  final String content;
   NoteItem(
      {super.key,
      required this.id,
      required this.title,
      required this.content});
      final CollectionReference noteapp =
      FirebaseFirestore.instance.collection("noteapp");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => ScreenAddNote(
                type: ActionType.editNote,
                title: title,
                content: content,
                id: id)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showAleart(context, id);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            Text(
              content,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }

  void showAleart(context, id) {
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text("Delete Note"),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text("Cancel"),),
            TextButton(onPressed: (){
              noteapp.doc(id).delete();
              Navigator.pop(context);
            }, child: const Text("Delete"),)
          ],
        );
      },
    );
  }
}
