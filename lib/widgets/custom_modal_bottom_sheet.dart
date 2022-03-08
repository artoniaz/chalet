import 'package:flutter/material.dart';

Future showCustomModalBottomSheet(BuildContext context, Widget Function(BuildContext) builder,
        [Future? whenComplete]) =>
    showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.3,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(48)),
            ),
            builder: builder)
        .whenComplete(() => whenComplete == null ? null : whenComplete);
