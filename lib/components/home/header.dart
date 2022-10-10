import 'dart:math';

import 'package:AttendanceApp/constants/constant.dart';
import 'package:flutter/material.dart';

class CurvedShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      child: CustomPaint(
        painter: _MyPainter(),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..color = colorPrimary;

    Offset circleCenter = Offset(size.width / 2, size.height - (200 * 0.3));

    Offset topLeft = Offset(0, 0);
    Offset bottomLeft = Offset(0, size.height * 0.7);
    Offset topRight = Offset(size.width, 0);
    Offset bottomRight = Offset(size.width, size.height * 0.7);
    Offset leftCurveControlPoint =
        Offset(circleCenter.dx * 0.5, size.height - (200 * 0.3));
    Offset rightCurveControlPoint =
        Offset(circleCenter.dx * 1.5, size.height - (200 * 0.3));

    final arcStartAngle = 200 / 180 * pi;
    final avatarLeftPointX = circleCenter.dx + (200 * 0) * cos(arcStartAngle);
    final avatarLeftPointY = circleCenter.dy + (200 * 0) * sin(arcStartAngle);
    Offset avatarLeftPoint =
        Offset(avatarLeftPointX, avatarLeftPointY); // the left point of the arc

    Path path = Path()
      ..moveTo(topLeft.dx,
          topLeft.dy) // this move isn't required since the start point is (0,0)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..quadraticBezierTo(leftCurveControlPoint.dx, leftCurveControlPoint.dy,
          avatarLeftPoint.dx, avatarLeftPoint.dy)
      ..quadraticBezierTo(rightCurveControlPoint.dx, rightCurveControlPoint.dy,
          bottomRight.dx, bottomRight.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
