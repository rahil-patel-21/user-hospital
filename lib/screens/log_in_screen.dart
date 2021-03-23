//Flutter Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/constants/resources.dart';
import 'package:customer/globals/responsive.dart';
import 'package:customer/globals/user_details.dart';
import 'package:customer/theme/app_theme.dart';
import 'package:customer/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'homepage.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController _numberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  bool _codeSent = false;

  String _verificationID = '';

  @override
  void dispose() {
    super.dispose();
    _numberController.dispose();
    _otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: AppTheme.offWhite,
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size(25)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: size(50)),
              Container(
                height: size(60),
                child: Image.asset(logoJPEG),
              ),
              Container(
                alignment: Alignment.center,
                child: Text('Log in',
                    style: TextStyle(
                        fontFamily: AppTheme.poppinsBold, fontSize: 20)),
              ),
              SizedBox(height: size(20)),
              SvgPicture.asset(logInSVG, height: size(125)),
              SizedBox(height: size(20)),
              _textField(
                  hintText: 'Enter 10 digit mobile number',
                  maxLength: 10,
                  controller: _numberController),
              if (_codeSent)
                Column(
                  children: [
                    SizedBox(
                      height: size(10),
                    ),
                    _textField(
                        hintText: 'Enter 6 Digit OTP',
                        maxLength: 6,
                        controller: _otpController),
                  ],
                ),
              SizedBox(height: size(20)),
              GestureDetector(
                onTap: () async {
                  if (!Utils.mobileValid(_numberController.text.trim())) {
                    Utils.showError('Please Enter Valid Number');
                  } else if (_numberController.text.trim().length != 10) {
                    Utils.showError('Please Enter Valid Number');
                  } else if (!await Utils.checkInternet()) {
                    Utils.showError('Please Check Your Connection');
                  } else if (!_codeSent) {
                    Utils.showProgressBar();
                    await verifyPhone(_numberController.text, context);
                  } else if (_otpController.text.trim().length != 6) {
                    Utils.showError('Please Enter Valid OTP');
                  } else {
                    await verifyOTP();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue',
                        style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.primaryColor,
                            fontFamily: AppTheme.poppinsBold)),
                    SizedBox(width: size(5)),
                    Icon(Icons.arrow_forward,
                        size: size(15), color: AppTheme.primaryColor)
                  ],
                ),
              )
            ],
          ),
        )));
  }

  Widget _textField(
      {TextEditingController controller, int maxLength, String hintText}) {
    return Padding(
      padding: EdgeInsets.symmetric(),
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: '',
          hintText: hintText,
          hintStyle: TextStyle(
              fontFamily: AppTheme.poppins, color: AppTheme.primaryColor),
          enabledBorder: new OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppTheme.primaryColor, width: 1.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            ),
          ),
          focusedBorder: new OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppTheme.primaryColor, width: 1.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            ),
          ),
          disabledBorder: new OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppTheme.primaryColor, width: 1.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            ),
          ),
          border: new OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppTheme.primaryColor, width: 1.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verifyOTP() async {
    try {
      Utils.showProgressBar();
      AuthCredential authCreds = PhoneAuthProvider.credential(
          verificationId: _verificationID, smsCode: _otpController.text.trim());
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCreds);
      Get.back();
      await saveUserDetails(userCredential);
    } catch (error) {
      Get.back();
      print(error);
    }
  }

  Future<String> getFCMToken() async {
    try {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
      String fcmToken = await _firebaseMessaging.getToken();
      return fcmToken;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> saveUserDetails(UserCredential userCredential) async {
    try {
      Utils.showProgressBar();
      currentUser = userCredential.user;
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(currentUser.phoneNumber)
          .get();
      if (documentSnapshot.exists) {
        await FirebaseFirestore.instance
            .collection('User')
            .doc(currentUser.phoneNumber)
            .update({'fcmToken': await getFCMToken()});
      } else {
        await FirebaseFirestore.instance
            .collection('User')
            .doc(currentUser.phoneNumber)
            .set({
          'fcmToken': await getFCMToken(),
          'createdAt': DateTime.now().toString(),
          'name': '',
          'address': '',
          'profilePicture': '',
          'location': '',
          'membership': false
        });
      }
      Get.back();
      Get.offAll(HomePage());
    } catch (error) {
      print(error);
      Get.back();
    }
  }

  Future<void> verifyPhone(phoneNo, BuildContext context) async {
    final PhoneVerificationCompleted verified =
        (AuthCredential authResult) async {
      Utils.showProgressBar();
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(authResult);
      Get.back();
      await saveUserDetails(userCredential);
    };

    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
      setState(() {
        _codeSent = false;
      });
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      _verificationID = verId;
      setState(() {
        _codeSent = true;
      });
      Get.back();
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      _verificationID = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91' + phoneNo,
        timeout: const Duration(seconds: 50),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
