import 'dart:async';

import 'package:AttendanceApp/bloc/cuti/cuti_bloc.dart';
import 'package:AttendanceApp/bloc/cuti/cuti_event.dart';
import 'package:AttendanceApp/bloc/employee/employee_bloc.dart';
import 'package:AttendanceApp/bloc/employee/employee_event.dart';
import 'package:AttendanceApp/bloc/time/time_bloc.dart';
import 'package:AttendanceApp/bloc/time/time_event.dart';
import 'package:AttendanceApp/bloc/user/absence_bloc.dart';
import 'package:AttendanceApp/bloc/user/absence_event.dart';
import 'package:AttendanceApp/bloc/user/cuti_bloc.dart';
import 'package:AttendanceApp/bloc/user/cuti_event.dart';
import 'package:AttendanceApp/bloc/user/user_bloc.dart';
import 'package:AttendanceApp/bloc/user/user_event.dart';
import 'package:AttendanceApp/repository/repo_absen.dart';
import 'package:AttendanceApp/repository/repo_cuti.dart';
import 'package:AttendanceApp/screens/admin/screen-tab.dart';
import 'package:AttendanceApp/constants/constant.dart';
import 'package:AttendanceApp/model/model_firestore.dart';
import 'package:AttendanceApp/repository/repo_user.dart';
import 'package:AttendanceApp/screens/employee/screen-tab.dart';
import 'package:AttendanceApp/screens/screen-login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocObserver();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  String userID;
  void getActiveUser() async {
    var prefs = await SharedPreferences.getInstance();
    print(prefs.getString("id"));
    String id = prefs.getString("id");

    userID = id;
  }

  @override
  Widget build(BuildContext context) {
    getActiveUser();
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) {
            return UserBloc(userRepo: UserRepository())..add(LoadUser());
          },
        ),
        BlocProvider<EmployeeBloc>(
          create: (context) {
            return EmployeeBloc(employeeRepo: UserRepository())
              ..add(InitEmployee());
          },
        ),
        BlocProvider<CutiBloc>(
          create: (context) {
            return CutiBloc(cutiRepo: CutiRepository())..add(InitCuti());
          },
        ),
        BlocProvider<TimeBloc>(
          create: (context) {
            return TimeBloc(absenRepo: AbsensiRepository())..add(InitTime());
          },
        ),
        BlocProvider<UserCutiBloc>(
          create: (context) {
            return UserCutiBloc(cutiRepo: CutiRepository())
              ..add(InitCutiUser());
          },
        ),
        BlocProvider<UserAbsenceBloc>(
          create: (context) {
            return UserAbsenceBloc(absenRepo: AbsensiRepository())
              ..add(UserInitAbsence());
          },
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomeApp()),
    );
  }
}

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  String role;
  String id;
  Model_Firestore user;
  UserRepository userRepo = UserRepository();

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String userID = prefs.getString('id');
    print(userID);
    if (userID != null) {
      var res = await userRepo.getEmployeeData(userID);
      setState(() {
        role = prefs.getString('role');
        user = res;
        id = userID;
      });
    }
  }

  Future<void> isLoggedIn() async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    var dbRes = await users.doc(id).get();

    print("RES ${dbRes.data()}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStringValuesSF();

    Timer(
        Duration(seconds: 3),
        () => user != null
            ? handlingRole()
            : Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen())));
  }

  void handlingRole() {
    if (user.role == "admin") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AdminLayoutScreen(user: user)));
    } else if (user.role == "user") {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LayoutScreen(user: user)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Attendance APP",
          style: TextStyle(
              color: colorPrimary, fontWeight: FontWeight.bold, fontSize: 36),
        ),
      ),
    );
  }
}
