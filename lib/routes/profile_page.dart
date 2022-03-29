import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pawgo/models/loggedUser.dart';
import 'package:pawgo/routes/profile_editing.dart';
import 'package:pawgo/routes/sign_in_page.dart';
import 'package:pawgo/services/authentication.dart';
import 'package:pawgo/services/mongodb_service.dart';
import 'package:pawgo/size_config.dart';
import 'package:flutter/material.dart';
import 'package:pawgo/utils/mobile_library.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pawgo/assets/custom_colors.dart';


class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  LoggedUser _miUser = LoggedUser.instance!;


  @override
  void initState() {
    _miUser.addListener(() => setState(() {}));
    print("userId of the logged user is: " + _miUser.userId);
    //MongoDB.instance.initUser(_miUser.userId).then((value) => getRideHistory());
    super.initState();
  }

  Widget header() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            left: 30.0, right: 30.0, top: 10 * SizeConfig.heightMultiplier!, bottom: 2.5*SizeConfig.heightMultiplier!),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 11 * SizeConfig.heightMultiplier!,
                  width: 11 * SizeConfig.heightMultiplier!,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      _miUser.image.url,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object object,
                          StackTrace? stacktrace) {
                        return Image.asset("lib/assets/app_icon.png");
                      },
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes as num)
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 5 * SizeConfig.widthMultiplier!,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _miUser.username,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 3 * SizeConfig.textMultiplier!,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 1 * SizeConfig.heightMultiplier!,
                    ),
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              nStringToNNString(_miUser.mail),
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 2 * SizeConfig.textMultiplier!,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 7 * SizeConfig.widthMultiplier!,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 1 * SizeConfig.heightMultiplier!,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    await Authentication.signOut(context: context);
                    setState(() {
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                          _routeToSignInScreen(), (_) => false);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white60),
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.lightGreen,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      child: Text(
                        "SIGN OUT",
                        style: TextStyle(
                            color: Colors.white60,
                            fontSize: 1.8 * SizeConfig.textMultiplier!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      LoggedUser.instance!.username,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 3 * SizeConfig.textMultiplier!,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Username",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 1.9 * SizeConfig.textMultiplier!,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "Smokey", // TODO Add dog's name from dog's instance
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 3 * SizeConfig.textMultiplier!,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Dog's name",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 1.9 * SizeConfig.textMultiplier!,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        pushNewScreen(context,
                            screen: ProfileEditing(),
                            pageTransitionAnimation:
                            PageTransitionAnimation.cupertino);
                      },
                      child: Container(
                        /*width: 15 * SizeConfig.heightMultiplier!,*/
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white60),
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.lightGreen,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "EDIT USER PROFILE",
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: 1.8 * SizeConfig.textMultiplier!),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1 * SizeConfig.heightMultiplier!,
                    ),
                    GestureDetector(
                      onTap: () async {
                        // TODO: To be implemented after DogEditing page is created
                        /*pushNewScreen(context,
                            screen: DogEditing(),
                            pageTransitionAnimation:
                            PageTransitionAnimation.cupertino);*/
                      },
                      child: Container(
                        /*width: 15 * SizeConfig.heightMultiplier!,*/
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white60),
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.lightGreen,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "EDIT DOG PROFILE",
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: 1.8 * SizeConfig.textMultiplier!),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pawrange,
      body: Column(
        children: <Widget>[
          header(),
          Container(
            child: Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0),
                    )),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        userinfo(),
                        Divider(
                          color: Colors.grey,
                        ),
                        dogsinfo(),
                        SizedBox(
                          height: 3 * SizeConfig.heightMultiplier!,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget userinfo() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // TODO: Read User's data from MongoDB <------------------------------
            Padding(
              padding: EdgeInsets.only(top: 3 * SizeConfig.heightMultiplier!),
              child: Text(
                "User's Profile",
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 3 * SizeConfig.textMultiplier!),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  color: Colors.grey.shade200,
                  border: Border.all(
                    color: Colors.black26.withOpacity(0.1),
                  ),
                ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Container(
                                height: 30 * SizeConfig.heightMultiplier!,
                                width: 30 * SizeConfig.heightMultiplier!,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    _miUser.image.url,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context, Object object,
                                        StackTrace? stacktrace) {
                                      return Image.asset("lib/assets/app_icon.png");
                                    },
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              (loadingProgress.expectedTotalBytes as num)
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            Text(
                              "Username:",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 2.5 * SizeConfig.textMultiplier!,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              LoggedUser.instance!.username,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 2.2 * SizeConfig.textMultiplier!,
                              ),
                            ),
                            SizedBox(
                              height: 3 * SizeConfig.heightMultiplier!,
                            ),
                            Text(
                              "Age:",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 2.5 * SizeConfig.textMultiplier!,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "31",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 2.2 * SizeConfig.textMultiplier!,
                              ),
                            ),
                            SizedBox(
                              height: 3 * SizeConfig.heightMultiplier!,
                            ),
                            Text(
                              "Email:",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 2.5 * SizeConfig.textMultiplier!,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              LoggedUser.instance!.mail,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 2.2 * SizeConfig.textMultiplier!,
                              ),
                            ),
                            SizedBox(
                              height: 3 * SizeConfig.heightMultiplier!,
                            ),
                            Text(
                              "Favorite Color:",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 2.5 * SizeConfig.textMultiplier!,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "Pawrange",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 2.2 * SizeConfig.textMultiplier!,
                              ),
                            ),
                           ],
                          ),
                         ),
                        ],
                      ),
                    ],
                  ),
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget dogsinfo() {
    return Container(
      child: SingleChildScrollView(
          child: Column(
            children: [
              // TODO: Read dog's data from MongoDB <---------------------------------
              Padding(
                padding: EdgeInsets.only(top: 3 * SizeConfig.heightMultiplier!),
                child: Text(
                  "Dog's Profile",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 3 * SizeConfig.textMultiplier!),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.black26.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 30 * SizeConfig.heightMultiplier!,
                                  width: 30 * SizeConfig.heightMultiplier!,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(
                                      image: AssetImage('lib/assets/Smokey.jpg'),
                                    ),
                                  ),
                                ),
                                Text(
                                  "Dog's name:",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 2.5 * SizeConfig.textMultiplier!,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                Text(
                                  "Smokey",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 2.2 * SizeConfig.textMultiplier!,
                                  ),
                                ),
                                SizedBox(
                                  height: 3 * SizeConfig.heightMultiplier!,
                                ),
                                Text(
                                  "Bread:",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 2.5 * SizeConfig.textMultiplier!,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                Text(
                                  "Brussels Griffon",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 2.2 * SizeConfig.textMultiplier!,
                                  ),
                                ),
                                SizedBox(
                                  height: 3 * SizeConfig.heightMultiplier!,
                                ),
                                Text(
                                  "Age:",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 2.5 * SizeConfig.textMultiplier!,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                Text(
                                  "3",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 2.2 * SizeConfig.textMultiplier!,
                                  ),
                                ),
                                SizedBox(
                                  height: 3 * SizeConfig.heightMultiplier!,
                                ),
                                Text(
                                  "Favorite Food:",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 2.5 * SizeConfig.textMultiplier!,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                Text(
                                  "Cooked food!",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 2.2 * SizeConfig.textMultiplier!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

  String nStringToNNString(String? str) {
    return str ?? "";
  }

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(-1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
                position: animation.drive(tween),
                child: child,
            );
         },
    );
  }
}