import 'package:AttendanceApp/model/model-time.dart';
import 'package:equatable/equatable.dart';

abstract class TimeEvent extends Equatable {
  const TimeEvent();

  List<Object> get props => [];
}

class InitTime extends TimeEvent {}

class UpdateTime extends TimeEvent {
  final TimeModel time;

  const UpdateTime(this.time);

  @override
  List<Object> get props => [time];

  @override
  String toString() => 'Update cu { cu: $time }';
}

class TimeSearch extends TimeEvent {
  final String query1, query2;

  const TimeSearch(this.query1, this.query2);

  @override
  List<Object> get props => [query1, query2];
}

class TimeUpdated extends TimeEvent {
  final List<TimeModel> time;
  final int counter;

  const TimeUpdated(this.time, {this.counter});

  @override
  List<Object> get props => [time, counter != null ? counter : 0];
}
