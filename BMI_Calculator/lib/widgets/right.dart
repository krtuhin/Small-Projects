import 'package:flutter/material.dart';
import 'package:bmi_calculator_flutter/constants/app_constants.dart';

class RightBar extends StatelessWidget {
  final double barWidth;

  const RightBar({super.key, required this.barWidth});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 25,
          width: barWidth,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: accentColor,
          ),
        )
      ],
    );
  }
}
