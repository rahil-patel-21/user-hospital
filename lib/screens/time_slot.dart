//Flutter Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/globals/responsive.dart';
import 'package:customer/globals/user_details.dart';
import 'package:customer/services/auth.dart';
import 'package:customer/theme/app_theme.dart';
import 'package:customer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class SlotPage extends StatefulWidget {
  final String doctorID, hosptialID;
  SlotPage({this.doctorID, this.hosptialID});
  @override
  _SlotPageState createState() => _SlotPageState();
}

class _SlotPageState extends State<SlotPage> {
  List<SlotButton> _tokens = [];
  DocumentSnapshot snapshot;
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
        int totalTokens = int.parse(documentSnapshot.data()['tokens']);
        for (int index = 0; index < totalTokens; index++) {
          _tokens.add(SlotButton(
              doctorName: documentSnapshot.data()['name'],
              doctorID: widget.doctorID,
              hospitalID: widget.hosptialID,
              time: (index + 1).toString()));
        }
        setState(() {
          snapshot = documentSnapshot;
          _openingTime = DateFormat('hh:mm a')
              .format(DateTime.parse(snapshot.data()['OpeningTime']));
          _closingTime = DateFormat('hh:mm a')
              .format(DateTime.parse(snapshot.data()['ClosingTime']));
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
            title: Text('Token Management',
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(height: 10),
              Container(
                child: Text(DateFormat('dd MMM yyyy').format(DateTime.now()),
                    style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontFamily: AppTheme.poppinsBold)),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red),
                  ),
                  SizedBox(width: 5),
                  Text('Completed',
                      style: TextStyle(
                          fontFamily: AppTheme.poppins,
                          color: AppTheme.primaryColor)),
                  SizedBox(width: 10),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.orange),
                  ),
                  SizedBox(width: 5),
                  Text('Pending',
                      style: TextStyle(
                          fontFamily: AppTheme.poppins,
                          color: AppTheme.primaryColor)),
                  SizedBox(width: 10),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.green),
                  ),
                  SizedBox(width: 5),
                  Text('Available',
                      style: TextStyle(
                          fontFamily: AppTheme.poppins,
                          color: AppTheme.primaryColor)),
                  SizedBox(width: 10)
                ],
              ),
              SizedBox(height: 15),
              Container(
                child: Text('Tokens',
                    style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontFamily: AppTheme.poppins)),
              ),
              SizedBox(height: 10),
              if (_tokens.length > 0) Wrap(children: _tokens)
            ],
          ),
        )));
  }
}

class SlotButton extends StatefulWidget {
  final String time, doctorID, hospitalID, doctorName;
  SlotButton({this.time, this.doctorID, this.hospitalID, this.doctorName});
  @override
  _SlotButtonState createState() => _SlotButtonState();
}

class _SlotButtonState extends State<SlotButton> {
  String _type = '0';
  bool _isAvailable = true;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSlotStatus();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _numberController.dispose();
  }

  getSlotStatus() async {
    try {
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('Hospital')
            .doc(widget.hospitalID)
            .collection('Doctors')
            .doc(widget.doctorID)
            .get();
        if (snapshot.data() != null) {
          if (snapshot.data()[widget.time] != null) {
            setState(() {
              _isAvailable = (DateTime.now().day !=
                  DateTime.parse(snapshot.data()[widget.time]).day);
              _type = snapshot.data()['S${widget.time}'];
            });
          }
        }
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          if (_type == '0') {
            showDialog(
                context: context,
                child: AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(DateFormat('dd MMM yyyy').format(DateTime.now())),
                        SizedBox(height: 15),
                        Text('token ' + widget.time,
                            style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontFamily: AppTheme.poppinsBold))
                      ],
                    ),
                    actions: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8)),
                          margin: EdgeInsets.only(right: 15, bottom: 10),
                          child: Text('Cancel',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: AppTheme.poppinsBold)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            Utils.showProgressBar();
                            String id = DateTime.now().toString();
                            await FirebaseFirestore.instance
                                .collection('User')
                                .doc(currentUser.phoneNumber)
                                .collection('Appointments')
                                .doc(id)
                                .set({
                              'hospitalID': widget.hospitalID,
                              'doctorID': widget.doctorID,
                              'time': widget.time,
                              'token': widget.time
                            });
                            await FirebaseFirestore.instance
                                .collection('Hospital')
                                .doc(widget.hospitalID)
                                .collection('Doctors')
                                .doc(widget.doctorID)
                                .collection("Appointments")
                                .doc(id)
                                .set({
                              'name': currentUser.displayName,
                              'number': currentUser.phoneNumber,
                              'time': widget.time,
                              'token': widget.time
                            });
                            await FirebaseFirestore.instance
                                .collection('Hospital')
                                .doc(widget.hospitalID)
                                .collection('Doctors')
                                .doc(widget.doctorID)
                                .update({
                              'S${widget.time}': '1',
                              '${widget.time}': DateTime.now().toString(),
                            });
                            await Auth.sendAppointmentNotification(
                                name: currentUser.displayName,
                                doctorName: widget.doctorName,
                                time: widget.time,
                                hospitalID: widget.hospitalID);
                            Get.back();
                            Navigator.pop(context);
                            Utils.showsuccess(
                                'Your Appointment for token ${widget.time} has been booked !');
                            getSlotStatus();
                          } catch (error) {
                            print(error);
                            Get.back();
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                              color: AppTheme.primaryAccent,
                              borderRadius: BorderRadius.circular(8)),
                          margin: EdgeInsets.only(right: 15, bottom: 10),
                          child: Text('Book Now',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: AppTheme.poppinsBold)),
                        ),
                      )
                    ],
                    title: Text(
                      'Confirm Your Appointment !',
                    )));
          }
        } catch (error) {
          print(error);
          Get.back();
        }
      },
      child: Container(
        width: size(90),
        height: size(40),
        alignment: Alignment.center,
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: _isAvailable && _type == '0'
              ? Colors.green
              : _isAvailable && _type == '1'
                  ? Colors.orange
                  : Colors.red,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(widget.time,
            style:
                TextStyle(color: Colors.white, fontFamily: AppTheme.poppins)),
      ),
    );
  }

  Widget _textField(TextEditingController controller,
      TextInputType keyBoardType, String labelText,
      {int maxLength}) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      keyboardType: keyBoardType,
      decoration: InputDecoration(
        counterText: '',
        hintText: labelText,
        labelText: labelText,
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
    );
  }
}
