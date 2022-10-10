import 'package:AttendanceApp/bloc/cuti/cuti_bloc.dart';
import 'package:AttendanceApp/bloc/cuti/cuti_event.dart';
import 'package:AttendanceApp/bloc/cuti/cuti_state.dart';
import 'package:AttendanceApp/components/item-box.dart';
import 'package:AttendanceApp/constants/constant.dart';
import 'package:AttendanceApp/model/model-time.dart';
import 'package:AttendanceApp/repository/repo_absen.dart';
import 'package:AttendanceApp/screens/admin/screen-detail-cuti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminViewCutiScreen extends StatefulWidget {
  @override
  _AdminViewCutiScreenState createState() => _AdminViewCutiScreenState();
}

class _AdminViewCutiScreenState extends State<AdminViewCutiScreen> {
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
      firstDate: type == "start"
          ? selectedDate
          : DateTime.parse(dateStart + " 00:00:00"),
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
      BlocProvider.of<CutiBloc>(context).add((CutiSearch(q1, q2)));
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
    getEmployeeAbsence();
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
          "Data Cuti",
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
                "Data Cuti",
                style: TextStyle(
                    color: colorPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            BlocBuilder<CutiBloc, CutiState>(
              builder: (context, state) {
                if (state is LoadingCuti) {
                  return Container(
                    alignment: Alignment.topCenter,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(colorPrimary),
                    ),
                  );
                } else if (state is CutiSuccessLoad) {
                  return Expanded(
                      child: ListView.builder(
                          itemCount: state.cuti.length,
                          itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdminDetailCuti(cuti: state.cuti[index],)));
                                },
                                child: ItemBox(
                                  title: state.cuti[index].getNama,
                                  subtitle: "YOKESEN",
                                  date:
                                      "${state.cuti[index].getMulai} - ${state.cuti[index].getSelesai}",
                                  status: state.cuti[index].getStatus,
                                  screen: "cuti",
                                ),
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
