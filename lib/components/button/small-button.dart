import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  const SmallButton({
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
      child: RaisedButton(
        onPressed: onClick,
        color: bgColor,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
            )),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
