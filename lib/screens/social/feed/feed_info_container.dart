import 'package:chalet/blocs/send_congrats/send_congrats_bloc.dart';
import 'package:chalet/blocs/send_congrats/send_congrats_event.dart';
import 'package:chalet/blocs/send_congrats/send_congrats_state.dart';
import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/config/functions/feed_display_info_helpers.dart';
import 'package:chalet/config/functions/timestamp_methods.dart';
import 'package:chalet/models/feed_info_model.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class FeedInfoContainer extends StatelessWidget {
  final FeedInfoModel feedInfo;
  const FeedInfoContainer({
    Key? key,
    required this.feedInfo,
  }) : super(key: key);

  final double _circleAvatarRadius = 35.0;

  bool _hasAlreadyBeenCongratulatedByUser(UserModel user) =>
      feedInfo.congratsSenderList.indexWhere((el) => el.userId == user.uid) > -1;

  bool _congratsValidation(UserModel user, SendCongratsState state) {
    if (state is SendCongratsStateLoading || feedInfo.userId == user.uid || _hasAlreadyBeenCongratulatedByUser(user))
      return false;
    else
      return true;
  }

  @override
  Widget build(BuildContext context) {
    UserModel _user = Provider.of<UserDataBloc>(context).state.props.first as UserModel;
    return BlocConsumer<SendCongratsBloc, SendCongratsState>(
        bloc: Provider.of<SendCongratsBloc>(context, listen: false),
        listener: (context, state) {
          if (state is SendCongratsStateError) {
            EasyLoading.showError(state.errorMessage);
          }
        },
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.all(Dimentions.medium),
            margin: EdgeInsets.only(bottom: Dimentions.big),
            decoration: BoxDecoration(
              border: Border.all(color: Palette.lightGrey),
              borderRadius: BorderRadius.circular(Dimentions.medium),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    feedInfo.userName,
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    getTimeagoFromDateTime(feedInfo.created),
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              )
                            ],
                          ),
                          VerticalSizedBox16(),
                          Text(
                            getFeedDisplayInfoModel(feedInfo.role).feedDescription,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VerticalSizedBox8(),
                              Text(
                                getFeedDisplayAdditionalDescInfo(feedInfo),
                                style: Theme.of(context).textTheme.headline5!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Palette.goldLeaf,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    UserAvatar(
                      avatarId: feedInfo.userAvatarId,
                      radius: _circleAvatarRadius,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _user.uid == feedInfo.userId
                          ? Container()
                          : CustomElevatedButton(
                              label: _hasAlreadyBeenCongratulatedByUser(_user) ? 'Już gratulowałeś' : 'Pogratuluj',
                              backgroundColor: Palette.goldLeaf,
                              onPressed: _congratsValidation(_user, state)
                                  ? () => Provider.of<SendCongratsBloc>(context, listen: false).add(SendCongrats(
                                        feedInfo,
                                        CongratsSenderModel(userId: _user.uid, userName: _user.displayName ?? 'anonim'),
                                      ))
                                  : null,
                            ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.emoji_emotions,
                              color: Palette.chaletBlue,
                              size: 36.0,
                            ),
                            onPressed: feedInfo.congratsSenderList.isNotEmpty
                                ? () => showCustomModalBottomSheet(
                                      context,
                                      (context) => Padding(
                                        padding: const EdgeInsets.all(Dimentions.medium),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Polubienia',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .copyWith(fontWeight: FontWeight.bold),
                                            ),
                                            ...feedInfo.congratsSenderList
                                                .map((el) => ListTile(title: Text(el.userName)))
                                          ],
                                        ),
                                      ),
                                    )
                                : null,
                          ),
                          Text(
                            feedInfo.congratsSenderList.length.toString(),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
