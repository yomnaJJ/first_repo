import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_application/module/SnackBar.dart';
import '../../main.dart';
import '../AuthPage.dart';
import 'Cart.dart';
import 'Category.dart';
import 'DrawerPages/BeautySaloon.dart';
import 'FastControlPages/searchPage.dart';
import 'FlowerShope.dart';
import 'makeupArtist.dart';
import 'package:search_page/search_page.dart';



class Dashboard extends StatefulWidget {
  DocumentSnapshot<Map<String, dynamic>> userData;

  @override
  _DashboardState createState() => _DashboardState();
  Dashboard({Key key, this.userData}) : super(key: key);
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _Scafoldkey = GlobalKey();
  final _advancedDrawerController = AdvancedDrawerController();
  QuerySnapshot<Map<String, dynamic>> Offers;
  QuerySnapshot<Map<String, dynamic>> categories;

  @override
  void initState() {
    getBestOffers();
    getCart();
    super.initState();
  }

  Future getBestOffers() async {
    try {
      await FirebaseFirestore.instance
          .collection('Category')
          .get()
          .then((value) {
        if (value.docs.isNotEmpty == true) {
          setState(() {
            categories = value;
          });
        }
      });
      await FirebaseFirestore.instance.collection('Offers').get().then((value) {
        if (value.docs.isNotEmpty == true) {
          setState(() {
            Offers = value;
          });
        }
      });
    } catch (e) {
      print(e);
    }
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
            cartBadgeCount = value.docs.length;
            showCartBadge = true;
          });
        } else {
          setState(() {
            showCartBadge = false;
            cartBadgeCount = 0;
          });
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _hundlaMenuButtonBressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: const Color(0xffA874E8),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 50),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(
                  top: 24.0,
                  bottom: 10.0,
                ),
                decoration: const BoxDecoration(
                    color: Color(0xff9B5DE5),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/blank-profile-picture-g6a1acfe07_1280.png'),
                        fit: BoxFit.fill)),
              ),
              Text(
                widget.userData.data()['UserName'].toString(),
                style: GoogleFonts.andadaPro(
                  color: Colors.white,
                  fontSize: 19,
                ),
              ),
              SizedBox(
                height: 55,
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.email),
                title: Text(
                  widget.userData.data()['UserEmail'].toString(),
                  style: GoogleFonts.andadaPro(
                    color: Colors.white,
                    fontSize: 19,
                  ),
                ),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(LineIcons.alternatePhone),
                title: Text(
                  widget.userData.data()['UserPhoneNumber'].toString(),
                  style: GoogleFonts.andadaPro(
                    color: Colors.white,
                    fontSize: 19,
                  ),
                ),
              ),
              Spacer(),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Material(
                      color: const Color(0xffFEE440),
                      type: MaterialType.card,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child:InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SignOut',
                              style: GoogleFonts.andadaPro(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                          onTap: () async {
                            await FirebaseAuth.instance.signOut().then((value) {
                              Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context)=> AuthenticationPage()));
                            });
                          },
                        ),
                      )),

                ),
              ),
            ],
          ),
        ),
      ),
      child: Scaffold(
        key: _Scafoldkey,
        backgroundColor: const Color(0xff9B5DE5),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            padding: EdgeInsets.only(top: 23),
            children: [
              headerSection(context),
              bestOffersSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: _hundlaMenuButtonBressed,
                    child: Material(
                      color: const Color(0xffFEE440),
                      type: MaterialType.card,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ValueListenableBuilder<AdvancedDrawerValue>(
                          valueListenable: _advancedDrawerController,
                          builder: (_, value, __) {
                            return AnimatedSwitcher(
                              duration: Duration(milliseconds: 250),
                              child: Icon(
                                value.visible
                                    ? Icons.clear
                                    : Icons.toc_outlined,
                                color: Colors.white,
                                size: 25,
                                key: ValueKey<bool>(value.visible),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (widget.userData.data()['UserName']),
                      style: GoogleFonts.andadaPro(
                        color: Colors.white,
                        fontSize: 19,
                      ),
                    ),
                  ],
                )
              ],
            ),

            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                    child:InkWell(
                    child: Material(
                      color: Color(0xffFEE440),
                      type: MaterialType.circle,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                        onTap: () {
                          showSearch(
                              context: context,
                              delegate: CategorySearch()
                          );
                        },
                    )

                ),

                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    child: Badge(
                      badgeColor: Colors.white,
                      showBadge: showCartBadge,
                      badgeContent: Text(
                        cartBadgeCount.toString(),
                        style: TextStyle(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.bold),
                      ),
                      child: Material(
                        color: Color(0xffFEE440),
                        type: MaterialType.circle,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {

                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (BuildContext context) => Cart(
                                userData: widget.userData,
                              )));
                    },
                  ),
                ),
                if (showCartBadge)
                  const SizedBox(
                    width: 10,
                  )
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget bestOffersSection(BuildContext context) {
    if (Offers != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ' Categories ✨ ',
            style: GoogleFonts.andadaPro(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 236,
            width: double.maxFinite,
            child: ListView(
              padding: EdgeInsets.zero,
              physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: SizedBox(
                    height: 236,
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Container(
                            height: 215,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.transparent,
                              image: const DecorationImage(
                                image: AssetImage('assets/images/c1.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (BuildContext context) => Category(
                                      userData: widget.userData,
                                    )));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: SizedBox(
                    height: 236,
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Container(
                            height: 215,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.transparent,
                              image: const DecorationImage(
                                image: AssetImage('assets/images/makeup.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (BuildContext context) => MakeupArtist(
                                      userData: widget.userData,
                                    )));
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: SizedBox(
                    height: 236,
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Container(
                            height: 215,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.transparent,
                              image: const DecorationImage(
                                image: AssetImage('assets/images/flower.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (BuildContext context) => FlowerShop(
                                      userData: widget.userData,
                                    )));
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: SizedBox(
                    height: 236,
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Container(
                            height: 215,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.transparent,
                              image: const DecorationImage(
                                image: AssetImage('assets/images/saloon.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (BuildContext context) => BeautySaloon(
                                      userData: widget.userData,
                                    )));
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            ' Best offers 🔥 ',
            style: GoogleFonts.andadaPro(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          if (Offers.docs.isEmpty == false)
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: Offers.docs.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    // Here when you click on the offer
                    itemDetailBottomSheet(context, Offers.docs[i]);
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
                                    image: NetworkImage(Offers.docs[i]
                                        .data()['OfferImageURL']
                                        .toString()),
                                    fit: BoxFit.fill)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        Offers.docs[i]
                                            .data()['DestinationName'],
                                        style: GoogleFonts.andadaPro(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        Offers.docs[i]
                                            .data()['DestinationType'],
                                        // ' women\'s beauty salon 💄 ',
                                        style: GoogleFonts.andadaPro(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 14,
                                        ),
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      );
    } else {
      return SizedBox(
        height: 1,
      );
    }
  }

  itemDetailBottomSheet(BuildContext context,
      DocumentSnapshot<Map<String, dynamic>> selectedOffer) {
    return showMaterialModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.8),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 25),
            child: SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child: Container(
                height: MediaQuery.of(context).size.height / 1.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xffA874E8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 275,
                        width: 175,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: Colors.white,
                            image: DecorationImage(
                                image: NetworkImage(selectedOffer
                                    .data()['OfferImageURL']
                                    .toString()),
                                fit: BoxFit.fill)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(
                          selectedOffer.data()['DestinationName'],
                          style: GoogleFonts.andadaPro(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        selectedOffer.data()['DestinationType'].toString(),
                        style: GoogleFonts.andadaPro(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 16,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '🕑',
                            style: GoogleFonts.andadaPro(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(
                                    selectedOffer.data()['OfferDate'].toDate())
                                .toString(),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '📷',
                              style: GoogleFonts.andadaPro(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '  ${selectedOffer.data()['OffersDescription'].toString()}',
                              style: GoogleFonts.andadaPro(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Container(
                                width: 125,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Cancel',
                                          style: GoogleFonts.andadaPro(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(
                                          LineIcons.stopCircle,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ],
                                    )),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              child: Container(
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Color(0xffFEE440),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'reserve coupon',
                                          style: GoogleFonts.andadaPro(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(
                                          LineIcons.shoppingCart,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ],
                                    )),
                              ),
                              onTap: () async {
                                await FirebaseFirestore.instance
                                    .collection('Cart')
                                    .add({
                                  'Item': selectedOffer.data(),
                                  'BelongsToUID': widget.userData.id,
                                }).then((value) {
                                  getCart();
                                  Navigator.of(context).pop();
                                  showInSnackBar(
                                      'coupon has reserved 🤩',
                                      Color(0xff00BBF9),
                                      Colors.white,
                                      3,
                                      context,
                                      _Scafoldkey);
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
class CategorySearch extends SearchDelegate {
  List<String> searchResult = [
    'Photographer',
    'MakeUp Artist',
    'Beauty Saloon',
    'Flower Shop',
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      ),
    ];
  }
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },

    );
  }
  @override
  Widget buildResults(BuildContext context) =>
      Center(
        child: Text(
            'Photographer'
        ),
      );
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> Suggestions = searchResult.where((searchResult) {
      final result = searchResult.toLowerCase();
      final intput = query.toLowerCase();
      return result.contains(intput);
    }).toList();
    return ListView.builder(
        itemCount: Suggestions.length,
        itemBuilder: (context, index) {
          var Suggestion = Suggestions[index];
          return ListTile(
            title: Text(Suggestion),
            onTap: () {
              query = Suggestion;
              if ( Text('Photographer') != null){
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (BuildContext context) =>
                      Category(
                      )));}
              if ( Text('MakeUp Artist') != null){
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        MakeupArtist(
                        )));}
              if ( Text('Flower Shop') != null){
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        FlowerShop(
                        )));}
              if ( Text('Beauty Saloon') != null){
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        BeautySaloon(
                        )));}
            },
          );
        });
  }
}
