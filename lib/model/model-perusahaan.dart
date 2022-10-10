import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyModel {
  final String id;
  final String nama;
  final String password;
  final String email;
  final String kode;

  CompanyModel({this.id, this.nama, this.password, this.email, this.kode});

  CompanyModel.fromSnapshot(QueryDocumentSnapshot snapshot)
      : id = snapshot.id,
        nama = snapshot["namaUsaha"],
        password = snapshot["password"],
        email = snapshot["email"],
        kode = snapshot["kodeUsaha"];
  CompanyModel.fromDocSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        nama = snapshot.data()["namaUsaha"],
        password = snapshot.data()["password"],
        email = snapshot.data()["email"],
        kode = snapshot.data()["KodeUsaha"];
  toJson() {
    return {
      "idCompany": id,
      "namaUsaha": nama,
      "password": password,
      "email": email,
      "kodeUsaha": kode
    };
  }
}
