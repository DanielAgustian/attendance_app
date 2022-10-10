import 'package:AttendanceApp/bloc/time/time_bloc.dart';
import 'package:AttendanceApp/bloc/time/time_event.dart';
import 'package:AttendanceApp/bloc/time/time_state.dart';
import 'package:AttendanceApp/components/item-box.dart';
import 'package:AttendanceApp/constants/constant.dart';
import 'package:AttendanceApp/model/model-time.dart';
import 'package:AttendanceApp/repository/repo_absen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:AttendanceApp/model/model_firestore.dart'; 

class AbsensiAdminScreen extends StatefulWidget {
  const AbsensiAdminScreen({Key key, this.user}) : super(key: key);
  final Model_Firestore user;
  @override
  _AbsensiAdminScreenState createState() => _AbsensiAdminScreenState();
}

class _AbsensiAdminScreenState extends State<AbsensiAdminScreen> {
  Model_Firestore user;
  AbsensiRepository absenRepo = AbsensiRepository();
  DateTime selectedDate = DateTime.now();
  String dateStart = "yyyy-MM-dd";
  String dateEnd = "yyyy-MM-dd";
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
      BlocProvider.of<TimeBloc>(context).add((TimeSearch(q1, q2)));
    }
  }

  List<TimeModel> absensiList = [];

  void getEmployeeTime() async { 
    var res = await absenRepo.getEmployeeTime(user.idUsaha);
    setState(() {
      absensiList = res;
      print(absensiList[0].getIDUser);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.user != null) {
      user = widget.user;
    }
    getEmployeeTime();
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
            BlocBuilder<TimeBloc, TimeState>(
              builder: (context, state) {
                if (state is LoadingTime) {
                  return Container(
                    alignment: Alignment.topCenter,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(colorPrimary),
                    ),
                  );
                } else if (state is TimeSuccessLoad) {
                  return Expanded(
                      child: ListView.builder(
                          itemCount: state.time.length,
                          itemBuilder: (context, index) => ItemBox(
                                title: state.time[index].getNama,
                                subtitle: "YOKESEN",
                                date: state.time[index].getDay,
                                status: state.time[index].getStatus,
                              )));
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
