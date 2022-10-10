import 'package:AttendanceApp/model/model-cuti.dart';
import 'package:equatable/equatable.dart';

abstract class UserCutiEvent extends Equatable {
  const UserCutiEvent();

  List<Object> get props => [];
}

class InitCutiUser extends UserCutiEvent {

}

class UpdateCutiUser extends UserCutiEvent {
  final CutiModel cuti;

  const UpdateCutiUser(this.cuti);

  @override
  List<Object> get props => [cuti];

  @override
  String toString() => 'Update cu { cu: $cuti }';
}

class AddCutiUser extends UserCutiEvent {
  final CutiModel cuti;

  const AddCutiUser(this.cuti);

  @override
  List<Object> get props => [cuti];

  @override
  String toString() => 'Update cu { cu: $cuti }';
}

class UserCutiSearch extends UserCutiEvent {
  final String query1, query2, id;

  const UserCutiSearch(this.query1, this.query2, this.id);

  @override
  List<Object> get props => [query1, query2, id];
}

class UserCutiUpdated extends UserCutiEvent {
  final List<CutiModel> cuti;

  const UserCutiUpdated(this.cuti);

  @override
  List<Object> get props => [cuti];
}
