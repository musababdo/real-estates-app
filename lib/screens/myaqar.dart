
import 'dart:convert';

import 'package:aqar/constants.dart';
import 'package:aqar/screens/addaqar.dart';
import 'package:aqar/screens/editaqar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAqar extends StatefulWidget {
  static String id='myaqar';
  @override
  _MyAqarState createState() => _MyAqarState();
}

class _MyAqarState extends State<MyAqar> {

  final formatter = new NumberFormat("###,###");

  SharedPreferences preferences;
  Future getMyAqar() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      //print(preferences.getString("id"));
    });
    var url = Uri.parse('http://10.0.2.2/aqar/display_myaqar.php');
    var response = await http.post(url, body: {
      "id": preferences.getString("id"),
    });
    var data = json.decode(response.body);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop:(){
        Navigator.pop(context);
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: new FloatingActionButton(
            onPressed:(){
              Navigator.pushNamed(context, AddAqar.id);
            } ,
            child: new Icon(Icons.add,color: Colors.white,),
            backgroundColor: kMainColor,
          ),
          appBar: AppBar(
            backgroundColor: kMainColor,
            elevation: 0,
            title: Text(
              'عقاراتي',
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
          ),
          body: FutureBuilder(
            future: getMyAqar(),
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
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              elevation: 8,
                              child:Row(
                                mainAxisAlignment:MainAxisAlignment.end ,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width / 5,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: Text(
                                                "العنوان",
                                                style: GoogleFonts.cairo(
                                                  textStyle: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(right:20),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => EditAqar(list: list,index: index,),),);
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(context: context,
                                                  builder: (context){
                                                    return AlertDialog(
                                                      content: Text('هل انت متأكد من انك تريد مسح هذا العقار'),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                            onPressed: (){
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text("لا")
                                                        ),
                                                        FlatButton(
                                                            onPressed: (){
                                                              setState(() {
                                                                var url = Uri.parse('http://10.0.2.2/aqar/delete_aqar.php');
                                                                http.post(url,body: {
                                                                  'id' : list[index]['id'],
                                                                });
                                                                Navigator.of(context).pop();
                                                              });
                                                            },
                                                            child: Text("نعم")
                                                        ),
                                                      ],
                                                    );
                                                  }
                                              );
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
        ),
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
