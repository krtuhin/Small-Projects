import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_flutter/data/database.dart';
import 'package:todo_app_flutter/screens/home.dart';

class NoteDetail extends StatefulWidget {
  int index;

  NoteDetail({Key? key, required this.index}) : super(key: key);

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  ToDoDatabase db = ToDoDatabase();
  final _myBox = Hive.box("myBox");
  final _formKey = GlobalKey<FormState>();
  num titleLength = 0;

  @override
  void initState() {
    //if this is first time opening the app then load default data
    if (_myBox.get("NAME") == null) {
      db.createInitialData();
    } else {
      // there already exist data
      db.loadData();
    }
    db.updateDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: db.nameList[widget.index]);
    final TextEditingController contentController =
        TextEditingController(text: db.detailList[widget.index]);
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
            (route) => false);
      },
      child: Scaffold(
        backgroundColor: Colors.yellow[200],
        appBar: AppBar(
          backgroundColor: Colors.yellow,
          elevation: 0.4,
          leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          title: Text(
            db.nameList[widget.index].toString(),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.yellow[200],
                    title: const Text("Do you want to delete?"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            db.nameList.removeAt(widget.index);
                            db.detailList.removeAt(widget.index);
                            db.valueList.removeAt(widget.index);
                          });
                          db.updateDatabase();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Home(),
                              ),
                              (route) => false);
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: Form(
                        onWillPop: () async {
                          setState(
                            () {
                              titleController.clear();
                              contentController.clear();
                            },
                          );
                          Navigator.pop(context);
                          return true;
                        },
                        key: _formKey,
                        child: AlertDialog(
                          backgroundColor: Colors.yellow[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          content: SizedBox(
                            height: 410,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Card(
                                  elevation: 0.2,
                                  color: Colors.yellow,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "EDIT THE NOTE",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Title cannot be empty !";
                                    } else if (value.length > 20) {
                                      return "Title is too long, $titleLength/20";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      titleLength = value.length;
                                    });
                                  },
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    hintText: "Add title (within 20 character)",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.yellow),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  maxLines: 10,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Content can not be empty !";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: contentController,
                                  decoration: InputDecoration(
                                    hintText: "Add content",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.yellow),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(
                                            () {
                                              Navigator.pop(context);
                                              titleController.clear();
                                              contentController.clear();
                                            },
                                          );
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              db.nameList.replaceRange(
                                                  widget.index,
                                                  widget.index + 1,
                                                  [titleController.text]);
                                              db.detailList.replaceRange(
                                                  widget.index,
                                                  widget.index + 1,
                                                  [contentController.text]);
                                              Navigator.pop(context);
                                              titleController.clear();
                                              contentController.clear();
                                            });
                                            db.updateDatabase();
                                          }
                                        },
                                        child: const Text("Save"),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Text(
                  db.detailList[widget.index].toString(),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
