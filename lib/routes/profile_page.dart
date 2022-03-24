import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pawgo/models/loggedUser.dart';
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
                                fontSize: 1.5 * SizeConfig.textMultiplier!,
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
              height: 3 * SizeConfig.heightMultiplier!,
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
                      "Cats",
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
                      LoggedUser.instance!.username ??
                          "0",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 3 * SizeConfig.textMultiplier!,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Dog!",
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
                      onTap: () { },
                      child: Container(
                        /*width: 15 * SizeConfig.heightMultiplier!,*/
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white60),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "EDIT PROFILE",
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
                        await Authentication.signOut(context: context);
                        setState(() {
                          Navigator.of(context, rootNavigator: true);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white60),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 5.0, bottom: 5.0),
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget scrollArea() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // TODO: Read Ride data from MongoDB <----------------------------------------------------------
            Divider(
              color: Colors.black,
            ),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: 3 * SizeConfig.heightMultiplier!,
            ),
            SizedBox(
              height: 20 * SizeConfig.heightMultiplier!,
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
                        Divider(
                          color: Colors.black,
                        ),
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

  String nStringToNNString(String? str) {
    return str ?? "";
  }

}