import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum ActionType{
  addNote,
  editNote,
}

// ignore: must_be_immutable
class ScreenAddNote extends StatelessWidget {
  final ActionType type;
  String? id;
    String? title;
    String? content;
   ScreenAddNote({Key? key,required this.type,this.id, this.title, this.content}):super(key:key);
  Widget saveBotten(BuildContext context)=>TextButton.icon(onPressed: (){
    
    switch(type){
      case ActionType.addNote:
      addNote();
      Navigator.pop(context);
      break;
      case ActionType.editNote:
      updateNote(id);
      Navigator.pop(context);
      break;
    }
  }, icon: const Icon(Icons.save,color: Color.fromARGB(255, 177, 68, 68),), label: Text('Save',style: TextStyle(color: Colors.black),));
  final CollectionReference noteapp =
      FirebaseFirestore.instance.collection("noteapp");
  late TextEditingController titleController = TextEditingController(text: type ==ActionType.editNote ? title :"");
  late TextEditingController contentController = TextEditingController(text: type ==ActionType.editNote ? content:"");
  void addNote(){
    final data = {
      "title" :titleController.text,
      "content":contentController.text
    };
    noteapp.add(data);
  }
  void updateNote(id){
    final data ={
      "title" : titleController.text,
      "content" : contentController.text
    };
    noteapp.doc(id).update(data);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type.name.toUpperCase()),
        actions: [
          saveBotten(context)
        ],
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Title'
                ),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: contentController,
                maxLines: 10,
                maxLength: 1000,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Content'
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
