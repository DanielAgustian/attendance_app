import 'dart:async';

import 'package:AttendanceApp/bloc/user/cuti_event.dart';
import 'package:AttendanceApp/bloc/user/cuti_state.dart';
import 'package:AttendanceApp/repository/repo_cuti.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCutiBloc extends Bloc<UserCutiEvent, UserCutiState> {
  StreamSubscription _subscription;
  final CutiRepository _cutiRepository;

  UserCutiBloc({@required CutiRepository cutiRepo})
      : assert(cutiRepo != null),
        _cutiRepository = cutiRepo,
        super(LoadingCutiUser());

  // Bloc for get Cuti data realtime
  Stream<UserCutiState> mapLoadAllCuti() async* {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("id");
    yield LoadingCutiUser();
    _subscription?.cancel();
    _subscription = _cutiRepository
        .loadAllUserCuti(id: id)
        .listen((data) => add(UserCutiUpdated(data)));
  }

  // Bloc for get Cuti data realtime
  Stream<UserCutiState> mapSearchCuti(UserCutiSearch event) async* {
    yield LoadingCutiUser();
    _subscription?.cancel();
    _subscription = _cutiRepository
        .loadAllUserCuti(
            query1: event.query1, query2: event.query2, id: event.id)
        .listen((data) => add(UserCutiUpdated(data)));
  }

  // Stream for update cuti
  Stream<UserCutiState> mapUpdateCuti(UpdateCutiUser event) async* {
    yield LoadingCutiUser();
    var res = await _cutiRepository.updateCuti(event.cuti);
    if (res) {
      yield UserSuccessCuti(dec: event.cuti.getStatus);
    } else {
      yield UserFailedCuti();
    }
  }

  // Stream for update cuti
  Stream<UserCutiState> mapAddCuti(AddCutiUser event) async* {
    yield LoadingCutiUser();
    var res = await _cutiRepository.addCutiPermission(event.cuti);
    if (res) {
      yield UserSuccessCuti(dec: event.cuti.getStatus);
    } else {
      yield UserFailedCuti();
    }
  }

  // Streamer to handle realtime Employee flow
  Stream<UserCutiState> mapUpdatingCutiState(UserCutiUpdated event) async* {
    yield UserCutiSuccessLoad(cuti: event.cuti);
  }

  @override
  Stream<UserCutiState> mapEventToState(UserCutiEvent event) async* {
    if (event is InitCutiUser) {
      yield* mapLoadAllCuti();
    } else if (event is UserCutiUpdated) {
      yield* mapUpdatingCutiState(event);
    } else if (event is UpdateCutiUser) {
      yield* mapUpdateCuti(event);
    } else if (event is UserCutiSearch) {
      yield* mapSearchCuti(event);
    } else if (event is AddCutiUser) {
      yield* mapAddCuti(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
