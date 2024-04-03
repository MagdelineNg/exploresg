import 'package:hidden_gems_sg/helper/home_controller.dart';
import 'package:hidden_gems_sg/helper/favourites_controller.dart';
import 'package:hidden_gems_sg/helper/location_controller.dart';
import 'package:hidden_gems_sg/helper/utils.dart';
import 'package:hidden_gems_sg/models/place.dart';
import 'package:hidden_gems_sg/screens/search_ui.dart';
import 'package:hidden_gems_sg/screens/place_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  String _placeTypeDropdownValue = 'airport',
      _filterByDropdownValue = 'filter by',
      _prevFilter = '';
  bool _searchByCategory = false, _isLoaded = false;
  final TextEditingController _searchController = TextEditingController();
  final HomeController _homeController = HomeController();
  final FavouritesController _favouritesController = FavouritesController();
  final Locator _locator = Locator();
  List<Place>? _places = [];
  List<String> _favourites = [];
  late LatLng _userLoc;

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
    _places = await _homeController.loadRecommendations(context);
    _favourites = await _favouritesController.getFavouritesList(context);
    setState(() {
      _isLoaded = true;
    });
  }

  InputDecoration dropdownDeco = const InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      labelStyle: TextStyle(color: Color(0xff22254C), fontSize: 16));

  Widget _dropDownList(double width, DropdownButtonFormField DDL) {
    return Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 0.1 * width),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: DDL);
  }

  RangeValues _priceValues = const RangeValues(0, 4);
  RangeValues _ratingValues = const RangeValues(1, 5);

  int _minFilter = 0;
  int _maxFilter = 4;
  double _distValue = 15000;

  Widget _ratingFilter(double width) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildSideLabel(
            _minFilter.toString(),
          ),
          Expanded(
            child: RangeSlider(
              values: _ratingValues,
              min: 1,
              max: 5,
              divisions: 5,
              labels: RangeLabels(
                _ratingValues.start.round().toString(),
                _ratingValues.end.round().toString(),
              ),
              onChanged: (values) {
                setState(() {
                  _ratingValues = values;
                  _minFilter = values.start.round();
                  _maxFilter = values.end.round();
                });
              },
            ),
          ),
          buildSideLabel(_maxFilter.toString()),
        ],
      ),
    );
  }

  Widget _priceFilter(double width) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildSideLabel(_minFilter.toString()),
          Expanded(
            child: RangeSlider(
              values: _priceValues,
              min: 0,
              max: 4,
              divisions: 4,
              labels: RangeLabels(
                _priceValues.start.round().toString(),
                _priceValues.end.round().toString(),
              ),
              onChanged: (values) {
                setState(() {
                  _priceValues = values;
                  _minFilter = values.start.round();
                  _maxFilter = values.end.round();
                });
              },
            ),
          ),
          buildSideLabel(_maxFilter.toString()),
        ],
      ),
    );
  }

  Widget _distanceFilter(double width) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildSideLabel('0 km'),
          Expanded(
            child: CupertinoSlider(
              activeColor: const Color(0xff6488E5),
              value: _distValue,
              min: 0,
              max: 15000,
              divisions: 1500,
              onChanged: (value) {
                setState(() {
                  _distValue = value;
                  _maxFilter = value.round();
                  _minFilter = 0;
                });
              },
            ),
          ),
          buildSideLabel('${_maxFilter / 1000}km'),
        ],
      ),
    );
  }

  Widget buildSideLabel(String value) {
    return SizedBox(
      width: 60,
      child: Text(
        value,
        style: const TextStyle(fontFamily: 'AvenirLtStd', fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _displayFiltered(double width) {
    if (_filterByDropdownValue == 'distance') {
      if (_prevFilter != _filterByDropdownValue) {
        setState(() {
          _minFilter = 0;
          _maxFilter = 15000;
          _distValue = 15000;
        });
      }
      _prevFilter = _filterByDropdownValue;
      return _distanceFilter(width);
    } else if (_filterByDropdownValue == 'ratings') {
      if (_prevFilter != _filterByDropdownValue) {
        setState(() {
          _minFilter = 1;
          _maxFilter = 5;
          _priceValues = const RangeValues(0, 4);
        });
      }
      _prevFilter = _filterByDropdownValue;
      return _ratingFilter(width);
    } else if (_filterByDropdownValue == 'price') {
      if (_prevFilter != _filterByDropdownValue) {
        setState(() {
          _minFilter = 0;
          _maxFilter = 4;
          _ratingValues = const RangeValues(1, 5);
        });
      }
      _prevFilter = _filterByDropdownValue;
      return _priceFilter(width);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _filterDropDown(double width) {
    return _dropDownList(
      0.6 * width,
      DropdownButtonFormField<String>(
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Color(0xffD1D1D6),
        ),
        items: [
          DropdownMenuItem(
              value: 'filter by',
              child: textMinor(
                'filter by',
                const Color(0xffD1D1D6),
              )),
          DropdownMenuItem(
              value: 'distance',
              child: textMinor(
                'distance',
                const Color(0xff22254C),
              )),
          DropdownMenuItem(
              value: 'ratings',
              child: textMinor(
                'ratings',
                const Color(0xff22254C),
              )),
          DropdownMenuItem(
              value: 'price',
              child: textMinor(
                'price',
                const Color(0xff22254C),
              ))
        ],
        decoration: dropdownDeco,
        isExpanded: true,
        value: _filterByDropdownValue,
        onChanged: (String? newValue) {
          setState(() {
            _filterByDropdownValue = newValue!;
            _displayFiltered(width);
          });
        },
      ),
    );
  }

  Widget _placeTypeDropDown(double width) {
    return _dropDownList(
      width,
      DropdownButtonFormField(
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Color(0xffD1D1D6),
        ),
        items: placeType
            .map(
              (String e) => DropdownMenuItem(
                value: e,
                child: textMinor(
                  e.replaceAll('_', ' '),
                  const Color(0xff22254C),
                ),
              ),
            )
            .toList(),
        decoration: dropdownDeco,
        isExpanded: true,
        value: _placeTypeDropdownValue,
        onChanged: (newValue) {
          setState(() {
            _placeTypeDropdownValue = newValue!;
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
        cursorColor: const Color(0xffD1D1D6),
        cursorHeight: 14.0,
        style: avenirLtStdStyle(
          const Color(0xff22254C),
        ),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xffD1D1D6),
          ),
          hintText: 'type a place...',
          hintStyle: avenirLtStdStyle(
            const Color(0xffD1D1D6),
          ),
          contentPadding: EdgeInsets.zero,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _searchSwitch() {
    return Transform.scale(
      transformHitTests: false,
      scale: .7,
      child: CupertinoSwitch(
        activeColor: const Color(0xff6488E5),
        trackColor: const Color(0xff6488E5), //change to closer colour
        value: _searchByCategory,
        onChanged: (value) {
          setState(() {
            _searchByCategory = !_searchByCategory;
          });
        },
      ),
    );
  }

  Widget _goButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color(0xff6488E5),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ))),
        onPressed: () {
          Navigator.pushNamed(
            context,
            SearchScreen.routeName,
            arguments: _searchByCategory == false //using input searchbar
                ? SearchScreenArguments(_maxFilter, _minFilter,
                    _filterByDropdownValue, _searchController.text)
                : SearchScreenArguments(
                    //using place type dropdown
                    _maxFilter,
                    _minFilter,
                    _filterByDropdownValue,
                    _placeTypeDropdownValue,
                  ),
          );
        },
        child: const Text('go!',
            style: TextStyle(
                fontFamily: 'AvenirLtStd', fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Widget _searchTools(double width, double height) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textMinor(
                  'keyword search',
                  _searchByCategory
                      ? const Color(0xffD1D1D6)
                      : const Color(0xff22254C)),
              _searchSwitch(),
              textMinor(
                  'dropdown list',
                  _searchByCategory
                      ? const Color(0xff22254C)
                      : const Color(0xffD1D1D6))
            ],
          ),
          _searchByCategory == false
              ? _searchBar(width, height)
              : _placeTypeDropDown(width),
          _displayFiltered(width),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _filterDropDown(width),
            SizedBox(width: 0.1 * width),
            _goButton()
          ]),
        ],
      ),
    );
  }

  Widget _addFav(Place place, double height, double width) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      width: width,
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              await _favouritesController.addOrRemoveFav(place.id);
              _favourites =
                  await _favouritesController.getFavouritesList(context);
              setState(() {
                place.likes = !place.likes;
              });
            },
            child: Row(
              children: [
                _favourites.contains(place.id)
                    ? const Icon(
                        Icons.favorite,
                        color: Color(0xffE56372),
                      )
                    : const Icon(
                        Icons.favorite_border,
                        color: Color(0xffA4A4A4),
                      ),
                const SizedBox(
                  width: 10,
                ),
                textMinor(
                    _favourites.contains(place.id)
                        ? 'added to favourites'
                        : 'add to favourites',
                    const Color(0xffA4A4A4))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget recommendedList(List<Place> places, double height, double width) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: places.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, PlaceScreen.routeName,
                        arguments:
                            PlaceScreenArguments(_places![index], _favourites));
                  },
                  child: placeContainer(
                    places[index],
                    0.8 * width,
                    0.22 * height,
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
              ],
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        );
      },
    );
  }

  Future<void> _reload() async {
    _isLoaded = false;
    _places = await _homeController.loadRecommendations(context);
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
                    const SizedBox(height: 30),
                    textMajor('find places', const Color(0xff22254C), 26),
                    const SizedBox(
                      height: 7,
                    ),
                    _searchTools(0.80 * width, 0.3 * height),
                    FittedBox(
                        fit: BoxFit.fill,
                        child: SvgPicture.asset('assets/img/home-mid.svg',
                            width: width, height: width)),
                    textMajor('explore', const Color(0xff22254C), 26),
                    recommendedList(_places!, height, width),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          )
        : Container(
            color: const Color(0XffFFF9ED),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
