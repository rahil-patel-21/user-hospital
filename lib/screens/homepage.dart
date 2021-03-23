//Flutter Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/constants/resources.dart';
import 'package:customer/globals/responsive.dart';
import 'package:customer/globals/user_details.dart';
import 'package:customer/screens/find_doctor.dart';
import 'package:customer/screens/find_hospital.dart';
import 'package:customer/screens/hospital_page.dart';
import 'package:customer/screens/profile_screen.dart';
import 'package:customer/theme/app_theme.dart';
import 'package:customer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'doctor_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _suggestionsController = TextEditingController();
  List<Widget> _hospitals = [];

  @override
  void dispose() {
    super.dispose();
    _suggestionsController.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkUserStatus();
    getHospitals();
  }

  checkUserStatus() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(currentUser.phoneNumber)
          .get();
      if (snapshot.exists) {
        if (snapshot.data()['name'] == '') {
          Utils.showError('Please Update Profile Data');
          Future.delayed(Duration(seconds: 3)).whenComplete(() async {
            try {
              dynamic response = await Get.to(ProfilePage());

              if (response) {}
            } catch (error) {
              print(error);
              setState(() {});
              checkUserStatus();
              getHospitals();
            }
          });
        }
      }
    } catch (error) {
      print(error);
    }
  }

  getHospitals() async {
    try {
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
        _hospitals = [];
        Utils.showProgressBar();
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('Hospital').get();
        if (querySnapshot != null) {
          if (querySnapshot.docs.length > 0) {
            for (int index = 0;
                index <
                    (querySnapshot.docs.length > 6
                        ? 6
                        : querySnapshot.docs.length);
                index++) {
              if (querySnapshot.docs[index].data()['location'] == userLocation)
                _hospitals.add(GestureDetector(
                  onTap: () => Get.to(HospitalPage(
                    hospitalID: querySnapshot.docs[index].id,
                    name: querySnapshot.docs[index].data()['name'],
                  )),
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.28,
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: Column(
                      children: [
                        Container(
                          height: 65,
                          width: 65,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey.withOpacity(0.41),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(querySnapshot.docs[index]
                                      .data()['profilePicture'])),
                              borderRadius: BorderRadius.circular(1000)),
                        ),
                        Text(querySnapshot.docs[index].data()['name'],
                            style: TextStyle(fontFamily: AppTheme.poppins))
                      ],
                    ),
                  ),
                ));
            }
          }
        }
        setState(() {});
        Get.back();
      });
    } catch (error) {
      print(error);
      Get.back();
    }
  }

  PageController _pageController = PageController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.offWhite,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () async {
              try {
                dynamic response = await Get.to(ProfilePage());
                if (response) {}
              } catch (error) {
                print(error);
                setState(() {});
              }
            },
            child: Padding(
                padding: EdgeInsets.all(10),
                child: CircleAvatar(
                    child: Icon(Icons.person, color: AppTheme.whiteColor),
                    backgroundColor: AppTheme.primaryColor,
                    radius: 20)),
          ),
          title: Container(
            height: size(35),
            child: Image.asset(logoJPEG),
          ),
          actions: [
            Icon(Icons.location_on, color: AppTheme.primaryAccent),
            SizedBox(width: 5),
            Container(
                alignment: Alignment.center,
                child: Text(userLocation ?? '',
                    style: TextStyle(
                        fontFamily: AppTheme.poppins,
                        color: AppTheme.primaryColor))),
            SizedBox(width: 5)
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _pageController.jumpToPage(0);
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home,
                        color: AppTheme.primaryColor,
                        size: 30,
                      ),
                      if (index == 0)
                        Text('Home',
                            style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontFamily: AppTheme.poppinsBold)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _pageController.jumpToPage(1);
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppTheme.primaryColor,
                        size: 30,
                      ),
                      if (index == 1)
                        Text('Appointments',
                            style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontFamily: AppTheme.poppinsBold)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _pageController.jumpToPage(2);
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.feedback,
                        color: AppTheme.primaryColor,
                        size: 30,
                      ),
                      if (index == 2)
                        Text('Feedback',
                            style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontFamily: AppTheme.poppinsBold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: currentUser.displayName != null
            ? SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        AppBar().preferredSize.height,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) => setState(() {
                        this.index = index;
                      }),
                      children: [
                        SingleChildScrollView(
                            child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: Column(
                            children: [
                              Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text('Find Doctor or Hospital',
                                              style: TextStyle(
                                                  fontFamily: AppTheme.poppins,
                                                  fontSize: 12)),
                                          SizedBox(height: 5),
                                          TextField(
                                            decoration: InputDecoration(
                                              prefixIcon: Container(
                                                child: Icon(
                                                  Icons.search,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              hintText: 'Search Name ...',
                                              hintStyle: TextStyle(
                                                  fontFamily: AppTheme.poppins,
                                                  color: AppTheme.primaryColor),
                                              enabledBorder:
                                                  new OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color:
                                                        AppTheme.primaryColor,
                                                    width: 1.0),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  const Radius.circular(8.0),
                                                ),
                                              ),
                                              focusedBorder:
                                                  new OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color:
                                                        AppTheme.primaryColor,
                                                    width: 1.0),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  const Radius.circular(8.0),
                                                ),
                                              ),
                                              disabledBorder:
                                                  new OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color:
                                                        AppTheme.primaryColor,
                                                    width: 1.0),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  const Radius.circular(8.0),
                                                ),
                                              ),
                                              border: new OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color:
                                                        AppTheme.primaryColor,
                                                    width: 1.0),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  const Radius.circular(8.0),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                              SizedBox(height: 5),
                              Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text('Top Facilities',
                                              style: TextStyle(
                                                  fontFamily: AppTheme.poppins,
                                                  fontSize: 12)),
                                          SizedBox(height: 5),
                                          if (_hospitals.length > 0)
                                            Wrap(
                                              children: [
                                                ..._hospitals,
                                              ],
                                            ),
                                          GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FindAHospitalPage())),
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppTheme
                                                            .primaryColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text('Find other hospitals',
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily: AppTheme
                                                                .poppins)),
                                                    SizedBox(width: 10),
                                                    Icon(Icons.arrow_forward,
                                                        size: 20)
                                                  ],
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                              SizedBox(height: 5),
                              SizedBox(height: size(50))
                            ],
                          ),
                        )),
                        MyAppointments(),
                        Column(
                          children: [
                            Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text('Let us Know',
                                            style: TextStyle(
                                                fontFamily: AppTheme.poppins,
                                                fontSize: 12)),
                                        SizedBox(height: 5),
                                        TextField(
                                          controller: _suggestionsController,
                                          maxLines: 4,
                                          decoration: InputDecoration(
                                            hintText:
                                                'Type Suggestions / Feedback',
                                            hintStyle: TextStyle(
                                                fontFamily: AppTheme.poppins,
                                                color: AppTheme.primaryColor),
                                            enabledBorder:
                                                new OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: AppTheme.primaryColor,
                                                  width: 1.0),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(8.0),
                                              ),
                                            ),
                                            focusedBorder:
                                                new OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: AppTheme.primaryColor,
                                                  width: 1.0),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(8.0),
                                              ),
                                            ),
                                            disabledBorder:
                                                new OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: AppTheme.primaryColor,
                                                  width: 1.0),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(8.0),
                                              ),
                                            ),
                                            border: new OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: AppTheme.primaryColor,
                                                  width: 1.0),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        RaisedButton(
                                            color: Colors.orange,
                                            onPressed: () async {
                                              if (_suggestionsController.text
                                                      .trim() ==
                                                  '') {
                                                Utils.showError(
                                                    'Please enter feedback first');
                                              } else if (!await Utils
                                                  .checkInternet()) {
                                                Utils.showError(
                                                    'Please check your connection');
                                              } else {
                                                try {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  Utils.showProgressBar();
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Admin')
                                                      .doc('Feedback')
                                                      .collection('List')
                                                      .doc(DateTime.now()
                                                          .toString())
                                                      .set({
                                                    'name':
                                                        currentUser.displayName,
                                                    'number':
                                                        currentUser.phoneNumber,
                                                    'feedback':
                                                        _suggestionsController
                                                            .text
                                                            .trim()
                                                  });
                                                  Get.back();
                                                  Utils.showsuccess(
                                                      'Feedback has been sent !');
                                                } catch (error) {
                                                  print(error);
                                                }
                                              }
                                            },
                                            child: Text(
                                                'Send Feedback / Suggestion',
                                                style: TextStyle(
                                                    fontFamily:
                                                        AppTheme.poppins,
                                                    color:
                                                        AppTheme.whiteColor)))
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        )
                      ],
                    )))
            : SizedBox.shrink());
  }
}

class MyAppointments extends StatefulWidget {
  @override
  _MyAppointmentsState createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  List<Widget> _appointments = [];

  @override
  void initState() {
    super.initState();
    getAppointments();
  }

  getAppointments() async {
    try {
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
        Utils.showProgressBar();
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('User')
            .doc(currentUser.phoneNumber)
            .collection('Appointments')
            .get();
        if (querySnapshot != null) {
          if (querySnapshot.docs.length > 0) {
            for (int index = querySnapshot.docs.length - 1;
                index >= 0;
                index--) {
              _appointments.add(
                DoctorAppointmentCard(
                  ddate: querySnapshot.docs[index].id,
                  date: querySnapshot.docs[index].data()['time'],
                  doctorID: querySnapshot.docs[index].data()['doctorID'],
                  hosptialID: querySnapshot.docs[index].data()['hospitalID'],
                ),
              );
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
    return Column(
      children: [if (_appointments.length > 0) ..._appointments],
    );
  }
}

class DoctorAppointmentCard extends StatefulWidget {
  final String doctorID, hosptialID, date, ddate;
  DoctorAppointmentCard(
      {this.date, this.doctorID, this.hosptialID, this.ddate});
  @override
  _DoctorAppointmentCardState createState() => _DoctorAppointmentCardState();
}

class _DoctorAppointmentCardState extends State<DoctorAppointmentCard> {
  DocumentSnapshot snapshot;

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

        setState(() {
          snapshot = documentSnapshot;
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
                  width: MediaQuery.of(context).size.width * 0.68,
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
                Column(
                  children: [
                    Text(
                      widget.date,
                      style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTheme.poppins),
                    ),
                    Text(
                      'Time',
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
                      '${snapshot != null ? DateFormat('dd MMM').format(DateTime.parse(widget.ddate)) : ''}',
                      style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTheme.poppins),
                    ),
                    Text(
                      'Date',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: AppTheme.poppins),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
