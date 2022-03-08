import 'package:chalet/models/user_model.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class OtherUserProfile extends StatefulWidget {
  const OtherUserProfile({Key? key}) : super(key: key);

  @override
  _OtherUserProfileState createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  late UserModel _userProfile;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)!.settings.arguments as UserModelArg;
    setState(() {
      _userProfile = args.userModel;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBars.customTransparentAppBar(context),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileCardHeader(
              user: _userProfile,
            ),
          ),
          SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Dimentions.medium),
              child: Text(
                'Statystyki',
                style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: Dimentions.medium),
            sliver: StatsGrid(
              chaletReviewsNumber: _userProfile.chaletReviewsNumber,
              chaletAddedNumber: _userProfile.chaletsAddedNumber,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Dimentions.medium),
              child: Text(
                'Osiągnięcia',
                style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(Dimentions.medium, 0, Dimentions.medium, Dimentions.medium),
            sliver: AchievementsList(
              user: _userProfile,
            ),
          ),
        ],
      ),
    );
  }
}
