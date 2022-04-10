import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pawgo/models/PeopleList.dart';
import 'package:pawgo/models/loggedUser.dart';
import 'package:pawgo/routes/TinderTab.dart';
import 'package:pawgo/routes/profile_editing.dart';
import 'package:pawgo/routes/sign_in_page.dart';
import 'package:pawgo/services/authentication.dart';
import 'package:pawgo/services/mongodb_service.dart';
import 'package:pawgo/size_config.dart';
import 'package:flutter/material.dart';
import 'package:pawgo/utils/mobile_library.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pawgo/assets/custom_colors.dart';
import 'package:pawgo/routes/dogs_profile_edit.dart';

import '../models/dogsList.dart';
import '../services/mongodb_service.dart';
import '../models/currentUser.dart';
import '../widget/MatchCard.dart';
import '../widget/TriangleClipperDog.dart';
import '../widget/TriangleClipperUser.dart';
import '../widget/custom_alert_dialog.dart';


class Matchmaking extends StatefulWidget {
  Matchmaking({Key? key}) : super(key: key);

  @override
  _MatchmakingState createState() => _MatchmakingState();
}

class _MatchmakingState extends State<Matchmaking> {
  LoggedUser _miUser = LoggedUser.instance!;
  User? user = FirebaseAuth.instance.currentUser;
  bool check = false;
  final usernameController = TextEditingController();
  final userAgeController = TextEditingController();
  final userDescController = TextEditingController();
  String username = LoggedUser.instance!.username;
  String userId = LoggedUser.instance!.userId;
  String userAge = "";
  String userDesc = "";
  String imageUrl = LoggedUser.instance!.image.url;
  bool imgInserted = false;
  File? f;
  //List<Dog>? dogs;

  // Use to get user information
  Future<void> getUser() async {
    setState(() {
      check = true;
    });
    {
      CurrentUser? currentUser = await MongoDB.instance.getUser(userId);
      if(currentUser != null) {
        userAge = currentUser.getUserAge();
        userDesc = currentUser.getUserDesc();
      }
    }
  }

  @override
  void initState() {
    _miUser.addListener(() => setState(() {}));
    print("userId of the logged user is: " + _miUser.userId);
    this.getUser();
    super.initState();
  }

  Widget header() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            left: 30.0, right: 30.0, top: 10 * SizeConfig.heightMultiplier!, bottom: 2.5 * SizeConfig.heightMultiplier!),
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
              //mainAxisAlignment: MainAxisAlignment.start,
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
                        // matchmaking(),
                        MatchCard("Alexa Georigna", 'assets/images/person3.jpg', 23, 'Photographer 📷'),
                        // TinderTab(),
                        Divider(
                          color: Colors.grey,
                        ),
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



  Widget matchmaking() {
    return
      Container(
        height: 55 * SizeConfig.heightMultiplier!,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
          ListView.builder(
              itemCount: DogsList.instance!.dogsList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index)
              {
                return
                Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 3 * SizeConfig.widthMultiplier!,
                  ),
                  //USER
                  Padding(
                    padding: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier!),
                    child: GestureDetector(
                      onTap: () {
                        showDialog<void>(
                            context: context,
                            barrierDismissible: true, // user must tap button!
                            builder: (BuildContext context) {
                              return Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8 * SizeConfig.heightMultiplier!),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Username:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text(LoggedUser.instance!.username, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text("Age:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text(CurrentUser.instance!.userAge, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text("About me:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text(CurrentUser.instance!.userDesc, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              /*return buildCustomAlertOKDialog(
                                  context, "User Info",
                                  "Username: " + LoggedUser.instance!.username + "\n" +
                                  "Age: " + CurrentUser.instance!.userAge + "\n" +
                                  "About Me: " + CurrentUser.instance!.userDesc + "\n"
                              );*/
                            });
                      },
                      child: Container(
                        height: 50 * SizeConfig.heightMultiplier!,
                        width: 40 * SizeConfig.widthMultiplier!,
                        // child: ClipPath(
                        //   clipper: TriangleClipperUser(),
                        child: ClipRRect(
                          //borderRadius: BorderRadius.circular(80),
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
                    ),
                  ),

                  // DOG
                  Padding(
                    padding: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier!),
                    child: GestureDetector(
                      onTap: () {
                        showDialog<void>(
                            context: context,
                            barrierDismissible: true, // user must tap button!
                            builder: (BuildContext context) {
                              return Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8 * SizeConfig.heightMultiplier!),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Name:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text(DogsList.instance!.dogsList[index].dogName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text("Age:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text(DogsList.instance!.dogsList[index].dogAge, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text("Breed:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text(DogsList.instance!.dogsList[index].dogBreed, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text("Hobby:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text(DogsList.instance!.dogsList[index].dogHobby, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text("Personality:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text(DogsList.instance!.dogsList[index].dogPersonality, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: Container(
                        height: 50 * SizeConfig.heightMultiplier!,
                        width: 40 * SizeConfig.widthMultiplier!,
                        // child: ClipPath(
                        //   clipper: TriangleClipperDog(),
                        child: ClipRRect(
                          //borderRadius: BorderRadius.circular(80),
                          child: Image.network(
                            DogsList.instance!.dogsList[index].imageUrl,
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
                    ),
                  ),
                  SizedBox(
                    width: 5 * SizeConfig.widthMultiplier!,
                  ),
              ],
            ),);
        }),
      ],),
    );
  }

  // TODO: To test stack cards HERE <-----------------------------------------------------

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