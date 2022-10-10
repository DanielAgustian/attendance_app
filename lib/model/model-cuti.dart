import 'package:cloud_firestore/cloud_firestore.dart';

class CutiModel {
  String idUser, idUsaha, nama, mulai, selesai, id, status, alasan;

  CutiModel(
      {this.idUser,
      this.idUsaha,
      this.nama,
      this.mulai,
      this.selesai,
      this.alasan,
      this.status});
  CutiModel.withID(
      {this.id,
      this.idUser,
      this.idUsaha,
      this.nama,
      this.alasan,
      this.mulai,
      this.selesai,
      this.status});

  String get getID => id;
  String get getIDUser => idUser;
  String get getNama => nama;
  String get getMulai => mulai;
  String get getSelesai => selesai;
  String get getAlasan => alasan;
  String get getStatus => status;
  String get getPerusahaan => idUsaha;

  Map<String, dynamic> toJson(CutiModel item) {
    var map = Map<String, dynamic>();
    map['nama'] = item.getNama;
    map['idUser'] = item.getIDUser;
    map['mulai'] = item.getMulai;
    map['selesai'] = item.getSelesai;
    map['alasan'] = item.getAlasan;
    map['status'] = item.getStatus;
    map['status'] = item.getStatus;
    map['idUsaha'] = item.getPerusahaan;
    return map;
  }

  CutiModel.fromJson(Map<String, dynamic> map) {
    this.idUser = map['idUser'];
    this.nama = map['nama'];
    this.alasan = map['alasan'];
    this.mulai = map['mulai'];
    this.selesai = map['selesai'];
    this.status = map['status'];
    this.idUsaha = map['idUsaha'];
  }

  CutiModel.fromSnapshot(DocumentSnapshot map) {
    this.idUser = map.data()['idUser'];
    this.nama = map.data()['nama'];
    this.alasan = map.data()['alasan'];
    this.mulai = map.data()['mulai'];
    this.selesai = map.data()['selesai'];
    this.status = map.data()['status'];
    this.idUsaha = map.data()['idUsaha'];
    this.id = map.id;
  }
}
