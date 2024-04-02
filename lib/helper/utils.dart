import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hidden_gems_sg/models/place.dart';
import 'package:flutter_svg/svg.dart';

Text textMajor(String text, Color color, double size) {
  return Text(
    text,
    style: TextStyle(fontFamily: 'MadeSunflower', fontSize: size, color: color),
  );
}

Text textMinor(String text, Color color) {
  return Text(text,
      style: TextStyle(fontFamily: 'AvenirLtStd', fontSize: 14, color: color));
}

TextStyle avenirLtStdStyle(Color color) {
  return TextStyle(fontFamily: 'AvenirLtStd', fontSize: 14, color: color);
}

Text textMinorBold(String text, Color color, double size) {
  return Text(text,
      style: TextStyle(
          fontFamily: 'AvenirLtStd',
          fontWeight: FontWeight.bold,
          fontSize: size,
          color: color));
}

Widget topBar(String title, double height, double width, String imagePath) {
  return Stack(
    children: [
      FittedBox(
          fit: BoxFit.fill,
          child: SvgPicture.asset(
            imagePath,
            width: width,
            height: width / 204 * 490,
          )),
      Positioned(
        bottom: width / 30,
        left: width / 8,
        child: textMajor(title, Colors.white, 36),
      )
    ],
  );
}

//calculate distance between 2 points in km
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

List<String> placeType = [
  'airport',
  'amusement_park',
  'aquarium',
  'art_gallery',
  'bakery',
  'bar',
  'beauty_salon',
  'book_store',
  'bowling_alley',
  'cafe',
  'casino',
  'cemetery',
  'clothing_store',
  'department_store',
  'florist',
  'gym',
  'hair_care',
  'library',
  'lodging',
  'movie_theater',
  'museum',
  'night_club',
  'park',
  'restaurant',
  'shopping_mall',
  'spa',
  'stadium',
  'tourist_attraction',
  'university',
  'zoo',
];

Future showAlert(BuildContext context, String title, String content) async {
  Platform.isIOS
      ? await showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          })
      : await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
}

Widget progressionIndicator() {
  return Container(
    color: const Color(0XffFFF9ED),
    child: const Center(
      child: CircularProgressIndicator(),
    ),
  );
}

Widget _printDist(distance) {
  return (distance != null)
      ? textMinor("${distance}km", const Color(0xff22254C))
      : const SizedBox();
}

Widget _printPrice(numOfD) {
  switch (numOfD) {
    case 0:
      return textMinor("\$", const Color(0xff22254C));
    case 1:
      return textMinor("\$\$", const Color(0xff22254C));
    case 2:
      return textMinor("\$\$\$", const Color(0xff22254C));
    case 3:
      return textMinor("\$\$\$\$", const Color(0xff22254C));
    case 4:
      return textMinor("\$\$\$\$\$", const Color(0xff22254C));
    default:
      return const SizedBox(width: 0);
  }
}

Widget placeContainer(Place place, double width, double height, Widget top,
    [Widget? extra, double? distance]) {
  return Container(
    decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20))),
    padding:
        EdgeInsets.symmetric(vertical: 0.05 * height, horizontal: 0.05 * width),
    width: width,
    child: Column(
      children: [
        top,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: place.images.isNotEmpty
                  ? Image.network(
                      place.images[0],
                      fit: BoxFit.fill,
                      height: 100,
                      width: 100,
                    )
                  : const Icon(
                      Icons.question_mark,
                      size: 100,
                    ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.placeName,
                    style: const TextStyle(
                        fontFamily: 'AvenirLtStd',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xff22254C)),
                  ),
                  RatingBarIndicator(
                    rating: place.ratings,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: width / 20,
                    direction: Axis.horizontal,
                  ),
                  textMinor(place.placeAddress, const Color(0xff22254C)),
                  const SizedBox(height: 5),
                  _printPrice(place.price),
                  const SizedBox(height: 5),
                  //include dist for afterseach
                  // textMinor(distance.toString() + "km", Colors.black),
                  _printDist(distance?.toStringAsFixed(2)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.14,
        ),
        extra ?? Container(),
      ],
    ),
  );
}
