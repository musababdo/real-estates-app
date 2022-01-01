
import 'package:aqar/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomListTile extends StatelessWidget {

  var titleName;

  CustomListTile(this.titleName);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      //height: MediaQuery.of(context).size.height * 0.6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
            decoration: new BoxDecoration(
                color: kMainColor,
                borderRadius: new BorderRadius.only(
                  topLeft:  const  Radius.circular(40.0),
//                  topRight: const  Radius.circular(40.0),
//                  bottomLeft: const  Radius.circular(40.0),
                  bottomRight: const  Radius.circular(40.0),
                )),
            child: Center(
                child: Text(this.titleName.toString(), style: GoogleFonts.cairo(
                  textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                  ),
                ),)
            )),
      ),
    );
  }
}