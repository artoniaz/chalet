import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final Widget child;
  const CustomDialog({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
        child: child,
      ),
    );
  }
}
