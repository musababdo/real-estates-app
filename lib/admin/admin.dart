
import 'dart:async';
import 'dart:convert';

import 'package:aqar/admin/showusers.dart';
import 'package:aqar/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class DataInfo {
  //Constructor
  String id;
  String username;
  String password;

  DataInfo.fromJson(Map json) {
    this.id       = json['id'];
    this.username = json['username'];
    this.password = json['password'];
  }
}

class Admin extends StatefulWidget {
  static String id='admin';
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  int _state=0;
  bool keepMeLoggedIn = false;

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  Future login() async {
    var url = Uri.parse('http://10.0.2.2/busticket/admin_login.php');

    try {
      var response = await http.post(url, body: {
        "username": username.text.trim(),
        "password": password.text.trim(),
      });
      var data = json.decode(response.body);
      String success = data['success'];
      if (success == "1") {
        setState(() {
          final items = (data['login'] as List).map((i) => new DataInfo.fromJson(i));
          for (final item in items) {
            //savePref(item.id);
          }
        });
        Navigator.pushNamed(context, Showusers.id);
      } else {
        Fluttertoast.showToast(
            msg: "هنالك خطاء ما",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }catch(e){
      setState(() {
        _state = 0;
      });
      errorDialog();
    }
  }

  errorDialog(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            content: Text('اسم المستخدم او كلمه المرور خطاء',style: GoogleFonts.cairo(),),
            actions: <Widget>[
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("حسنا",style: GoogleFonts.cairo(),)
              ),
            ],
          );
        }
    );
  }

  bool _validate = false;
  bool _secureText = true;
  void showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  String _errorMessage(String hint) {
    if(hint=="أسم المستخدم"){
      return 'الرجاء ادخال اسم المستخدم';
    }else if(hint=="كلمه المرور"){
      return 'الرجاء ادخال كلمه المرور';
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Form(
      key: _globalKey,
      child: SafeArea(
        child: WillPopScope(
          onWillPop:(){
            SystemNavigator.pop();
            return Future.value(false);
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: kMainColor,
              elevation: 0,
              title: Text(
                'الأداره',
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
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * .2,
                    ),
                    TextFormField(
                      validator:(value) {
                        if (value.isEmpty) {
                          return _errorMessage("أسم المستخدم");
                          // ignore: missing_return
                        }
                      },
                      controller: username,
                      decoration: InputDecoration(
                          icon: Icon(Icons.person,color: kMainColor,),
                          hintStyle: TextStyle(color: Colors.blue),
                          hintText: "أسم المستخدم"
                      ),
                    ),
                    SizedBox(height: 5,),
                    TextFormField(
                      validator:(value) {
                        if (value.isEmpty) {
                          return _errorMessage("كلمه المرور");
                          // ignore: missing_return
                        }
                      },
                      controller: password,
                      obscureText: _secureText,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock,color: kMainColor,),
                          suffixIcon: IconButton(
                            onPressed: showHide,
                            icon: Icon(_secureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                          hintStyle: TextStyle(color: Colors.blue),
                          hintText: "كلمه المرور"
                      ),
                    ),
                    SizedBox(height: 5,),
//                    Padding(
//                      padding: EdgeInsets.only(left: 20),
//                      child: Row(
//                        children: <Widget>[
//                          Theme(
//                            data: ThemeData(unselectedWidgetColor: blueColor),
//                            child: Checkbox(
//                              checkColor: Colors.white,
//                              activeColor: blueColor,
//                              value: keepMeLoggedIn,
//                              onChanged: (value) {
//                                setState(() {
//                                  keepMeLoggedIn = value;
//                                });
//                              },
//                            ),
//                          ),
//                          Text(
//                            'تذكرني ',
//                            style: GoogleFonts.cairo(
//                              textStyle: TextStyle(
//                                  color: Colors.black,
//                                  fontSize: 16
//                              ),
//                            ),
//                          )
//                        ],
//                      ),
//                    ),
//                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.only(left: 15,right: 15,bottom: 8,top: 8),
                      child: Builder(
                        builder: (context) => FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            if (_state == 0) {
                              animateButton();
                            }

                            if (_globalKey.currentState.validate()){
                              _globalKey.currentState.save();
                              try{
                                login();
                              }on PlatformException catch(e){

                              }
                            }else{
                              setState(() {
                                _state = 0;
                              });
                            }
                          },
                          color: kMainColor,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 5,top: 5),
                            child: Center(
                                child:setUpButtonChild()
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        "تسجيل دخول",
        style: GoogleFonts.cairo(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 0;
      });
    });
  }
}
