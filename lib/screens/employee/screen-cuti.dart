import 'package:AttendanceApp/bloc/user/cuti_bloc.dart';
import 'package:AttendanceApp/bloc/user/cuti_event.dart';
import 'package:AttendanceApp/bloc/user/cuti_state.dart';
import 'package:AttendanceApp/components/button/long-button.dart';
import 'package:AttendanceApp/components/cuti/counter-box.dart';
import 'package:AttendanceApp/constants/constant.dart';
import 'package:AttendanceApp/model/model-cuti.dart';
import 'package:AttendanceApp/model/model_firestore.dart';
import 'package:AttendanceApp/repository/repo_cuti.dart';
import 'package:AttendanceApp/screens/employee/screen-view-cuti.dart';

import 'package:AttendanceApp/screens/employee/screen-tab.dart';

import 'package:AttendanceApp/util/utility.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class CutiScreen extends StatefulWidget {
  const CutiScreen({Key key, this.user}) : super(key: key);

  @override
  _CutiScreenState createState() => _CutiScreenState();
  final Model_Firestore user;
}

class _CutiScreenState extends State<CutiScreen> {
  TextEditingController textReason = new TextEditingController();
  CutiRepository cutiRepo = CutiRepository();
  DateTime selectedDate = DateTime.now();
  String dateStart = "yyyy-MM-dd";
  String dateEnd = "yyyy-MM-dd";
  Model_Firestore user;
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
    if (picked != null && picked != selectedDate)
      setState(() {
        type == "start"
            ? dateStart = DateFormat("yyyy-MM-dd").format(picked)
            : dateEnd = DateFormat("yyyy-MM-dd").format(picked);
      });
  }

  void showToast(String msg, {int duration, Color color}) {
    Toast.show(msg, context,
        duration: duration,
        gravity: Toast.BOTTOM,
        backgroundColor: color,
        textColor: Colors.white);
  }

  void sendCuti() async {
    CutiModel data = CutiModel(
        idUser: widget.user.id,
        nama: widget.user.nama,
        alasan: textReason.text,
        mulai: dateStart,
        selesai: dateEnd,
        idUsaha: widget.user.idUsaha,
        status: "");

    var res = await cutiRepo.addCutiPermission(data);
    if (res) {
      showToast("Application Success !", color: colorSuccess);
      Model_Firestore user1 = widget.user;
      //textReason = new TextEditingController(text: "");

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LayoutScreen(user: user1)));
    } else {
      showToast("Something Wrong !", color: colorError);
    }

    BlocProvider.of<UserCutiBloc>(context).add(AddCutiUser(data));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<UserCutiBloc, UserCutiState>(
        listener: (context, state) {
          if (state is UserSuccessCuti) {
            Util().showToast(
                msg: "Updated !", color: colorSuccess, context: this.context);
          } else if (state is UserFailedCuti) {
            Util().showToast(
                msg: "Something Wrong !",
                color: colorError,
                context: this.context);
          }
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                ),
                Container(
                  child: Text(
                    "Pengajuan Cuti",
                    style: TextStyle(
                        color: colorPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CounterBoxCuti(
                      size: size,
                      counter: 12,
                      boxText: "Batas Cuti Tahunan",
                      bgColor: colorPrimary,
                      textColor: Colors.white,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    CounterBoxCuti(
                      size: size,
                      counter: 7,
                      boxText: "Sisa Cuti Tahunan",
                      bgColor: colorAdditional1,
                      textColor: colorSecondary,
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: Text(
                    "FORM PENGAJUAN",
                    style: TextStyle(
                        color: colorPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Tanggal Pengajuan",
                    style: TextStyle(
                        color: colorAdditional2,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () =>
                          _selectDate(context, "start"), // Refer step 3
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
                  height: 30,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Alasan Pengajuan",
                    style: TextStyle(
                        color: colorAdditional2,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: textReason,
                  maxLines: 7,
                  style: TextStyle(
                      color: colorPrimary,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          borderSide: BorderSide(color: colorPrimary)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          borderSide: BorderSide(color: colorPrimary)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          borderSide: BorderSide(color: colorPrimary)),
                      fillColor: Colors.white70),
                ),
                SizedBox(
                  height: 20,
                ),
                LongButton(
                  onClick: sendCuti,
                  title: "SUBMIT",
                  textColor: Colors.white,
                  bgColor: colorPrimary,
                ),
                SizedBox(
                  height: 15,
                ),
                LongButton(
                  onClick: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewCutiScreen()));
                  },
                  title: "Lihat Pengajuan",
                  bgColor: Colors.white,
                  textColor: colorPrimary,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
