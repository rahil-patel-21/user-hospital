//Flutter Imports
import 'package:customer/constants/resources.dart';
import 'package:customer/screens/doctor_list_screen.dart';
import 'package:customer/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FindADoctorPage extends StatefulWidget {
  @override
  _FindADoctorPageState createState() => _FindADoctorPageState();
}

class _FindADoctorPageState extends State<FindADoctorPage> {
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
              SizedBox(height: 5),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('Search by speciality',
                    style: TextStyle(
                        fontFamily: AppTheme.poppins,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DoctorListPage())),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6)),
                      padding: EdgeInsets.all(10),
                      width: (MediaQuery.of(context).size.width - 50) / 2,
                      child: Row(
                        children: [
                          Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.41),
                                  borderRadius: BorderRadius.circular(1000)),
                              child: SvgPicture.asset(doctorASVG)),
                          SizedBox(width: 5),
                          Text('Consultant',
                              style: TextStyle(fontFamily: AppTheme.poppins))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.all(10),
                    width: (MediaQuery.of(context).size.width - 50) / 2,
                    child: Row(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.41),
                                borderRadius: BorderRadius.circular(1000)),
                            child: SvgPicture.asset(doctorBSVG)),
                        SizedBox(width: 5),
                        Text('Child Spe.',
                            style: TextStyle(fontFamily: AppTheme.poppins))
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.all(10),
                    width: (MediaQuery.of(context).size.width - 50) / 2,
                    child: Row(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.41),
                                borderRadius: BorderRadius.circular(1000)),
                            child: SvgPicture.asset(doctorCSVG)),
                        SizedBox(width: 5),
                        Text('Sergeon',
                            style: TextStyle(fontFamily: AppTheme.poppins))
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.all(10),
                    width: (MediaQuery.of(context).size.width - 50) / 2,
                    child: Row(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.41),
                                borderRadius: BorderRadius.circular(1000)),
                            child: SvgPicture.asset(doctorDSVG)),
                        SizedBox(width: 5),
                        Text('Orthopedic',
                            style: TextStyle(fontFamily: AppTheme.poppins))
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.all(10),
                    width: (MediaQuery.of(context).size.width - 50) / 2,
                    child: Row(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.41),
                                borderRadius: BorderRadius.circular(1000)),
                            child: SvgPicture.asset(doctorESVG)),
                        SizedBox(width: 5),
                        Text('Urologist',
                            style: TextStyle(fontFamily: AppTheme.poppins))
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.all(10),
                    width: (MediaQuery.of(context).size.width - 50) / 2,
                    child: Row(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.41),
                                borderRadius: BorderRadius.circular(1000)),
                            child: SvgPicture.asset(doctorASVG)),
                        SizedBox(width: 5),
                        Text('Specialist',
                            style: TextStyle(fontFamily: AppTheme.poppins))
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.all(10),
                    width: (MediaQuery.of(context).size.width - 50) / 2,
                    child: Row(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.41),
                                borderRadius: BorderRadius.circular(1000)),
                            child: SvgPicture.asset(doctorASVG)),
                        SizedBox(width: 5),
                        Text('Consultant',
                            style: TextStyle(fontFamily: AppTheme.poppins))
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.all(10),
                    width: (MediaQuery.of(context).size.width - 50) / 2,
                    child: Row(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.41),
                                borderRadius: BorderRadius.circular(1000)),
                            child: SvgPicture.asset(doctorBSVG)),
                        SizedBox(width: 5),
                        Text('Child Spe.',
                            style: TextStyle(fontFamily: AppTheme.poppins))
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.all(10),
                    width: (MediaQuery.of(context).size.width - 50) / 2,
                    child: Row(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.41),
                                borderRadius: BorderRadius.circular(1000)),
                            child: SvgPicture.asset(doctorCSVG)),
                        SizedBox(width: 5),
                        Text('Sergeon',
                            style: TextStyle(fontFamily: AppTheme.poppins))
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.all(10),
                    width: (MediaQuery.of(context).size.width - 50) / 2,
                    child: Row(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.41),
                                borderRadius: BorderRadius.circular(1000)),
                            child: SvgPicture.asset(doctorDSVG)),
                        SizedBox(width: 5),
                        Text('Orthopedic',
                            style: TextStyle(fontFamily: AppTheme.poppins))
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.all(10),
                    width: (MediaQuery.of(context).size.width - 50) / 2,
                    child: Row(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.41),
                                borderRadius: BorderRadius.circular(1000)),
                            child: SvgPicture.asset(doctorESVG)),
                        SizedBox(width: 5),
                        Text('Urologist',
                            style: TextStyle(fontFamily: AppTheme.poppins))
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.all(10),
                    width: (MediaQuery.of(context).size.width - 50) / 2,
                    child: Row(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.41),
                                borderRadius: BorderRadius.circular(1000)),
                            child: SvgPicture.asset(doctorASVG)),
                        SizedBox(width: 5),
                        Text('Specialist',
                            style: TextStyle(fontFamily: AppTheme.poppins))
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        )));
  }
}
