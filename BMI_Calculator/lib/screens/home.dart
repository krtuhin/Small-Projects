import 'package:flutter/material.dart';
import 'package:bmi_calculator_flutter/widgets/left.dart';
import 'package:bmi_calculator_flutter/widgets/right.dart';
import 'package:bmi_calculator_flutter/constants/app_constants.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _height = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  double _result = 0;
  String _textResult = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "BMI Calculator",
            style: TextStyle(color: accentColor, fontWeight: FontWeight.w300),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true),
      backgroundColor: mainColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 130,
                  child: TextFormField(
                      controller: _height,
                      style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w300,
                          color: accentColor),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Height",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w300,
                              color: Colors.white.withOpacity(0.8)))),
                ),
                Container(
                  width: 130,
                  child: TextFormField(
                    controller: _weight,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w300,
                      color: accentColor,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Weight",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 42,
                            color: Colors.white.withOpacity(0.8))),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () {
                double _h = double.parse(_height.text) / 3.28084;
                double _w = double.parse(_weight.text);
                setState(() {
                  _result = _w / (_h * _h);
                  if (_result > 25) {
                    _textResult = "You are Over Weight";
                  } else if (_result >= 18.5 && _result <= 25) {
                    _textResult = "You have Normal Weight";
                  } else {
                    _textResult = "Yor are Under Weight";
                  }
                });
              },
              child: Container(
                child: Text(
                  "Calculate",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: accentColor),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              child: Text(
                _result.toStringAsFixed(2),
                style: TextStyle(fontSize: 90, color: accentColor),
              ),
            ),
            const SizedBox(height: 32),
            Visibility(
              visible: _textResult.isNotEmpty,
              child: Container(
                child: Text(
                  _textResult,
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: accentColor),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const LeftBar(barWidth: 40),
            const SizedBox(height: 20),
            const LeftBar(barWidth: 70),
            const SizedBox(height: 20),
            const LeftBar(barWidth: 40),
            const SizedBox(width: 20),
            const RightBar(barWidth: 70),
            const SizedBox(height: 50),
            const RightBar(barWidth: 70),
          ],
        ),
      ),
    );
  }
}
