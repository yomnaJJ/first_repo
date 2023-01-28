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

class MakeupArtist extends StatefulWidget {
  MakeupArtist({Key key, this.userData}) : super(key: key);
  DocumentSnapshot<Map<String, dynamic>> userData;
  @override
  State<MakeupArtist> createState() => _MakeupArtistState();
}
class _MakeupArtistState extends State<MakeupArtist> {
  QuerySnapshot<Map<String, dynamic>> MakeupArtist;

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
      await FirebaseFirestore.instance
          .collection('MakeUpArtist')
          .get()
          .then((value) {
        if (value.docs.isNotEmpty == true) {
          setState(() {
            MakeupArtist = value;
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
          'Makeup Artist💄',
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
    if (MakeupArtist != null) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
            itemCount: MakeupArtist.docs.length,
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
                            height: 800,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                color: Colors.white,
                                image: DecorationImage(
                                    image: NetworkImage(MakeupArtist.docs[i]
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
                                          MakeupArtist.docs[i].data()['category'].toString(),
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
                                          MakeupArtist.docs[i].data()['name'].toString(),
                                          style: GoogleFonts.andadaPro(
                                            color: Colors.white,

                                            fontSize: 14,
                                          ),
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        width: 253,
                                        child: Text(
                                          MakeupArtist.docs[i].data()['infomation'].toString(),
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
                                        maxLines: 2,
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