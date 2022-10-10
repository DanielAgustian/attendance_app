import 'package:AttendanceApp/components/button/small-button.dart';
import 'package:AttendanceApp/constants/constant.dart';
import 'package:AttendanceApp/screens/screen-login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController textPassword = new TextEditingController();
  TextEditingController textEmail = new TextEditingController();
  TextEditingController textPhone = new TextEditingController();
  TextEditingController textCode = new TextEditingController();
  TextEditingController textName = new TextEditingController();
  bool _obscureText = true;
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> register() async {
    if (_formKey.currentState.validate()) {
      String id = getRandomString(7);

      String nama = "";
      if (textName.text == null) {
        nama = "";
      } else {
        nama = textName.text;
      }
      String email = textEmail.text;
      String hp = textPhone.text;
      String password = textPassword.text;
      String idUsaha = textCode.text;
      final CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      users.doc(id).set({
        'nama': nama,
        'email': email,
        'hp': hp,
        'idUsaha': idUsaha,
        'password': password,
        'role': 'user',
        'image': '',
        'team': 'not'
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      setState(() {
        this.loading = false;
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: [
              Container(
                child: Image.asset('assets/images/background-login.png'),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Form(
                      autovalidate: _autoValidate,
                      key: _formKey,
                      child: Container(
                        // margin: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Nama Lengkap",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            TextFormField(
                              cursorColor: Colors.white,
                              controller: textName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.length < 6)
                                  return "Name is too short";
                                else
                                  return null;
                              },
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.white),
                                hintStyle: TextStyle(color: Colors.white),
                                focusColor: colorPrimary,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Email",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            TextFormField(
                              cursorColor: Colors.white,
                              controller: textEmail,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18),
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                Pattern pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regex = new RegExp(pattern);

                                if (!regex.hasMatch(val))
                                  return "Email doesn't valid";
                                else if (val.length < 7)
                                  return "Email doesn't valid";
                                else
                                  return null;
                              },
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintStyle: TextStyle(color: Colors.white),
                                  focusColor: colorPrimary,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  )),
                            ),
                            SizedBox(height: 5),
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Nomor HP",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            TextFormField(
                              cursorColor: Colors.white,
                              controller: textPhone,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                              ],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.length < 9)
                                  return "Phone number doesn't valid";
                                else
                                  return null;
                              },
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintStyle: TextStyle(color: Colors.white),
                                  focusColor: colorPrimary,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  )),
                            ),
                            SizedBox(height: 5),
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Password",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            TextFormField(
                              cursorColor: Colors.white,
                              controller: textPassword,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18),
                              validator: (value) {
                                if (value.length < 6)
                                  return "Password is too short";
                                else
                                  return null;
                              },
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintStyle: TextStyle(color: Colors.white),
                                  focusColor: colorPrimary,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: FaIcon(
                                      _obscureText
                                          ? FontAwesomeIcons.solidEye
                                          : FontAwesomeIcons.eye,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  )),
                            ),
                            SizedBox(height: 5),
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Kode Perusahaan",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            TextFormField(
                              cursorColor: Colors.white,
                              controller: textCode,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.length > 6)
                                  return "Code doesn't valid";
                                else
                                  return null;
                              },
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintStyle: TextStyle(color: Colors.white),
                                  focusColor: colorPrimary,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    SmallButton(
                      onClick: register,
                      title: "REGISTER",
                      bgColor: Colors.white,
                      textColor: colorPrimary,
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: size.height < 690
                                    ? Colors.white
                                    : colorPrimary),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
