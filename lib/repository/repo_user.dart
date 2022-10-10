import 'dart:io';

import 'package:AttendanceApp/model/model-team.dart';
import 'package:AttendanceApp/util/utility.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:AttendanceApp/model/model_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference teamCollection =
      FirebaseFirestore.instance.collection('team');
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<Model_Firestore> getEmployeeData(String idUser) async {
    var res = await collection.doc(idUser).get();
    return Model_Firestore.fromDocSnapshot(res);
  }

  Future<List<Model_Firestore>> getAllEmployeeData() async {
    var res = await collection.get();
    List<Model_Firestore> teams = [];

    if (res.docs.length != 0) {
      res.docs.forEach((value) {
        teams.add(Model_Firestore.fromSnapshot(value));
      });
    }
    return teams;
  }

  Future<String> updateRole(String idUser, role) async {
    await collection.doc(idUser).update({"role": role});
    return "Role has changed";
  }

  Future<int> getEmployeeTotal() async {
    var res = await collection.get();
    int count = 0;
    if (res.docs.length == 0) {
    } else {
      res.docs.forEach((value) {
        count++;
      });
    }
    return count;
  }

  Future<List<TeamModel>> getTeams() async {
    var res = await teamCollection.get();
    List<TeamModel> teams = [];

    if (res.docs.length != 0) {
      res.docs.forEach((value) {
        teams.add(TeamModel.fromJson(value.data()));
      });
    }
    return teams;
  }

  Future<String> uploadImage(File image) async {
    String urlRes = "";
    String imageCode = Util().randomStringNumber(10) + ".png";
    Reference fireRef = _firebaseStorage.ref().child(imageCode);

    TaskSnapshot task = await fireRef.putFile(image);
    await task.ref.getDownloadURL().then((value) {
      print(value);
      urlRes = value;
    });

    return urlRes;
  }

  Future<bool> updateImage(String id, String image) async {
    bool success = false;
    await collection
        .doc(id)
        .update({'image': image})
        .then((value) => success = true)
        .catchError((onError) => success = false);

    return success;
  }

  Future loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    var res = await collection.where("email", isEqualTo: email).get();

    if (res.docs.length == 0) {
      return "Email or phone doesn't exists";
    } else {
      if (res.docs[0]['password'] == password) {
        Model_Firestore user = Model_Firestore.fromDocSnapshot(res.docs[0]);
        prefs.setString("id", res.docs[0].id);
        return user;
      } else {
        return "Password not match";
      }
    }
  }

  //  Stream for realtime data flow
  Stream<Model_Firestore> loadUser(String id) {
    return collection.doc(id).snapshots().map((value) {
      return Model_Firestore.fromDocSnapshot(value);
    });
  }

  //  Stream for realtime all data flow
  Stream<List<Model_Firestore>> loadAllUser({String query}) {
    if (query == null || query == "") {
      return collection.snapshots().map((value) {
        return value.docs
            .map((data) => Model_Firestore.fromDocSnapshot(data))
            .toList();
      });
    } else {
      return collection.snapshots().map((value) {
        return value.docs
            .map((data) => Model_Firestore.fromDocSnapshot(data))
            .where((x) => hasFilteredContent(x, query))
            .toList();
      });
    }
  }

  bool hasFilteredContent(Model_Firestore data, String filter) {
    return data.nama.toLowerCase().contains(filter.toLowerCase()) ||
        data.team.toLowerCase().contains(filter.toLowerCase());
  }

  //  Stream for realtime all data flow
  Stream<List<Model_Firestore>> searchUser(String query) {
    return collection.snapshots().map((value) {
      return value.docs
          .map((data) => Model_Firestore.fromDocSnapshot(data))
          .toList();
    });
  }

  Future registerUser(Model_Firestore data) async {
    var resEmail = checkEmail(data.email);
    final prefs = await SharedPreferences.getInstance();

    await resEmail.then((value) async {
      if (!value) {
        await collection.add(data.toJson(data)).then((value) {
          prefs.setString("id", value.id);
          data.id = value.id;
        }).catchError((err) {
          print(err);
        });
      } else {
        data = null;
      }
    });

    return data;
  }

  Future checkEmail(String email) async {
    var res = await collection.where('email', isEqualTo: email).get();
    if (res.docs.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future updateUser(Model_Firestore user) async {
    bool success = false;
    await collection
        .doc(user.id)
        .update(user.toJson(user))
        .then((value) => success = true)
        .catchError((onError) => success = false);

    return success;
  }
}
