import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class CustomColorIndicator extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final void Function()? onSelect;
  const CustomColorIndicator({
    Key? key,
    required this.color,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorIndicator(
      width: 50,
      height: 50,
      borderRadius: 25,
      color: color,
      isSelected: isSelected,
      onSelect: onSelect ?? null,
    );
  }
}
