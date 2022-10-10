import 'dart:async';

import 'package:AttendanceApp/bloc/employee/employee_event.dart';
import 'package:AttendanceApp/bloc/employee/employee_state.dart'; 
import 'package:AttendanceApp/repository/repo_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  StreamSubscription _subscription;
  final UserRepository _employeeRepository;

  EmployeeBloc({@required UserRepository employeeRepo})
      : assert(employeeRepo != null),
        _employeeRepository = employeeRepo,
        super(LoadingEmployee());

  // Bloc for get Employee data realtime
  Stream<EmployeeState> mapLoadAllEmployee() async* {
    yield LoadingEmployee();
    _subscription?.cancel();
    _subscription = _employeeRepository
        .loadAllUser()
        .listen((data) => add(EmployeeUpdated(data)));
  }

  // Bloc for get Employee data realtime
  Stream<EmployeeState> mapSearchUser(EmployeeSearch e) async* {
    yield LoadingEmployee();
    _subscription?.cancel();
    _subscription = _employeeRepository
        .loadAllUser(query: e.query)
        .listen((data) => add(EmployeeUpdated(data)));
  }

  // Bloc for update employee
  Stream<EmployeeState> mapUpdateEmployee(UpdateEmployee event) async* {
    yield LoadingEmployee();
    var res = await _employeeRepository.updateUser(event.employee);
    if (res) {
      yield SuccessEmployee();
    } else {
      yield FailedEmployee();
    }
  }
  
  // Streamer to handle realtime Employee flow
  Stream<EmployeeState> mapUpdatingEmployeeState(EmployeeUpdated event) async* {
    yield EmployeeSuccessLoad(employee: event.employee);
  }


  @override
  Stream<EmployeeState> mapEventToState(EmployeeEvent event) async* {
    if (event is InitEmployee) {
      yield* mapLoadAllEmployee();
    } else if (event is EmployeeUpdated) {
      yield* mapUpdatingEmployeeState(event);
    } else if (event is EmployeeSearch) {
      yield* mapSearchUser(event);
    }else if (event is UpdateEmployee) {
      yield* mapUpdateEmployee(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
