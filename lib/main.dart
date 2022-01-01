

import 'package:aqar/admin/admin.dart';
import 'package:aqar/admin/showusers.dart';
import 'package:aqar/onboarding/boardingHome.dart';
import 'package:aqar/profile/profile_screen.dart';
import 'package:aqar/screens/addaqar.dart';
import 'package:aqar/screens/editaqar.dart';
import 'package:aqar/screens/home.dart';
import 'package:aqar/screens/land.dart';
import 'package:aqar/screens/myaqar.dart';
import 'package:aqar/screens/myui.dart';
import 'package:aqar/screens/rent.dart';
import 'package:aqar/screens/searchresult.dart';
import 'package:aqar/screens/sell.dart';
import 'package:aqar/screens/spalshscreen.dart';
import 'package:aqar/sell/east.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isUserLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //initialRoute: isUserLoggedIn ? SplashScreen.id : Myui.id,
      initialRoute: BoardingHome.id,
      routes: {
        BoardingHome.id: (context) => BoardingHome(),
        Home.id: (context) => Home(),
        SplashScreen.id: (context) => SplashScreen(),
        Rent.id: (context) => Rent(),
        Sell.id: (context) => Sell(),
        Land.id: (context) => Land(),
        Myui.id: (context) => Myui(),
        MyAqar.id: (context) => MyAqar(),
        AddAqar.id: (context) => AddAqar(),
        EditAqar.id: (context) => EditAqar(),
        ProfileScreen.id: (context) => ProfileScreen(),
        East.id: (context) => East(),
        searchResult.id: (context) => searchResult(),
        Admin.id: (context) => Admin(),
        Showusers.id: (context) => Showusers(),
      },
    );
  }
}
