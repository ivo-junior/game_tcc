import 'package:flutter/material.dart';
import 'AnswerText.dart';

class AnswerButton extends StatelessWidget {
  final Function checkAnswer;
  final String? optionText;
  final double screenWidth;

  AnswerButton(this.optionText, this.checkAnswer, this.screenWidth);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 1),
      child: MaterialButton(
        minWidth: screenWidth * 0.4,
        onPressed: () => checkAnswer("$optionText"),
        color: Colors.lightBlue[800],
        height: 45.0,
        child: AnswerText("$optionText", screenWidth),
        // child: Text(
        //   "$optionText",
        //   softWrap: true,
        //   style: TextStyle(
        //     fontSize: 24.0,
        //     // fontWeight: FontWeight.w700,
        //     color: Colors.white,
        //   ),
        // ),
      ),
    );
  }
}
