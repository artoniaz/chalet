import 'package:chalet/config/functions/dissmis_focus.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  late UserModel? _userProfile;

  @override
  void initState() {
    final _user = Provider.of<UserModel?>(context, listen: false);
    setState(() => _userProfile = _user ?? null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    print(_userProfile?.email ?? 'null');

    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Palette.chaletBlue,
            elevation: 0,
            expandedHeight: MediaQuery.of(context).size.height * 0.3,
            floating: false,
            pinned: false,
            snap: false,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              stretchModes: [StretchMode.zoomBackground],
              background: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.all(Dimentions.small),
                child: CircleAvatar(),
              )),
            ),
          ),
          SliverFillRemaining(
              child: GestureDetector(
            onTap: () => dissmissCurrentFocus(context),
            child: Column(
              children: [
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Nazwa użytkownika'),
                  onChanged: (String val) => setState(() => _userProfile!.displayName = val),
                  onEditingComplete: () => node.nextFocus(),
                  keyboardType: TextInputType.text,
                ),
                VerticalSizedBox16(),
                TextFormField(
                  initialValue: _userProfile!.email,
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val!.isEmpty || !val.contains('@') ? 'Podaj poprawny adres email' : null,
                  onChanged: (String val) => setState(() => _userProfile!.email = val),
                  onEditingComplete: () => node.nextFocus(),
                  keyboardType: TextInputType.emailAddress,
                ),
                VerticalSizedBox16(),
                CustomElevatedButton(
                  label: 'Zapisz dane',
                  onPressed: () {},
                ),
              ],
            ),
          )),
        ],
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(
      //     Dimentions.medium,
      //   ),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     crossAxisAlignment: CrossAxisAlignment.stretch,
      //     children: [
      //       Column(
      //         children: [
      //           CircleAvatar(),
      //           Text(_userProfile!.uid),
      //         ],
      //       ),
      //       Column(
      //         children: [
      //           CustomTextButton(
      //             onPressed: () {},
      //             label: 'Edytuj konto',
      //             color: Palette.ivoryBlack,
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
