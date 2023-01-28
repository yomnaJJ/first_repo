import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_application/Authentication/DashBoard/DashBoard.dart';
import 'AuthPage.dart';

class SplashSreen extends StatefulWidget {
  const SplashSreen({Key key}) : super(key: key);

  @override
  State<SplashSreen> createState() => _SplashSreenState();
}
class _SplashSreenState extends State<SplashSreen> {

  @override
  void initState(){
    navigateAfterDuration();
    super.initState();
  }

  void navigateAfterDuration()async {
    User user=FirebaseAuth.instance.currentUser;
    if(user!=null && user.uid!=null){
      Future.delayed(const Duration(seconds: 4),()async{
       try{
         await FirebaseFirestore.instance.collection('userAccount').doc(user.uid).get().then((userDoc)async{
           if(userDoc.id!=null && userDoc.data().isNotEmpty==true) {
             // ScaffoldMessenger.of(context).hideCurrentSnackBar();
             Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context)=> Dashboard(userData: userDoc,)));
           }else{
             // ScaffoldMessenger.of(context).hideCurrentSnackBar();
             await FirebaseAuth.instance.signOut().then((value) {
               Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context)=> const AuthenticationPage()));
             });
           }
         });
       }catch(e){}
      });
  }else{
      Future.delayed(const Duration(seconds: 4),(){
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context)=> const AuthenticationPage()));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff9B5DE5),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 250,
                width: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/new logo.png'),
                    fit: BoxFit.fill
                  ),
                  )
                  ),
              Text(
                'weddings & celebrations app',
                style: GoogleFonts.andadaPro(
                  color: Colors.white,
                  fontSize:27,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 200),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  'Loading',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize:24,
                  ),
                ),
              ),

            ],
          )


        ),
      ),
    );
  }
}
