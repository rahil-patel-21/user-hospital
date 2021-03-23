//Flutter Imports
import 'package:customer/constants/resources.dart';
import 'package:customer/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'doctor_page.dart';

class DoctorListPage extends StatefulWidget {
  @override
  _DoctorListPageState createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
            title: Text('Find a doctor',
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
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                              enabledBorder: new OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppTheme.primaryColor, width: 1.0),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(8.0),
                                ),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppTheme.primaryColor, width: 1.0),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(8.0),
                                ),
                              ),
                              disabledBorder: new OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppTheme.primaryColor, width: 1.0),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(8.0),
                                ),
                              ),
                              border: new OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppTheme.primaryColor, width: 1.0),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(8.0),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
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
                        children: [
                          Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.41),
                                  borderRadius: BorderRadius.circular(1000)),
                              child: SvgPicture.asset(doctorASVG)),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dr. Salman Mansoor',
                                style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 16,
                                    fontFamily: AppTheme.poppinsBold),
                              ),
                              Text(
                                'Cosmetic Surgeon, Aesthetic\nMedicine Specialist',
                                style: TextStyle(
                                    fontSize: 14, fontFamily: AppTheme.poppins),
                              ),
                              Text(
                                'MBBDS, MD (USA), D Derm (London)',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontFamily: AppTheme.poppins),
                              )
                            ],
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
                                '9 Years',
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
                                'Today',
                                style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppTheme.poppins),
                              ),
                              Text(
                                'Available',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontFamily: AppTheme.poppins),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Time',
                                style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppTheme.poppins),
                              ),
                              Text(
                                '2:00 PM',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontFamily: AppTheme.poppins),
                              ),
                            ],
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DoctorPage())),
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppTheme.primaryColor),
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
              ),
            ],
          ),
        )));
  }
}
