import 'dart:io';

import 'package:AttendanceApp/model/model_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  List<Object> get props => [];
}

class InitUser extends UserEvent {}

class LoadUser extends UserEvent {}

class LoadAllUser extends UserEvent {
  final List<Model_Firestore> employees;

  const LoadAllUser(this.employees);

  @override
  List<Object> get props => [employees];
}

class UpdateUser extends UserEvent {
  final Model_Firestore user;

  const UpdateUser(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Update User { User: $user }';
}

class UpdateImage extends UserEvent {
  final File image;

  const UpdateImage(this.image);

  @override
  List<Object> get props => [image];

  @override
  String toString() => 'Update Image { image : ${image.path} }';
}

class RegisterUser extends UserEvent {
  final Model_Firestore user;
  const RegisterUser(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Register user { user: $user }';
}

class LoginUser extends UserEvent {
  final String email, password;
  const LoginUser(this.email, this.password);

  @override
  List<Object> get props => [email, password];

  @override
  String toString() =>
      'Register user { Email / Phone: $email, Password : $password }';
}

class UserUpdated extends UserEvent {
  final Model_Firestore user;

  const UserUpdated(this.user);

  @override
  List<Object> get props => [user];
}
