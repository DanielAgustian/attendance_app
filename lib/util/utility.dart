import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Util {
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String randomStringNumber(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void showToast({BuildContext context, String msg, int duration, Color color}) {
    Toast.show(msg, context,
        duration: duration,
        gravity: Toast.BOTTOM,
        backgroundColor: color,
        textColor: Colors.white);
  }
}
