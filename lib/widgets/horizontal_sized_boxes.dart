import 'package:Challet/styles/index.dart';
import 'package:flutter/material.dart';

class HorizontalSizedBox4 extends StatelessWidget {
  const HorizontalSizedBox4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimentions.textGap,
    );
  }
}

class HorizontalSizedBox8 extends StatelessWidget {
  const HorizontalSizedBox8({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimentions.small,
    );
  }
}

class HorizontalSizedBox16 extends StatelessWidget {
  const HorizontalSizedBox16({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimentions.medium,
    );
  }
}

class HorizontalSizedBox24 extends StatelessWidget {
  const HorizontalSizedBox24({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimentions.big,
    );
  }
}

class HorizontalSizedBox48 extends StatelessWidget {
  const HorizontalSizedBox48({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimentions.large,
    );
  }
}
