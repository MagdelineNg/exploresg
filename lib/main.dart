import 'package:flutter/material.dart';
import 'package:hidden_gems_sg/screens/base_ui.dart';
import 'package:hidden_gems_sg/screens/home_ui.dart';
import 'package:hidden_gems_sg/screens/login_ui.dart';
import 'package:hidden_gems_sg/screens/sign_up_ui.dart';
import 'package:hidden_gems_sg/screens/verify_ui.dart';
import 'package:hidden_gems_sg/theme/theme_constants.dart';
// import 'package:hidden_gems_sg/screens/splash_ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';
import 'helper/user_controller.dart';

void main() async {
  // Ensure that Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Then run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // User is null if not logged in
              return snapshot.data != null ? BaseScreen() : const LoginScreen();
            }
            return const CircularProgressIndicator(); // Show loading indicator while waiting for auth state
          },
        ),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        VerifyScreen.routeName: (context) => const VerifyScreen(),
        // Define other routes as needed
      },
    );
  }
}


