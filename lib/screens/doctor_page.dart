//Flutter Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/globals/responsive.dart';
import 'package:customer/screens/time_slot.dart';
import 'package:customer/theme/app_theme.dart';
import 'package:customer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DoctorPage extends StatefulWidget {
  final String hosptialID;
  final String doctorID;
  DoctorPage({this.doctorID, this.hosptialID});
  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
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
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
            title: Text(snapshot != null ? snapshot.data()['name'] : '',
                style: TextStyle(
                    fontFamily: AppTheme.poppins,
                    fontWeight: FontWeight.bold))),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 10),
              Card(
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
                                        image: NetworkImage(
                                            snapshot.data()['profile']))
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
                                  snapshot != null
                                      ? snapshot.data()['name']
                                      : '',
                                  style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 16,
                                      fontFamily: AppTheme.poppinsBold),
                                ),
                                Text(
                                  '${snapshot != null ? ((snapshot.data()['special1'] ?? '') + ' ' + (snapshot.data()['special2'] ?? '') + ' ' + (snapshot.data()['special3'] ?? '') + ' ' + (snapshot.data()['special4'] ?? '') + ' ' + (snapshot.data()['special5'] ?? '')) : ""}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: AppTheme.poppins),
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
                                    color:
                                        available ? Colors.green : Colors.red,
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
                                  fontFamily: AppTheme.poppins,
                                  color: Colors.green),
                            ))
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Clinic Details',
                          style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppTheme.poppins)),
                      SizedBox(height: 2),
                      Divider(),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: size(160),
                            child: Text(
                                '${snapshot != null ? snapshot.data()['hospital'] : ''}',
                                style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontFamily: AppTheme.poppinsBold)),
                          ),
                          Text(
                              'Rs. ${snapshot != null ? snapshot.data()['fees'] : ''}',
                              style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontFamily: AppTheme.poppins)),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                          'Address: ${snapshot != null ? snapshot.data()['address'] : ''}',
                          style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 10),
                      if (available)
                        GestureDetector(
                          onTap: () => Get.to(SlotPage(
                            doctorID: widget.doctorID,
                            hosptialID: widget.hosptialID,
                          )),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(8)),
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: Text('Appointment Details',
                                style: TextStyle(
                                    color: AppTheme.whiteColor,
                                    fontSize: 14,
                                    fontFamily: AppTheme.poppins,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Services',
                          style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppTheme.poppins)),
                      SizedBox(height: 2),
                      Divider(),
                      SizedBox(height: 4),
                      Text(
                          '${snapshot != null ? snapshot.data()['service1'] ?? '' : ''}',
                          style: TextStyle(
                              fontSize: 12, fontFamily: AppTheme.poppins)),
                      SizedBox(height: 4),
                      Text(
                          '${snapshot != null ? snapshot.data()['service2'] ?? '' : ''}',
                          style: TextStyle(
                              fontSize: 12, fontFamily: AppTheme.poppins)),
                      SizedBox(height: 4),
                      Text(
                          '${snapshot != null ? snapshot.data()['service3'] ?? '' : ''}',
                          style: TextStyle(
                              fontSize: 12, fontFamily: AppTheme.poppins)),
                      SizedBox(height: 4),
                      Text(
                          '${snapshot != null ? snapshot.data()['service4'] ?? '' : ''}',
                          style: TextStyle(
                              fontSize: 12, fontFamily: AppTheme.poppins)),
                      SizedBox(height: 4),
                      Text(
                          '${snapshot != null ? snapshot.data()['service5'] ?? '' : ''}',
                          style: TextStyle(
                              fontSize: 12, fontFamily: AppTheme.poppins)),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Specialization',
                          style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppTheme.poppins)),
                      SizedBox(height: 2),
                      Divider(),
                      Text(
                          '${snapshot != null ? snapshot.data()['special1'] ?? '' : ''}',
                          style: TextStyle(
                              fontSize: 12, fontFamily: AppTheme.poppins)),
                      SizedBox(height: 4),
                      Text(
                          '${snapshot != null ? snapshot.data()['special2'] ?? '' : ''}',
                          style: TextStyle(
                              fontSize: 12, fontFamily: AppTheme.poppins)),
                      SizedBox(height: 4),
                      Text(
                          '${snapshot != null ? snapshot.data()['special3'] ?? '' : ''}',
                          style: TextStyle(
                              fontSize: 12, fontFamily: AppTheme.poppins)),
                      SizedBox(height: 4),
                      Text(
                          '${snapshot != null ? snapshot.data()['special4'] ?? '' : ''}',
                          style: TextStyle(
                              fontSize: 12, fontFamily: AppTheme.poppins)),
                      SizedBox(height: 4),
                      Text(
                          '${snapshot != null ? snapshot.data()['special5'] ?? '' : ''}',
                          style: TextStyle(
                              fontSize: 12, fontFamily: AppTheme.poppins)),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Education',
                          style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppTheme.poppins)),
                      SizedBox(height: 2),
                      Divider(),
                      SizedBox(height: 4),
                      Text(
                          '${snapshot != null ? snapshot.data()['education1'] ?? '' : ''}',
                          style: TextStyle(
                              fontSize: 12, fontFamily: AppTheme.poppins)),
                      SizedBox(height: 4),
                      Text(
                          '${snapshot != null ? snapshot.data()['education2'] ?? '' : ''}',
                          style: TextStyle(
                              fontSize: 12, fontFamily: AppTheme.poppins)),
                      SizedBox(height: 4),
                      Text(
                          '${snapshot != null ? snapshot.data()['education3'] ?? '' : ''}',
                          style: TextStyle(
                              fontSize: 12, fontFamily: AppTheme.poppins)),
                      SizedBox(height: 4),
                      Text(
                          '${snapshot != null ? snapshot.data()['education4'] ?? '' : ''}',
                          style: TextStyle(
                              fontSize: 12, fontFamily: AppTheme.poppins)),
                      SizedBox(height: 4),
                      Text(
                          '${snapshot != null ? snapshot.data()['education5'] ?? '' : ''}',
                          style: TextStyle(
                              fontSize: 12, fontFamily: AppTheme.poppins)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
