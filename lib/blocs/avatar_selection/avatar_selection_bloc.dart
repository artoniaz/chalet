import 'dart:async';

import 'package:chalet/blocs/avatar_selection/avatar_selection_event.dart';
import 'package:chalet/blocs/avatar_selection/avatar_selection_state.dart';
import 'package:chalet/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AvatarSelectionBloc extends Bloc<AvatarSelectionEvent, AvatarSelectionState> {
  final UserDataRepository userDataRepository;

  AvatarSelectionBloc({
    required this.userDataRepository,
  }) : super(AvatarSelectionStateInitial());

  StreamSubscription? userDataSubscripton;

  AvatarSelectionState get initialState => AvatarSelectionStateInitial();

  @override
  void onTransition(Transition<AvatarSelectionEvent, AvatarSelectionState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<AvatarSelectionState> mapEventToState(AvatarSelectionEvent event) async* {
    if (event is UpdateUserAvatarId) {
      yield* _handleUpdateUserAvatarId(event);
    }
  }

  Stream<AvatarSelectionState> _handleUpdateUserAvatarId(UpdateUserAvatarId event) async* {
    yield AvatarSelectionStateLoading();
    try {
      await userDataRepository.updateUserAvatarId(event.userId, event.avatarId);
      yield AvatarSelectionStateUpdated();
      yield AvatarSelectionStateInitial();
    } catch (e) {
      yield AvatarSelectionStateError(errorMessage: e.toString());
    }
  }
}
