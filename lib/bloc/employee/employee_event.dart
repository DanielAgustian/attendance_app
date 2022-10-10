
import 'package:AttendanceApp/model/model_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  List<Object> get props => [];
}

class InitEmployee extends EmployeeEvent {}

class UpdateEmployee extends EmployeeEvent {
  final Model_Firestore employee;

  const UpdateEmployee(this.employee);

  @override
  List<Object> get props => [employee];
}

class EmployeeSearch extends EmployeeEvent {
  final String query;

  const EmployeeSearch(this.query);

  @override
  List<Object> get props => [query];
}

class EmployeeUpdated extends EmployeeEvent {
  final List<Model_Firestore> employee;

  const EmployeeUpdated(this.employee);

  @override
  List<Object> get props => [employee];
}
