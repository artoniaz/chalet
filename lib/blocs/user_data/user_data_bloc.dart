import 'dart:async';
import 'package:chalet/blocs/user_data/user_data_event.dart';
import 'package:chalet/blocs/user_data/user_data_state.dart';
import 'package:chalet/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final UserDataRepository userDataRepository;

  UserDataBloc({required this.userDataRepository}) : super(UserDataStateInitial());

  StreamSubscription? userDataSubscripton;

  UserDataState get initialState => UserDataStateInitial();

  @override
  void onTransition(Transition<UserDataEvent, UserDataState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<UserDataState> mapEventToState(UserDataEvent event) async* {
    if (event is CreateUserData) {
      yield* _handleCreateUserData(event);
    }
    if (event is GetUserData) {
      yield* _handleGetUserData(event);
    }
    if (event is UpdateUserData) {
      yield* _handleUpdateUserData(event);
    }
    if (event is GetUserDataInitialState) {
      yield* _handleGetUserDataInitialState(event);
    }
  }

  Stream<UserDataState> _handleGetUserData(GetUserData event) async* {
    userDataSubscripton?.cancel();
    userDataSubscripton = userDataRepository.getUserData(event.userId).listen(
      (user) => add(UpdateUserData(user)),
      onError: (e) async* {
        yield UserDataStateError(errorMessage: 'Błąd pobierania danych użytkownika');
      },
    );
  }

  Stream<UserDataState> _handleUpdateUserData(UpdateUserData event) async* {
    yield UserDataStateLoaded(user: event.user);
  }

  Stream<UserDataState> _handleCreateUserData(CreateUserData event) async* {
    yield UserDataStateLoading();
    try {
      await userDataRepository.setUserDataOnRegister(event.userId, event.user);
      yield UserDataStateCreated();
    } catch (e) {
      yield UserDataStateError(errorMessage: e.toString());
    }
  }

  Stream<UserDataState> _handleGetUserDataInitialState(GetUserDataInitialState event) async* {
    yield UserDataStateInitial();
  }
}
