//Flutter Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/globals/responsive.dart';
import 'package:customer/globals/user_details.dart';
import 'package:customer/screens/payment.dart';
import 'package:customer/screens/splash_screen.dart';
import 'package:customer/services/auth.dart';
import 'package:customer/theme/app_theme.dart';
import 'package:customer/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  File _profilePicture;
  String _profileImage = '';
  String _location = '';
  List<String> _locations = [];
  bool _membership = false;
  bool _isExpired = true;
  String _days = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  pickImage() async {
    try {
      ImagePicker imagePicker = ImagePicker();
      PickedFile file = await imagePicker.getImage(
          source: ImageSource.gallery, imageQuality: 65);
      if (file != null) {
        _profilePicture = File(file.path);
      }
      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  getData() async {
    Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
      try {
        Utils.showProgressBar();
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('User')
            .doc(currentUser.phoneNumber)
            .get();
        _nameController.text = snapshot.data()['name'] ?? '';
        _addressController.text = snapshot.data()['address'] ?? '';
        _profileImage = snapshot.data()['profilePicture'] ?? '';
        _location = snapshot.data()['location'] ?? '';
        _membership = snapshot.data()['membership'] ?? false;
        if (!_membership) {
          DateTime _creationDate = DateTime.parse(snapshot.data()['createdAt']);
          DateTime _expiresOn = _creationDate.add(Duration(days: 30));
          _days =
              _expiresOn.difference(DateTime.now()).inDays.toString() + ' Days';
          if (_expiresOn.isBefore(DateTime.now())) {
            _isExpired = true;
          }
        }

        DocumentSnapshot locationSnapshot = await FirebaseFirestore.instance
            .collection('Admin')
            .doc('Locations')
            .get();
        if (locationSnapshot.exists) {
          _locations = [];
          if (locationSnapshot.data()['Locations'] != null) {
            for (int index = 0;
                index < locationSnapshot.data()['Locations'].length;
                index++) {
              _locations.add(locationSnapshot.data()['Locations'][index]);
            }
          }
        }
        Get.back();
        setState(() {});
      } catch (error) {
        print(error);
        Get.back();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('User Profile',
            style: TextStyle(
              fontFamily: AppTheme.poppinsBold,
            )),
        actions: [
          GestureDetector(
            onTap: () async {
              try {
                Utils.showProgressBar();
                await FirebaseFirestore.instance
                    .collection('User')
                    .doc(currentUser.phoneNumber)
                    .update({'fcmToken': ''});
                await FirebaseAuth.instance.signOut();
                Get.back();
                Get.offAll(SplashScreen());
              } catch (error) {
                Get.back();
                print(error);
              }
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: size(10)),
              child: Text(
                'Logout',
                style: TextStyle(color: AppTheme.whiteColor),
              ),
            ),
          )
        ],
      ),
      body: Container(
          width: double.infinity,
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(height: size(15)),
              Column(
                children: [
                  Text(
                      'Membership Status : ' +
                          (_membership ? 'Premium' : 'Trial Period'),
                      style: TextStyle(
                          fontFamily: AppTheme.poppinsBold,
                          color: _membership ? Colors.green : Colors.orange)),
                  if (!_membership) Text('Trial Expires in : ' + (_days)),
                  if (!_membership)
                    RaisedButton(
                      color: AppTheme.primaryAccent,
                      onPressed: () async {
                        try {
                          dynamic response = await Get.to(Payment());
                          if (response) ;
                        } catch (error) {
                          print(error);
                          getData();
                        }
                      },
                      child: Text(
                        'Start Membership',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
              SizedBox(height: size(15)),
              _profilePicture == null && _profileImage == ''
                  ? GestureDetector(
                      onTap: () async => await pickImage(),
                      child: CircleAvatar(
                        child: Icon(Icons.add),
                        radius: size(25),
                      ),
                    )
                  : GestureDetector(
                      onTap: () async => await pickImage(),
                      child: Container(
                          height: size(70),
                          width: size(70),
                          decoration: BoxDecoration(
                              color: AppTheme.primaryAccent.withOpacity(0.21),
                              borderRadius: BorderRadius.circular(1000),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: _profilePicture != null
                                      ? FileImage(_profilePicture)
                                      : NetworkImage(_profileImage)))),
                    ),
              SizedBox(height: size(5)),
              Text('Profile Picture',
                  style: TextStyle(fontFamily: AppTheme.poppins)),
              _textField(controller: _nameController, hintText: 'Name'),
              _textField(
                  controller: _addressController,
                  hintText: 'Address',
                  maxLines: 4),
              if (_locations.length > 0) _locationField(),
              SizedBox(height: 50),
              RaisedButton(
                onPressed: () async {
                  if (_nameController.text.trim() == '') {
                    Utils.showError('Please Enter Valid Name');
                  } else if (_addressController.text.trim() == '') {
                    Utils.showError('Please Enter Valid Address');
                  } else if (!await Utils.checkInternet()) {
                    Utils.showError('Please Check Your Connection');
                  } else {
                    try {
                      userLocation = _location;
                      Utils.showProgressBar();
                      await FirebaseFirestore.instance
                          .collection('User')
                          .doc(currentUser.phoneNumber)
                          .update({
                        'name': _nameController.text.trim(),
                        'address': _addressController.text.trim(),
                        'profilePicture': _profilePicture == null
                            ? _profileImage
                            : await Auth.uploadPhoto(_profilePicture),
                        'location': _location
                      });
                      await currentUser.updateProfile(
                        displayName: _nameController.text,
                      );
                      currentUser = FirebaseAuth.instance.currentUser;
                      Get.back();
                      Utils.showsuccess("Your Profile Updated !");
                    } catch (error) {
                      print(error);
                      Get.back();
                    }
                  }
                },
                color: AppTheme.primaryAccent,
                child: Text('Update Profile',
                    style: TextStyle(color: AppTheme.whiteColor)),
              )
            ],
          ))),
    );
  }

  Widget _textField(
      {TextEditingController controller,
      int maxLength,
      String hintText,
      int maxLines}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size(15), vertical: size(15)),
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        keyboardType: TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          counterText: '',
          hintText: hintText,
          labelText: hintText,
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

  Widget _locationField() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: size(15), vertical: size(15)),
        child: DropdownButtonFormField<String>(
          value: _location != '' ? _location : 'Amravati',
          items: _locations.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(child: Text(value)),
            );
          }).toList(),
          onChanged: (location) => setState(() {
            _location = location;
          }),
        ));
  }
}
