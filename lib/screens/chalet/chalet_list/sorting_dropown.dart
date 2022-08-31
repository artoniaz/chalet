import 'package:Challet/screens/chalet/chalet_list/sorting_values.dart';
import 'package:Challet/widgets/horizontal_sized_boxes.dart';
import 'package:flutter/material.dart';

class SortingDropdown extends StatelessWidget {
  final String currentSorting;
  final Function(String) onChanged;
  const SortingDropdown({
    Key? key,
    required this.currentSorting,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.sort),
        HorizontalSizedBox16(),
        DropdownButton<String>(
          value: currentSorting,
          items: SortingValues()
              .sortingValues
              .map((el) => DropdownMenuItem(
                    child: Text(
                      el,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    value: el,
                  ))
              .toList(),
          onChanged: (val) => onChanged(val!),
        ),
      ],
    );
  }
}
