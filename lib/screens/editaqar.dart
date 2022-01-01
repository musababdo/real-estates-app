
import 'dart:convert';
import 'dart:io';

import 'package:aqar/constants.dart';
import 'package:aqar/screens/myaqar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAqar extends StatefulWidget {
  static String id='editaqar';
  final List list;
  final int index;
  EditAqar({this.list,this.index});
  @override
  _AddAqarState createState() => _AddAqarState();
}

class _AddAqarState extends State<EditAqar> {

  final ImagePicker _picker = ImagePicker();
  File _image;
  String _chosenValue,specilValue,id,aqarid;
  int chosenint;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  TextEditingController  title   =new TextEditingController();
  TextEditingController  area     =new TextEditingController();
  TextEditingController  price   =new TextEditingController();
  TextEditingController  rooms   =new TextEditingController();
  TextEditingController  halls   =new TextEditingController();
  TextEditingController  toilets   =new TextEditingController();
  TextEditingController nameController = TextEditingController();

  Future editAqar() async{
    var url = Uri.parse('http://10.0.2.2/aqar/edit_aqar.php');
    http.post(url,body: {
      "id"          : aqarid,
      "title"       : title.text,
      "area"        : area.text,
      "price"       : price.text,
      "rooms"       : rooms.text,
      "halls"       : halls.text,
      "toilets"     : toilets.text,
      "chosenvalue" : chosenint.toString(),
      "specilvalue" : specilValue,
    });
  }

  Future editImage() async{
    List<int> imageBytes = _image.readAsBytesSync();
    String baseimage = base64Encode(imageBytes);
    var url = Uri.parse('http://10.0.2.2/aqar/edit_image.php');
    http.post(url,body: {
      'id'        : aqarid,
      'image'     : baseimage,
    });
  }

  SharedPreferences preferences;

  Future getID() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
      print(id);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getID();
    aqarid        =  widget.list[widget.index]['id'];
    title.text    =  widget.list[widget.index]['title'];
    area.text     =  widget.list[widget.index]['area'];
    price.text    =  widget.list[widget.index]['price'];
    rooms.text    =  widget.list[widget.index]['rooms'];
    halls.text    =  widget.list[widget.index]['halls'];
    toilets.text  =  widget.list[widget.index]['toilets'];
  }

  String _errorMessage(String hint) {
    if(hint=="العنوان"){
      return 'الرجاء ادخال العنوان';
    }else if(hint=="الوصف"){
      return 'الرجاء ادخال الوصف';
    }else if(hint=="المساحه"){
      return 'الرجاء ادخال المساحه';
    }else if(hint=="السعر"){
      return 'الرجاء ادخال السعر';
    }else if(hint=="عدد الغرف"){
      return 'الرجاء ادخال عدد الغرف';
    }else if(hint=="عدد الهول"){
      return 'الرجاء ادخال عدد الهول';
    }else if(hint=="عدد الحمامات"){
      return 'الرجاء ادخال عدد الحمامات';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop:(){
        //Navigator.popAndPushNamed(context, CartScreen.id);
        Navigator.pop(context);
        return Future.value(false);
      },
      child: SafeArea(
        child: Form(
          key: _globalKey,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: kMainColor,
              elevation: 0,
              title: Text(
                'تعديل عقار',
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
              child: Column(
                children: [
                  SizedBox(
                    height:screenHeight * .07,
                  ),
                  GestureDetector(
                    onTap:(){
                      _optionsDialogBox();
                    },
                    child: _image == null
                        ? new Stack(
                      children: <Widget>[
                        new Center(
                          child: new CircleAvatar(
                            radius: 80.0,
                            backgroundColor: kMainColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 45),
                          child: new Center(
                            child: new Image.asset("images/camera.png"),
                          ),
                        ),

                      ],
                    ): new Container(
                        height: 190.0,
                        width: 190.0,
                        child:Image.file(_image)
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(7, 15, 7, 5),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10,left: 10),
                                child: new TextFormField(
                                  validator:(value) {
                                    if (value.isEmpty) {
                                      return _errorMessage("العنوان");
                                      // ignore: missing_return
                                    }
                                  },
                                  controller: title,
                                  decoration: InputDecoration(
                                      labelText: 'ادخل العنوان',
                                      hintText: "العنوان"
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10,left: 10),
                                child: new TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator:(value) {
                                    if (value.isEmpty) {
                                      return _errorMessage("المساحه");
                                      // ignore: missing_return
                                    }
                                  },
                                  controller: area,
                                  decoration: InputDecoration(
                                      labelText: 'ادخل المساحه',
                                      hintText: "المساحه"
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10,left: 10),
                                child: new TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator:(value) {
                                    if (value.isEmpty) {
                                      return _errorMessage("السعر");
                                      // ignore: missing_return
                                    }
                                  },
                                  controller: price,
                                  decoration: InputDecoration(
                                    //hintStyle: TextStyle(color: Colors.blue),
                                      labelText: 'ادخل السعر',
                                      hintText: "السعر"
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10,left: 10),
                                child: new TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator:(value) {
                                    if (value.isEmpty) {
                                      return _errorMessage("عدد الغرف");
                                      // ignore: missing_return
                                    }
                                  },
                                  controller: rooms,
                                  decoration: InputDecoration(
                                      labelText: 'ادخل عدد الغرف',
                                      hintText: "عدد الغرف"
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10,left: 10),
                                child: new TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator:(value) {
                                    if (value.isEmpty) {
                                      return _errorMessage("عدد الهول");
                                      // ignore: missing_return
                                    }
                                  },
                                  controller: halls,
                                  decoration: InputDecoration(
                                    //hintStyle: TextStyle(color: Colors.blue),
                                      labelText: 'عدد الهول',
                                      hintText: "عدد الهول"
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10,left: 10),
                                child: new TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator:(value) {
                                    if (value.isEmpty) {
                                      return _errorMessage("عدد الحمامات");
                                      // ignore: missing_return
                                    }
                                  },
                                  controller: toilets,
                                  decoration: InputDecoration(
                                      labelText: 'ادخل عدد الحمامات',
                                      hintText: "عدد الحمامات"
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10,left: 10),
                                child: new DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _chosenValue,
                                    //elevation: 5,
                                    style: TextStyle(color: Colors.black),

                                    items: <String>[
                                      'ايجار',
                                      'بيع',
                                      'قطع اراضي',
                                    ].map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    hint: Text(
                                      "أختر نوع العقار",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        _chosenValue = value;
                                        print("-----------------------------");
                                        try{
                                          if(value == "ايجار"){
                                            chosenint = 1;
                                            print(chosenint);
                                          }else if(value == "بيع"){
                                            chosenint = 2;
                                            print(chosenint);
                                          }else if(value == "قطع اراضي"){
                                            chosenint = 3;
                                            print(chosenint);
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
                        Container(
                          width: MediaQuery.of(context).size.width * 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8,right: 8),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: specilValue,
                                //elevation: 5,
                                style: TextStyle(color: Colors.black),

                                items: <String>[
                                  'أسر',
                                  'ازواج',
                                  'اعذب',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: Text(
                                  "أختر نوع السكن",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                onChanged: (String value) {
                                  setState(() {
                                    specilValue = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height:screenHeight * .02,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap:(){
                        if (_globalKey.currentState.validate()){
                          _globalKey.currentState.save();
                          try{
                            editAqar();
                            Fluttertoast.showToast(
                                msg: "تم تعديل العقار",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            Navigator.pushNamed(context, MyAqar.id);
                          }on PlatformException catch(e){

                          }
                        }
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)
                        ),
                        elevation: 9,
                        color: Colors.white,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: kMainColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: kMainColor.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 4,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child:  Center(
                            child: Text(
                                "تعديل",
                                style: GoogleFonts.cairo(
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                            ),
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
    );
  }
  Future<void> _optionsDialogBox() {
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Row(
                      children: <Widget>[
                        new Icon(Icons.camera_alt),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        new Text('ألتقط صوره')
                      ],
                    ),
                    onTap: openCamera,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Row(
                      children: <Widget>[
                        new Icon(Icons.camera),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        new Text('أختر من الصور الموجوده')
                      ],
                    ),
                    onTap: openGallery,
                  ),
                ],
              ),
            ),
          );
        });
  }
  void openGallery()async{
    PickedFile gallery = await _picker.getImage(source: ImageSource.gallery);
    final File file_gallery = File(gallery.path);
    setState(() {
      Navigator.pop(context);
      _image=file_gallery;
      editImage();
    });
  }
  void openCamera()async{
    PickedFile camera = await _picker.getImage(source: ImageSource.camera);
    final File file_camera = File(camera.path);
    setState(() {
      Navigator.pop(context);
      _image=file_camera;
      editImage();
    });
  }
}
