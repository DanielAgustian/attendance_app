import 'dart:async';

import 'package:AttendanceApp/bloc/cuti/cuti_bloc.dart';
import 'package:AttendanceApp/bloc/cuti/cuti_state.dart';
import 'package:AttendanceApp/bloc/time/time_bloc.dart';
import 'package:AttendanceApp/bloc/time/time_state.dart';
import 'package:AttendanceApp/bloc/user/user_bloc.dart';
import 'package:AttendanceApp/bloc/user/user_state.dart';
import 'package:AttendanceApp/components/cuti/counter-box.dart';
import 'package:AttendanceApp/components/home/header.dart';
import 'package:AttendanceApp/constants/constant.dart';
import 'package:AttendanceApp/repository/repo_notif.dart';
import 'package:AttendanceApp/screens/admin/screen-absensi-admin.dart';
import 'package:AttendanceApp/screens/admin/screen-employee-cuti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:badges/badges.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:AttendanceApp/model/model_firestore.dart';
import 'package:AttendanceApp/screens/screen-login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key key, this.user}) : super(key: key);

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
  final Model_Firestore user;
}

read(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  Map<String, dynamic> jsonValue = json.decode(prefs.getString(key));
  print('Howdy, ${jsonValue['nama']}!');
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  Model_Firestore user;
  DateTime now = DateTime.now();
  String tapType = "Clock In";
  String formattedDate = "";
  String id;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Notifications _notifications = Notifications();
  void _getTime() {
    final DateTime now = DateTime.now();
    if (mounted) {
      setState(() {
        formattedDate = DateFormat("kk:mm").format(now);
      });
    }
  }

  void _pushNotification(int notif) {
    String messages;
    DateFormat clockFormat = DateFormat.Hm();
    String jam = clockFormat.format(DateTime.now());
    if (notif == 0) {
      messages = "Clock in Success at " + jam;
    } else if (notif == 1) {
      messages = "Clock Out Success at " + jam;
    } else {
      messages = "You already clock in and out.";
    }
    this._notifications.pushNotification(widget.user.nama, messages);
  }

  void getStringValuesSF(int penentu, String from) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('id');

    setState(() {
      if (from == "dbCheck") {
        if (penentu == 0) {
          tapType = "Clock in";
          prefs.setInt('update', 0);
        } else if (penentu == 1) {
          tapType = "ClockOut";
          prefs.setInt('update', 1);
        } else if (penentu == 2) {
          prefs.setInt('update', 2);
          tapType = "Locked.";
        }
      } else if (from == "press") {
        int updating = prefs.getInt('update');
        if (updating == 0) {
          tapType = "Clock Out";
          _pushNotification(updating); //clock in successs ->0
          prefs.setInt('update', 1);

          dbWriteUpdate(stringValue, 0);
        } else if (updating == 1) {
          prefs.setInt('update', 2);
          tapType = "Locked.";
          //clock out success->1
          _pushNotification(updating);
          dbWriteUpdate(stringValue, 1);
          // read("model");
        } else if (updating == 2) {
          _pushNotification(updating);
        }
      }

      print("Data Screen Home:" + stringValue);
      id = stringValue;
    });
  }

  void dbWriteUpdate(String idKaryawan, int pp) async {
    final CollectionReference time =
        FirebaseFirestore.instance.collection('time');

    DateFormat dateFormatHari = DateFormat("yyyy-MM-dd");
    String hari = dateFormatHari.format(DateTime.now());
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
    String jam = dateFormat.format(DateTime.now());

    // Check is employee late
    DateFormat clockFormat = DateFormat.Hm();
    DateTime limit = clockFormat.parse("09:00");
    String status = DateTime.now().isAfter(limit) ? "late" : "on time";

    String idTime = hari + widget.user.id;
    print("idTime= " + widget.user.nama);
    if (pp == 0) {
      time.doc(idTime).set({
        'idUser': idKaryawan,
        'day': hari,
        'nama': widget.user.nama,
        'pergi': jam,
        'pulang': "",
        'status': status,
      });
    } else if (pp == 1) {
      CollectionReference time = FirebaseFirestore.instance.collection('time');
      var dbRef = time
          .where("day", isEqualTo: hari)
          .where("idUser", isEqualTo: idKaryawan);
      dbRef.get().then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          doc.reference.update({'pulang': jam});
        });
      });
    }
  }

  void dbCheck(String idKaryawan) async {
    print("DB_CHECK");
    bool cek;
    DateFormat dateFormatHari = DateFormat("yyyy-MM-dd");
    String hari = dateFormatHari.format(DateTime.now());
    CollectionReference times = FirebaseFirestore.instance.collection('time');
    var dbCek = times
        .where("day", isEqualTo: hari)
        .where("idUser", isEqualTo: widget.user.id);
    print("Day: " + hari + "idUser: " + widget.user.id);
    int addData = 0;
    dbCek.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["day"]);
        if (doc.exists) {
          cek = true;
          print("data ada");
          addData = 1;
          if (doc["pulang"] == "") {
            print("update pulang field");
            getStringValuesSF(1, "dbCheck"); //Update Node for pulang
          } else {
            print("Has Completely Absent.");
            getStringValuesSF(2, "dbCheck"); //No Need for update
          }
        } else {
          cek = false;
          print("Data Ga ada");
          print("Make new time field");
          getStringValuesSF(0, "dbCheck"); //Make new Node for pergi
        }
      });
    });
    if (addData == 0) {
      print("Make new time field");
      getStringValuesSF(0, "dbCheck");
    }
  }

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
    this._notifications.initNotifications();
    formattedDate = DateFormat("kk:mm").format(now);
    print(widget.user.nama);
    if (widget.user != null) {
      user = widget.user;
    }
    dbCheck(widget.user.id);
  }

  void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void gotoabsensiAdmin() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AbsensiAdminScreen(user: user)));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: [
                CurvedShape(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                        if (state is LoadingUser) {
                          return Container(
                            alignment: Alignment.topCenter,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor: AlwaysStoppedAnimation(colorPrimary),
                            ),
                          );
                        } else if (state is UserSuccessLoad) {
                          return Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Halo, ${state.user.nama}!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "YOKESEN",
                                    style: TextStyle(
                                        color: colorAdditional1,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container();
                      }),
                      SizedBox(
                        height: 100,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(300)),
                        padding: EdgeInsets.all(20),
                        onPressed: () {
                          getStringValuesSF(0, "press");
                        },
                        child: Container(
                            width: size.width * 0.7,
                            height: size.width * 0.7,
                            decoration: BoxDecoration(
                                color: colorPrimary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(52, 131, 234, 0.39),
                                      spreadRadius: 20)
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    formattedDate,
                                    style: TextStyle(
                                        color: colorAdditional1,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 64),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    tapType == "Locked."
                                        ? "Thank you, Have a nice day"
                                        : "Tap to $tapType",
                                    style: TextStyle(
                                        color: colorAdditional1,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                )
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<TimeBloc, TimeState>(
                            builder: (context, state) {
                              if (state is LoadingTime) {
                                return CounterBoxCuti(
                                  size: size,
                                  counter: 0,
                                  boxText: "Karyawan Masuk",
                                  bgColor: colorPrimary,
                                  textColor: Colors.white,
                                  loading: true,
                                );
                              } else if (state is TimeSuccessLoad) {
                                return InkWell(
                                  onTap: gotoabsensiAdmin,
                                  child: CounterBoxCuti(
                                    size: size,
                                    counter: state.counter,
                                    boxText: "Karyawan Masuk",
                                    bgColor: colorPrimary,
                                    textColor: Colors.white,
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          BlocBuilder<CutiBloc, CutiState>(
                            builder: (context, state) {
                              if (state is LoadingCuti) {
                                return CounterBoxCuti(
                                  size: size,
                                  counter: 0,
                                  boxText: "Karyawan Izin",
                                  bgColor: Colors.white,
                                  textColor: colorPrimary,
                                  loading: true,
                                );
                              } else if (state is CutiSuccessLoad) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AdminViewCutiScreen()));
                                  },
                                  child: CounterBoxCuti(
                                    size: size,
                                    counter: state.counter,
                                    boxText: "Karyawan Izin",
                                    bgColor: Colors.white,
                                    textColor: colorPrimary,
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class IconNotification extends StatelessWidget {
  const IconNotification({
    Key key,
    this.count,
  }) : super(key: key);

  final count;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Badge(
      position: BadgePosition.topEnd(top: -5, end: -5),
      animationDuration: Duration(milliseconds: 300),
      animationType: BadgeAnimationType.fade,
      badgeContent: Text(
        "$count",
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      badgeColor: colorError,
      child: FaIcon(
        FontAwesomeIcons.bell,
        size: 27,
        color: Colors.white,
      ),
    ));
  }
}
