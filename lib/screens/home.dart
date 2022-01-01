
import 'dart:async';
import 'dart:convert';

import 'package:aqar/admin/admin.dart';
import 'package:aqar/constants.dart';
import 'package:aqar/profile/profile_screen.dart';
import 'package:aqar/screens/all.dart';
import 'package:aqar/screens/land.dart';
import 'package:aqar/screens/myaqar.dart';
import 'package:aqar/screens/myui.dart';
import 'package:aqar/screens/rent.dart';
import 'package:aqar/screens/sell.dart';
import 'package:aqar/widgets/customlistile.dart';
import 'package:aqar/widgets/porderlistile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Info {
  //Constructor
  String username;
  String phone;

  Info.fromJson(Map json) {
    username = json['username'];
    phone    = json['phone'];
  }
}

class Home extends StatefulWidget {
  static String id='home';
  @override
  _HommeState createState() => _HommeState();
}

class _HommeState extends State<Home> {

  final List<String> names = ["الكل","ايجار","شراء","قطع اراضي"];
  int _state=0;

  bool visibilityCount = false;
  int _selectedIndex = 0;
  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  show(int index){
    setState(() {
      visibilityCount=true;
    });
  }

  String name,phone;
  int profilevalue,aqarvalue;

  SharedPreferences preferences;
  Future getProfile() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      //print(preferences.getString("id"));
    });
    var url = Uri.parse('http://10.0.2.2/aqar/profile/display_profile.php');
    var response = await http.post(url, body: {
      "id" : preferences.getString("id"),
    });
    var data = json.decode(response.body);
    setState(() {
      final items = (data['login'] as List).map((i) => new Info.fromJson(i));
      for (final item in items) {
        name  = item.username;
        phone = item.phone;
      }
    });

    return data;
  }

  Future<void> signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.remove("id");
      pref.clear();
      SystemNavigator.pop();
      Fluttertoast.showToast(
          msg: "تم تسجيل الخروج",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
  }

  Future getMyProfile() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      profilevalue = preferences.getInt("value") ;
      if ((preferences.getInt("value") == 1)) {
        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => confirmnow()));
        Navigator.pushNamed(context, ProfileScreen.id);
      }else{
        myDialog();
      }
    });
  }

  Future getMyAqar() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      aqarvalue = preferences.getInt("value") ;
      if ((preferences.getInt("value") == 1)) {
        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => confirmnow()));
        Navigator.pushNamed(context, MyAqar.id);
      }else{
        myDialog();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  setState(() {
        if (_state == 0) {
      animateButton();
    }
  });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop:(){
        exitDialog();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          drawer: new Drawer(
            child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: kMainColor,
                    ),
                    accountName: Text(name !=null?name:"",style: TextStyle(color:Colors.white,fontSize: 20),),
                    accountEmail: Text(phone !=null?phone:"",style: TextStyle(color:Colors.white,fontSize: 20),),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: Column(children: <Widget>[
                      ListTile(
                        dense: true,
                        title: Text(
                            'الملف الشخصي',
                            style: GoogleFonts.cairo(
                              textStyle: TextStyle(
                                color: Colors.black,
                              ),
                            )
                        ),
                        leading: Icon(Icons.person),
                        onTap: (){
                          Navigator.pop(context);
                          getMyProfile();
                        },
                      ),
                      ListTile(
                        dense: true,
                        title: Text(
                            'عقاراتي',
                            style: GoogleFonts.cairo(
                              textStyle: TextStyle(
                                color: Colors.black,
                              ),
                            )
                        ),
                        leading: Icon(Icons.home),
                        onTap: (){
                          Navigator.pop(context);
                          getMyAqar();
                        },
                      ),
                      ListTile(
                        dense: true,
                        title: Text(
                            'تسجيل خروج',
                            style: GoogleFonts.cairo(
                              textStyle: TextStyle(
                                color: Colors.black,
                              ),
                            )
                        ),
                        leading: Icon(Icons.logout),
                        onTap: (){
                          Navigator.pop(context);
                          signOut();
                          //Navigator.pushNamed(context,login.id);
                        },
                      ),
//                      ListTile(
//                        dense: true,
//                        title: Text(
//                            'خاص بالأدمن',
//                            style: GoogleFonts.cairo(
//                              textStyle: TextStyle(
//                                color: Colors.black,
//                              ),
//                            )
//                        ),
//                        leading: Icon(Icons.person),
//                        onTap: (){
//                          Navigator.pop(context);
//                          Navigator.pushNamed(context,Admin.id);
//                        },
//                      ),
                    ],),
                  ),
                ]
            ),
          ),
          appBar: AppBar(
            backgroundColor:Colors.transparent,
            elevation: 0,
            iconTheme: new IconThemeData(color: Colors.black),
            title: Text(
                'الرئيسيه',
                style: GoogleFonts.cairo(
                  textStyle: TextStyle(
                      color: Colors.black,
                  ),
                )
            ),
          ),
          body:SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height:height* .1,
                ),
                setUpButtonChild(),
                SizedBox(
                  height:height* .09,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap:(){
                          Navigator.pushNamed(context, Sell.id);
                        },
                        child: Container(
                          height: 150.0,
                          width: 150.0,
                          color: Colors.transparent,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: kMainColor,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              child: new Center(
                                child: new Text("شراء",
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white
                                    ),
                                  ),
                                  textAlign: TextAlign.center,),
                              )),
                        ),
                      ),
                      GestureDetector(
                        onTap:(){
                          Navigator.pushNamed(context, Rent.id);
                        },
                        child: Container(
                          height: 150.0,
                          width: 150.0,
                          color: Colors.transparent,
                          child: Container(
                              decoration: BoxDecoration(
                                  color:kMainColor,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              child: new Center(
                                child: new Text("ايجار",
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white
                                    ),
                                  ),
                                  textAlign: TextAlign.center,),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height:height* .02,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap:(){
                          Navigator.pushNamed(context, Land.id);
                        },
                        child: Container(
                          height: 150.0,
                          width: 150.0,
                          color: Colors.transparent,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: kMainColor,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              child: new Center(
                                child: new Text("قطع اراضي",
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white
                                    ),
                                  ),
                                  textAlign: TextAlign.center,),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  myDialog(){
    showModalBottomSheet(context: context, builder: (context){
      return WillPopScope(
        onWillPop:(){
          Navigator.pop(context);
          return Future.value(false);
        },
        child: SafeArea(
            child: Container(
              color: Color(0xFF737373),
              height: 180,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Text("تنبيه",style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 22,
                      ),
                    ),),
                    const SizedBox(height:8),
                    Text('ليس لديك حساب قم بعمل حساب الأن ',style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 19,
                      ),
                    ),),
                    const SizedBox(height:10),
                    Padding(
                      padding: const EdgeInsets.only(left: 25,right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text('الغاء',
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                Navigator.pushNamed(context, Myui.id).then((_){
                                  Navigator.of(context).pop();
                                });
                              });
                            },
                            child: Text('موافق',
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
      );
    });
  }
  exitDialog(){
    showModalBottomSheet(context: context, builder: (context){
      return WillPopScope(
        onWillPop:(){
          Navigator.pop(context);
          return Future.value(false);
        },
        child: SafeArea(
            child: Container(
              color: Color(0xFF737373),
              height: 180,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Text("الخروج من التطبيق",style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 22,
                      ),
                    ),),
                    const SizedBox(height:8),
                    Text('هل تود الخروج من التطبيق ',style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 19,
                      ),
                    ),),
                    const SizedBox(height:10),
                    Padding(
                      padding: const EdgeInsets.only(left: 25,right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text('الغاء',
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                SystemNavigator.pop();
                              });
                            },
                            child: Text('موافق',
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
      );
    });
  }
  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        "مرحبا بك في عقاراتي",
        style: GoogleFonts.cairo(
          textStyle: TextStyle(
              color: Colors.black,
              fontSize: 35,
              fontWeight: FontWeight.bold
          ),
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }
  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(seconds: 3), () {
      setState(() {
        _state = 0;
      });
    });
  }
}
