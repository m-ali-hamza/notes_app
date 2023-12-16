import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/boxes/boxes.dart';
import 'package:notes_app/constants/colors.dart';
import 'package:notes_app/models/notes_model.dart';
import 'package:notes_app/view/add_note.dart';
import 'package:notes_app/view/edit_note.dart';
import 'package:notes_app/view/show_note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  var search = '';
  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Notes",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    hintText: "Search Notes",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade800,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.transparent))),
                onChanged: (value) {
                  setState(() {
                    search = value.trim();
                  });
                },
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Expanded(
                child: ValueListenableBuilder<Box<NotesModel>>(
                    valueListenable: Boxes.getNotes().listenable(),
                    builder: (context, value, _) {
                      var notFilterData = value.values.toList();
                      var data = notFilterData
                          .where((element) => element.title
                              .toLowerCase()
                              .contains(search.toLowerCase()))
                          .toList()
                          .cast<NotesModel>();
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowNoteScreen(
                                              title: data[index].title,
                                              description:
                                                  data[index].description,
                                            )));
                              },
                              child: Card(
                                  color: getRandomColor(),
                                  child: ListTile(
                                      title: Text(
                                        data[index].title,
                                        style: TextStyle(
                                            fontSize: width * 0.04,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      subtitle: Text(
                                        data[index].description,
                                        style: TextStyle(
                                          fontSize: width * 0.03,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      trailing: SizedBox(
                                        width: width * 0.2,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditNoteScreen(
                                                                title:
                                                                    data[index]
                                                                        .title,
                                                                description: data[
                                                                        index]
                                                                    .description,
                                                                notesModel: data[
                                                                    index])));
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                //create a dialogue alert
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          actionsAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          backgroundColor:
                                                              Colors.grey
                                                                  .shade900,
                                                          icon: const Icon(
                                                            Icons.info,
                                                            color: Colors.white,
                                                          ),
                                                          title: const Text(
                                                            'Delete Note',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          content: const Text(
                                                            'Are you sure you want to delete this note?',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          actions: [
                                                            ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .green),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                'Cancel',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red),
                                                              child: const Text(
                                                                'Delete',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              onPressed: () {
                                                                deletNote(data[
                                                                    index]);

                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ],
                                                        ));
                                              },
                                            ),
                                          ],
                                        ),
                                      ))),
                            );
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 10,
          backgroundColor: Colors.grey.shade900,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddNoteScreen()));
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          )),
    );
  }
}

void deletNote(NotesModel notesModel) async {
  //it will delete the note from the box
  await notesModel.delete();
}
