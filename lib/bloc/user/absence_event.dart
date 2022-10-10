import 'package:AttendanceApp/model/model-time.dart';
import 'package:equatable/equatable.dart';

abstract class UserAbsenceEvent extends Equatable {
  const UserAbsenceEvent();

  List<Object> get props => [];
}

class UserInitAbsence extends UserAbsenceEvent {

}

class UserUpdateAbsence extends UserAbsenceEvent {
  final TimeModel absence;

  const UserUpdateAbsence(this.absence);

  @override
  List<Object> get props => [absence];

  @override
  String toString() => 'Update cu { cu: $absence }';
}

class AbsenceSearch extends UserAbsenceEvent {
  final String query1, query2, id;

  const AbsenceSearch(this.query1, this.query2, this.id);

  @override
  List<Object> get props => [query1, query2, id];
}

class AbsenceUpdated extends UserAbsenceEvent {
  final List<TimeModel> absence;

  const AbsenceUpdated(this.absence);

  @override
  List<Object> get props => [absence];
}
