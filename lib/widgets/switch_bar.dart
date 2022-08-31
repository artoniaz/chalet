import 'package:Challet/styles/index.dart';
import 'package:flutter/material.dart';

class SwitchBar extends StatelessWidget {
  final String label;
  final Function(bool) handleis24Update;
  final bool value;
  const SwitchBar({
    Key? key,
    required this.label,
    required this.handleis24Update,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Palette.ivoryBlack,
                )),
        Switch(
          value: value,
          activeColor: Palette.chaletBlue,
          onChanged: handleis24Update,
        ),
      ],
    );
  }
}
