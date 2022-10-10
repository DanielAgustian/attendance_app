import 'package:AttendanceApp/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ItemBox extends StatelessWidget {
  ItemBox(
      {Key key,
      this.title,
      this.subtitle,
      this.date,
      this.status,
      this.screen = "employee"})
      : super(key: key);

  final String title, subtitle, date, status, screen;

  DateFormat dateFormat = DateFormat.yMMMMd();

  @override
  Widget build(BuildContext context) {
    var convertDate = DateFormat("yy-MM-dd").parse(date);
    var formattedDate =
        this.screen == "employee" ? dateFormat.format(convertDate) : date;
    Color color = colorSuccess;
    IconData icon = FontAwesomeIcons.clock;

    if (status == "late" || status == "ditolak") {
      color = colorError;
    }
    if (status == "ditolak") {
      icon = FontAwesomeIcons.times;
    } else if (status == "diterima") {
      icon = FontAwesomeIcons.check;
    }
    if (status == "") {
      icon = FontAwesomeIcons.clock;
      color = colorAdditional2;
    }
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: darkShadow),
      alignment: Alignment.topLeft,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: colorPrimary, fontSize: 16),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                      color: colorSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                      color: colorSecondary.withOpacity(0.6), fontSize: 12),
                ),
              ],
            ),
            Column(
              children: [
                FaIcon(
                  icon,
                  color: color,
                  size: 30,
                ),
                Text(
                  status != "" ? status : "waiting",
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
