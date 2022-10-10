import 'package:AttendanceApp/constants/constant.dart';
import 'package:flutter/material.dart';

class LongButton extends StatelessWidget {
  const LongButton({
    Key key,
    this.onClick,
    this.title,
    this.bgColor,
    this.textColor,
  }) : super(key: key);

  final Function onClick;
  final String title;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: darkShadow),
      child: RaisedButton(
        elevation: 0,
        onPressed: onClick,
        color: bgColor,
        child: Container(
            width: 350,
            height: 50,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: textColor),
              ),
            )),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
