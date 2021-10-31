import 'package:chalet/config/chalet_image_slider_phases.dart';
import 'package:chalet/config/index.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/styles/palette.dart';
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
  ChaletModel? _chalet;
  ScrollController _controller = ScrollController();

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)!.settings.arguments as ChaletDetailsArgs;
    setState(() => _chalet = args.chalet);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double _pictureHeight = MediaQuery.of(context).size.height * .5;
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CustomAppBars.customImageSliderSliverAppBar(_chalet!, _pictureHeight),
          SliverToBoxAdapter(
            child: ChaletCard(
              controller: _controller,
              chalet: _chalet,
              isMapEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
