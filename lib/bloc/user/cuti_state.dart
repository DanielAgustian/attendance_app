import 'package:AttendanceApp/model/model-cuti.dart';
import 'package:equatable/equatable.dart';

abstract class UserCutiState extends Equatable {
  const UserCutiState();

  List<Object> get props => [];
}

class LoadingCutiUser extends UserCutiState {}

class UserSuccessCuti extends UserCutiState {
  final String dec;

  UserSuccessCuti({this.dec});
  List<Object> get props => [dec != null ?? dec];
}

class UserFailedCuti extends UserCutiState {}

class UserCutiFailLoad extends UserCutiState {
  final String msg;

  UserCutiFailLoad({this.msg});
  List<Object> get props => [msg != null ?? msg];
}

class UserCutiSuccessLoad extends UserCutiState {
  final List<CutiModel> cuti;

  UserCutiSuccessLoad({this.cuti});
  List<Object> get props => [cuti != null ?? cuti];
}
