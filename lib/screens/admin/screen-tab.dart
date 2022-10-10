import 'package:AttendanceApp/constants/constant.dart';
import 'package:AttendanceApp/screens/admin/screen-dashboard.dart';
import 'package:AttendanceApp/screens/admin/screen-member.dart';
import 'package:AttendanceApp/screens/admin/screen-profil.dart'; 
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:AttendanceApp/model/model_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:AttendanceApp/repository/repo_user.dart';

class AdminLayoutScreen extends StatefulWidget {
  const AdminLayoutScreen({Key key, this.user}) : super(key: key);

  @override
  _AdminLayoutScreenState createState() => _AdminLayoutScreenState();

  final Model_Firestore user;
}

class _AdminLayoutScreenState extends State<AdminLayoutScreen> {
  List<Widget> screenList = [];
  int _currentScreenIndex;
  UserRepository userRepo = UserRepository();
  Model_Firestore user;

  void getAdminActive() async {
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
    if (widget.user != null) {
      user = widget.user;
    }
    getAdminActive();
    _currentScreenIndex = 0;
    screenList.add(AdminDashboardScreen(user: user));
    screenList.add(MemberScreen());
    screenList.add(AdminProfilScreen(user: user));
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
              icon: FaIcon(FontAwesomeIcons.users),
              label: "Member",
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
