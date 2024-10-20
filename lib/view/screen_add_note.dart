import 'package:flutter/material.dart';

enum ActionType{
  addNote,
  editNote,
}

// ignore: must_be_immutable
class ScreenAddNote extends StatelessWidget {
  final ActionType type;
  String? id;
   ScreenAddNote({Key? key,required this.type,this.id}):super(key:key);
  Widget get saveBotten=>TextButton.icon(onPressed: (){
    switch(type){
      case ActionType.addNote:
      break;
      case ActionType.editNote:
      break;
    }
  }, icon: Icon(Icons.save,color: Colors.white,), label: Text('Save',style: TextStyle(color: Colors.white),));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type.name.toUpperCase()),
        actions: [
          saveBotten,
        ],
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Title'
              ),
            ),
            const SizedBox(height: 20,),
            TextFormField(
              maxLines: 4,
              maxLength: 100,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Content'
              ),
            )
          ],
        ),
      )),
    );
  }
}
