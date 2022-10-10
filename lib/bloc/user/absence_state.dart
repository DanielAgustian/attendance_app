import 'package:AttendanceApp/model/model-time.dart';
import 'package:equatable/equatable.dart';

abstract class UserAbsenceState extends Equatable {
  const UserAbsenceState();

  List<Object> get props => [];
}

class UserLoadingAbsence extends UserAbsenceState {}

class UserSuccessAbsence extends UserAbsenceState {
  final String dec;

  UserSuccessAbsence({this.dec});
  List<Object> get props => [dec != null ?? dec];
}

class FailedAbsence extends UserAbsenceState {}

class AbsenceFailLoad extends UserAbsenceState {
  final String msg;

  AbsenceFailLoad({this.msg});
  List<Object> get props => [msg != null ?? msg];
}

class AbsenceSuccessLoad extends UserAbsenceState {
  final List<TimeModel> absence;

  AbsenceSuccessLoad({this.absence});
  List<Object> get props => [absence != null ?? absence];
}
