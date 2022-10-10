import 'package:AttendanceApp/bloc/user/cuti_bloc.dart';
import 'package:AttendanceApp/bloc/user/cuti_state.dart';
import 'package:AttendanceApp/components/cuti/counter-box.dart';
import 'package:AttendanceApp/components/item-box.dart';
import 'package:AttendanceApp/constants/constant.dart';
import 'package:AttendanceApp/model/model-cuti.dart';
import 'package:AttendanceApp/repository/repo_cuti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewCutiScreen extends StatefulWidget {
  @override
  _ViewCutiScreenState createState() => _ViewCutiScreenState();
}

class _ViewCutiScreenState extends State<ViewCutiScreen> {
  List<CutiModel> cutiList = [];
  CutiRepository cutiRepository = CutiRepository();

  void getEmployeeAbsence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String userID = prefs.getString('id');
    var res = await cutiRepository.getEmployeeApplication(userID);
    setState(() {
      cutiList = res;
    });
  }

  String userID;
  void getActiveUser() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("id");

    setState(() {
      userID = id;
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
            BlocBuilder<UserCutiBloc, UserCutiState>(
              builder: (context, state) {
                if (state is LoadingCutiUser) {
                  return Container(
                    alignment: Alignment.topCenter,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(colorPrimary),
                    ),
                  );
                } else if (state is UserCutiSuccessLoad) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: state.cuti.length,
                        itemBuilder: (context, index) => ItemBox(
                              title: state.cuti[index].getNama,
                              subtitle: "YOKESEN",
                              date:
                                  "${state.cuti[index].getMulai} - ${state.cuti[index].getSelesai}",
                              status: state.cuti[index].getStatus,
                              screen: "cuti",
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
