import 'package:flutter/material.dart';
import 'package:hidden_gems_sg/models/place.dart';
import 'package:hidden_gems_sg/helper/utils.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavouriteScreen();
}

class _FavouriteScreen extends State<FavouriteScreen> {
  List<Place> _favourite_places = [];
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    _isLoaded = false;
    _favourite_places = [];
    // _favourites = await _favouritesController.getFavouritesList();
    // if (_favourites != []) {
    //   for (var fav in _favourites) {
    //     var _place = await _placesApi.placeDetailsSearchFromText(fav);
    //     _favourite_places.add(_place!);
    //   }
    // } else {
    //   _favourite_places = [];
    // }
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return _isLoaded
        ? RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _isLoaded = false;
        });
        _reload();
      },
      child: Scaffold(
        backgroundColor: Color(0xFFFFF9ED),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _reload();
                  },
                  child: topBar('favourites', height, width,
                      'assets/img/favourites-top.svg'),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 30,
                ),
                //recommendedList(_favourite_places, height, width),
                Container(child: _favourite_places.length == 0 ? textMinor("No favourites", Colors.black):Container(height: 10,)),
                SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    )
        : Container(
      color: Color(0XffFFF9ED),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
