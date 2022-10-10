import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AttendanceApp/model/model-perusahaan.dart';
import 'dart:math';

class CompanyRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('company');
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  Future<CompanyModel> getCompanyData(String idComp) async {
    var res = await collection.doc(idComp).get();
    return CompanyModel.fromDocSnapshot(res);
  }

  Future<String> updateCode(String idComp, kode) async {
    await collection.doc(idComp).update({"KodeUsaha": kode});
    return kode;
  }

  Future<String> registerCompany(String namaUsaha, password, email) async {
    String idUsaha = getRandomString(5);
    String kodeUsaha = getRandomString(5);
    await collection.doc(idUsaha).set({
      'namaUsaha': namaUsaha,
      'email': email,
      'password': password,
      'KodeUsaha': kodeUsaha
    });
    return idUsaha;
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
