import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pawgo/models/dogsList.dart';
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
import 'package:pawgo/routes/dogs_profile_edit.dart';

import '../models/dog.dart';
import '../services/mongodb_service.dart';
import '../models/currentUser.dart';
import '../widget/custom_alert_dialog.dart';


class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  LoggedUser _miUser = LoggedUser.instance!;
  User? user = FirebaseAuth.instance.currentUser;
  bool check = false;
  final usernameController = TextEditingController();
  final userAgeController = TextEditingController();
  final userDescController = TextEditingController();
  String username = LoggedUser.instance!.username;
  String userId = LoggedUser.instance!.userId;
  String userAge = CurrentUser.instance!.userAge;
  String userDesc = CurrentUser.instance!.userDesc;
  String imageUrl = LoggedUser.instance!.image.url;
  bool imgInserted = false;
  File? f;

  List<Dog>? dogsList = DogsList.instance!.dogsList;

  // Use to get user information
  Future<void> getUser() async {
    setState(() {
    });
    CurrentUser? currentUser = await MongoDB.instance.getUser(userId);
    if(currentUser != null) {
      userAge = currentUser.getUserAge();
      userDesc = currentUser.getUserDesc();
    }
  }

  Future<void> getDogs() async {
    setState(() {
    });
    List<Dog>? list = await MongoDB.instance.getDogsByUserId(userId);
    if(list != null) {
      dogsList = list;
    }
  }

  Future<void> removeDogByDogId(String dogId, String userId) async {
    setState(() {
      check = true;
    });
    try
    {
      // TODO loading icon problem
      await MongoDB.instance.removeDogByDogId(dogId, userId);
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return buildCustomAlertOKDialog(context, "",
              "Successfully removed this dog!");
        },
      );
      List<Dog>? dogsList = await updateDogList(userId);
      if(dogsList != null) {
        DogsList.instance!.updateDogsList(dogsList);
      }
      // List<Dog> doss = [Dog("123", "123", "123", "123", "213", "123", "213")];
      // DogsList.instance!.updateDogsList(doss);
    }
    finally
    {
      setState(() {
        check = false;
      });
    }
  }

  Future<List<Dog>?> updateDogList(String userId) async {
    try
    {
      List<Dog>? dogsList = await MongoDB.instance.getDogsByUserId(userId);
      return dogsList;
    }
    finally
    {}
  }

  @override
  void initState() {
    _miUser.addListener(() => setState(() {}));
    print("userId of the logged user is: " + _miUser.userId);
    this.getDogs();
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
                SizedBox(
                  width: 4 * SizeConfig.widthMultiplier!,
                ),
                GestureDetector(
                  onTap: () {
                    pushNewScreen(context,
                        screen: ProfileEditing(),
                        pageTransitionAnimation:
                        PageTransitionAnimation.cupertino);
                  },
                  child: Container(
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
              ],
            ),
            Column(
              children: [

                SizedBox(
                  height: 1 * SizeConfig.heightMultiplier!,
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => DogsProfilePage(),),).then(
                            (data) {
                              this.getUser();
                              this.getDogs();
                            });
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
                        "ADD NEW DOG",
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
                        userInfo(),
                        Divider(
                          color: Colors.grey,
                        ),
                        dogsInfo(),
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

  Widget userInfo() {
    return
      Container(
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
                  child: Column(
                    children: [
                      Column(
                        children: [
                        Padding(
                          padding: EdgeInsets.all(0),
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
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier!,
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
                              height: 1 * SizeConfig.heightMultiplier!,
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
                              CurrentUser.instance!.userAge,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 2.2 * SizeConfig.textMultiplier!,
                              ),
                            ),
                            SizedBox(
                              height: 1 * SizeConfig.heightMultiplier!,
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
                              height: 1 * SizeConfig.heightMultiplier!,
                            ),
                            Text(
                              "About Me:",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 2.5 * SizeConfig.textMultiplier!,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier!,
                              ),
                            Container(
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              color: Colors.grey.shade200,
                              border: Border.all(
                              color: Colors.black26.withOpacity(0.1),),
                              ),
                              child: (userDesc.toString() != null)
                                  ? Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                                child: Text(
                                  CurrentUser.instance!.userDesc,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 2.2 * SizeConfig.textMultiplier!,
                                  ),
                                ),
                              ) :
                              Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                              child: Text(
                                CurrentUser.instance!.userDesc,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                               ),
                              ),
                             ),
                           ],
                          ),
                         ),
                        ],
                      ),
                    ],
                  ),
              //),
            ),
          ],
        )
      ),
    );
  }

  Widget dogsInfo() {
    return Container(
      child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier!),
                child: Text(
                  "Dog's Profile",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 3 * SizeConfig.textMultiplier!),
                ),
              ),
              displayDog(),
            ],
          )
      ),
    );
  }

  Widget displayDog() {
    return ListView.builder(
        // TODO: Read dog's data from MongoDB <---------------------------------
        // TODO: To be implemented later from backend
        // itemCount: MongoDB.instance!.dog?.length ?? 0,
        itemCount: DogsList.instance!.dogsList.length, // to be replaced with the above code
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          // TODO: To be implemented later from backend
          // Dog selectedDog = MongoDB.instance!.dogs![index];
          return Column(
            children: <Widget>[
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
                          padding: EdgeInsets.only(
                            top: 5 * SizeConfig.heightMultiplier!,
                            left: 10 * SizeConfig.widthMultiplier!,
                            right: 10 * SizeConfig.widthMultiplier!,
                            bottom: 5 * SizeConfig.heightMultiplier!,
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 30 * SizeConfig.heightMultiplier!,
                                width: 30 * SizeConfig.heightMultiplier!,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset("lib/assets/Smokey.jpg",
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context, Object object,
                                        StackTrace? stacktrace) {
                                      return Image.asset("lib/assets/app_icon.png");
                                    },
                                  ),
                                ),
                              ),
                              Text(
                                "Name:",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 2.5 * SizeConfig.textMultiplier!,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                DogsList.instance!.dogsList[index].dogName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier!,
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
                                DogsList.instance!.dogsList[index].dogAge,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier!,
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
                                DogsList.instance!.dogsList[index].dogBreed,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier!,
                              ),
                              Text(
                                "Hobbies:",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 2.5 * SizeConfig.textMultiplier!,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                DogsList.instance!.dogsList[index].dogHobby,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier!,
                              ),
                              Text(
                                "Personality:",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 2.5 * SizeConfig.textMultiplier!,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                DogsList.instance!.dogsList[index].dogPersonality,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 1 * SizeConfig.heightMultiplier!),
                                child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 250),
                                  child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 250),
                                    child: ElevatedButton(
                                        onPressed: () async{
                                          if(!check)
                                          {
                                            // TODO: To add dog's data grab from MongoDB

                                          }
                                        },
                                        child: Text("Update Dog's Profile"),
                                        style: ButtonStyle(
                                            fixedSize: MaterialStateProperty.all(
                                                Size(200, 35)),
                                            backgroundColor: MaterialStateProperty.all(
                                                CustomColors.pawrange),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(18.0))))),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 1 * SizeConfig.heightMultiplier!),
                                child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 250),
                                  child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 250),
                                    child: ElevatedButton(
                                        onPressed: () async{
                                          if(!check)
                                          {
                                            await removeDogByDogId(DogsList.instance!.dogsList[index].id, LoggedUser.instance!.userId);
                                          }
                                        },
                                        child: Text("Remove Profile"),
                                        style: ButtonStyle(
                                            fixedSize: MaterialStateProperty.all(
                                                Size(200, 35)),
                                            backgroundColor: MaterialStateProperty.all(
                                                CustomColors.pawrange),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(18.0))))),
                                  ),
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
          );
        });
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