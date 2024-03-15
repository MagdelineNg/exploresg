import 'package:flutter/material.dart';
import 'package:hidden_gems_sg/helper/utils.dart';
import 'package:hidden_gems_sg/models/invitation.dart';
import 'package:hidden_gems_sg/models/place.dart';
import 'package:flutter_svg/svg.dart';

class TrackerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TrackerScreen();
}

class _TrackerScreen extends State<TrackerScreen> {
  bool _isLoaded = false;
  List<Invitation> _invites = [], _toExplore = [], _explored = [];
  Map<String, Place> _places = {};

  @override
  void initState() {
    super.initState();
    _loadExplores();
  }

  void _reload() {
    _isLoaded = false;
    setState(() {});
    _loadExplores();
  }

  void _loadExplores() async {
    // _favourites = await _favouritesController.getFavouritesList();
    // var user = _authController.getCurrentUser();
    // _invites = await _trackerController.getConfirmedInvitations(user!.uid);
    //
    // if (_invites.length != 0) {
    //   for (Invitation iv in _invites) {
    //     var place = await _placesApi.placeDetailsSearchFromText(iv.place);
    //     if (place != null) {
    //       _places[iv.place] = place;
    //       print(place.id);
    //     }
    //   }
    // }
    // var result =
    //     await _trackerController.sortBasedOnToExploreAndExplored(_invites);
    // _toExplore = result[0];
    // _explored = result[1];
    setState(() {
      _isLoaded = true;
    });
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
                // Navigator.pushNamed(context, PlaceScreen.routeName,
                //     arguments: PlaceScreenArguments(
                //         _places[list[index].getPlace()]!, _favourites));
              },
              child: placeContainer(
                  _places[list[index].getPlace()]!,
                  0.8 * width,
                  0.3 * height,
                  // _inviteContainer(list[index], width),
                  Container()),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
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
                        child: topBar('my tracker', height, width,
                            'assets/img/tracker-top.svg'),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      textMajor('to explore', Color(0xff22254C), 26),
                      _toExplore.length != 0
                          ? _exploreList(_toExplore, height, width)
                          : Container(),
                      FittedBox(
                          fit: BoxFit.fill,
                          child: SvgPicture.asset('assets/img/tracker-mid.svg',
                              width: width, height: width)),
                      textMajor('explored', Color(0xff22254C), 26),
                      _explored.length != 0
                          ? _exploreList(_explored, height, width)
                          : Container(),
                      SizedBox(
                        height: 35,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
