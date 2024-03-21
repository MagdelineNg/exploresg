import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hidden_gems_sg/helper/auth_controller.dart';
import 'package:hidden_gems_sg/models/place.dart';
import 'package:hidden_gems_sg/helper/utils.dart';

class FavouritesController {
  AuthController _auth = AuthController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void updateFavOnDB(uid, favourites) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update({'favourites': favourites});
  }

  Future addOrRemoveFav(placeID) async {
    String uid = _auth.getCurrentUser()!.uid;
    String favourites = '';
    await _firestore.collection('users').doc(uid).get().then((value) {
      favourites = value['favourites'];
    });
    if (favourites == '') {
      favourites = placeID;
    } else {
      List favouritesList = favourites.split(',');
      if (favouritesList.contains(placeID)) {
        favouritesList.remove(placeID);
        favourites = favouritesList.join(',');
      } else {
        favourites = '$favourites,$placeID';
      }
    }
    updateFavOnDB(uid, favourites);
  }

  Future<List<Place>> removeFavourites(int index, List<Place> places) async {
    places.removeAt(index);
    return places;
  }

  Future<List<String>> getFavouritesList(BuildContext context) async {
    String uid = _auth.getCurrentUser()!.uid;
    String favourites = '';
    await _firestore.collection('users').doc(uid).get().then((value) {
      favourites = value['favourites'];
    }).onError((error, stackTrace) {
      showAlert(context, 'Retrieve User Profile', error.toString());
    });
    if (favourites == '') {
      return [];
    }
    return favourites.split(',');
  }

  Future<bool> isUserFavourite(place) async {
    String uid = _auth.getCurrentUser()!.uid;
    await _firestore.collection('users').doc(uid).get().then((value) {
      String favourites = value['favourites'];
      List favouritesList = favourites.split(',');
      return favouritesList.contains(place.id);
    });
    return false;
  }
}
