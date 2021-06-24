import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

class VerticalSizedBox8 extends StatelessWidget {
  const VerticalSizedBox8({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimentions.small,
    );
  }
}

class VerticalSizedBox16 extends StatelessWidget {
  const VerticalSizedBox16({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimentions.medium,
    );
  }
}

class VerticalSizedBox24 extends StatelessWidget {
  const VerticalSizedBox24({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimentions.big,
    );
  }
}

class VerticalSizedBox48 extends StatelessWidget {
  const VerticalSizedBox48({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimentions.large,
    );
  }
}
