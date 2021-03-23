//Flutter Imports
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/constants/resources.dart';
import 'package:customer/globals/responsive.dart';
import 'package:customer/theme/app_theme.dart';
import 'package:customer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'doctor_page.dart';

class HospitalPage extends StatefulWidget {
  final String hospitalID;
  final String name;
  HospitalPage({this.hospitalID, this.name});
  @override
  _HospitalPageState createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  List<Widget> _banners = [];
  List<DoctorCard> _doctors = [];

  @override
  void initState() {
    super.initState();
    getBanners();
    getDoctors();
  }

  getBanners() async {
    try {
      _banners = [];
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
        Utils.showProgressBar();
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Hospital')
            .doc(widget.hospitalID)
            .collection('Banner Section')
            .get();
        if (querySnapshot != null) {
          if (querySnapshot.docs != null) {
            if (querySnapshot.docs.isNotEmpty) {
              for (int index = 0; index < querySnapshot.docs.length; index++) {
                _banners.add(Stack(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      child: Container(
                        width: size(50),
                        height: size(50),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                        child: CircularProgressIndicator(
                            backgroundColor: AppTheme.primaryAccent),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: size(15)),
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(querySnapshot.docs[index]
                                  .data()['bannerURL']),
                            ),
                            borderRadius: BorderRadius.circular(10))),
                  ],
                ));
              }
            }
          }
        }
        Get.back();
        Future.delayed(Duration(milliseconds: 100))
            .whenComplete(() => setState(() {}));
      });
    } catch (error) {
      Get.back();
      print(error);
    }
  }

  getDoctors() async {
    try {
      _doctors = [];
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
        Utils.showProgressBar();
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Hospital')
            .doc(widget.hospitalID)
            .collection('Doctors')
            .get();
        if (querySnapshot != null) {
          if (querySnapshot.docs != null) {
            for (int index = 0; index < querySnapshot.docs.length; index++) {
              _doctors.add(DoctorCard(
                  hosptialID: widget.hospitalID,
                  doctorID: querySnapshot.docs[index].id));
            }
          }
        }
        Get.back();
        setState(() {});
      });
    } catch (error) {
      Get.back();
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
            centerTitle: true,
            title: Text(widget.name ?? '',
                style: TextStyle(
                    fontFamily: AppTheme.poppins,
                    fontWeight: FontWeight.bold))),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 10),
              CarouselSlider(
                  items: [if (_banners.length > 0) ..._banners],
                  options: CarouselOptions(
                    height: 200,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  )),
              SizedBox(height: 10),
              if (_doctors.length > 0) ..._doctors
            ],
          ),
        )));
  }
}

class DoctorCard extends StatefulWidget {
  final String hosptialID, doctorID;
  DoctorCard({this.hosptialID, this.doctorID});
  @override
  _DoctorCardState createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  DocumentSnapshot snapshot;
  bool available = true;
  int total = 0;
  String date = '';
  String _openingTime = '';
  String _closingTime = '';

  @override
  void initState() {
    super.initState();
    getDoctorInfo();
  }

  getDoctorInfo() async {
    try {
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
        Utils.showProgressBar();
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('Hospital')
            .doc(widget.hosptialID)
            .collection('Doctors')
            .doc(widget.doctorID)
            .get();
        Get.back();

        int availabl = 0;
        snapshot = documentSnapshot;
        dynamic data = snapshot.data();
        int totalTokens = int.parse(data['tokens']);
        for (int index = 0; index < totalTokens; index++) {
          String date = data[(index + 1).toString()];
          if (DateTime.now().day != DateTime.parse(date).day) {
            availabl++;
          }
        }
        setState(() {
          _openingTime =
              DateFormat('hh:mm a').format(DateTime.parse(data['OpeningTime']));
          _closingTime =
              DateFormat('hh:mm a').format(DateTime.parse(data['ClosingTime']));
          if (DateTime.now().weekday == 1) {
            available = data['monday'];
          } else if (DateTime.now().weekday == 2) {
            available = data['tuesday'];
          } else if (DateTime.now().weekday == 3) {
            available = data['wednesday'];
          } else if (DateTime.now().weekday == 4) {
            available = data['thursday'];
          } else if (DateTime.now().weekday == 5) {
            available = data['friday'];
          } else if (DateTime.now().weekday == 6) {
            available = data['saturday'];
          } else if (DateTime.now().weekday == 7) {
            available = data['sunday'];
          }
          if (available) {
            if (availabl == 0) {
              available = false;
            }
            if (DateTime.now()
                .hour
                .isGreaterThan(DateTime.parse(data['ClosingTime']).hour)) {
              available = false;
            }
          }
          total = availabl;
        });
      });
    } catch (error) {
      Get.back();
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.41),
                      image: snapshot != null
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(snapshot.data()['profile']))
                          : null,
                      borderRadius: BorderRadius.circular(1000)),
                ),
                SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot != null ? snapshot.data()['name'] : '',
                        style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 16,
                            fontFamily: AppTheme.poppinsBold),
                      ),
                      Text(
                        '${snapshot != null ? ((snapshot.data()['special1'] ?? '') + ' ' + (snapshot.data()['special2'] ?? '') + ' ' + (snapshot.data()['special3'] ?? '') + ' ' + (snapshot.data()['special4'] ?? '') + ' ' + (snapshot.data()['special5'] ?? '')) : ""}',
                        style: TextStyle(
                            fontSize: 14, fontFamily: AppTheme.poppins),
                      ),
                      Text(
                        '${snapshot != null ? ((snapshot.data()['education1'] ?? '') + ' ' + (snapshot.data()['education2'] ?? '') + ' ' + (snapshot.data()['education3'] ?? '') + ' ' + (snapshot.data()['education4'] ?? '') + ' ' + (snapshot.data()['education5'] ?? '')) : ""}',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: AppTheme.poppins),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      '${snapshot != null ? snapshot.data()['years'] : ''} Years',
                      style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTheme.poppins),
                    ),
                    Text(
                      'Experience',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: AppTheme.poppins),
                    ),
                  ],
                ),
                if (available)
                  Column(
                    children: [
                      Text(
                        'Open',
                        style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppTheme.poppins),
                      ),
                      Text(
                        _openingTime,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: AppTheme.poppins),
                      ),
                    ],
                  ),
                if (available)
                  Column(
                    children: [
                      Text(
                        'Close',
                        style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppTheme.poppins),
                      ),
                      Text(
                        _closingTime,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: AppTheme.poppins),
                      ),
                    ],
                  ),
                Column(
                  children: [
                    Text(
                      'Today',
                      style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTheme.poppins),
                    ),
                    Text(
                      available ? 'Available' : 'Not Available',
                      style: TextStyle(
                          color: available ? Colors.green : Colors.red,
                          fontSize: 12,
                          fontFamily: AppTheme.poppins),
                    ),
                  ],
                ),
              ],
            ),
            if (available)
              Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '$total tokens Available',
                    style: TextStyle(
                        fontFamily: AppTheme.poppins, color: Colors.green),
                  )),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DoctorPage(
                            hosptialID: widget.hosptialID,
                            doctorID: widget.doctorID,
                          ))),
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.primaryColor),
                      borderRadius: BorderRadius.circular(8)),
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Book Appointment & More',
                          style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppTheme.poppins)),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, size: 20)
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
