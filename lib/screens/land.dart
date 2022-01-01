
import 'dart:convert';

import 'package:aqar/constants.dart';
import 'package:aqar/screens/details.dart';
import 'package:aqar/land/east.dart';
import 'package:aqar/land/middle.dart';
import 'package:aqar/land/south.dart';
import 'package:aqar/land/west.dart';
import 'package:aqar/screens/searchresult.dart';
import 'package:aqar/searchDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Land extends StatefulWidget {
  static String id='land';
  @override
  _RentState createState() => _RentState();
}

class _RentState extends State<Land> {

  final formatter = new NumberFormat("###,###");
  int _tabBarIndex = 0;

  TextEditingController citytext=new TextEditingController();
  String city,searchValue;
  int searchint;
  bool cityvalidate = false;

  SharedPreferences preferences;
  savePref(String name,String search) async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("name", name);
      preferences.setString("search", search);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: WillPopScope(
        onWillPop:(){
          //Navigator.popAndPushNamed(context, CartScreen.id);
          Navigator.pop(context);
          return Future.value(false);
        },
        child: SafeArea(
            child: Scaffold(
                floatingActionButton: new FloatingActionButton(
                    child:Icon(Icons.search),
                    backgroundColor: kMainColor,
                    onPressed:(){
                      _displayTextInputDialog();
                    }
                ),
                appBar: AppBar(
                  backgroundColor: kMainColor,
                  elevation: 0,
                  title: Text(
                    'قطع اراضي',
                    style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                  leading: GestureDetector(
                    onTap: () {
                      //Navigator.pushNamed(context, Home.id);
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  bottom: TabBar(
                    indicatorColor: kMainColor,
                    onTap: (value) {
                      setState(() {
                        _tabBarIndex = value;
                      });
                    },
                    tabs: <Widget>[
                      Text(
                          'الغربي',
                          style: GoogleFonts.cairo(
                            textStyle: TextStyle(
                                color:
                                _tabBarIndex == 0 ? Colors.black : Colors.white,
                                fontSize: _tabBarIndex == 0 ? 25 : null
                            ),
                          )
                      ),
                      Text(
                        'الاوسط',
                        style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                              color:
                              _tabBarIndex == 1 ? Colors.black : Colors.white,
                              fontSize: _tabBarIndex == 1 ? 25 : null
                          ),
                        ),
                      ),
                      Text(
                        'الشرقي',
                        style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                              color:
                              _tabBarIndex == 2 ? Colors.black : Colors.white,
                              fontSize: _tabBarIndex == 2 ? 25 : null
                          ),
                        ),
                      ),
                      Text(
                        'الجنوبي',
                        style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                              color:
                              _tabBarIndex == 3 ? Colors.black : Colors.white,
                              fontSize: _tabBarIndex == 3 ? 25 : null
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    West(),
                    Middle(),
                    East(),
                    South()
                  ],
                )
            )
        ),
      ),
    );
  }
  locationDialog(){
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("اختر عنوان السكن"),
            content:MyDialog(mlocation: citytext,),
          );
        }
    );
  }
  _displayTextInputDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState)
              {
                return AlertDialog(
                  title: Text('بحث عن عقار'),
                  content:SingleChildScrollView(
                    child: Container(
                      height: 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            onTap:(){
                              locationDialog();
                            },
                            decoration: InputDecoration(
                              hintText: "أختر الحي",
                              errorText: cityvalidate ? 'الرجاء قم بادخال الحي' : null,
                            ),
                            onChanged: (value) {
                              setState(() {
                                city = value;
                              });
                            },
                            controller: citytext,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .01,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 2,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8,left: 8),
                              child: new DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: searchValue,
                                  //elevation: 5,
                                  style: TextStyle(color: Colors.black),

                                  items: <String>[
                                    'البر الشرقي',
                                    'البر الغربي',
                                    'البر الجنوبي',
                                    'البر الاوسط',
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  hint: Text(
                                    "أختر موقع العقار",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onChanged: (String value) {
                                    setState(() {
                                      searchValue = value;
                                      print("-----------------------------");
                                      try{
                                        if(value == "البر الشرقي"){
                                          searchint = 1;
                                          print(searchint);
                                        }else if(value == "البر الغربي"){
                                          searchint = 2;
                                          print(searchint);
                                        }else if(value == "البر الجنوبي"){
                                          searchint = 3;
                                          print(searchint);
                                        }else if(value == "البر الاوسط"){
                                          searchint = 4;
                                          print(searchint);
                                        }
                                      }on PlatformException catch(e){

                                      }
                                      print("-----------------------------");
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(

                      textColor: Colors.black,
                      child: Text('الغاء'),
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                          citytext.clear();
                          cityvalidate = false;
                        });
                      },
                    ),
                    FlatButton(
                      color: kMainColor,
                      textColor: Colors.white,
                      child: Text('بحث'),
                      onPressed: () {
                        setState(() {
                          if (citytext.text.isEmpty) {
                            cityvalidate = true;
                          } else {
                            cityvalidate = false;
                            savePref(citytext.text,searchValue);
                            citytext.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => searchResult(),
                              ),
                            ).then((result){
                              Navigator.of(context).pop();
                            });
                          }
                        });
                      },
                    ),
                  ],
                );
              }
          );
        });
  }
}
