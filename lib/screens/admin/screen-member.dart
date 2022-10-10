import 'package:AttendanceApp/bloc/employee/employee_bloc.dart';
import 'package:AttendanceApp/bloc/employee/employee_event.dart';
import 'package:AttendanceApp/bloc/employee/employee_state.dart';
import 'package:AttendanceApp/constants/constant.dart';
import 'package:AttendanceApp/model/model-team.dart';
import 'package:AttendanceApp/model/model_firestore.dart';
import 'package:AttendanceApp/repository/repo_user.dart';
import 'package:AttendanceApp/screens/admin/screen-detail-member.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MemberScreen extends StatefulWidget {
  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  UserRepository userRepo = UserRepository();
  TextEditingController filterText = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  String dateStart = "yyyy-MM-dd";
  String dateEnd = "yyyy-MM-dd";
  // get calendar function
  void _selectDate(BuildContext context, String type) async {
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

  List<TeamModel> teams = [];

  void getTeams() async {
    var res = await userRepo.getTeams();
    setState(() {
      teams = res;
    });
  }

  void tap() {
    print("AAAAAAAAAAAAAAAAAAAA");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTeams();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Text(
          "Absensi Karyawan",
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
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colorPrimary),
                  borderRadius: BorderRadius.circular(20)),
              child: TextFormField(
                textInputAction: TextInputAction.search,
                onChanged: (val) {
                  BlocProvider.of<EmployeeBloc>(context)
                      .add((EmployeeSearch(val)));
                },
                controller: filterText,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 20, right: 20),
                    hintText: "Search",
                    hintStyle: TextStyle(
                      color: colorAdditional1,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Data Karyawan A",
                style: TextStyle(
                    color: colorPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            BlocBuilder<EmployeeBloc, EmployeeState>(
              builder: (context, state) {
                if (state is LoadingEmployee) {
                  return Container(
                    alignment: Alignment.topCenter,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(colorPrimary),
                    ),
                  );
                } else if (state is EmployeeSuccessLoad) {
                  return Expanded(
                      child: ListView.builder(
                          itemCount: state.employee.length,
                          itemBuilder: (context, index) => MemberItem(
                                member: state.employee[index],
                                onClick: () {
                                  print("AAAAAAAAAAAAA");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdminDetailMember(
                                                user: state.employee[index],
                                                teams: teams,
                                              )));
                                },
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

class MemberItem extends StatelessWidget {
  const MemberItem({
    Key key,
    @required this.member,
    this.onClick,
  }) : super(key: key);

  final Model_Firestore member;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: darkShadow),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.nama,
                  style: TextStyle(color: colorPrimary, fontSize: 16),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  member.team,
                  style: TextStyle(
                      color: colorSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "YOKESEN",
                  style: TextStyle(
                      color: colorAdditional2,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
