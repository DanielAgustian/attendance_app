import 'package:AttendanceApp/bloc/cuti/cuti_bloc.dart';
import 'package:AttendanceApp/bloc/cuti/cuti_event.dart';
import 'package:AttendanceApp/bloc/cuti/cuti_state.dart';
import 'package:AttendanceApp/constants/constant.dart';
import 'package:AttendanceApp/model/model-cuti.dart';
import 'package:AttendanceApp/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminDetailCuti extends StatefulWidget {
  const AdminDetailCuti({Key key, this.cuti}) : super(key: key);

  @override
  _AdminDetailCutiState createState() => _AdminDetailCutiState();
  final CutiModel cuti;
}

class _AdminDetailCutiState extends State<AdminDetailCuti> {
  void updateStatus(String status) {
    print(status);
    CutiModel newCuti = CutiModel.withID(
        id: widget.cuti.getID,
        alasan: widget.cuti.alasan,
        idUsaha: widget.cuti.getPerusahaan,
        nama: widget.cuti.getNama,
        idUser: widget.cuti.getIDUser,
        mulai: widget.cuti.getMulai,
        selesai: widget.cuti.getSelesai,
        status: status);
    print(newCuti.getID);
    BlocProvider.of<CutiBloc>(context).add(UpdateCuti(newCuti));
  }

  CutiModel cuti;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cuti = widget.cuti;
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
          "Application",
          style: TextStyle(
              color: colorPrimary, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: BlocListener<CutiBloc, CutiState>(
        listener: (context, state) {
          if (state is SuccessCuti) {
            setState(() {
              cuti.status = state.dec;
            });
            Util().showToast(
                msg: "Success", color: colorSuccess, context: this.context);
          } else if (state is FailedCuti) {
            Util().showToast(
                msg: "Something Wrong",
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
                  widget.cuti.getNama,
                  style: TextStyle(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Tanggal",
                  style: TextStyle(
                      color: colorAdditional2,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${widget.cuti.getMulai} - ${widget.cuti.getSelesai}",
                  style: TextStyle(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Alasan",
                  style: TextStyle(
                      color: colorAdditional2,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  width: size.width,
                  height: size.width * 0.8,
                  decoration: BoxDecoration(
                      border: Border.all(color: colorPrimary),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    widget.cuti.getAlasan,
                    style: TextStyle(color: colorPrimary, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                cuti.getStatus == ""
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              updateStatus("diterima");
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  boxShadow: darkShadow,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.check,
                                  color: colorSuccess,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 60,
                          ),
                          InkWell(
                            onTap: () {
                              updateStatus("ditolak");
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  boxShadow: darkShadow,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.times,
                                  color: colorError,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
