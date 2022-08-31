import 'package:Challet/widgets/platform_svg.dart';
import 'package:flutter/material.dart';

class MainImage extends StatelessWidget {
  const MainImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformSvgAsset(
      assetName: 'snake_with_title_subtitle',
      folder: 'snake/svg',
      height: 200.0,
    );
  }
}
