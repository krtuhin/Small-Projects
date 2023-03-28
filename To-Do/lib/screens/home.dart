import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_flutter/data/database.dart';
import 'package:todo_app_flutter/screens/note_detail.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ToDoDatabase db = ToDoDatabase();

  //reference of box
  final _myBox = Hive.box("myBox");
  final TextEditingController _control = TextEditingController();
  final TextEditingController _content = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String title = "";

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
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.yellow[200],
            title: const Text("Exit"),
            content: const Text("Do you want to close the app?"),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text(
                      "No",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text(
                      "Exit",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.yellow[200],
        appBar: AppBar(
          title: const Text("TO DO",
              style: TextStyle(fontWeight: FontWeight.w600)),
          centerTitle: true,
          elevation: 1.0,
        ),
        body: ListView.builder(
          itemCount: db.nameList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Card(
                color: Colors.yellow,
                clipBehavior: Clip.antiAlias,
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          setState(() {
                            db.nameList.removeAt(index);
                            db.detailList.removeAt(index);
                            db.valueList.removeAt(index);
                          });
                          db.updateDatabase();
                        },
                        icon: Icons.delete,
                        backgroundColor: Colors.red.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NoteDetail(
                                index: index,
                              )));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: db.valueList[index],
                            activeColor: Colors.black,
                            onChanged: (value) {
                              db.valueList[index] = value!;
                              setState(() {
                                value = !value!;
                              });
                              db.updateDatabase();
                            },
                          ),
                          const SizedBox(width: 20),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text(
                              db.nameList[index].toString(),
                              style: TextStyle(
                                decorationColor: Colors.black,
                                decorationStyle: TextDecorationStyle.double,
                                decoration: db.valueList[index]
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
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
                          _control.clear();
                          _content.clear();
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
                                    "ADD NEW TASK",
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
                                  return "Title is too long, ${title.length}/20";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  title = value;
                                });
                              },
                              controller: _control,
                              decoration: InputDecoration(
                                hintText: "Add title (within 20 character)",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.yellow),
                                ),
                              ),
                            ),
                            // title.length <= 20 ? Text("${title.length}/20") : Container(),
                            TextFormField(
                              maxLines: 10,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Content can not be empty !";
                                } else {
                                  return null;
                                }
                              },
                              controller: _content,
                              decoration: InputDecoration(
                                hintText: "Add content",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.yellow),
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
                                          _control.clear();
                                          _content.clear();
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
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          db.nameList.add(_control.text);
                                          db.detailList.add(_content.text);
                                          db.valueList.add(false);
                                          Navigator.pop(context);
                                          _control.clear();
                                          _content.clear();
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
          child: const Icon(Icons.add, size: 30),
        ),
      ),
    );
  }
}
