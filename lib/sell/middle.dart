
import 'dart:convert';

import 'package:aqar/screens/details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Middle extends StatefulWidget {
  @override
  _EastState createState() => _EastState();
}

class _EastState extends State<Middle> {

  final formatter = new NumberFormat("###,###");

  Future getMiddle() async{
    var url = Uri.parse('http://10.0.2.2/aqar/display_sell_middle.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: screenHeight *  1,
      child: FutureBuilder(
        future: getMiddle(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          try {
            if(snapshot.data.length > 0 ){
              return snapshot.hasData ?
              ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    List list = snapshot.data;
                    //print(list);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: screenHeight * .18,
                        child: GestureDetector(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Details(list: list,index: index,),),);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            elevation: 8,
                            child:Row(
                              mainAxisAlignment:MainAxisAlignment.end ,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: Text(
                                                list[index]['title'],
                                                style: GoogleFonts.cairo(
                                                  textStyle: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: Text(
                                                "العنوان",
                                                style: GoogleFonts.cairo(
                                                  textStyle: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]
                                      ),
                                      Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: Text(
                                                formatter.format(int.parse(list[index]['area'])),
                                                style: GoogleFonts.cairo(
                                                  textStyle: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "المساحه",
                                              style: GoogleFonts.cairo(
                                                textStyle: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ]
                                      ),
                                      Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: Text(
                                                'SDG ${formatter.format(int.parse(list[index]['price']))}',
                                                style: GoogleFonts.cairo(
                                                  textStyle: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "السعر",
                                              style: GoogleFonts.cairo(
                                                textStyle: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ]
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(padding: const EdgeInsets.only(right:15)),
                                ClipRRect(
                                  borderRadius: new BorderRadius.only(
                                    topRight: const Radius.circular(20),
                                    bottomRight: const Radius.circular(20),
                                  ),
                                  child:CachedNetworkImage(
                                    imageUrl: list[index]['image'],
                                    placeholder: (context, url) => placeImage(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                ),
                                //Padding(padding: const EdgeInsets.only(right:15)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
                  : new Center(
                child: new CircularProgressIndicator(),
              );
            }else{
              return Container(
                height: screenHeight -
                    (screenHeight * .08) -
                    appBarHeight -
                    statusBarHeight,
                child: Center(
                  child: Text('لايوجد عقارات',
                    style: TextStyle(
                        fontSize: 30
                    ),
                  ),
                ),
              );
            }
          }catch(e){
            return new Center(
              child: new CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
  placeImage(){
    return Image.asset("assets/images/place.png",
      height: MediaQuery.of(context).size.height * 0.4,
      fit: BoxFit.contain,
    );
  }
}
