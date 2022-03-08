import 'package:chalet/blocs/send_congrats/send_congrats_event.dart';
import 'package:chalet/blocs/send_congrats/send_congrats_state.dart';
import 'package:chalet/repositories/team_feed_info_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendCongratsBloc extends Bloc<SendCongratsEvent, SendCongratsState> {
  final TeamFeedInfoRepository teamFeedInfoRepository;

  SendCongratsBloc({required this.teamFeedInfoRepository}) : super(SendCongratsStateInitial());

  SendCongratsState get initialState => SendCongratsState();

  @override
  void onTransition(Transition<SendCongratsEvent, SendCongratsState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<SendCongratsState> mapEventToState(SendCongratsEvent event) async* {
    if (event is SendCongrats) {
      yield* _handleSendCongrats(event);
    }
  }

  Stream<SendCongratsState> _handleSendCongrats(SendCongrats event) async* {
    yield SendCongratsStateLoading();
    try {
      await teamFeedInfoRepository.sendCongratsToFeed(event.feedInfo, event.congratsSender);
      yield SendCongratsStateLoaded();
    } catch (e) {
      yield SendCongratsStateError(errorMessage: e.toString());
    }
  }
}
