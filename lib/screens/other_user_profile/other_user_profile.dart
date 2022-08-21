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
              padding: const EdgeInsets.only(
                top: Dimentions.medium,
                left: Dimentions.horizontalPadding,
                right: Dimentions.horizontalPadding,
              ),
              child: Text(
                'Statystyki',
                style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: Dimentions.horizontalPadding),
            sliver: StatsGrid(
              chaletReviewsNumber: _userProfile.chaletReviewsNumber,
              chaletAddedNumber: _userProfile.chaletsAddedNumber,
              userCreatedTimestamp: _userProfile.created!,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimentions.horizontalPadding,
                vertical: Dimentions.medium,
              ),
              child: Text(
                'Osiągnięcia',
                style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              Dimentions.horizontalPadding,
              0,
              Dimentions.horizontalPadding,
              Dimentions.medium,
            ),
            sliver: AchievementsList(
              user: _userProfile,
            ),
          ),
        ],
      ),
    );
  }
}
