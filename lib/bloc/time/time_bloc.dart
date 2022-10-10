import 'dart:async';

import 'package:AttendanceApp/bloc/time/time_event.dart';
import 'package:AttendanceApp/bloc/time/time_state.dart';
import 'package:AttendanceApp/repository/repo_absen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

class TimeBloc extends Bloc<TimeEvent, TimeState> {
  StreamSubscription _subscription;
  final AbsensiRepository _timeRepository;

  TimeBloc({@required AbsensiRepository absenRepo})
      : assert(absenRepo != null),
        _timeRepository = absenRepo,
        super(LoadingTime());

  // Bloc for get Cuti data realtime
  Stream<TimeState> mapLoadAllAbsence() async* {
    yield LoadingTime();
    var res = await _timeRepository.countActiveEmployee();
    // yield TimeSuccessLoad(counter: res);
    _subscription?.cancel();
    _subscription = _timeRepository
        .loadAllAbsence()
        .listen((data) => add(TimeUpdated(data, counter: res)));
  }

  // Bloc for get Cuti data realtime
  Stream<TimeState> mapSearchAbsence(TimeSearch event) async* {
    yield LoadingTime();
    var res = await _timeRepository.countActiveEmployee();
    _subscription?.cancel();
    _subscription = _timeRepository
        .loadAllAbsence(query1: event.query1, query2: event.query2)
        .listen((data) => add(TimeUpdated(data, counter: res)));
  }

  // Streamer to handle realtime Employee flow
  Stream<TimeState> mapUpdatingTimeState(TimeUpdated event) async* {
    yield TimeSuccessLoad(time: event.time, counter: event.counter);
  }

  @override
  Stream<TimeState> mapEventToState(TimeEvent event) async* {
    if (event is InitTime) {
      yield* mapLoadAllAbsence();
    } else if (event is TimeUpdated) {
      yield* mapUpdatingTimeState(event);
    } else if (event is TimeSearch) {
      yield* mapSearchAbsence(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
