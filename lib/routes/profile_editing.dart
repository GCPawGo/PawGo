import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pawgo/assets/custom_colors.dart';
import 'package:pawgo/models/loggedUser.dart';
import 'package:pawgo/size_config.dart';
import 'package:flutter/material.dart';
import 'package:pawgo/utils/get_image.dart';
import 'package:pawgo/utils/username_check.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../services/mongodb_service.dart';
import '../models/currentUser.dart';

class ProfileEditing extends StatefulWidget {
  ProfileEditing({Key? key}) : super(key: key);

  @override
  _ProfileEditingState createState() => _ProfileEditingState();
}

class _ProfileEditingState extends State<ProfileEditing> {
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
  void initState() {
    this.getUser();
    setState(() {
      usernameController.value = usernameController.value.copyWith(text: username);
      // userAgeController.value = userAgeController.value.copyWith(text: userAge);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: CustomColors.pawrange,
                height: 30 * SizeConfig.heightMultiplier!,
                child: Transform.translate(
                  offset: const Offset(0,-10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 11 * SizeConfig.heightMultiplier!,
                              width: 11 * SizeConfig.heightMultiplier!,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(imageUrl),
                                  )),
                            ),
                            SizedBox(
                              width: 5 * SizeConfig.widthMultiplier!,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  username,
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
                                          LoggedUser.instance!.mail,
                                          style: TextStyle(
                                            color: Colors.white60,
                                            fontSize:
                                                2 * SizeConfig.textMultiplier!,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0,-30),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                      )),
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 3 * SizeConfig.heightMultiplier!,),
                            child: !imgInserted?ElevatedButton(
                                onPressed: () async {
                                  Map<Permission, PermissionStatus> statuses = await [
                                    Permission.camera,
                                    Permission.storage,
                                  ].request();
                                  _showPicker(context);
                                },
                                child: Text("Change profile picture"),
                                style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                        Size(200, 35)),
                                    backgroundColor: MaterialStateProperty.all(
                                        CustomColors.pawrange),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0))))):CircularProgressIndicator(
                              color: CustomColors.pawrange,
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15,
                                top: 2 * SizeConfig.heightMultiplier!,
                                right: 15.0),
                            child: TextField(
                              cursorColor: CustomColors.pawrange,
                              decoration: InputDecoration(
                                  counterStyle: TextStyle(
                                    color: CustomColors.silver,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: CustomColors.silver),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: CustomColors.pawrange),
                                  ),
                                  hintText: "Insert new name",
                                  labelText: "Name",
                                  hintStyle:
                                      TextStyle(color: CustomColors.silver)),
                              controller: usernameController,
                              maxLength: 20,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15,
                                top: 2 * SizeConfig.heightMultiplier!,
                                right: 15.0),
                            child: TextField(
                              cursorColor: CustomColors.pawrange,
                              decoration: InputDecoration(
                                  counterStyle: TextStyle(
                                    color: CustomColors.silver,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: CustomColors.silver),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: CustomColors.pawrange),
                                  ),
                                  hintText: "Insert new age",
                                  labelText: "Age",
                                  hintStyle:
                                  TextStyle(color: CustomColors.silver)),
                              controller: userAgeController,
                              maxLength: 20,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15,
                                top: 2 * SizeConfig.heightMultiplier!,
                                right: 15.0),
                            child: TextField(
                              cursorColor: CustomColors.pawrange,
                              decoration: InputDecoration(
                                  counterStyle: TextStyle(
                                    color: CustomColors.silver,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: CustomColors.silver),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: CustomColors.pawrange),
                                  ),
                                  hintText: "About Me",
                                  labelText: "Description",

                                  hintStyle:
                                  TextStyle(color: CustomColors.silver)),
                              maxLength: 100,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 1 * SizeConfig.heightMultiplier!,),
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 250),
                              child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 250),
                                child: check?CircularProgressIndicator():ElevatedButton(
                                    onPressed: () async{
                                      if(!check)
                                      {
                                        await checkColor();
                                      }
                                    },
                                    child: Text("Update"),
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
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String nStringToNNString(String? str) {
    return str ?? "";
  }

  Future<void> updateUserName() async {
    setState(() {
      check = true;
    });
    try
    {
      await updateUsername(usernameController.text, context);
    }
    finally
    {
      setState(() {
        check = false;
      });
    }
  }

  Future<void> updateUserAge() async {
    setState(() {
      check = true;
    });
    try
    {
      // TODO: to add controller from MongoDB
      await MongoDB.instance.updateUserAge(userId, userAgeController.text);
    }
    finally
    {
      setState(() {
        check = false;
      });
    }
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

  Future<void> checkColor() async {
    setState(() {
      check = true;
    });
    try
    {
      // TODO: to add controller from MongoDB
      // await updateUsername(usernameController.text, context);
    }
    finally
    {
      setState(() {
        check = false;
      });
    }
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
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageRef = storage.ref();
        Reference imageRef = storageRef.child(uuid.toString() + ".jpg");
        await imageRef.putFile(image);
        CollectionReference usersCollection = FirebaseFirestore.instance.collection("Users");
        String docID="";
        String urlFirebase="";
        await usersCollection
            .where("Mail", isEqualTo: user!.email)
            .get()
            .then((QuerySnapshot querySnapshot) async {
          docID=querySnapshot.docs[0].id;
          urlFirebase=querySnapshot.docs[0].get("Image");
        });
        await imageRef.getDownloadURL().then( (url) async {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(docID)
              .update({"Image": url})
              .then( (value) async{
            LoggedUser.instance!.changeProfileImage(url);
            await FirebaseStorage.instance.refFromURL(urlFirebase).delete();
            imageUrl=url;
            setState(() {

            });
          });
        });

      }
    }
    finally
    {
      imgInserted=false;
      setState(() {

      });
    }

  }

}
