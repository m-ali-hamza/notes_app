import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes_app/boxes/boxes.dart';
import 'package:notes_app/models/notes_model.dart';

class AddNoteScreen extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Add Note',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(height * 0.015),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextFormField(
                style: const TextStyle(color: Colors.white, fontSize: 30),
                controller: titleController,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 30),
                )),
            SizedBox(height: height * 0.01),
            TextFormField(
                style: const TextStyle(color: Colors.white, fontSize: 20),
                controller: descriptionController,
                maxLines: 15,
                decoration: const InputDecoration(
                  hintText: 'description',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                  border: InputBorder.none,
                ))
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 10,
          backgroundColor: Colors.grey.shade800,
          onPressed: () async {
            final data = NotesModel(
                title: titleController.text,
                description: descriptionController.text);
            if (titleController.text.isEmpty &&
                descriptionController.text.isEmpty) {
              Navigator.pop(context);
            } else {
              // get reference to an element
              final box = Boxes.getNotes();

              await box.add(data);
              data.save();

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
