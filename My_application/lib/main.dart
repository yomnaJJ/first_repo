import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_application/Authentication/SplashScreen.dart';
import 'Authentication/DashBoard/Cart.dart';
import 'Authentication/DashBoard/DashBoard.dart';


bool showCartBadge=false;
int cartBadgeCount=0;
QuerySnapshot<Map<String, dynamic>> cartItems;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Celebration app',
      debugShowCheckedModeBanner: false,
      home: SplashSreen(),
    );

  }
}
