import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Calculator App",
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Simple Interest Calculator"),
      ),
      body: MyApp(),
    ),
    theme: ThemeData(
      accentColor: Colors.tealAccent,
      brightness: Brightness.dark,
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final _currencies = ["Select", "Rupees", "Dollars", "Pounds", "Others"];
  var _currentItem = "";
  var showResult = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _currentItem = _currencies[0];
  }

  TextEditingController amount = TextEditingController();
  TextEditingController interest = TextEditingController();
  TextEditingController time = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          getImg(),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: TextFormField(
                validator: (var value) {
                  if (value!.isEmpty) {
                    return "Please enter principal amount";
                  } else if (double.tryParse(value) == null) {
                    return "Invalid input!";
                  }
                },
                controller: amount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Principal",
                  labelStyle: Theme.of(context).textTheme.titleMedium,
                  errorStyle: const TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 15,
                  ),
                  hintText: "Enter principal ex, 12000",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
            child: TextFormField(
                validator: (var value) {
                  if (value!.isEmpty) {
                    return "Please enter rate of interest";
                  } else if(double.tryParse(value) == null){
                    return "Invalid input!";
                  }
                },
                controller: interest,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Rate of Interest",
                  labelStyle: Theme.of(context).textTheme.titleMedium,
                  errorStyle: const TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 15,
                  ),
                  hintText: "In percent",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                )),
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                child: TextFormField(
                    validator: (var value) {
                      if (value!.isEmpty) {
                        return "Please enter time in years";
                      }else if(double.tryParse(value) == null) {
                        return "Invalid input!";
                      }
                    },
                    controller: time,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Term",
                      labelStyle: Theme.of(context).textTheme.titleMedium,
                      errorStyle: const TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 14,
                      ),
                      hintText: "Enter Years",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    )),
              )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.0),
                child: DropdownButton<String>(
                  items: _currencies.map((String strItem) {
                    return DropdownMenuItem<String>(
                        value: strItem, child: Text(strItem));
                  }).toList(),
                  onChanged: (var nowValue) {
                    setState(() {
                      _currentItem = nowValue.toString();
                    });
                  },
                  value: _currentItem,
                ),
              ))
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_formKey.currentState!.validate() &&
                            _currentItem != "Select") {
                          showResult = calculate();
                        } else if (_currentItem == "Select") {
                          showResult = "Please select your currency";
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      elevation: 6,
                    ),
                    child: const Text(
                      "Calculate",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          reset();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    elevation: 6,
                  ),
                  child: const Text("Reset",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 20.0, right: 10.0, bottom: 50.0),
            child: Text(
              showResult,
              style: const TextStyle(
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getImg() {
    AssetImage img = const AssetImage("images/money.png");
    Image image = Image(
      image: img,
      width: 140,
      height: 140,
    );
    return Container(
      margin: const EdgeInsets.only(top: 60, bottom: 40),
      child: image,
    );
  }

  String calculate() {
    double principal = double.parse(amount.text);
    double roi = double.parse(interest.text);
    double trm = double.parse(time.text);
    double iop = principal + (principal * roi * trm) / 100;
    String result =
        "After ${trm.toInt()} years, your investment will be $iop $_currentItem";
    return result;
  }

  void reset() {
    _formKey.currentState!.reset();
    amount.text = "";
    interest.text = "";
    time.text = "";
    _currentItem = "Select";
    showResult = "";
  }
}
