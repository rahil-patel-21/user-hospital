//Flutter Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/constants/resources.dart';
import 'package:customer/globals/user_details.dart';
import 'package:customer/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'homepage.dart';
import 'log_in_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUserStatus();
  }

  goToNext() {
    Future.delayed(Duration(seconds: 3)).whenComplete(() =>
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LogInScreen()),
            (route) => false));
  }

  checkUserStatus() async {
    Future.delayed(Duration(seconds: 3)).whenComplete(() async {
      User user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        currentUser = user;
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('User')
            .doc(currentUser.phoneNumber)
            .get();
        userLocation = snapshot.data()['location'];
        Get.offAll(HomePage());
      } else {
        Get.offAll(LogInScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Image.asset(logoJPEG),
      ),
    );
  }
}
