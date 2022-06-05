import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonalNumberConfirmDialog extends StatelessWidget {
  final bool hasAlsoUserNameChanged;
  const PersonalNumberConfirmDialog({
    Key? key,
    required this.hasAlsoUserNameChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Serio kurwa?!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.w700)),
          VerticalSizedBox16(),
          Text(
              hasAlsoUserNameChanged
                  ? 'Zmieniliśmy Ci ten nick, no ale kuuurwa, PESEL to dana wrażliwa i serio nie podawaj tego nigdzie.'
                  : 'No kuuurwa, PESEL to dana wrażliwa i serio nie podawaj tego nigdzie.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1),
          Text('Nawet w apce do srania', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1),
          VerticalSizedBox16(),
          Text('Masz tu linka i poczytaj o swoim bezpieczeństwie',
              textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1),
          CustomTextButton(
            onPressed: () async {
              try {
                await launch('https://sieciaki.pl/warto-wiedziec/zasady-bezpieczenstwa');
              } catch (e) {
                EasyLoading.showError('Nie udało się otworzyć linku');
              }
            },
            label: 'https://sieciaki.pl/warto-wiedziec/zasady-bezpieczenstwa',
            color: Palette.ivoryBlack,
          ),
        ],
      ),
    );
  }
}

class SeriouslyDialog extends StatelessWidget {
  const SeriouslyDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
        child: Text('Na pewno, kurwa?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.w700)),
      ),
    );
  }
}
