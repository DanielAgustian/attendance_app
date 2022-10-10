 
import 'package:AttendanceApp/bloc/employee/employee_bloc.dart';
import 'package:AttendanceApp/bloc/employee/employee_event.dart';
import 'package:AttendanceApp/bloc/employee/employee_state.dart'; 
import 'package:AttendanceApp/components/button/long-button.dart';
import 'package:AttendanceApp/constants/constant.dart'; 
import 'package:AttendanceApp/model/model-team.dart';
import 'package:AttendanceApp/model/model_firestore.dart';
import 'package:AttendanceApp/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

class AdminDetailMember extends StatefulWidget {
  const AdminDetailMember({Key key, this.user, this.teams}) : super(key: key);

  @override
  _AdminDetailMemberState createState() => _AdminDetailMemberState();
  final Model_Firestore user;
  final List<TeamModel> teams;
}

class _AdminDetailMemberState extends State<AdminDetailMember> {

  Model_Firestore user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Member Profile",
          style: TextStyle(
              color: colorPrimary, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: BlocListener<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is SuccessEmployee) {
            Util().showToast(
                msg: "Updated !", color: colorSuccess, context: this.context);
            BlocProvider.of<EmployeeBloc>(context).add(InitEmployee());
          } else if (state is FailedEmployee) {
            Util().showToast(
                msg: "Something Wrong !",
                color: colorError,
                context: this.context);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.width * 0.1,
                ),
                Center(
                  child: CircleAvatar(
                    backgroundColor: colorAdditional1,
                    radius: 100,
                    child: user.image == ""
                        ? Image.asset("assets/images/ava.png")
                        : ClipOval(
                            child: Image.network(
                              user.image,
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Nama",
                  style: TextStyle(
                      color: colorAdditional2,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.user.nama,
                  style: TextStyle(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Nomor HP",
                  style: TextStyle(
                      color: colorAdditional2,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.user.hp,
                  style: TextStyle(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Email",
                  style: TextStyle(
                      color: colorAdditional2,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.user.email,
                  style: TextStyle(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Team",
                  style: TextStyle(
                      color: colorAdditional2,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 6,
                ),
                DropdownButton<String>(
                  value: widget.user.team == "" ? "not" : widget.user.team,
                  style: TextStyle(color: colorPrimary, fontSize: 16),
                  items: widget.teams.map((value) {
                    return new DropdownMenuItem<String>(
                      value: value.getTeam,
                      child: new Text(value.getTeam),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      user.team = val;
                    });
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: LongButton(
                    bgColor: Colors.white,
                    textColor: colorPrimary,
                    title: "UPDATE",
                    onClick: () {
                      BlocProvider.of<EmployeeBloc>(context)
                          .add(UpdateEmployee(user));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
