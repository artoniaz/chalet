import 'package:chalet/blocs/add_chalet/add_chalet_bloc.dart';
import 'package:chalet/blocs/add_review/add_review_bloc.dart';
import 'package:chalet/blocs/geolocation/geolocation_bloc.dart';
import 'package:chalet/blocs/problem/problem_bloc.dart';
import 'package:chalet/blocs/send_congrats/send_congrats_bloc.dart';
import 'package:chalet/blocs/team/team_bloc.dart';
import 'package:chalet/blocs/team_feed/team_feed_bloc.dart';
import 'package:chalet/blocs/team_feed/team_feed_event.dart';
import 'package:chalet/blocs/team_member/team_member_bloc.dart';
import 'package:chalet/blocs/team_members/team_members_bloc.dart';
import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/config/index.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/repositories/chalet_repository.dart';
import 'package:chalet/repositories/geolocation_repository.dart';
import 'package:chalet/repositories/problem_repository.dart';
import 'package:chalet/repositories/storage_repository.dart';
import 'package:chalet/repositories/team_feed_info_repository.dart';
import 'package:chalet/repositories/team_repository.dart';
import 'package:chalet/repositories/user_data_repository.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/services/index.dart';
import 'package:chalet/services/review_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:chalet/styles/index.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamProvider<firebaseAuth.User?>.value(
      initialData: null,
      value: AuthService().user,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProblemBloc>(
            create: (context) => ProblemBloc(problemRepository: ProblemRepository()),
          ),
          BlocProvider<AddChaletBloc>(
            create: (context) => AddChaletBloc(
              chaletRepository: ChaletRepository(),
              storageRepository: StorageRepository(),
            ),
          ),
          BlocProvider<GeolocationBloc>(
            create: (context) => GeolocationBloc(geolocationRepository: GeolocationRepository()),
          ),
          BlocProvider<TeamFeedInfoBloc>(
              create: (context) => TeamFeedInfoBloc(
                    teamFeedInfoRepository: TeamFeedInfoRepository(),
                  )),
          BlocProvider<AddReviewBloc>(
            create: (context) => AddReviewBloc(
              reviewRepository: ReviewService(),
              teamFeedInfoBloc: BlocProvider.of<TeamFeedInfoBloc>(context),
            ),
          ),
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
              userDataRepository: UserDataRepository(),
            ),
          ),
          BlocProvider<SendCongratsBloc>(
            create: (context) => SendCongratsBloc(
              teamFeedInfoRepository: TeamFeedInfoRepository(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Chalet app - find your own Chalet!',
          theme: themeData(),
          onGenerateRoute: onGenerateRoute(),
          builder: EasyLoading.init(),
          home: AuthWrapper(),
        ),
      ),
    );
  }
}
