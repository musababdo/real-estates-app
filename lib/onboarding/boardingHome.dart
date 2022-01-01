import 'dart:io';

import 'package:aqar/model/sliderModel.dart';
import 'package:aqar/onboarding/slideTile.dart';
import 'package:aqar/screens/home.dart';
import 'package:flutter/material.dart';

class BoardingHome extends StatefulWidget {
  static String id='boardinghome';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<BoardingHome> {

  List<SliderModel> mySLides = new List<SliderModel>();
  int slideIndex = 0;
  PageController controller;

  Widget _buildPageIndicator(bool isCurrentPage){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySLides = getSlides();
    controller = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [const Color(0xff3C8CE7), const Color(0xff00EAFF)])),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            height: MediaQuery.of(context).size.height - 100,
            child: PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  slideIndex = index;
                });
              },
              children: <Widget>[
                SlideTile(
                  imagePath: mySLides[0].getImageAssetPath(),
                  title: mySLides[0].getTitle(),
                  desc: mySLides[0].getDesc(),
                ),
                SlideTile(
                  imagePath: mySLides[1].getImageAssetPath(),
                  title: mySLides[1].getTitle(),
                  desc: mySLides[1].getDesc(),
                ),
                SlideTile(
                  imagePath: mySLides[2].getImageAssetPath(),
                  title: mySLides[2].getTitle(),
                  desc: mySLides[2].getDesc(),
                )
              ],
            ),
          ),
          bottomSheet: slideIndex != 2 ? Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                FlatButton(
                onPressed: (){
          controller.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.linear);
          },
            splashColor: Colors.blue[50],
            child: Text(
              "تخطي",
              style: TextStyle(color: Color(0xFF0074E4), fontWeight: FontWeight.w600),
            ),
          ),
          Container(
              child: Row(
                  children: [
              for (int i = 0; i < 3 ; i++) i == slideIndex ? _buildPageIndicator(true): _buildPageIndicator(false),
      ],),
    ),
    FlatButton(
    onPressed: (){
    //print("this is slideIndex: $slideIndex");
    controller.animateToPage(slideIndex + 1, duration: Duration(milliseconds: 500), curve: Curves.linear);
    },
    splashColor: Colors.blue[50],
    child: Text(
    "التالي",
    style: TextStyle(color: Color(0xFF0074E4), fontWeight: FontWeight.w600),
    ),
    ),
    ],
    ),
    ): InkWell(
    onTap: (){
    Navigator.pushNamed(context, Home.id);
    },
    child: Padding(
    padding: const EdgeInsets.all(10),
    child: Card(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20)
    ),
    elevation: 8,
    child: Container(
    height: Platform.isIOS ? 70 : 60,
    alignment: Alignment.center,
    decoration: new BoxDecoration(
    color: Colors.blue,
    borderRadius: new BorderRadius.only(
    topLeft: const Radius.circular(20),
    topRight: const Radius.circular(20),
    bottomLeft: const Radius.circular(20),
    bottomRight: const Radius.circular(20),
    )
    ),
    child: Text(
    "أبدا",
    style: TextStyle(color: Colors.white,fontSize: 30 ,fontWeight: FontWeight.w600),
    ),
    ),
    ),
    ),
    ),
    ),
    );
  }
}