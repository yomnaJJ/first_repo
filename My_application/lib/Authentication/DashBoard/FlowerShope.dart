import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../module/SnackBar.dart';

class FlowerShop extends StatefulWidget {
  FlowerShop({Key key, this.userData}) : super(key: key);
  DocumentSnapshot<Map<String, dynamic>> userData;

  @override
  State<FlowerShop> createState() => _FlowerShopState();
}
class _FlowerShopState extends State<FlowerShop> {
  QuerySnapshot<Map<String, dynamic>> FlowerShop;

  File selectedImage;
  TextEditingController detinationNameController = TextEditingController();
  TextEditingController detinationRateController = TextEditingController();
  TextEditingController offerDescriptionController = TextEditingController();
  var detinationType;

  @override
  void initState() {
    getOffers();
    super.initState();
  }

  Future getOffers() async {
    try {
      await FirebaseFirestore.instance.collection('FlowerShop').get().then((value) {
        if (value.docs.isNotEmpty == true) {
          setState(() {
            FlowerShop = value;
          });
        }
      });
    } catch (e) {
      print(e);
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
          'Flower Shop💐',
          style: GoogleFonts.andadaPro(
            color: Colors.white,
            fontSize: 19,
          ),
        ),
      ),
      body: flowList(context),
    );
  }
  Widget flowList(BuildContext context) {
    if (FlowerShop != null) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
            itemCount: FlowerShop.docs.length,
            itemBuilder: (context, i) {
              return Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: SizedBox(
                      height: 160,
                      width: double.maxFinite,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 600,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                color: Colors.white,
                                image: DecorationImage(
                                    image: NetworkImage(FlowerShop.docs[i]
                                        .data()['photoURL']),
                                    fit: BoxFit.fill)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child:Row(
                              children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 253,
                                        child: Text(
                                          FlowerShop.docs[i].data()['category'].toString(),
                                          style: GoogleFonts.andadaPro(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        width: 253,
                                        child: Text(
                                          FlowerShop.docs[i].data()['name'].toString(),
                                          style: GoogleFonts.andadaPro(
                                            color: Colors.white,

                                            fontSize: 14,
                                          ),
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        width: 253,
                                        child: Text(
                                          FlowerShop.docs[i].data()['information '].toString(),
                                          style: GoogleFonts.andadaPro(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 13,
                                          ),
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines:3,
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
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
                                                  size: 15,
                                                ),
                                              ],
                                            ),
                                          ),

                                        ],
                                      )
                                    ]),
                              ],
                            ),
                          )

                        ],

                      )));
            }),
      );
    } else {
      return SizedBox();
    }
  }
}