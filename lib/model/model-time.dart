import 'package:cloud_firestore/cloud_firestore.dart';

class TimeModel {
  String day, idUser, nama, pergi, pulang, id, status;

  TimeModel(
      this.day, this.idUser, this.nama, this.pergi, this.pulang, this.status);
  TimeModel.withID(this.id, this.day, this.idUser, this.nama, this.pergi,
      this.pulang, this.status);

  String get getID => id;
  String get getDay => day;
  String get getIDUser => idUser;
  String get getNama => nama;
  String get getPergi => pergi;
  String get getPulang => pulang;
  String get getStatus => status;

  Map<String, dynamic> toJson(TimeModel item) {
    var map = Map<String, dynamic>();
    map['nama'] = item.getNama;
    map['idUser'] = item.getIDUser;
    map['day'] = item.getDay;
    map['pergi'] = item.getPergi;
    map['pulang'] = item.getPulang;
    map['status'] = item.getStatus;
    return map;
  }

  TimeModel.fromJson(Map<String, dynamic> map) {
    this.idUser = map['idUser'];
    this.nama = map['nama'];
    this.day = map['day'];
    this.pergi = map['pergi'];
    this.pulang = map['pulang'];
    this.status = map['status'];
  }

  TimeModel.fromSnapshot(DocumentSnapshot map) {
    this.idUser = map.data()['idUser'];
    this.nama = map.data()['nama'];
    this.day = map.data()['day'];
    this.pergi = map.data()['pergi'];
    this.pulang = map.data()['pulang'];
    this.status = map.data()['status'];
  }

  TimeModel.fromQuerySnapshot(DocumentSnapshot map) {
    this.idUser = map['idUser'];
    this.nama = map['nama'];
    this.day = map['day'];
    this.pergi = map['pergi'];
    this.pulang = map['pulang'];
    this.status = map['status'];
  }
}
