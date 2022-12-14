import 'package:flutter/material.dart';

class AnswerText extends StatelessWidget {
  final String textToDisplay;
  final double screenWidth;
  const AnswerText(this.textToDisplay, this.screenWidth);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: screenWidth * 0.4,
      child: Text(
        "$textToDisplay",
        softWrap: true,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
