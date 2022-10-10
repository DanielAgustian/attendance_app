import 'dart:io';
import 'package:AttendanceApp/bloc/user/user_bloc.dart';
import 'package:AttendanceApp/bloc/user/user_event.dart';
import 'package:AttendanceApp/bloc/user/user_state.dart';
import 'package:AttendanceApp/repository/repo_user.dart';
import 'package:AttendanceApp/screens/screen-login.dart';
import 'package:AttendanceApp/screens/employee/screen-tab.dart';
import 'package:AttendanceApp/util/utility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:AttendanceApp/components/button/small-button.dart';
import 'package:AttendanceApp/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:AttendanceApp/model/model_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key key, this.user}) : super(key: key);

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
  final Model_Firestore user;
}

class _ProfilScreenState extends State<ProfilScreen> {
  UserRepository userRepository = UserRepository();
  TextEditingController textCompanyCode = new TextEditingController();
  TextEditingController textEmail;
  TextEditingController textNama;
  TextEditingController textHp;

  String _namaValidator, _emailValidator, _hpValidator = '';
  final picker = ImagePicker();
  File _image;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      BlocProvider.of<UserBloc>(context).add(UpdateImage(_image));
    }
  }

  void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void changeCompanyDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Masukan Kode Perusahaan",
                      style: TextStyle(
                          color: colorPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: textCompanyCode,
                      cursorColor: colorPrimary,
                      style: TextStyle(color: colorPrimary, fontSize: 24),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        errorText: _namaValidator == '' ? null : _namaValidator,
                        labelStyle: TextStyle(color: colorPrimary),
                        hintStyle: TextStyle(color: colorPrimary),
                        focusColor: colorPrimary,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorPrimary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorPrimary),
                        ),
                      ),
                    ),
                  ),
                  SmallButton(
                    bgColor: colorPrimary,
                    textColor: Colors.white,
                    title: "UBAH",
                    onClick: () {},
                  ),
                ],
              ),
            ),
          );
        });
  }

  void update() {
    bool sukses = false;
    if (textNama.text == "") {
      sukses = false;
      setState(() {
        _namaValidator = "Required fields !";
      });
    } else {
      sukses = true;
      setState(() {
        _namaValidator = "";
      });
    }
    if (textEmail.text == "") {
      sukses = false;
      setState(() {
        _emailValidator = "Required fields !";
      });
    } else {
      sukses = true;
      setState(() {
        _emailValidator = "";
      });
    }
    if (textHp.text == "") {
      sukses = false;
      setState(() {
        _hpValidator = "Required fields !";
      });
    } else {
      sukses = true;
      setState(() {
        _hpValidator = "";
      });
    }
    if (sukses == true) {
      Model_Firestore user = Model_Firestore(
          id: widget.user.id,
          nama: textNama.text,
          email: textEmail.text,
          hp: textHp.text,
          idUsaha: widget.user.idUsaha,
          image: widget.user.image,
          team: widget.user.team,
          password: widget.user.password,
          role: widget.user.role);

      BlocProvider.of<UserBloc>(context).add(UpdateUser(user));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LayoutScreen(user: user)));
      // updateProfile(textNama.text, textEmail.text, textHp.text);
    }
  }

  void updateProfile(String nama, email, hp) async {
    String idUser = widget.user.id;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(idUser).update({'nama': nama, 'email': email, 'hp': hp});
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
          "Profil",
          style: TextStyle(
              color: colorPrimary, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserSuccessLoad) {
            print(state.user.email);
            setState(() {
              textEmail = new TextEditingController(text: state.user.email);
              textNama = new TextEditingController(text: state.user.nama);
              textHp = new TextEditingController(text: state.user.hp);
            });
            if (state.dec) {
              Util().showToast(
                  msg: "Data successfully update !",
                  color: colorSuccess,
                  context: this.context);
            }
          } else if (state is ImageFail) {
            Util().showToast(
                msg: "Failed to update Image !",
                color: colorError,
                context: this.context);
          } else if (state is ImageSuccess) {
            widget.user.setImage(state.imgURL);
            update();
            Util().showToast(
                msg: "Success Upload !",
                color: colorSuccess,
                context: this.context);
          } else if (state is UserFail) {
            Util().showToast(
                msg: "Failed to update !",
                color: colorError,
                context: this.context);
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
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
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.width * 0.06,
                      ),
                      CircleAvatar(
                        backgroundColor: colorAdditional1,
                        radius: 100,
                        child: state.user.image == null
                            ? Image.asset("assets/images/ava.png")
                            : ClipOval(
                                child: Image.network(
                                  state.user.image,
                                  fit: BoxFit.cover,
                                  width: 200,
                                  height: 200,
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: getImage,
                        child: Text(
                          "Ubah Foto",
                          style: TextStyle(color: colorPrimary, fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Perusahaan",
                          style: TextStyle(
                              color: colorPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "YOKESEN",
                            style: TextStyle(
                                color: colorSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                          Container(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              onTap: changeCompanyDialog,
                              child: Column(
                                children: [
                                  FaIcon(FontAwesomeIcons.pen,
                                      size: 15, color: colorAdditional2),
                                  Text(
                                    "Ubah",
                                    style: TextStyle(
                                        color: colorAdditional2,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Nama Lengkap",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colorPrimary),
                        ),
                      ),
                      Container(
                        width: size.width,
                        child: TextFormField(
                          controller: textNama,
                          cursorColor: colorPrimary,
                          style: TextStyle(color: colorPrimary, fontSize: 16),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            errorText:
                                _namaValidator == '' ? null : _namaValidator,
                            labelStyle: TextStyle(color: colorPrimary),
                            hintStyle: TextStyle(color: colorPrimary),
                            focusColor: colorPrimary,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorPrimary),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorPrimary),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colorPrimary),
                        ),
                      ),
                      Container(
                        width: size.width,
                        child: TextFormField(
                          controller: textEmail,
                          cursorColor: colorPrimary,
                          style: TextStyle(color: colorPrimary, fontSize: 16),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            errorText:
                                _emailValidator == '' ? null : _emailValidator,
                            labelStyle: TextStyle(color: colorPrimary),
                            hintStyle: TextStyle(color: colorPrimary),
                            focusColor: colorPrimary,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorPrimary),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorPrimary),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Nomor HP",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colorPrimary),
                        ),
                      ),
                      Container(
                        width: size.width,
                        child: TextFormField(
                          controller: textHp,
                          cursorColor: colorPrimary,
                          style: TextStyle(color: colorPrimary, fontSize: 16),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            errorText: _hpValidator == '' ? null : _hpValidator,
                            labelStyle: TextStyle(color: colorPrimary),
                            hintStyle: TextStyle(color: colorPrimary),
                            focusColor: colorPrimary,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorPrimary),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorPrimary),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SmallButton(
                        onClick: update,
                        title: "UPDATE",
                        bgColor: Colors.white,
                        textColor: colorPrimary,
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: logout,
        child: FaIcon(
          FontAwesomeIcons.signOutAlt,
          color: colorError,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
