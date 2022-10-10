import 'package:AttendanceApp/model/model_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  List<Object> get props => [];
}

class LoadingEmployee extends EmployeeState {}

class SuccessEmployee extends EmployeeState {}
class FailedEmployee extends EmployeeState {}

class EmployeeFailLoad extends EmployeeState {
  final String msg;

  EmployeeFailLoad({this.msg});
  List<Object> get props => [msg != null ?? msg];
}

class EmployeeSuccessLoad extends EmployeeState {
  final List<Model_Firestore> employee;

  EmployeeSuccessLoad({this.employee});
  List<Object> get props => [employee != null ?? employee];
}


