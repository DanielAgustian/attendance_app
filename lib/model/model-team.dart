import 'package:cloud_firestore/cloud_firestore.dart';

class TeamModel {
  String id, team;

  TeamModel({this.team});
  TeamModel.withID({this.id, this.team});

  String get getID => id;
  String get getTeam => team;

  Map<String, dynamic> toJson(TeamModel item) {
    var map = Map<String, dynamic>();
    map['team'] = item.getTeam;
    return map;
  }

  TeamModel.fromJson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.team = map['team'];
  }

  TeamModel.fromSnapshot(DocumentSnapshot map) {
    this.team = map.data()['team'];
    this.id = map.id;
  }

  TeamModel.fromQuerySnapshot(QueryDocumentSnapshot map) {
    this.team = map['team'];
    this.id = map.id;
  }
}
