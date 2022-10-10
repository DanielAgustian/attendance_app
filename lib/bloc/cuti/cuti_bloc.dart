import 'dart:async';

import 'package:AttendanceApp/bloc/cuti/cuti_event.dart';
import 'package:AttendanceApp/bloc/cuti/cuti_state.dart';
import 'package:AttendanceApp/repository/repo_cuti.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

class CutiBloc extends Bloc<CutiEvent, CutiState> {
  StreamSubscription _subscription;
  final CutiRepository _cutiRepository;

  CutiBloc({@required CutiRepository cutiRepo})
      : assert(cutiRepo != null),
        _cutiRepository = cutiRepo,
        super(LoadingCuti());

  // Bloc for get Cuti data realtime
  Stream<CutiState> mapLoadAllCuti() async* {
    yield LoadingCuti();
    var res = await _cutiRepository.countCutiEmployee();
    print("JUMLAH $res");
    _subscription?.cancel();
    _subscription = _cutiRepository
        .loadAllCuti()
        .listen((data) => add(CutiUpdated(data, counter: res)));
  }

  // Bloc for get Cuti data realtime
  Stream<CutiState> mapSearchCuti(CutiSearch event) async* {
    yield LoadingCuti();
    var res = await _cutiRepository.countCutiEmployee();
    _subscription?.cancel();
    _subscription = _cutiRepository
        .loadAllCuti(query1: event.query1, query2: event.query2)
        .listen((data) => add(CutiUpdated(data, counter: res)));
  }

  // Stream for update cuti
  Stream<CutiState> mapUpdateCuti(UpdateCuti event) async* {
    yield LoadingCuti();
    var res = await _cutiRepository.updateCuti(event.cuti);
    if (res) {
      yield SuccessCuti(dec: event.cuti.getStatus);
    } else {
      yield FailedCuti();
    }
  }

  // Streamer to handle realtime Employee flow
  Stream<CutiState> mapUpdatingCutiState(CutiUpdated event) async* {
    yield CutiSuccessLoad(cuti: event.cuti, counter: event.counter);
  }

  @override
  Stream<CutiState> mapEventToState(CutiEvent event) async* {
    if (event is InitCuti) {
      yield* mapLoadAllCuti();
    } else if (event is CutiUpdated) {
      yield* mapUpdatingCutiState(event);
    } else if (event is UpdateCuti) {
      yield* mapUpdateCuti(event);
    } else if (event is CutiSearch) {
      yield* mapSearchCuti(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
