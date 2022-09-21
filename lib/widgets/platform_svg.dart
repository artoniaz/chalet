import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class PlatformSvgAsset extends StatelessWidget {
  final String assetName;
  final String folder;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final AlignmentGeometry alignment;
  final String? semanticsLabel;
  final BlendMode? colorBlenMode;
  const PlatformSvgAsset({
    Key? key,
    required this.assetName,
    this.width = 45.0,
    this.height = 45.0,
    this.fit = BoxFit.contain,
    this.color,
    this.alignment = Alignment.center,
    this.semanticsLabel,
    this.colorBlenMode,
    this.folder = 'chaletIcons',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/$folder/$assetName.svg',
      width: width,
      height: height,
      fit: fit,
      color: color,
      alignment: alignment,
      semanticsLabel: semanticsLabel,
      colorBlendMode: colorBlenMode ?? BlendMode.srcIn,
    );
  }
}
