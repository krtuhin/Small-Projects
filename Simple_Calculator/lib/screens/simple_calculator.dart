import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class SimpleCalculator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SimpleCalculatorState();
  }
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationText = 48.0;
  double resultText = 38.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Calculator"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          //    Display for Equation and Result

          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              equation,
              style: TextStyle(
                fontSize: equationText,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
            child: Text(
              result,
              style: TextStyle(
                fontSize: resultText,
              ),
            ),
          ),
          const Expanded(child: Divider()),

          ///   keyBoard

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Table(
                  children: [
                    TableRow(children: [
                      myButton(
                          buttonText: "C",
                          buttonHeight: 1,
                          buttonColor: Colors.redAccent),
                      myButton(
                          buttonText: "⌫",
                          buttonHeight: 1,
                          buttonColor: Colors.lightBlueAccent),
                      myButton(
                          buttonText: "÷",
                          buttonHeight: 1,
                          buttonColor: Colors.lightBlueAccent),
                    ]),
                    TableRow(children: [
                      myButton(
                          buttonText: "7",
                          buttonHeight: 1,
                          buttonColor: Colors.black26),
                      myButton(
                          buttonText: "8",
                          buttonHeight: 1,
                          buttonColor: Colors.black26),
                      myButton(
                          buttonText: "9",
                          buttonHeight: 1,
                          buttonColor: Colors.black26),
                    ]),
                    TableRow(children: [
                      myButton(
                          buttonText: "4",
                          buttonHeight: 1,
                          buttonColor: Colors.black26),
                      myButton(
                          buttonText: "5",
                          buttonHeight: 1,
                          buttonColor: Colors.black26),
                      myButton(
                          buttonText: "6",
                          buttonHeight: 1,
                          buttonColor: Colors.black26),
                    ]),
                    TableRow(children: [
                      myButton(
                          buttonText: "1",
                          buttonHeight: 1,
                          buttonColor: Colors.black26),
                      myButton(
                          buttonText: "2",
                          buttonHeight: 1,
                          buttonColor: Colors.black26),
                      myButton(
                          buttonText: "3",
                          buttonHeight: 1,
                          buttonColor: Colors.black26),
                    ]),
                    TableRow(children: [
                      myButton(
                          buttonText: ".",
                          buttonHeight: 1,
                          buttonColor: Colors.black26),
                      myButton(
                          buttonText: "%",
                          buttonHeight: 1,
                          buttonColor: Colors.black26),
                      myButton(
                          buttonText: "0",
                          buttonHeight: 1,
                          buttonColor: Colors.black26),
                    ]),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Table(
                  children: [
                    TableRow(children: [
                      myButton(
                          buttonText: "✕",
                          buttonHeight: 1,
                          buttonColor: Colors.lightBlueAccent),
                    ]),
                    TableRow(children: [
                      myButton(
                          buttonText: "-",
                          buttonHeight: 1,
                          buttonColor: Colors.lightBlueAccent),
                    ]),
                    TableRow(children: [
                      myButton(
                          buttonText: "+",
                          buttonHeight: 1,
                          buttonColor: Colors.lightBlueAccent),
                    ]),
                    TableRow(
                      children: [
                        myButton(
                            buttonText: "=",
                            buttonHeight: 2,
                            buttonColor: Colors.lightBlueAccent),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  //    Method for buttons

  myButton(
      {required String buttonText,
      required double buttonHeight,
      required Color buttonColor}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0.0)),
              side: BorderSide(
                color: Colors.white,
                width: 1,
                style: BorderStyle.solid,
              ))),
          padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
        ),
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: const TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  //    Method for calculation

  buttonPressed(String buttonText) {
    setState(
      () {
        if (buttonText == "C") {
          equation = "0";
          result = "0";
          equationText = 38.0;
          resultText = 48.0;
        } else if (buttonText == "⌫") {
          equationText = 48.0;
          resultText = 38.0;
          equation = equation.substring(0, equation.length - 1);
          if (equation == "") {
            equation = "0";
            equationText = 38.0;
            resultText = 48.0;
          } else {
            return;
          }
        } else if (buttonText == "=") {
          equationText = 38.0;
          resultText = 48.0;

          expression = equation;
          expression = expression.replaceAll("✕", "*");
          expression = expression.replaceAll("÷", "/");

          try {
            Parser p = Parser();
            Expression exp = p.parse(expression);
            ContextModel cm = ContextModel();
            result = "${exp.evaluate(EvaluationType.REAL, cm)}";
          } catch (e) {
            result = "Error";
          }
        } else {
          equationText = 48.0;
          resultText = 38.0;
          if (equation == "0") {
            equation = buttonText;
          } else {
            equation = equation + buttonText;
          }
        }
      },
    );
  }
}
