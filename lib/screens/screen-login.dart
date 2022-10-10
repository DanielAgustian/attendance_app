import 'package:AttendanceApp/bloc/user/absence_bloc.dart';
import 'package:AttendanceApp/bloc/user/absence_event.dart';
import 'package:AttendanceApp/bloc/user/cuti_bloc.dart';
import 'package:AttendanceApp/bloc/user/cuti_event.dart';
import 'package:AttendanceApp/bloc/user/user_bloc.dart';
import 'package:AttendanceApp/bloc/user/user_event.dart';
import 'package:AttendanceApp/bloc/user/user_state.dart';
import 'package:AttendanceApp/components/button/small-button.dart';
import 'package:AttendanceApp/constants/constant.dart';
import 'package:AttendanceApp/model/model_firestore.dart';
import 'package:AttendanceApp/screens/admin/screen-tab.dart';
import 'package:AttendanceApp/screens/employee/screen-tab.dart';
import 'package:AttendanceApp/screens/screen-register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //final Future<FirebaseApp> _fbapp = Firebase.initializeApp();
  TextEditingController textEmailUsername = new TextEditingController();
  TextEditingController textPassword = new TextEditingController();
  String _passValidator, _emailValidator = '';
  bool _obscureText = true;
  Model_Firestore data;
  String id, password;

  Future<void> dbread(String email) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    var dbRef = users.where("email", isEqualTo: email);
    String mail = textEmailUsername.text;
    String pass = textPassword.text;
    dbRef.get().then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length != 0) {
        print(querySnapshot.docs.length);
        querySnapshot.docs.forEach((doc) {
          print(doc["email"]);
          data = Model_Firestore.fromSnapshot(doc);
          addStringToSF(data.id, data.role);
          print("data role = " + data.role);
          print("pass = " + data.password);
          print("email = " + data.email);
          if (data.email == mail && data.password == pass) {
            print("Login Success");
            //BUAT USER
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => data.role == "user"
                        ? LayoutScreen(user: data)
                        : AdminLayoutScreen(user: data)));
          } else {
            showToast("Wrong email or password", color: colorError);
          }
        });
      } else {
        showToast("Wrong email or password", color: colorError);
      }
    });
  }

  void showToast(String msg, {Color color = colorSecondary, int duration}) {
    Toast.show(msg, context,
        duration: duration,
        gravity: Toast.BOTTOM,
        backgroundColor: color,
        textColor: Colors.white);
  }

  void addStringToSF(String idKaryawan, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', idKaryawan);
    prefs.setString('role', role);
  }

  void login() {
    bool sukses = false;
    if (textEmailUsername.text == "") {
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

    if (textPassword.text == "") {
      sukses = false;
      setState(() {
        _passValidator = "Required fields !";
      });
    } else {
      sukses = true;
      setState(() {
        _passValidator = "";
      });
    }

    if (sukses) {
      // dbread(email);
      BlocProvider.of<UserBloc>(context)
          .add(LoginUser(textEmailUsername.text, textPassword.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserSuccess) {
          if (state.user.role == "user") {
            BlocProvider.of<UserAbsenceBloc>(context).add(UserInitAbsence());
            BlocProvider.of<UserCutiBloc>(context).add(InitCutiUser());
          }
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => state.user.role == "user"
                      ? LayoutScreen(user: state.user)
                      : AdminLayoutScreen(user: state.user)));
        } else if (state is UserFail) {
          showToast(state.msg, color: colorError);
        }
      },
      child: Scaffold(
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
                        controller: textEmailUsername,
                        cursorColor: Colors.white,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 18),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          errorText:
                              _emailValidator == '' ? null : _emailValidator,
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
                      SizedBox(height: 20),
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
                        controller: textPassword,
                        cursorColor: Colors.white,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 18),
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                            errorText:
                                _passValidator == '' ? null : _passValidator,
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
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {},
                        child: Container(
                            alignment: Alignment.bottomRight,
                            child: Text("Lupa Password ?",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16))),
                      ),
                      SizedBox(height: 50),
                      SmallButton(
                        onClick: login,
                        title: "LOGIN",
                        bgColor: Colors.white,
                        textColor: colorPrimary,
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()));
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text(
                              "REGISTER",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
