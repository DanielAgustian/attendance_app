import 'package:firebase_database/firebase_database.dart';

class Model {
  final String id;
  final String nama;
  final String password;
  final String idUsaha;
  final String pergi;
  final String pulang;
  final String hp, email,role;

  Model({
    this.id,
    this.nama,
    this.password,
    this.idUsaha,
    this.pergi,
    this.pulang,
    this.hp,
    this.email,
    this.role,
  });

  Model.fromSnapshot(DataSnapshot snapshot) :
    id = snapshot.key ,
    nama = snapshot.value["nama"],
    password = snapshot.value["password"],
    idUsaha = snapshot.value["idUsaha"],
    pergi = snapshot.value["pergi"],
    pulang = snapshot.value["pulang"],
    hp = snapshot.value["hp"],
    email = snapshot.value["email"],
    role = snapshot.value["role"];

  toJson() {
    return {
      "id": id,
      "nama": nama,
      "password": password,
      "idUsaha" : idUsaha,
      "pergi": pergi,
      "pulang": pulang,
      "hp": hp,
      "email":email,
      "role":role
    };
  }
}