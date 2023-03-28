import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List<dynamic> nameList = [];
  List<dynamic> detailList = [];
  List<dynamic> valueList = [];

  //reference box
  final _myBox = Hive.box("myBox");

  //run this method if this is first time ever opening this app

  void createInitialData() {
    nameList = ["Thanks to Tuhin", "This app created by Tuhin"];
    detailList = [
      "Hello this is a note taking application by Tuhin",
      "Use this application and rate Tuhin's work"
    ];
    valueList = [false, false];
  }

  // load data from database
  void loadData() {
    nameList = _myBox.get("NAME");
    detailList = _myBox.get("DETAIL");
    valueList = _myBox.get("VALUE");
  }

// update database
  void updateDatabase() {
    _myBox.put("NAME", nameList);
    _myBox.put("DETAIL", detailList);
    _myBox.put("VALUE", valueList);
  }
}
