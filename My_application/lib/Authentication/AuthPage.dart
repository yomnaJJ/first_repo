import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_application/Authentication/DashBoard/DashBoard.dart';

import '../module/SnackBar.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  GlobalKey<ScaffoldState> _scafoldKey = new GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool ObsecurePasswordText = true;
  bool isLoginActivated = true;
  TextEditingController FirstLastNameController = TextEditingController();
  TextEditingController PhoneNumberController = TextEditingController();
  TextEditingController SignUpEmailController = TextEditingController();
  TextEditingController SignUpPasswordController = TextEditingController();
  double passBruteforseStrength = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldKey,
      backgroundColor: const Color(0xff9B5DE5),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Visibility(
          visible: isLoginActivated,
          //Login design
          child: loginScreenDesign(context),
          // Signup design
          replacement: signUpScreenDesign(context),
        ),
      ),
    );
  }

  Widget loginScreenDesign(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/new logo.png'),
                    fit: BoxFit.fill),
              )),
        ),
        Center(
          child: Text(
            'Login',
            style: GoogleFonts.andadaPro(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.4),
                      blurRadius: 5.0,
                      offset: const Offset(0, 3),
                    )
                  ]),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                    )),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: GoogleFonts.andadaPro(
                            color: Colors.grey,
                          )),
                    ),
                  ),
                  Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                        ),
                      )),
                      child: TextField(
                        controller: passwordController,
                        obscureText: ObsecurePasswordText,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: GoogleFonts.andadaPro(
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            icon: ObsecurePasswordText == true
                                ? Icon(Icons.remove_red_eye)
                                : Icon(Icons.remove_red_eye_outlined),
                            color: const Color(0xffF15BB5),
                            onPressed: () {
                              if (ObsecurePasswordText == true) {
                                setState(() {
                                  ObsecurePasswordText = false;
                                });
                              } else {
                                setState(() {
                                  ObsecurePasswordText = true;
                                });
                              }
                            },
                          ),
                        ),
                      ))
                ],
              )),
        ),
        const SizedBox(height: 30),
        Center(
          child: InkWell(
            onTap: () {
              print('Login Button Pressed');
              userLoginInputValidation();
            },
            child: Container(
              height: 45,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffFEE440).withOpacity(0.9),
              ),
              child: Center(
                child: Text(
                  'Login',
                  style: GoogleFonts.andadaPro(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Center(
          child: GestureDetector(
            onTap: () async {
              showInSnackBar(
                  'Working on it please wait...',
                  const Color(0xff00BBF9),
                  Colors.white,
                  2,
                  context,
                  _scafoldKey);
              Future.delayed(const Duration(seconds: 2), () {
                sendRecoveryPass();
              });
            },
            child: Text(
              'Forget Password ? ',
              style: GoogleFonts.andadaPro(
                color: Colors.white,
                fontSize: 21,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isLoginActivated = false;
              });
              clearControllers();
            },
            child: Text(
              'Don\'t have an account ?',
              style: GoogleFonts.andadaPro(
                color: Colors.white,
                fontSize: 21,
              ),
            ),
          ),
        ),
      ],
    );
  }

  sendRecoveryPass() async {
    if (emailController.text == null ||
        emailController.text.contains('@') == false ||
        emailController.text.contains('.com') == false) {
      showInSnackBar(
          'Invalid Email', Colors.red, Colors.white, 2, context, _scafoldKey);
    } else {
      await FirebaseFirestore.instance
          .collection('userAccount')
          .where('UserEmail', isEqualTo: emailController.text)
          .get()
          .then((whereResult) async {
        if (whereResult == null && whereResult.docs.isEmpty) {
          showInSnackBar('There is no record for this email', Colors.red,
              Colors.white, 3, context, _scafoldKey);
        } else {
          try {
            await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text).then((metaData) {
              showInSnackBar('Reset password email has been sent ', const Color(0xff00BBF9), Colors.white, 2, context, _scafoldKey);passwordController.clear();
            });
          } catch (e) {
            showInSnackBar('There is no record for this email', Colors.red,
                Colors.white, 3, context, _scafoldKey);
          }
        }
      });
    }
  }

  Widget signUpScreenDesign(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/new logo.png'),
                    fit: BoxFit.fill),
              )),
        ),
        Center(
          child: Text(
            'SignUp',
            style: GoogleFonts.andadaPro(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.4),
                      blurRadius: 5.0,
                      offset: const Offset(0, 3),
                    )
                  ]),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                    )),
                    child: TextField(
                      controller: FirstLastNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'First & Last name ',
                          hintStyle: GoogleFonts.andadaPro(
                            color: Colors.grey,
                          )),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                    )),
                    child: TextField(
                      controller: PhoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: ' Phone number ',
                          hintStyle: GoogleFonts.andadaPro(
                            color: Colors.grey,
                          )),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                    )),
                    child: TextField(
                      controller: SignUpEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: GoogleFonts.andadaPro(
                            color: Colors.grey,
                          )),
                    ),
                  ),
                  Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                        ),
                      )),
                      child: TextField(
                        controller: SignUpPasswordController,
                        obscureText: ObsecurePasswordText,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: GoogleFonts.andadaPro(
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            icon: ObsecurePasswordText == true
                                ? Icon(Icons.remove_red_eye)
                                : Icon(Icons.remove_red_eye_outlined),
                            color: const Color(0xffF15BB5),
                            onPressed: () {
                              if (ObsecurePasswordText == true) {
                                setState(() {
                                  ObsecurePasswordText = false;
                                });
                              } else {
                                setState(() {
                                  ObsecurePasswordText = true;
                                });
                              }
                            },
                          ),
                        ),
                      ))
                ],
              )),
        ),
        const SizedBox(height: 30),
        Center(
          child: InkWell(
            onTap: () async {
              print('Login Button Pressed');
              userSignUpInputValidation();
            },
            child: Container(
              height: 45,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffFEE440).withOpacity(0.9),
              ),
              child: Center(
                child: Text(
                  'Create Account',
                  style: GoogleFonts.andadaPro(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isLoginActivated = true;
              });
              clearControllers();
            },
            child: Text(
              'Have an account ?',
              style: GoogleFonts.andadaPro(
                color: Colors.white,
                fontSize: 21,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void userLoginInputValidation() {
    if (emailController.text == null ||
        emailController.text.contains('@') == false ||
        emailController.text.contains('.com') == false) {
      showInSnackBar(
          'Invalid Email', Colors.red, Colors.white, 2, context, _scafoldKey);
    } else if (passwordController.text == null ||
        passwordController.text.length < 8) {
      showInSnackBar('Invalid Password', Colors.red, Colors.white, 2, context,
          _scafoldKey);
    } else {
      print('Validation Completed');
      showInwaitingSnackBar('Logging you in, please wait...',
          const Color(0xfff00bbf9), Colors.white, context, _scafoldKey);
      Future.delayed(const Duration(seconds: 2), () {
        loginUser();
      });
    }
  }

  Future loginUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ).then((userCredentials) async {
        if (userCredentials.user.uid != null) {
          if (userCredentials.user.emailVerified == false) {
            clearControllers();
            await userCredentials.user.sendEmailVerification();
            await FirebaseAuth.instance.signOut().then((value) {
              showInSnackBar('Your email is not verified, please verify your email ', const Color(0xff00BBF9), Colors.white, 2, context, _scafoldKey);
            });
          } else {
            await FirebaseFirestore.instance
                .collection('userAccount')
                .doc(userCredentials.user.uid)
                .get()
                .then((userDoc) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.of(context).pushReplacement(CupertinoPageRoute(
                  builder: (BuildContext context) => Dashboard(
                        userData: userDoc,
                      )));
            });
          }
        } else {
          showInSnackBar('Login failed due to incorrect account information ',
              Colors.red, Colors.white, 2, context, _scafoldKey);
        }
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      showInSnackBar('Login failed due to incorrect account information ',
          Colors.red, Colors.white, 2, context, _scafoldKey);
    }
  }

  estimateBruteforseStrength() {
    setState(() {
      passBruteforseStrength = 0;
    });
    if (SignUpPasswordController.text.isEmpty) return 0.0;
    double charsetBonus;
    if (RegExp(r'^[0-9]+$').hasMatch(SignUpPasswordController.text)) {
      charsetBonus = 0.7;
    } else if (RegExp(r'^[a-z]+$').hasMatch(SignUpPasswordController.text)) {
      charsetBonus = 1.0;
    } else if (RegExp(r'^[a-z0-9]+$').hasMatch(SignUpPasswordController.text)) {
      charsetBonus = 1.2;
    } else if (RegExp(r'^[a-zA-Z]+$').hasMatch(SignUpPasswordController.text)) {
      charsetBonus = 1.3;
    } else if (RegExp(r'^[a-z\-_!?]+$')
        .hasMatch(SignUpPasswordController.text)) {
      charsetBonus = 1.3;
    } else if (RegExp(r'^[a-zA-Z0-9]+$')
        .hasMatch(SignUpPasswordController.text)) {
      charsetBonus = 1.5;
    } else {
      charsetBonus = 1.8;
    }
    setState(() {
      passBruteforseStrength = double.parse(
          (SignUpPasswordController.text.length * charsetBonus)
              .toStringAsFixed(2));
    });
    print(passBruteforseStrength);
  }

  void userSignUpInputValidation() {
    if (FirstLastNameController.text == null ||
        FirstLastNameController.text.length < 6) {
      showInSnackBar('Please enter your first and last name', Colors.red,
          Colors.white, 2, context, _scafoldKey);
    } else if (PhoneNumberController.text == null ||
        PhoneNumberController.text.contains('05') == false ||
        PhoneNumberController.text.length < 10) {
      showInSnackBar('Please enter your phone number, ex: 05xxxxxxxxx',
          Colors.red, Colors.white, 2, context, _scafoldKey);
    } else if (SignUpEmailController.text == null ||
        SignUpEmailController.text.contains('@') == false ||
        SignUpEmailController.text.contains('.com') == false) {
      showInSnackBar(
          'Invalid Email', Colors.red, Colors.white, 2, context, _scafoldKey);
    } else if (SignUpPasswordController.text == null ||
        SignUpPasswordController.text.length < 8) {
      showInSnackBar('Password is too weak', Color(0xffF15BB5), Colors.white, 2,
          context, _scafoldKey);
    } else {
      print('Validation Completed');
      showInwaitingSnackBar('Creating your account, please wait...',
          const Color(0xffF00BBF9), Colors.white, context, _scafoldKey);
      Future.delayed(const Duration(seconds: 2), () {
        signUpCreateUserAccount();
      });
    }
  }

  Future signUpCreateUserAccount() async {
    DocumentSnapshot<Map<String, dynamic>> userData;
    try {
      print(SignUpEmailController.text.toString());
      print(SignUpPasswordController.text.toString());
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: SignUpEmailController.text,
              password: SignUpPasswordController.text).then((userCredentials) async {
        print(userCredentials.user.uid);
        if (userCredentials.user != null) {userCredentials.user.sendEmailVerification().then((metaData) async {
            try {
              await FirebaseFirestore.instance.collection('userAccount').doc(userCredentials.user.uid).set({
                'UserId': userCredentials.user.uid,
                'UserEmail': userCredentials.user.email,
                'UserName': FirstLastNameController.text,
                'UserPhoneNumber': PhoneNumberController.text,
                'AccountCreateDateTime': DateTime.now(),
                'IsEmailVerified': false,
              }).then((value) async {
                await FirebaseFirestore.instance
                    .collection('userAccount')
                    .doc(userCredentials.user.uid)
                    .get()
                    .then((userDbData) async {
                  setState(() {
                    userData = userDbData;
                  });
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  clearControllers();
                  await FirebaseAuth.instance.signOut();
                  showInSnackBar(
                      'The verification email has been sent😉....', const Color(0xff00BBF9), Colors.white, 3, context, _scafoldKey);
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      isLoginActivated = true;
                    });
                  });
                });
              });
            } catch (e) {
              await FirebaseAuth.instance.currentUser
                  .delete()
                  .then((value) async {
                await FirebaseAuth.instance.signOut().then((value) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  showInSnackBar('An error occur due to created account',
                      Colors.red, Colors.white, 3, context, _scafoldKey);
                });
              });
            }
          });
        }
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      showInSnackBar(
          e.message.trim(), Colors.red, Colors.white, 3, context, _scafoldKey);
    }
  }

  clearControllers() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    FirstLastNameController.clear();
    PhoneNumberController.clear();
    SignUpEmailController.clear();
    SignUpPasswordController.clear();
    emailController.clear();
    passwordController.clear();
  }
}
