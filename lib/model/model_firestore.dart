import 'package:cloud_firestore/cloud_firestore.dart'; 

class Model_Firestore {
  String id;
  final String nama;
  final String password;
  final String idUsaha;

  String hp, email, role, image, team;

  Model_Firestore(
      {this.id,
      this.nama,
      this.password,
      this.idUsaha,
      this.hp,
      this.email,
      this.role,
      this.image,
      this.team});

  void setImage(String image) {
    this.image = image;
  }

  Model_Firestore.fromSnapshot(QueryDocumentSnapshot snapshot)
      : id = snapshot.id,
        nama = snapshot["nama"],
        password = snapshot["password"],
        idUsaha = snapshot["idUsaha"],
        hp = snapshot["hp"],
        email = snapshot["email"],
        role = snapshot["role"],
        image = snapshot["image"],
        team = snapshot["team"];

  Model_Firestore.fromDocSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        nama = snapshot.data()["nama"],
        password = snapshot.data()["password"],
        idUsaha = snapshot.data()["idUsaha"],
        hp = snapshot.data()["hp"],
        email = snapshot.data()["email"],
        role = snapshot.data()["role"],
        team = snapshot.data()["team"],
        image = snapshot.data()["image"];

  // Convert a Note object into a Map object
  Map<String, dynamic> toJson(Model_Firestore data) {
    var map = Map<String, dynamic>();
    map['nama'] = data.nama;
    map['email'] = data.email;
    map['password'] = data.password;
    map['hp'] = data.hp;
    map['idUsaha'] = data.idUsaha;
    map['role'] = data.role;
    map['image'] = data.image;
    map['team'] = data.team;

    return map;
  }
}
