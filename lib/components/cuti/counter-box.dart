import 'package:AttendanceApp/constants/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CounterBoxCuti extends StatelessWidget {
  const CounterBoxCuti({
    Key key,
    @required this.size,
    this.boxText,
    this.counter,
    this.bgColor,
    this.textColor,
    this.loading = false,
  }) : super(key: key);

  final Size size;
  final String boxText;
  final int counter;
  final Color bgColor;
  final Color textColor;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.4,
      height: size.width * 0.25,
      decoration: BoxDecoration(
          color: bgColor,
          boxShadow: darkShadow,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          SizedBox(
            height: 18,
          ),
          Container(
              margin: EdgeInsets.only(left: 10),
              alignment: Alignment.topLeft,
              child: Text(boxText,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12))),
          loading
              ? Container(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator(
                    backgroundColor: bgColor,
                    valueColor: AlwaysStoppedAnimation(textColor),
                  ))
              : Text(
                  "$counter",
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 48),
                )
        ],
      ),
    );
  }
}
