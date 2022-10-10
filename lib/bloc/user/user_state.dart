import 'package:AttendanceApp/model/model_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();

  List<Object> get props => [];
}

class LoadingUser extends UserState {}

class UserFail extends UserState {
  final String msg;

  UserFail({this.msg});
  List<Object> get props => [msg != null ?? msg];
}

class UserSuccess extends UserState {
  final Model_Firestore user;

  UserSuccess({this.user});
  List<Object> get props => [user];
}

class ImageSuccess extends UserState {
  final String imgURL;

  ImageSuccess(this.imgURL);
  List<Object> get props => [imgURL];
}

class ImageFail extends UserState {}

class UserSuccessLoad extends UserState {
  final Model_Firestore user;
  final bool dec;

  UserSuccessLoad({this.user, this.dec});

  List<Object> get props => [user, dec];

  @override
  String toString() {
    return 'Data : { Profile List: $user }';
  }
}

class AllUserSuccessLoad extends UserState {
  final List<Model_Firestore> profileList;

  AllUserSuccessLoad(this.profileList);

  List<Object> get props => [profileList];

  @override
  String toString() {
    return 'Data : { Profile List: $profileList }';
  }
}
