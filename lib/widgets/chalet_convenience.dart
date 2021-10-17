import 'package:chalet/screens/chalet/chalet_conveniences_types.dart';
import 'package:chalet/widgets/vertical_sized_boxes.dart';
import 'package:flutter/material.dart';

class ChaletConvenience extends StatelessWidget {
  final ConvenienceType convenienceType;
  final double convenienceScore;
  const ChaletConvenience({
    Key? key,
    required this.convenienceType,
    required this.convenienceScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image(
          width: 56.0,
          height: 56.0,
          image: AssetImage('assets/chaletIcons/${convenienceType.type}.png'),
        ),
        VerticalSizedBox8(),
        Text(convenienceType.name, style: Theme.of(context).textTheme.bodyText2),
        Text(convenienceScore.toString(), style: Theme.of(context).textTheme.bodyText2),
      ],
    );
  }
}
