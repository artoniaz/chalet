import 'package:flutter/material.dart';

class ErrorMessageContainer extends StatelessWidget {
  final String errorMessage;
  const ErrorMessageContainer({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        errorMessage,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
