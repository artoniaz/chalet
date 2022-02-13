import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

class TeamNameContainer extends StatelessWidget {
  final String teamName;
  const TeamNameContainer({
    Key? key,
    required this.teamName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimentions.medium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimentions.medium),
        color: Palette.chaletBlue,
      ),
      child: Text(
        teamName,
        style: Theme.of(context).textTheme.headline2!.copyWith(
              color: Palette.white,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
