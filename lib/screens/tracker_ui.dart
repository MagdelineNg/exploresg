import 'package:hidden_gems_sg/helper/auth_controller.dart';
import 'package:hidden_gems_sg/helper/favourites_controller.dart';
import 'package:hidden_gems_sg/helper/places_api.dart';
import 'package:hidden_gems_sg/helper/tracker_controller.dart';
import 'package:hidden_gems_sg/helper/utils.dart';
import 'package:hidden_gems_sg/models/invitation.dart';
import 'package:hidden_gems_sg/models/place.dart';
import 'package:hidden_gems_sg/screens/place_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TrackerScreen();
  }
}

class _TrackerScreen extends State<TrackerScreen> {
  final TrackerController _trackerController = TrackerController();
  final AuthController _authController = AuthController();
  final PlacesApi _placesApi = PlacesApi();
  final FavouritesController _favouritesController = FavouritesController();
  List<Invitation> _invites = [], _toExplore = [], _explored = [];
  final Map<String, Place> _places = {};
  bool _isLoaded = false;
  String _dropDownValue = 'to explore';
  List<String> _dropDownValues = ['unexplored', 'to explore', 'explored'];
  List<String> _favourites = [];

  @override
  void initState() {
    super.initState();
    _loadExplores();
  }

  Widget _dropDown(Invitation invite) {
    if (invite.visited) {
      _dropDownValue = 'explored';
      _dropDownValues = ['explored'];
    } else {
      _dropDownValue = 'to explore';
      _dropDownValues = ['unexplored', 'to explore', 'explored'];
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0XffFFF9ED),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _dropDownValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: const TextStyle(
            color: Colors.orange,
            fontFamily: 'AvenirLtStd',
            fontSize: 14,
          ),
          onChanged: (String? newValue) {
            setState(() {
              _dropDownValue = newValue!;
              _checkAction(invite);
            });
          },
          items: _dropDownValues.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _inviteContainer(Invitation invite, double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dropDown(invite),
        Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: textMinor('date: ${invite.date}', const Color(0xff22254C))),
        const SizedBox(
          height: 5,
        ),
        Container(
            child: textMinor('time: ${invite.time}', const Color(0xff22254C))),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            textMinorBold('people', const Color(0xff22254C), 14),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: width * 0.5,
              height: 25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: invite.users.length,
                itemBuilder: (BuildContext context, int idx) => ClipOval(
                  child: Column(
                    children: [
                      invite.users[idx].getPicture() == ''
                          ? CircleAvatar(
                              radius: 12.5,
                              backgroundColor: const Color(0xff6488E5),
                              child: textMajor(
                                  invite.users[idx].getUsername() != ''
                                      ? invite.users[idx].getUsername()[0]
                                      : '?',
                                  Colors.white,
                                  10),
                            )
                          : Image.network(
                              invite.users[idx].getPicture(),
                              height: width / 16,
                              width: width / 16,
                              fit: BoxFit.cover,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _exploreList(List<Invitation> list, double height, double width) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, PlaceScreen.routeName,
                    arguments: PlaceScreenArguments(
                        _places[list[index].getPlace()]!, _favourites));
              },
              child: placeContainer(
                  _places[list[index].getPlace()]!,
                  0.8 * width,
                  0.3 * height,
                  _inviteContainer(list[index], width),
                  Container()),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }

  void _checkAction(Invitation invite) async {
    var user = _authController.getCurrentUser();
    if (_dropDownValue == 'explored' && !invite.visited) {
      await _trackerController.setExplored(invite, user!.uid);
    } else if (_dropDownValue == 'to explore' && invite.visited) {
      await _trackerController.setToExplored(invite, user!.uid);
    } else if (_dropDownValue == 'unexplored') {
      await _trackerController.setUnexplored(invite, user!.uid);
    }
    setState(() {
      _loadExplores();
    });
  }

  void _loadExplores() async {
    _favourites = await _favouritesController.getFavouritesList(context);
    var user = _authController.getCurrentUser();
    _invites = await _trackerController.getConfirmedInvitations(user!.uid);

    if (_invites.isNotEmpty) {
      for (Invitation iv in _invites) {
        var place = await _placesApi.placeDetailsSearchFromText(iv.place);
        if (place != null) {
          _places[iv.place] = place;
          print(place.id);
        }
      }
    }
    var result =
        await _trackerController.sortBasedOnToExploreAndExplored(_invites);
    _toExplore = result[0];
    _explored = result[1];
    setState(() {
      _isLoaded = true;
    });
  }

  void _reload() {
    _isLoaded = false;
    setState(() {});
    _loadExplores();
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
                      child: topBar('my tracker', height, width,
                          'assets/img/tracker-top.svg'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    textMajor('to explore', const Color(0xff22254C), 26),
                    _toExplore.isNotEmpty
                        ? _exploreList(_toExplore, height, width)
                        : Container(),
                    FittedBox(
                        fit: BoxFit.fill,
                        child: SvgPicture.asset('assets/img/tracker-mid.svg',
                            width: width, height: width)),
                    textMajor('explored', const Color(0xff22254C), 26),
                    _explored.isNotEmpty
                        ? _exploreList(_explored, height, width)
                        : Container(),
                    const SizedBox(
                      height: 35,
                    ),
                  ],
                ),
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
