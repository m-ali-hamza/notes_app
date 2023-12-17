import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes_app/boxes/boxes.dart';
import 'package:notes_app/models/notes_model.dart';

class EditNoteScreen extends StatelessWidget {
  String title;
  String description;
  NotesModel notesModel;
  EditNoteScreen(
      {super.key,
      required this.title,
      required this.description,
      required this.notesModel});
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    titleController.text = title;
    descriptionController.text = description;
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Edit Note',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(height * 0.020),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: ListView(
                children: [
                  TextFormField(
                      style: const TextStyle(color: Colors.white, fontSize: 30),
                      controller: titleController,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                      )),
                  SizedBox(height: height * 0.01),
                  TextFormField(
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      controller: descriptionController,
                      maxLines: 15,
                      decoration: const InputDecoration(
                        hintText: 'description',
                        border: InputBorder.none,
                      ))
                ],
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 10,
          backgroundColor: Colors.grey.shade800,
          onPressed: () async {
            notesModel.title = titleController.text;
            notesModel.description = descriptionController.text;
           if (titleController.text.isEmpty ||
                descriptionController.text.isEmpty) {
              Navigator.pop(context);
            } 
            else{
              await notesModel.save();

            titleController.clear();
            descriptionController.clear();

            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            }
          },
          child: const Icon(
            Icons.save,
            color: Colors.white,
            size: 30,
          )),
    );
  }
}
