import 'dart:collection';
import 'dart:convert';
//import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pawgo/models/dog.dart';
import 'package:pawgo/models/loggedUser.dart';
import 'package:pawgo/services/authentication.dart';
import 'package:pawgo/services/mongodb_service.dart';
import 'package:pawgo/size_config.dart';
import 'package:flutter/material.dart';
import 'package:pawgo/utils/mobile_library.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pawgo/assets/custom_colors.dart';
import 'package:uuid/uuid.dart';

import '../models/currentUser.dart';
import '../utils/dogInfo_check.dart';
import '../utils/get_image.dart';
import '../widget/custom_alert_dialog.dart';

class DogsProfilePage extends StatefulWidget {
  String? data;
  DogsProfilePage({Key? key, this.data}) : super(key: key);



  @override
  _DogsProfilePageState createState() => _DogsProfilePageState(data: data);
}

class _DogsProfilePageState extends State<DogsProfilePage> {
  String? data;
  _DogsProfilePageState({this.data});

  User? user = FirebaseAuth.instance.currentUser;
  bool check = false;
  String userId = LoggedUser.instance!.userId;
  String imageUrl = LoggedUser.instance!.image.url;
  bool imgInserted = false;
  File? f;
  final dogNameController = TextEditingController();
  final dogAgeController = TextEditingController();
  final dogBreedController = TextEditingController();
  final dogHobbyController = TextEditingController();
  final dogPersonalityController = TextEditingController();
  String dogName = "";
  String dogAge = "";
  String dogBreed = "";
  String dogHobby = "";
  String dogPersonality = "";
  String dogUrl = "";
  String docID = "";
  String dogImageUrl = "";

  @override
  void initState() {
    print("UserId" + userId);
    if(data != null) {
      this.getDog();
      print("DogId" + data!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Transform.translate(
            offset: const Offset(0, 0),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView(
                children: [
                  Center(
                    child: Text(
                      "New Dog Profile",
                      style: TextStyle(fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
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
                            child: Image.network(
                              dogImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context, Object object,
                                  StackTrace? stacktrace) {
                                return Image.asset("lib/assets/default_dog.jpg");
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  dogNameTextField("Dog's Name", "Enter dog's name"),
                  dogAgeTextField("Dog's Age", "Enter dog's age"),
                  dogBreedTextField("Dog's Breed", "Enter dog's breed"),
                  dogHobbyTextField("Dog's Hobby", "Enter dog's hobby (optional)"),
                  dogPersonalityTextField("Dog's Personality", "Enter dog's Personality (optional)"),
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
                              child: check
                                  ? CircularProgressIndicator()
                                  : ElevatedButton(
                                  onPressed: () async {
                                    if (!check) {
                                      data == null? await addDog() : await updateDog();
                                    }
                                  },
                                  child: data == null? Text("Create Dog Profile") : Text("Update Dog Profile"),
                                  style: ButtonStyle(
                                      fixedSize: MaterialStateProperty.all(
                                          Size(200, 35)),
                                      backgroundColor: MaterialStateProperty
                                          .all(
                                          CustomColors.pawrange),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(18.0))))),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 3 * SizeConfig.heightMultiplier!,),
                          child: !imgInserted
                              ? ElevatedButton(
                              onPressed: () async {
                                Map<Permission, PermissionStatus> statuses = await [
                                  Permission.camera,
                                  Permission.storage,
                                ].request();
                                _showPicker(context);
                              },
                              child: Text("Upload dog's picture"),
                              style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      Size(200, 35)),
                                  backgroundColor: MaterialStateProperty.all(
                                      CustomColors.pawrange),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              18.0)))))
                              : CircularProgressIndicator(
                            color: CustomColors.pawrange,
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

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () async {
                        if (await Permission.storage.isGranted) {
                          f = await getImageGallery();
                          if (f != null) {
                            setState(() {
                              imgInserted = true;
                            });
                            loadImageToFirebase(f!);
                          }
                        } else {
                          var storageAccessStatus =
                          await Permission.storage.status;
                          if (storageAccessStatus != PermissionStatus.granted) {
                            //here
                            var status = await Permission.storage.request();
                            if (status == PermissionStatus.permanentlyDenied) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  "To use this funcion, please allow access to storage in settings.",),
                                action: SnackBarAction(
                                  label: "Settings",
                                  textColor: CustomColors.pawrange,
                                  onPressed: () {
                                    openAppSettings();
                                  },
                                ),
                              ));
                            }
                          } else {
                            Permission.storage.request();
                          }
                        }
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      if (await Permission.camera.isGranted) {
                        f = await getImageCamera();
                        if (f != null) {
                          setState(() {
                            imgInserted = true;
                          });
                          loadImageToFirebase(f!);
                        }
                      } else {
                        var cameraAccessStatus = await Permission.camera.status;
                        if (cameraAccessStatus != PermissionStatus.granted) {
                          var status = await Permission.camera.request();
                          if (status == PermissionStatus.permanentlyDenied) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text(
                                "To use this funcion, please allow access to camera in settings.",),
                              action: SnackBarAction(
                                label: "Settings",
                                textColor: CustomColors.pawrange,
                                onPressed: () {
                                  openAppSettings();
                                },
                              ),
                            ));
                          }
                        } else {
                          Permission.camera.request();
                        }
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
  void loadImageToFirebase(File? image) async {
    var uuid = Uuid().v4();
    try
    {
      if (image != null) {
        // create dog image or update dog image
        CollectionReference dogsCollection = FirebaseFirestore.instance.collection("Dogs");
        if(data != null) {
          // TODO update app dog image
          await dogsCollection
              .where("dogId", isEqualTo: data!)
              .get()
              .then((QuerySnapshot querySnapshot) async {

          });
        }else {
          // add dog image to Firebase (dogId with default timestamp)
          Map<String, Object> dog = new HashMap();
          dog["dogId"] = DateTime.now().millisecondsSinceEpoch;
          dog["userId"] = LoggedUser.instance!.userId;
          // upload image to Firebase
          FirebaseStorage storage = FirebaseStorage.instance;
          Reference storageRef = storage.ref();
          Reference imageRef = storageRef.child(uuid.toString() + ".jpg");
          await imageRef.putFile(image);
          await imageRef.getDownloadURL().then((url) async {
            dog["Image"] = url;
            await FirebaseFirestore.instance
                .collection("Dogs")
                .add(dog)
                .then((value) async {
              // TODO get and update app image for display
              dogImageUrl = url;
              docID = value.id;
              print(docID);
            }).catchError((error) {});
          }).catchError((error) {});
        }
      };
    }
    finally
    {
      imgInserted=false;
      setState(() {

      });
    }
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
      await addDogInfo(userId,
          dogNameController.text,
          dogAgeController.text,
          dogBreedController.text,
          dogHobbyController.text,
          dogPersonalityController.text,
          context,
          docID);
    }
    finally
    {
      // TODO loading icon problem
      setState(() {
        check = false;
      });
    }
  }

  Future<void> updateDog() async {
    setState(() {
      check = true;
    });
    try
    {
      await updateDogInfo(data!,
          userId,
          dogNameController.text,
          dogAgeController.text,
          dogBreedController.text,
          dogHobbyController.text,
          dogPersonalityController.text,
          context);
    }
    finally
    {
      // TODO loading icon problem
      setState(() {
        check = false;
      });
    }
  }

  Future<void> getDog() async {
    setState(() {
      check = true;
    });
    try {
      // get dog information from MongoDB
      Dog dog = await MongoDB.instance.getDogsByDogId(this.data!);
      dogName = dog.dogName;
      dogAge = dog.dogAge;
      dogBreed = dog.dogBreed;
      dogHobby = dog.dogHobby;
      dogPersonality = dog.dogPersonality;

      // get dog image from Firebase
      CollectionReference dogsCollection = FirebaseFirestore.instance.collection("Dogs");
      QuerySnapshot querySnapshot = await dogsCollection
          .where("dogId", isEqualTo: data)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        dogImageUrl = querySnapshot.docs[0].get("Image");
      }
    }
    finally
    {
      setState(() {
        dogNameController.value = dogNameController.value.copyWith(text: dogName);
        dogAgeController.value = dogAgeController.value.copyWith(text: dogAge);
        dogBreedController.value = dogBreedController.value.copyWith(text: dogBreed);
        dogHobbyController.value = dogHobbyController.value.copyWith(text: dogHobby);
        dogPersonalityController.value = dogPersonalityController.value.copyWith(text: dogPersonality);
        check = false;
      });
    }
  }
}
