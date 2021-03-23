//Flutter Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/constants/resources.dart';
import 'package:customer/globals/user_details.dart';
import 'package:customer/screens/hospital_page.dart';
import 'package:customer/theme/app_theme.dart';
import 'package:customer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FindAHospitalPage extends StatefulWidget {
  @override
  _FindAHospitalPageState createState() => _FindAHospitalPageState();
}

class _FindAHospitalPageState extends State<FindAHospitalPage> {
  TextEditingController _searchController = TextEditingController();
  String _search = '';
  List<Widget> _hospitals = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getHospitals();
  }

  getHospitals() async {
    try {
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
        Utils.showProgressBar();
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection('Hospital').get();
        if (snapshot != null) {
          if (snapshot.docs != null) {
            for (int index = 0; index < snapshot.docs.length; index++) {
              if (snapshot.docs[index].data()['location'] == userLocation)
                _hospitals.add(
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HospitalPage(
                                  hospitalID: snapshot.docs[index].id,
                                  name: snapshot.docs[index].data()['name'],
                                ))),
                    child: _search == '' ||
                            snapshot.docs[index]
                                .data()['name']
                                .toString()
                                .toLowerCase()
                                .contains(_search.toLowerCase())
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            margin: EdgeInsets.only(bottom: 10),
                            width: MediaQuery.of(context).size.width * 0.87,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Container(
                                  height: 55,
                                  width: 55,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(snapshot
                                              .docs[index]
                                              .data()['profilePicture'])),
                                      borderRadius:
                                          BorderRadius.circular(1000)),
                                ),
                                SizedBox(width: 15),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: Text(
                                    snapshot.docs[index].data()['name'],
                                    style:
                                        TextStyle(fontFamily: AppTheme.poppins),
                                  ),
                                )
                              ],
                            ))
                        : SizedBox.shrink(),
                  ),
                );
            }
          }
        }
        Get.back();
        setState(() {});
      });
    } catch (error) {
      print(error);
      Get.back();
    }
  }

  searchHospitals() async {
    try {
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
        _hospitals = [];
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection('Hospital').get();
        if (snapshot != null) {
          if (snapshot.docs != null) {
            for (int index = 0; index < snapshot.docs.length; index++) {
              _hospitals.add(
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HospitalPage(
                                hospitalID: snapshot.docs[index].id,
                                name: snapshot.docs[index].data()['name'],
                              ))),
                  child: _search == '' ||
                          snapshot.docs[index]
                              .data()['name']
                              .toString()
                              .toLowerCase()
                              .contains(_search.toLowerCase())
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          margin: EdgeInsets.only(bottom: 10),
                          width: MediaQuery.of(context).size.width * 0.87,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Container(
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(snapshot.docs[index]
                                            .data()['profilePicture'])),
                                    borderRadius: BorderRadius.circular(1000)),
                              ),
                              SizedBox(width: 15),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.54,
                                child: Text(
                                  snapshot.docs[index].data()['name'],
                                  style:
                                      TextStyle(fontFamily: AppTheme.poppins),
                                ),
                              )
                            ],
                          ))
                      : SizedBox.shrink(),
                ),
              );
            }
          }
        }

        setState(() {});
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
            title: Text('Find a hospital',
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
                            controller: _searchController,
                            onChanged: (_) {
                              setState(() {
                                _search = _;
                              });
                              searchHospitals();
                            },
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
                child: Text('Search by facility',
                    style: TextStyle(
                        fontFamily: AppTheme.poppins,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              ..._hospitals
            ],
          ),
        )));
  }
}
