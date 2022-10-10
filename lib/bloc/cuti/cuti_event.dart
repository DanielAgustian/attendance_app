import 'package:AttendanceApp/model/model-cuti.dart';
import 'package:equatable/equatable.dart';

abstract class CutiEvent extends Equatable {
  const CutiEvent();

  List<Object> get props => [];
}

class InitCuti extends CutiEvent {}

class UpdateCuti extends CutiEvent {
  final CutiModel cuti;

  const UpdateCuti(this.cuti);

  @override
  List<Object> get props => [cuti];

  @override
  String toString() => 'Update cu { cu: $cuti }';
}

class CutiSearch extends CutiEvent {
  final String query1, query2;

  const CutiSearch(this.query1, this.query2);

  @override
  List<Object> get props => [query1, query2];
}

class CutiUpdated extends CutiEvent {
  final List<CutiModel> cuti;
final int counter;

  const CutiUpdated(this.cuti, {this.counter});

  @override
  List<Object> get props => [cuti,counter != null ? counter : 0];
}
