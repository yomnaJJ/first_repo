import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_application/module/SnackBar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import 'DashBoard.dart';

class Cart extends StatefulWidget {
  Cart({Key key, this.userData}) : super(key: key);
  DocumentSnapshot<Map<String, dynamic>> userData;
  @override
  State<Cart> createState() => _Cart();
}

class _Cart extends State<Cart> {
  QuerySnapshot<Map<String, dynamic>> cartItems;
  @override
  void initState() {
    getCart();
    super.initState();
  }

  getCart() async {
    try {
      await FirebaseFirestore.instance
          .collection('Cart')
          .where('BelongsToUID', isEqualTo: widget.userData.id)
          .get()
          .then((value) {
        if (value.docs.isEmpty == false) {
          setState(() {
            cartItems = value;
          });
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _lunchUrl(Uri uri) async {
    if (!await canLaunchUrl(
      uri,
    )) {
      throw 'could not lunch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff9B5DE5),
      appBar: AppBar(
        toolbarHeight: 57.0,
        backgroundColor: Color(0xff8135DE),
        elevation: 10,
        title: Text(
          'Coupons Cart 🛒',
          style: GoogleFonts.andadaPro(
            color: Colors.white,
            fontSize: 19,
          ),
        ),
      ),
      body: cartList(context),
    );
  }

  Widget cartList(BuildContext context) {
    if (cartItems != null) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: cartItems.docs.length,
          itemBuilder: (context, i) {
            return InkWell(
              onTap: () {
                // Here when you click on the offer
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 11.0),
                child: SizedBox(
                  height: 195,
                  width: double.maxFinite,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 250,
                        width: 145,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: Colors.transparent,
                            image: DecorationImage(
                                image: NetworkImage(cartItems.docs[i]
                                    .data()['Item']['OfferImageURL']
                                    .toString()),
                                fit: BoxFit.fill)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItems.docs[i].data()['Item']
                                  ['DestinationName'],
                              style: GoogleFonts.andadaPro(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              cartItems.docs[i].data()['Item']
                                  ['DestinationType'],
                              // ' women\'s beauty salon 💄 ',
                              style: GoogleFonts.andadaPro(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Contact us',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final url = Uri.parse('tel:+123456789');
                                    await launchUrl(url);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xffFEE440),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.phone,
                                        color: Color(0xff6A20C5),
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 25,),
                                ElevatedButton(
                                  onPressed: () async {
                                    if(cartItems.docs.length>=2) {
                                      await FirebaseFirestore.instance
                                          .collection('Cart')
                                          .doc(cartItems.docs[i].id)
                                          .delete().then((value) {
                                        getCart();
                                        cartList(context);
                                      });
                                    }else{
                                      await FirebaseFirestore.instance
                                          .collection('Cart')
                                          .doc(cartItems.docs[i].id)
                                          .delete().then((value) {
                                        Navigator.of(context).push(CupertinoPageRoute(
                                            builder: (BuildContext context) => Dashboard(
                                              userData: widget.userData,
                                            )));
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.delete,
                                        color: Color(0xff6A20C5),
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
