import 'package:chalet/config/chalet_image_slider_phases.dart';
import 'package:chalet/config/index.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/styles/palette.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class ChaletDetails extends StatefulWidget {
  final ChaletModel chalet;
  const ChaletDetails({
    Key? key,
    required this.chalet,
  }) : super(key: key);

  @override
  _ChaletDetailsState createState() => _ChaletDetailsState();
}

class _ChaletDetailsState extends State<ChaletDetails> {
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    double _pictureHeight = MediaQuery.of(context).size.height * .5;
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CustomAppBars.customImageSliderSliverAppBar(widget.chalet, _pictureHeight),
          SliverToBoxAdapter(
            child: ChaletCard(
              controller: _controller,
              chalet: widget.chalet,
              isMapEnabled: true,
              isGalleryEnabled: false,
            ),
          ),
        ],
      ),
    );
  }
}
