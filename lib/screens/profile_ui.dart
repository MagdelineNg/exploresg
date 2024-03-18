import 'package:flutter/material.dart';
import 'package:hidden_gems_sg/screens/login_ui.dart';
import 'package:hidden_gems_sg/helper/user_controller.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Define the async function for logging out
  Future<void> _logout() async {
    await UserController.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const LoginScreen(), // Ensure LoginScreen is imported correctly
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        // Use a Column or other layout widget if you want to add more widgets
        child: ElevatedButton(
          onPressed: () => _logout(), // Call the async function here
          child: Text("Logout"),
        ),
      ),
    );
  }
}