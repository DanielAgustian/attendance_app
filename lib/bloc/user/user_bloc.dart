import 'dart:async';

import 'package:AttendanceApp/bloc/user/user_event.dart';
import 'package:AttendanceApp/bloc/user/user_state.dart';
import 'package:AttendanceApp/model/model_firestore.dart';
import 'package:AttendanceApp/repository/repo_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  StreamSubscription _subscription;
  final UserRepository _userRepository;

  UserBloc({@required UserRepository userRepo})
      : assert(userRepo != null),
        _userRepository = userRepo,
        super(LoadingUser());

  // Bloc for login user
  Stream<UserState> mapLogin(LoginUser event) async* {
    var res = await _userRepository.loginUser(event.email, event.password);
    yield LoadingUser();
    if (res is Model_Firestore) {
      _subscription?.cancel();
      _subscription = _userRepository
          .loadUser(res.id)
          .listen((data) => add(UserUpdated(data)));
      yield UserSuccess(user: res);
    } else {
      yield UserFail(msg: res);
    }
  }

  // Bloc for register user
  Stream<UserState> mapRegister(RegisterUser event) async* {
    yield LoadingUser();
    var res = await _userRepository.registerUser(event.user);
    if (res == null) {
      yield UserFail(msg: "");
    } else {
      _subscription?.cancel();
      _subscription = _userRepository
          .loadUser(res)
          .listen((data) => add(UserUpdated(data)));
      yield UserSuccess(user: res);
    }
  }

  // Bloc for get user data realtime
  Stream<UserState> mapLoadUser() async* {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("id");
    yield LoadingUser();
    _subscription?.cancel();
    _subscription =
        _userRepository.loadUser(id).listen((data) => add(UserUpdated(data)));
  }

  // Bloc for get user data realtime
  Stream<UserState> mapLoadAllUser() async* {
    yield LoadingUser();
    _subscription?.cancel();
    _subscription =
        _userRepository.loadAllUser().listen((data) => add(LoadAllUser(data)));
  }

  // Bloc for update user
  Stream<UserState> mapUpdateUser(UpdateUser event) async* {
    yield LoadingUser();
    var res = await _userRepository.updateUser(event.user);
    if (res) {
      yield UserSuccessLoad(user: event.user, dec: res);
    } else {
      yield UserFail();
    }
  }

  // Bloc for upload image file
  Stream<UserState> mapUpdateImage(UpdateImage event) async* {
    var res = await _userRepository.uploadImage(event.image);
    if (res != "") {
      yield ImageSuccess(res);
    } else {
      yield ImageFail();
    }
  }

  // Streamer to handle realtime user flow
  Stream<UserState> mapUpdatingUserState(UserUpdated event) async* {
    yield UserSuccessLoad(user: event.user);
  }

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is LoadUser) {
      yield* mapLoadUser();
    } else if (event is LoginUser) {
      yield* mapLogin(event);
    } else if (event is RegisterUser) {
      yield* mapRegister(event);
    } else if (event is UpdateImage) {
      yield* mapUpdateImage(event);
    } else if (event is UpdateUser) {
      yield* mapUpdateUser(event);
    } else if (event is UserUpdated) {
      yield* mapUpdatingUserState(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
