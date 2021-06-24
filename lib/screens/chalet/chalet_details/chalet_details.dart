import 'package:chalet/config/index.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class ChaletDetails extends StatefulWidget {
  const ChaletDetails({
    Key? key,
  }) : super(key: key);

  @override
  _ChaletDetailsState createState() => _ChaletDetailsState();
}

class _ChaletDetailsState extends State<ChaletDetails> {
  ChaletModel? chalet;

  @override
  void didChangeDependencies() {
    final args =
        ModalRoute.of(context)!.settings.arguments as ChaletDetailsArgs;
    setState(() => chalet = args.chalet);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomAppBars.customSliverAppBarDark(context, 'nazwa'),
          SliverFillRemaining(
            child: Container(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
