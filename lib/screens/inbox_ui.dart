import 'package:flutter/material.dart';
import 'package:hidden_gems_sg/models/invitation.dart';
import 'package:hidden_gems_sg/helper/utils.dart';

class InboxScreen extends StatefulWidget {
  @override
  State<InboxScreen> createState() => _InboxScreen();
}

class _InboxScreen extends State<InboxScreen> {
  bool _isLoaded = false;
  List<Invitation> _inbox = [];

  @override
  void initState() {
    super.initState();
    _loadInbox();
  }

  void _loadInbox() {
    setState(() {
      _isLoaded = true;
    });
  }

  void _reload() async {
    _isLoaded = false;
    setState(() {});
    _loadInbox();
  }

  Widget _inboxList(double width) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _inbox.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            InkWell(
                onTap: () {
                  //   Navigator.pushNamed(context, PlaceScreen.routeName,
                  //       arguments: PlaceScreenArguments(
                  //           _places[_inbox[index].getPlace()]!, _favourites));
                },
                child: Container(
                  width: width,
                )
                // child: _invitationContainer(index, width, _inbox[index],
                //     _places[_inbox[index].getPlace()]!),
                ),
            SizedBox(
              height: 5,
            )
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
            child: Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _reload();
                        },
                        child: topBar('my inbox', height, width,
                            'assets/img/inbox-top.svg'),
                        //_inboxList(width)
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onRefresh: () async {
              setState(() {
                _isLoaded = false;
              });
              _reload();
            })
        : Container(
            color: Color(0XffFFF9ED),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
