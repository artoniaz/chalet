import 'package:Challet/services/geolocation_service.dart';
import 'package:Challet/styles/index.dart';
import 'package:Challet/widgets/custom_appBars.dart';
import 'package:Challet/widgets/custom_elevated_button.dart';
import 'package:Challet/widgets/horizontal_sized_boxes.dart';
import 'package:Challet/widgets/vertical_sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:Challet/.env.dart';

class AddressInputScreen extends StatefulWidget {
  const AddressInputScreen({Key? key}) : super(key: key);

  @override
  _AddressInputScreenState createState() => _AddressInputScreenState();
}

class _AddressInputScreenState extends State<AddressInputScreen> {
  String _searchedAddress = '';
  List<AutocompletePrediction>? _placePredictions = [];

  void _getPredictionsFromAddress(String address) async {
    AutocompleteResponse? risult =
        await GooglePlace(googleAPIKey).autocomplete.get(_searchedAddress, language: 'pl', region: 'pl');
    setState(() => _placePredictions = risult!.predictions);
  }

  void _getLocationsFromPrediction(String predictionDesc) async {
    var result = await GeolocationService().getLocationFromAddress(predictionDesc);
    Navigator.pop(context, result.first);
  }

  List<ListTile> _getPredictionsListTiles() => _placePredictions!
      .map((el) => ListTile(
            leading: Icon(Icons.place),
            title: Text(el.description ?? ''),
            onTap: () => _getLocationsFromPrediction(el.description ?? ''),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBars.customTransparentAppBar(context),
      body: Padding(
        padding: EdgeInsets.all(Dimentions.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Znajdź lokalizację',
              style: Theme.of(context).textTheme.headline6,
            ),
            VerticalSizedBox16(),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    decoration: textInputDecoration.copyWith(hintText: 'Szukaj lokalizacji'),
                    onChanged: (String val) => setState(() => _searchedAddress = val),
                    keyboardType: TextInputType.text,
                  ),
                ),
                HorizontalSizedBox24(),
                CustomElevatedButton(
                  label: 'Szukaj',
                  onPressed: () {
                    _getPredictionsFromAddress(_searchedAddress);
                  },
                ),
              ],
            ),
            Divider(),
            if (_placePredictions!.isNotEmpty) ..._getPredictionsListTiles(),
          ],
        ),
      ),
    );
  }
}
