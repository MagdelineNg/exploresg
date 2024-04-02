import 'dart:async';
import 'package:hidden_gems_sg/helper/auth_controller.dart';
import 'package:hidden_gems_sg/screens/base_ui.dart';
import 'package:hidden_gems_sg/screens/login_ui.dart';
import 'package:flutter/material.dart';
import '../helper/utils.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  final AuthController _auth = AuthController();

  @override
  void initState() {
    super.initState();
    _timer();
  }

  Future<Timer> _timer() async {
    var d = const Duration(seconds: 3);
    return Timer(d, _homePage);
  }

  void _homePage() {
    var user = _auth.getCurrentUser();
    if (user != null) {
      Navigator.pushReplacementNamed(context, BaseScreen.routeName);
    } else {
      // Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Image.asset('assets/img/splash.png',
                height: height, width: width, fit: BoxFit.fill),
            Positioned(
              top: height / 4,
              left: width / 4.5,
              child: textMajor('explore', const Color(0xff22254C), 36),
            ),
            Positioned(
                top: height / 3.5,
                left: width / 2.2,
                child: textMajor('SG', const Color(0xff22254C), 36)),
            Positioned(
              top: height / 2.9,
              left: width / 4.5,
              child: SizedBox(
                width: width / 1.8,
                child: textMinor(
                    'discover new places and invite your friends to go together!',
                    const Color(0xff22254C)),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textMinor('Copyright HDMILF 2022', const Color(0xff22254C)),
                    textMinor('All rights reserved', const Color(0xff22254C))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
