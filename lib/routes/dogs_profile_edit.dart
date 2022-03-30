import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pawgo/models/loggedUser.dart';
import 'package:pawgo/services/authentication.dart';
import 'package:pawgo/services/mongodb_service.dart';
import 'package:pawgo/size_config.dart';
import 'package:flutter/material.dart';
import 'package:pawgo/utils/mobile_library.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pawgo/assets/custom_colors.dart';

import '../models/currentUser.dart';

class DogsProfilePage extends StatefulWidget {
  DogsProfilePage({Key? key}) : super(key: key);

  @override
  _DogsProfilePageState createState() => _DogsProfilePageState();
}

class _DogsProfilePageState extends State<DogsProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  bool check = false;
  final usernameController = TextEditingController();
  final userAgeController = TextEditingController();
  String username = LoggedUser.instance!.username;
  String userId = LoggedUser.instance!.userId;
  late String userAge;
  String imageUrl = LoggedUser.instance!.image.url;
  bool imgInserted = false;
  File? f;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      child: Transform.translate(
          offset: const Offset(0, 0),
        child: GestureDetector(
          onTap:() {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Text(
                  "New Dog Profile",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black54),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Center(
                  child: Stack(
                    children: [
                  Container(
                  height: 20 * SizeConfig.heightMultiplier!,
                    width: 20 * SizeConfig.heightMultiplier!,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        image: AssetImage('lib/assets/default_dog.jpg'),
                      ),
                     ),
                    ),
                    ],
                  ),
              ),
              SizedBox(
                height: 35,
              ),
              buildTextField("Dog's Name", "Enter dog's name"),
              buildTextField("Age","Enter dog's age"),
              buildTextField("Color","Enter dog's color"),
              buildTextField("Breed","Enter dog's breed"),
              buildTextField("Hobby","Enter dog's hobby"),
              SizedBox(
                height: 1,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 24 * SizeConfig.widthMultiplier!,
                        top: 1 * SizeConfig.heightMultiplier!),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 250),
                        child: check?CircularProgressIndicator():ElevatedButton(
                            onPressed: () async{
                              if(!check)
                              {
                                // TODO: To add dog's data grab from MongoDB

                              }
                            },
                            child: Text("Create Profile"),
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
                ]
              )
            ],
          ),
        )
       ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Center(
        child: SizedBox(
          width: 280,
          child: TextField(
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1,color: CustomColors.pawrange),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1,color: CustomColors.pawrange),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeholder,


              //Text Styles
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColors.pawrange,
              ),

            ),
          ),
        ),
      ),
    );
  }

  Future<void> getUser() async {
    setState(() {
      check = true;
    });
    try {
      CurrentUser? currentUser = await MongoDB.instance.getUser(userId);
      if(currentUser != null) {
        userAge = currentUser.getUserAge();
        print(userAge);
      }
    }
    finally
    {
      setState(() {
        userAgeController.value = userAgeController.value.copyWith(text: userAge);
        check = false;
      });
    }
  }
}
