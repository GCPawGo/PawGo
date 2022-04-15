import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawgo/models/loggedUser.dart';
import 'package:pawgo/routes/sign_in_page.dart';
import 'package:pawgo/services/authentication.dart';
import 'package:pawgo/services/mongodb_service.dart';
import 'package:pawgo/size_config.dart';
import 'package:flutter/material.dart';
import 'package:pawgo/utils/mobile_library.dart';
import 'package:pawgo/assets/custom_colors.dart';

import '../services/mongodb_service.dart';
import '../models/currentUser.dart';
import 'match_favourite_page.dart';


class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              //mainAxisAlignment: MainAxisAlignment.end,
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
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      CustomColors.pawrange,
                      Colors.white,
                    ],
                  ),
                ),
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
                          color: Colors.white,
                        ),
                          Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            buildLikeButtons(),
                                            const SizedBox(width: 5),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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

  Widget userinfo() {
    return Container(
        child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier!),
                  child: Text(
                    "Home page",
                    style: TextStyle(
                      fontSize: 5 * SizeConfig.textMultiplier!,
                      fontFamily: 'pawfont',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
        ),
      );
  }

  Widget buildLikeButtons() {
    return Container(
      child: ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => MatchFavouritePage(
                ),
              ),
            ).then((data) {

            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Users Like Me", style: TextStyle(fontSize: 2.2 * SizeConfig.textMultiplier!),),
              SizedBox(width: 2 * SizeConfig.widthMultiplier!),
              ClipOval(
                child: Material(
                  color: Colors.white, // button color
                  child: InkWell(
                    splashColor: CustomColors.pawrange, // inkwell color
                    child: SizedBox(width: 30, height: 30, child: Icon(Icons.favorite_sharp, color: Colors.red, size: 20.0)),
                  ),
                ),
              ),
            ],
          ),
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(
                  Size(200, 35)),
              backgroundColor: MaterialStateProperty
                  .all(
                  CustomColors.pawrange),
              shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)
                  )
              )
          ),
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