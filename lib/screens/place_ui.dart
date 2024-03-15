import 'package:hidden_gems_sg/models/place.dart';
import 'package:hidden_gems_sg/helper/utils.dart';
import 'package:hidden_gems_sg/models/place.dart';
import 'package:flutter/material.dart';

class PlaceScreenArguments {
  final Place place;
  final List<String> favourites;

  PlaceScreenArguments(this.place, this.favourites);
}

class PlaceScreen extends StatefulWidget {
  static const routeName = '/placeScreen';
  final Place place;
  final List<String> favourites;

  PlaceScreen(this.place, this.favourites);

  @override
  State<StatefulWidget> createState() {
    return _PlaceScreen();
  }
}

class _PlaceScreen extends State<PlaceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.placeName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // _placeImage(widget.place),
            // _placeDetails(widget.place),
            // _placeDescription(widget.place),
            // _placeRating(widget.place),
            // _placeReviews(widget.place),
            // _placeLocation(widget.place),
            // _placeContact(widget.place),
            // _placeOpeningHours(widget.place),
            // _placeFavouriteButton(widget.place, widget.favourites),
          ],
        ),
      ),
    );
  }
}
