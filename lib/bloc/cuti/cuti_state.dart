import 'package:AttendanceApp/model/model-cuti.dart';
import 'package:equatable/equatable.dart';

abstract class CutiState extends Equatable {
  const CutiState();

  List<Object> get props => [];
}

class LoadingCuti extends CutiState {}

class SuccessCuti extends CutiState {
  final String dec;

  SuccessCuti({this.dec});
  List<Object> get props => [dec != null ?? dec];
}

class FailedCuti extends CutiState {}

class CutiFailLoad extends CutiState {
  final String msg;

  CutiFailLoad({this.msg});
  List<Object> get props => [msg != null ?? msg];
}

class CutiSuccessLoad extends CutiState {
  final List<CutiModel> cuti;
  final int counter;

  CutiSuccessLoad({this.cuti, this.counter});
  List<Object> get props =>
      [cuti != null ?? cuti, counter != null ? counter : 0];
}
