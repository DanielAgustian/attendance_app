import 'dart:async';
import 'package:AttendanceApp/bloc/user/absence_event.dart';
import 'package:AttendanceApp/bloc/user/absence_state.dart';
import 'package:AttendanceApp/repository/repo_absen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAbsenceBloc extends Bloc<UserAbsenceEvent, UserAbsenceState> {
  StreamSubscription _subscription;
  final AbsensiRepository _timeRepository;

  UserAbsenceBloc({@required AbsensiRepository absenRepo})
      : assert(absenRepo != null),
        _timeRepository = absenRepo,
        super(UserLoadingAbsence());

  // Bloc for get Cuti data realtime
  Stream<UserAbsenceState> mapLoadAllAbsence() async* {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("id");

    yield UserLoadingAbsence();
    _subscription?.cancel();
    _subscription = _timeRepository
        .loadAllAbsence(id: id)
        .listen((data) => add(AbsenceUpdated(data)));
  }

  // Bloc for search absence data realtime
  Stream<UserAbsenceState> mapSearchAbsence(AbsenceSearch event) async* {
    yield UserLoadingAbsence();
    _subscription?.cancel();
    _subscription = _timeRepository
        .loadAllAbsence(
            query1: event.query1, query2: event.query2, id: event.id)
        .listen((data) => add(AbsenceUpdated(data)));
  }

  // Streamer to handle realtime Employee flow
  Stream<UserAbsenceState> mapUpdatingTimeState(AbsenceUpdated event) async* {
    yield AbsenceSuccessLoad(absence: event.absence);
  }

  @override
  Stream<UserAbsenceState> mapEventToState(UserAbsenceEvent event) async* {
    if (event is UserInitAbsence) {
      yield* mapLoadAllAbsence();
    } else if (event is AbsenceUpdated) {
      yield* mapUpdatingTimeState(event);
    } else if (event is AbsenceSearch) {
      yield* mapSearchAbsence(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
