
import 'dart:convert';
import 'package:aqar/constants.dart';
import 'package:aqar/screens/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Details extends StatefulWidget {
  static String id='details';

  final List list;
  final int index;
  Details({this.list,this.index});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  String id,image,name,phone,price,title,location,area,specialvalue,rooms,halls,toilets;
  final formatter = new NumberFormat("###,###");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id   =  widget.list[widget.index]['id'];
    image   =  widget.list[widget.index]['image'];
    name    =  widget.list[widget.index]['name'];
    phone   =  widget.list[widget.index]['phone'];
    price   =  widget.list[widget.index]['price'];
    title   =  widget.list[widget.index]['title'];
    location   =  widget.list[widget.index]['location'];
    area    =  widget.list[widget.index]['area'];
    rooms=  widget.list[widget.index]['rooms'];
    halls=  widget.list[widget.index]['halls'];
    toilets=  widget.list[widget.index]['toilets'];
    specialvalue=  widget.list[widget.index]['specilvalue'];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:(){
        Navigator.pop(context);
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    new Container(
                      height: 300.0,
                      child: new ClipRRect(
                        borderRadius: new BorderRadius.only(
                          bottomLeft: const Radius.circular(20),
                          bottomRight: const Radius.circular(20),
                        ),
                        child:Image.network(image,fit:BoxFit.contain),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: new Card(
                        color: Colors.white,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .5,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15,left: 15),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                         Column(
                                       children: [
                                         Text(
                                           'السعر',
                                           style: GoogleFonts.cairo(
                                             textStyle: TextStyle(
                                                 color: Colors.black,
                                                 fontSize: 20,
                                                 fontWeight: FontWeight.bold
                                             ),
                                           ),
                                         ),
                                         Text(
                                           'SDG ${formatter.format(int.parse(price))}',
                                           style: GoogleFonts.cairo(
                                             textStyle: TextStyle(
                                                 color: Colors.black54,
                                                 fontSize: 20,
                                             ),
                                           ),
                                         ),
                                       ],
                                         ),
                                      Column(
                                        children: [
                                          Text(
                                            'الموقع',
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          Text(
                                            title,
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * .03,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          Text(
                                            'المساحه',
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          Text(
                                            formatter.format(int.parse(area)),
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'نوع السكن',
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          Text(
                                            specialvalue,
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * .03,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          Text(
                                            'عدد الغرف',
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          Text(
                                            rooms,
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'عدد الهول',
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          Text(
                                            halls,
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * .03,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          Text(
                                            'الحي',
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          Text(
                                            location,
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'عدد الحمامات',
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          Text(
                                            toilets,
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: new Card(
                        color: Colors.white,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                FloatingActionButton(
                                  onPressed:(){
                                    launch(('tel://${phone}'));
                                  },
                                  child: Icon(Icons.call),
                                  backgroundColor: kMainColor,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      name,
                                      style: TextStyle(color: Colors.black,fontSize: 18),
                                    ),
                                    Text(
                                      '  :  المالك',
                                      style: TextStyle(color: Colors.black,fontSize: 20,fontWeight:FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Container(
                  height: MediaQuery.of(context).size.height * .1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap:(){
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
