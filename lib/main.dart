import 'package:hidden_gems_sg/screens/base_ui.dart';
import 'package:hidden_gems_sg/screens/forgot_password_ui.dart';
import 'package:hidden_gems_sg/screens/login_ui.dart';
import 'package:hidden_gems_sg/screens/sign_up_ui.dart';
import 'package:hidden_gems_sg/screens/splash_ui.dart';
import 'package:hidden_gems_sg/screens/verify_ui.dart';
import 'package:hidden_gems_sg/theme/theme_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hidden_gems_sg/screens/interests_ui.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      initialRoute: '/',
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        BaseScreen.routeName: (context) => BaseScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        VerifyScreen.routeName: (context) => VerifyScreen(),
        ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case InterestScreen.routeName: {
            final InterestScreenArguments args = settings.arguments as InterestScreenArguments;
            return MaterialPageRoute(builder: (context) {
              return InterestScreen(args.userID, args.userInts);
            });
            // ignore: dead_code
            break;
          }
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


