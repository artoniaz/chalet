import 'package:chalet/blocs/geolocation/geolocation_bloc.dart';
import 'package:chalet/blocs/geolocation/geolocation_event.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GeoLocationInfoScreen extends StatelessWidget {
  const GeoLocationInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimentions.horizontalPadding, vertical: Dimentions.big),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Text(
                'Zaraz zobaczysz najbliższe szalety',
                style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              VerticalSizedBox16(),
              Text(
                'Challet gromadzi dane o lokalizacji, aby umożliwić działanie funkcji wyświetlania najbliższych szaletów nawet wtedy, gdy aplikacja jest zamknięta lub nieużywana',
                style: Theme.of(context).textTheme.bodyText1!,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(22.0),
            decoration: new BoxDecoration(
              border: Border.all(color: Palette.grey),
              shape: BoxShape.circle,
              color: Palette.lightGrey,
            ),
            child: Icon(
              Icons.location_on,
              size: 80.0,
              color: Palette.ivoryBlack,
            ),
          ),
          CustomElevatedButton(
              label: 'Przejdź dalej',
              onPressed: () => Provider.of<GeolocationBloc>(context, listen: false)
                  .add(GetUserGeolocation(hasUserSeenLocationInfoScreen: true))),
        ],
      ),
    );
  }
}
