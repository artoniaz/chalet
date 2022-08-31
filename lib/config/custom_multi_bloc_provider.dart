import 'package:Challet/blocs/add_chalet/add_chalet_bloc.dart';
import 'package:Challet/blocs/add_review/add_review_bloc.dart';
import 'package:Challet/blocs/avatar_selection/avatar_selection_bloc.dart';
import 'package:Challet/blocs/chalet_icon/chalet_icon_bloc.dart';
import 'package:Challet/blocs/create_team/create_team_bloc.dart';
import 'package:Challet/blocs/damaging_model/damaging_model_bloc.dart';
import 'package:Challet/blocs/delete_team_member/delete_team_member_bloc.dart';
import 'package:Challet/blocs/geolocation/geolocation_bloc.dart';
import 'package:Challet/blocs/get_chalets_bloc/get_chalets_bloc.dart';
import 'package:Challet/blocs/pending_invitations_teams/pending_invitations_teams_bloc.dart';
import 'package:Challet/blocs/pending_members/pending_members_bloc.dart';
import 'package:Challet/blocs/problem/problem_bloc.dart';
import 'package:Challet/blocs/review/review_bloc.dart';
import 'package:Challet/blocs/send_congrats/send_congrats_bloc.dart';
import 'package:Challet/blocs/social_map_chalet_list/social_map_chalet_list_bloc.dart';
import 'package:Challet/blocs/team/team_bloc.dart';
import 'package:Challet/blocs/team_feed/team_feed_bloc.dart';
import 'package:Challet/blocs/team_member/team_member_bloc.dart';
import 'package:Challet/blocs/team_members/team_members_bloc.dart';
import 'package:Challet/blocs/user_data/user_data_bloc.dart';
import 'package:Challet/blocs/validate_quick_review/validate_quick_review_bloc.dart';
import 'package:Challet/repositories/chalet_icon_repository.dart';
import 'package:Challet/repositories/chalet_repository.dart';
import 'package:Challet/repositories/geolocation_repository.dart';
import 'package:Challet/repositories/problem_repository.dart';
import 'package:Challet/repositories/review_repository.dart';
import 'package:Challet/repositories/storage_repository.dart';
import 'package:Challet/repositories/team_feed_info_repository.dart';
import 'package:Challet/repositories/team_repository.dart';
import 'package:Challet/repositories/user_data_repository.dart';
import 'package:Challet/services/review_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CustomMultiBlocProvider extends StatelessWidget {
  final Widget child;
  const CustomMultiBlocProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<ProblemBloc>(
        create: (context) => ProblemBloc(problemRepository: ProblemRepository()),
      ),
      BlocProvider<GeolocationBloc>(
        create: (context) => GeolocationBloc(geolocationRepository: GeolocationRepository()),
      ),
      BlocProvider<TeamFeedInfoBloc>(
          create: (context) => TeamFeedInfoBloc(
                teamFeedInfoRepository: TeamFeedInfoRepository(),
              )),
      BlocProvider<UserDataBloc>(
        create: (context) => UserDataBloc(
          userDataRepository: UserDataRepository(),
        ),
      ),
      BlocProvider<TeamBloc>(
        create: (context) => TeamBloc(
          teamRepository: TeamRepository(),
          userDataRepository: UserDataRepository(),
        ),
      ),
      BlocProvider<TeamMemberBloc>(
        create: (context) => TeamMemberBloc(
          userDataRepository: UserDataRepository(),
        ),
      ),
      BlocProvider<TeamMembersBloc>(
        create: (context) => TeamMembersBloc(
          teamRepository: TeamRepository(),
          teamBloc: Provider.of<TeamBloc>(context, listen: false),
        ),
      ),
      BlocProvider<SendCongratsBloc>(
        create: (context) => SendCongratsBloc(
          teamFeedInfoRepository: TeamFeedInfoRepository(),
        ),
      ),
      BlocProvider<PendingTeamMembersBloc>(
        create: (context) => PendingTeamMembersBloc(
          teamRepository: TeamRepository(),
          userDataRepository: UserDataRepository(),
        ),
      ),
      BlocProvider<DeleteTeamMemberBloc>(
        create: (context) => DeleteTeamMemberBloc(
          teamRepository: TeamRepository(),
          teamMembersBloc: BlocProvider.of<TeamMembersBloc>(context),
          userDataRepository: UserDataRepository(),
        ),
      ),
      BlocProvider<PendingInvitationsTeamsBloc>(
        create: (context) => PendingInvitationsTeamsBloc(
          teamRepository: TeamRepository(),
        ),
      ),
      BlocProvider<ChaletListForSocialMapBloc>(
        create: (context) => ChaletListForSocialMapBloc(
          chaletRepository: ChaletRepository(),
          teamMembersBloc: BlocProvider.of<TeamMembersBloc>(context),
        ),
      ),
      BlocProvider<CreateTeamBloc>(
        create: (context) => CreateTeamBloc(
          teamRepository: TeamRepository(),
          userDataRepository: UserDataRepository(),
        ),
      ),
      BlocProvider<GetChaletsBloc>(
        create: (context) => GetChaletsBloc(
          chaletRepository: ChaletRepository(),
        ),
      ),
      BlocProvider<ChaletIconBloc>(
        create: (context) => ChaletIconBloc(
          chaletIconRepository: ChaletIconRepository(),
        ),
      ),
      BlocProvider<DamagingDeviceModelBloc>(
        create: (context) => DamagingDeviceModelBloc(),
      ),
      BlocProvider<ReviewBloc>(
        create: (context) => ReviewBloc(reviewRepository: ReviewRepository()),
        lazy: false,
      ),
      BlocProvider<AddReviewBloc>(
        create: (context) => AddReviewBloc(
          reviewRepository: ReviewService(),
          teamFeedInfoBloc: BlocProvider.of<TeamFeedInfoBloc>(context),
          reviewBloc: BlocProvider.of<ReviewBloc>(context),
        ),
      ),
      BlocProvider<ValidateQuickReviewBloc>(
        create: (context) => ValidateQuickReviewBloc(addReviewBloc: BlocProvider.of<AddReviewBloc>(context)),
      ),
      BlocProvider<AddChaletBloc>(
        create: (context) => AddChaletBloc(
          chaletRepository: ChaletRepository(),
          storageRepository: StorageRepository(),
          teamFeedInfoBloc: BlocProvider.of<TeamFeedInfoBloc>(context),
        ),
      ),
      BlocProvider<AvatarSelectionBloc>(
        create: (context) => AvatarSelectionBloc(
          userDataRepository: UserDataRepository(),
        ),
      ),
    ], child: child);
  }
}
