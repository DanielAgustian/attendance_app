import 'package:AttendanceApp/bloc/user/absence_bloc.dart';
import 'package:AttendanceApp/bloc/user/absence_event.dart';
import 'package:AttendanceApp/bloc/user/absence_state.dart';
import 'package:AttendanceApp/components/item-box.dart';
import 'package:AttendanceApp/constants/constant.dart';
import 'package:AttendanceApp/model/model-time.dart';
import 'package:AttendanceApp/repository/repo_absen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbsensiScreen extends StatefulWidget {
  @override
  _AbsensiScreenState createState() => _AbsensiScreenState();
}

class _AbsensiScreenState extends State<AbsensiScreen> {
  AbsensiRepository absenRepo = AbsensiRepository();
  DateTime selectedDate = DateTime.now();
  String dateStart = "yyyy-MM-dd";
  String dateEnd = "yyyy-MM-dd";
  String userID;

  void getActiveUser() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("id");

    setState(() {
      userID = id;
    });
  }

  // get calendar function
  _selectDate(BuildContext context, String type) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: type == "start"
          ? selectedDate
          : DateTime.parse(dateStart + " 00:00:00"), // Refer step 1
      firstDate: DateTime(2020),
      lastDate: DateTime(2500),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        type == "start"
            ? dateStart = DateFormat("yyyy-MM-dd").format(picked)
            : dateEnd = DateFormat("yyyy-MM-dd").format(picked);
      });
      String q1 = dateStart == "yyyy-MM-dd" ? "" : dateStart;
      String q2 = dateEnd == "yyyy-MM-dd" ? "" : dateEnd;
      BlocProvider.of<UserAbsenceBloc>(context)
          .add((AbsenceSearch(q1, q2, userID)));
    }
  }

  List<TimeModel> absensiList = [];

  void getEmployeeAbsence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String userID = prefs.getString('id');
    var res = await absenRepo.getEmployeeAbsence(userID);
    setState(() {
      absensiList = res;
      print(absensiList[0].getIDUser);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getActiveUser();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Data Absensi",
          style: TextStyle(
              color: colorPrimary, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.filter,
                      color: colorPrimary, size: 18),
                  SizedBox(width: 6),
                  Text(
                    "Filter",
                    style: TextStyle(
                        color: colorPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => _selectDate(context, "start"), // Refer step 3
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colorPrimary)),
                    child: Text(
                      dateStart,
                      style: TextStyle(color: colorPrimary),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "to",
                    style: TextStyle(
                        color: colorPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                InkWell(
                  onTap: () => _selectDate(context, "end"), // Refer step 3
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colorPrimary)),
                    child: Text(
                      dateEnd,
                      style: TextStyle(color: colorPrimary),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Data Absensi",
                style: TextStyle(
                    color: colorPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            BlocBuilder<UserAbsenceBloc, UserAbsenceState>(
              builder: (context, state) {
                if (state is UserLoadingAbsence) {
                  return Container(
                    alignment: Alignment.topCenter,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(colorPrimary),
                    ),
                  );
                } else if (state is AbsenceSuccessLoad) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: state.absence.length,
                        itemBuilder: (context, index) => ItemBox(
                              title: state.absence[index].getNama,
                              subtitle: "YOKESEN",
                              date: state.absence[index].getDay,
                              status: state.absence[index].getStatus,
                            )),
                  );
                }
                return Container();
              },
            ), 
          ],
        ),
      ),
    );
  }
}
