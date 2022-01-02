import 'dart:async';

import 'package:chalet/blocs/team_feed/team_feed_event.dart';
import 'package:chalet/blocs/team_feed/team_feed_state.dart';
import 'package:chalet/models/feed_info_model.dart';
import 'package:chalet/repositories/team_feed_info_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamFeedInfoBloc extends Bloc<TeamFeedInfoEvent, TeamFeedInfoState> {
  final TeamFeedInfoRepository teamFeedInfoRepository;

  TeamFeedInfoBloc({required this.teamFeedInfoRepository}) : super(TeamFeedInfoStateInitial());

  StreamSubscription? teamFeedInfoListSubscription;

  TeamFeedInfoState get initialState => TeamFeedInfoStateInitial();

  @override
  void onTransition(Transition<TeamFeedInfoEvent, TeamFeedInfoState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<TeamFeedInfoState> mapEventToState(TeamFeedInfoEvent event) async* {
    if (event is GetTeamFeedInfos) {
      yield* _handleGetTeamFeedInfos(event);
    }
    if (event is UpdateTeamFeedInfos) {
      yield* _handleUpdateTeamFeedInfos(event);
    }
    if (event is CreateTeamFeedInfo) {
      yield* _handleCreateTeamInfoFeed(event);
    }
  }

  Stream<TeamFeedInfoState> _handleGetTeamFeedInfos(GetTeamFeedInfos event) async* {
    teamFeedInfoListSubscription?.cancel();
    teamFeedInfoListSubscription = teamFeedInfoRepository.getFeedInfos(event.teamId).listen(
      (feedInfoList) => add(UpdateTeamFeedInfos(feedInfoList)),
      onError: (e) async* {
        yield TeamFeedInfoStateError(errorMessage: 'Błąd pobierania listy wydarzeń dla klanu');
      },
    );
  }

  Stream<TeamFeedInfoState> _handleUpdateTeamFeedInfos(UpdateTeamFeedInfos event) async* {
    yield TeamFeedInfoStateLoaded(feedInfoList: event.feedInfoList);
  }

  Stream<TeamFeedInfoState> _handleCreateTeamInfoFeed(CreateTeamFeedInfo event) async* {
    yield TeamFeedInfoStateLoading();
    try {
      await teamFeedInfoRepository.createTeamFeedInfo(event.feedInfo);
    } catch (e) {
      yield TeamFeedInfoStateError(errorMessage: e.toString());
    }
  }
}
