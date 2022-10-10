import 'package:AttendanceApp/constants/constant.dart';
import 'package:AttendanceApp/repository/repo_user.dart';
import 'package:AttendanceApp/screens/employee/screen-cuti.dart';
import 'package:AttendanceApp/screens/employee/screen-home.dart';
import 'package:AttendanceApp/screens/employee/screen-profil.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:AttendanceApp/model/model_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key key, this.user}) : super(key: key);

  @override
  _LayoutScreenState createState() => _LayoutScreenState();

  final Model_Firestore user;
}

class _LayoutScreenState extends State<LayoutScreen> {
  List<Widget> screenList = [];
  UserRepository userRepo = UserRepository();
  int _currentScreenIndex;
  Model_Firestore user;
  String id;

  void getUserActive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String userID = prefs.getString('id');
    var res = await userRepo.getEmployeeData(userID);
    setState(() {
      user = res;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserActive();
    if (widget.user != null) {
      user = widget.user;
    }
    _currentScreenIndex = 0;
    screenList.add(HomeScreen(user: user));
    screenList.add(CutiScreen(
      user: user,
    ));
    screenList.add(ProfilScreen(user: user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _currentScreenIndex,
          children: screenList,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.edit),
              label: "Form",
            ),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.solidUser), label: "Profil"),
          ],
          selectedItemColor: colorPrimary,
          unselectedItemColor: Colors.grey,
          selectedIconTheme: IconThemeData(color: colorPrimary),
          unselectedIconTheme: IconThemeData(color: Colors.grey),
          currentIndex: _currentScreenIndex,
          onTap: (index) {
            setState(() {
              _currentScreenIndex = index;
            });
          },
        ));
  }
}
