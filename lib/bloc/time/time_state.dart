import 'package:AttendanceApp/model/model-time.dart';
import 'package:equatable/equatable.dart';

abstract class TimeState extends Equatable {
  const TimeState();

  List<Object> get props => [];
}

class LoadingTime extends TimeState {}

class SuccessTime extends TimeState {
  final String dec;

  SuccessTime({this.dec});
  List<Object> get props => [dec != null ?? dec];
}

class FailedTime extends TimeState {}

class TimeFailLoad extends TimeState {
  final String msg;

  TimeFailLoad({this.msg});
  List<Object> get props => [msg != null ?? msg];
}

class TimeSuccessLoad extends TimeState {
  final List<TimeModel> time;
  final int counter;

  TimeSuccessLoad({this.time, this.counter});
  List<Object> get props => [time, counter != null ? counter : 0];
}
