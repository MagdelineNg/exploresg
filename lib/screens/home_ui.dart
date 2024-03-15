import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hidden_gems_sg/helper/tracker_controller.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps/google_maps.dart';
// import 'package:hidden_gems_sg/theme/theme_constants.dart';
import 'package:hidden_gems_sg/helper/utils.dart';
import 'package:hidden_gems_sg/helper/location_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:hidden_gems_sg/models/place.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  String _placeTypeDropdownValue = 'airport';
  Locator _locator = Locator();
  TextEditingController _searchController = new TextEditingController();
  late LatLng _userLoc;
  bool _isLoaded = false;
  bool _searchByCategory = false;
  List<Place>? _places = [];
  List<String> _favourites = [];

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  Future<void> _loadPage() async {
    var result = await _locator.getCurrentLocation();
    if (result != null) {
      _userLoc = result;
    }
    //_places = await _homeController.loadRecommendations(context);
    //_favourites = await _favouritesController.getFavouritesList();
    setState(() {
      _isLoaded = true;
    });
  }

  Future<void> _reload() async {
    _isLoaded = false;
    // _places = await _homeController.loadRecommendations(context);
    setState(() {
      _isLoaded = true;
    });
  }

  Widget _dropDownList(double width, DropdownButtonFormField DDL) {
    return Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 0.1 * width),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: DDL);
  }

  InputDecoration dropdownDeco = InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      labelStyle: TextStyle(color: Color(0xff22254C), fontSize: 16));

  Widget _placeTypeDropDown(double width) {
    return _dropDownList(
        width,
        DropdownButtonFormField(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Color(0xffD1D1D6),
            ),
            items: placeType
                .map((String e) => DropdownMenuItem(
                    value: e,
                    child:
                        textMinor(e.replaceAll('_', ' '), Color(0xff22254C))))
                .toList(),
            decoration: dropdownDeco,
            isExpanded: true,
            value: _placeTypeDropdownValue,
            onChanged: (newValue) {
              setState(() {
                _placeTypeDropdownValue = newValue!;
              });
            }));
  }

  Widget _searchSwitch() {
    return Transform.scale(
      transformHitTests: false,
      scale: .7,
      child: CupertinoSwitch(
        activeColor: Color(0xff6488E5),
        trackColor: Color(0xff6488E5), //change to closer colour
        value: _searchByCategory,
        onChanged: (value) {
          setState(() {
            _searchByCategory = !_searchByCategory;
          });
        },
      ),
    );
  }

  Widget _searchBar(double width, double height) {
    return Container(
      width: width,
      height: height / 5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        controller: _searchController,
        cursorColor: Color(0xffD1D1D6),
        cursorHeight: 14.0,
        style: avenirLtStdStyle(
          Color(0xff22254C),
        ),
        decoration: new InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xffD1D1D6),
          ),
          hintText: 'type a place...',
          hintStyle: avenirLtStdStyle(
            Color(0xffD1D1D6),
          ),
          contentPadding: EdgeInsets.zero,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _addFav(Place place, double height, double width) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      width: width,
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              InkWell(
                  onTap: () async {
                    //await _favouritesController.addOrRemoveFav(place.id);
                    //_favourites =
                    // await _favouritesController.getFavouritesList();
                    setState(() {
                      place.likes = !place.likes;
                    });
                  },
                  child: _favourites.contains(place.id)
                      ? Icon(
                          Icons.favorite,
                          color: Color(0xffE56372),
                        )
                      : Icon(
                          Icons.favorite_border,
                          color: Color(0xffE56372),
                        )),
              SizedBox(
                width: 10,
              ),
              textMinor(
                  _favourites.contains(place.id)
                      ? 'added to favourites'
                      : 'add to favourites',
                  Color(0xffD1D1D6))
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchTools(double width, double height) {
    return Container(
      width: width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textMinor('keyword search',
                  _searchByCategory ? Color(0xffD1D1D6) : Color(0xff22254C)),
              _searchSwitch(),
              textMinor('dropdown list',
                  _searchByCategory ? Color(0xff22254C) : Color(0xffD1D1D6))
            ],
          ),
          _searchByCategory == false
              ? _searchBar(width, height)
              : _placeTypeDropDown(width),
          // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          //   SizedBox(width: 0.02 * width),
          //   _filterDropDown(width)
          // ]),
          // _displayFiltered(width),
          // _goButton()
        ],
      ),
    );
  }

  Widget recommendedList(List<Place> places, double height, double width) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: places.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Stack(children: [
                InkWell(
                  onTap: () {},
                  child: placeContainer(
                    places[index],
                    0.8 * width,
                    0.24 * height,
                    _addFav(places[index], 0.05 * height, 0.8 * width),
                    Container(),
                    calculateDistance(
                      _userLoc.latitude,
                      _userLoc.longitude,
                      double.parse(_places![index].coordinates['lat']!),
                      double.parse(_places![index].coordinates['long']!),
                    ),
                  ),
                ),
              ])
            ],
          );
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
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _reload();
                      },
                      child: topBar(
                          'home', height, width, 'assets/img/home-top.svg'),
                    ),
                    SizedBox(height: 30),
                    textMajor('find places', Color(0xff22254C), 26),
                    SizedBox(
                      height: 7,
                    ),
                    _searchTools(0.80 * width, 0.3 * height),
                    FittedBox(
                        fit: BoxFit.fill,
                        child: SvgPicture.asset('assets/img/home-mid.svg',
                            width: width, height: width)),
                    textMajor('explore', Color(0xff22254C), 26),
                    recommendedList(_places!, height, width),
                    const SizedBox(height: 20)
                  ],
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
