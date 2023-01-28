import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

showInSnackBar(String value,Color backgroundColor,Color textColor,int duration,BuildContext context, GlobalKey<ScaffoldState>_scafoldKey){
    FocusScope.of(context).requestFocus(FocusNode());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:Container(
          height: 50,
            width:double.maxFinite,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child:Text(
                value,
                textAlign: TextAlign.center,
                style: GoogleFonts.andadaPro(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      elevation: 0,
        backgroundColor: Colors.transparent ,
        duration: Duration(seconds: duration),
    ));

}

showInwaitingSnackBar(String value,Color backgroundColor,Color textColor,BuildContext context, GlobalKey<ScaffoldState>_scafoldKey){
  FocusScope.of(context).requestFocus(FocusNode());
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content:Container(
      height: 50,
      width:double.maxFinite,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child:Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.andadaPro(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),

          ),
        ),
      ),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent ,

  ));

}