import 'package:Challet/models/color_model.dart';
import 'package:Challet/styles/dimentions.dart';
import 'package:Challet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ColorPickerDialog extends StatefulWidget {
  final Function(ColorModel) handleChoosenColor;
  final List<double> alreadyChoosenColors;
  const ColorPickerDialog({
    Key? key,
    required this.handleChoosenColor,
    required this.alreadyChoosenColors,
  }) : super(key: key);

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  ColorModel? selectedColor;

  @override
  Widget build(BuildContext context) {
    List<ColorModel> colors = [];
    colors = avaliableColors.where((el) => !widget.alreadyChoosenColors.contains(el.bitmapDescriptor)).toList();

    return AlertDialog(
      title: Text('Wybierz swój kolor'),
      content: Scrollbar(
          child: Wrap(
        spacing: Dimentions.small,
        runSpacing: Dimentions.small,
        children: colors
            .map((el) => CustomColorIndicator(
                  color: el.color,
                  isSelected: el == selectedColor,
                  onSelect: () => setState(() => selectedColor = el),
                ))
            .toList(),
      )),
      actions: [
        ButtonsPopUpRow(
          approveButtonLabel: 'Zatwierdź',
          onPressedApproveButton: () => widget.handleChoosenColor(selectedColor!),
        ),
      ],
    );
  }
}

List<ColorModel> avaliableColors = [
  ColorModel(
    color: Colors.blueAccent,
    bitmapDescriptor: BitmapDescriptor.hueAzure,
  ),
  ColorModel(
    color: Colors.blue,
    bitmapDescriptor: BitmapDescriptor.hueBlue,
  ),
  ColorModel(
    color: Colors.cyan,
    bitmapDescriptor: BitmapDescriptor.hueCyan,
  ),
  ColorModel(
    color: Colors.green,
    bitmapDescriptor: BitmapDescriptor.hueGreen,
  ),
  ColorModel(
    color: Colors.purple,
    bitmapDescriptor: BitmapDescriptor.hueMagenta,
  ),
  ColorModel(
    color: Colors.orange,
    bitmapDescriptor: BitmapDescriptor.hueOrange,
  ),
  ColorModel(
    color: Colors.red,
    bitmapDescriptor: BitmapDescriptor.hueRed,
  ),
  ColorModel(
    color: Colors.pink,
    bitmapDescriptor: BitmapDescriptor.hueRose,
  ),
  ColorModel(
    color: Colors.deepPurple,
    bitmapDescriptor: BitmapDescriptor.hueViolet,
  ),
  ColorModel(
    color: Colors.yellow,
    bitmapDescriptor: BitmapDescriptor.hueYellow,
  ),
];
