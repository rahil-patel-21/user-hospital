import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Utils {
  Utils._();

  //Check if Internet availability is there or not
  static Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      return false;
    }
  }

  //Show ProgressBar
  static showProgressBar() {
    return Get.dialog(Center(child: CircularProgressIndicator()),
        barrierDismissible: false);
  }

  // Mobile Valid
  static bool mobileValid(String number) {
    bool numberValid = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(number);
    return numberValid;
  }

  //Show Success
  static void showsuccess(String msg) {
    Future.delayed(Duration(milliseconds: 100)).whenComplete(() {
      Get.snackbar('Great !', msg);
    });
  }

  //Show Error
  static void showError(String msg) {
    Future.delayed(Duration(milliseconds: 100)).whenComplete(() {
      Get.snackbar('Alert !', msg);
    });
  }
}
