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
import '../utils/dogInfo_check.dart';
import '../widget/custom_alert_dialog.dart';

class DogsProfilePage extends StatefulWidget {
  DogsProfilePage({Key? key}) : super(key: key);

  @override
  _DogsProfilePageState createState() => _DogsProfilePageState();
}

class _DogsProfilePageState extends State<DogsProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  bool check = false;
  String userId = LoggedUser.instance!.userId;
  final dogNameController = TextEditingController();
  final dogAgeController = TextEditingController();
  final dogBreedController = TextEditingController();
  final dogHobbyController = TextEditingController();
  final dogPersonalityController = TextEditingController();

  @override
  void initState() {
    print(userId);
    super.initState();
  }

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
              dogNameTextField("Dog's Name", "Enter dog's name"),
              dogAgeTextField("Dog's Age","Enter dog's age"),
              dogBreedTextField("Dog's Breed","Enter dog's breed"),
              dogHobbyTextField("Dog's Hobby","Enter dog's hobby (optional)"),
              dogPersonalityTextField("Dog's Personality","Enter dog's Personality (optional)"),
              SizedBox(
                height: 1,
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
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
                                await addDog();
                              }
                            },
                            child: Text("Create Dog Profile"),
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
                        child: check?CircularProgressIndicator():ElevatedButton(
                            onPressed: () async{
                              if(!check)
                              {
                                // TODO: To add dog's data grab from MongoDB

                              }
                            },
                            child: Text("Upload Dog Photos"),
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
                  SizedBox(
                    height: 3 * SizeConfig.heightMultiplier!,
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

  Widget dogNameTextField(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Center(
        child: SizedBox(
          width: 280,
          child: TextField(
            cursorColor: CustomColors.pawrange,
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
            controller: dogNameController,
          ),
        ),
      ),
    );
  }

  Widget dogAgeTextField(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Center(
        child: SizedBox(
          width: 280,
          child: TextField(
            cursorColor: CustomColors.pawrange,
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
            controller: dogAgeController,
          ),
        ),
      ),
    );
  }

  Widget dogBreedTextField(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Center(
        child: SizedBox(
          width: 280,
          child: TextField(
            cursorColor: CustomColors.pawrange,
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
            controller: dogBreedController,
          ),
        ),
      ),
    );
  }

  Widget dogHobbyTextField(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Center(
        child: SizedBox(
          width: 280,
          child: TextField(
            cursorColor: CustomColors.pawrange,
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
            controller: dogHobbyController,
          ),
        ),
      ),
    );
  }

  Widget dogPersonalityTextField(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Center(
        child: SizedBox(
          width: 280,
          child: TextField(
            cursorColor: CustomColors.pawrange,
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
            controller: dogPersonalityController,
          ),
        ),
      ),
    );
  }

  Future<void> addDog() async {
    setState(() {
      check = true;
    });
    try
    {
      await addDoginfo(userId,
          dogNameController.text,
          dogAgeController.text,
          dogBreedController.text,
          dogHobbyController.text,
          dogPersonalityController.text,
          context);
    }
    finally
    {
      setState(() {
        check = false;
      });
    }
  }
}
