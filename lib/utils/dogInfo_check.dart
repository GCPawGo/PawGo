import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawgo/models/currentUser.dart';
import 'package:pawgo/models/dogsList.dart';
import 'package:pawgo/widget/custom_alert_dialog.dart';
import 'package:pawgo/services/mongodb_service.dart';

import '../models/dog.dart';

Future<void>addDogInfo(String userId, String dogName, String dogAge, String dogBreed, String dogHobby, String dogPersonality, BuildContext context, String docID) async {
  if (docID.isEmpty) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return buildCustomAlertOKDialog(context, "Warning",
            "Please upload your Dog's image!");
      },
    );
  }else if (dogName.isEmpty) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return buildCustomAlertOKDialog(context, "Warning",
            "Please input your Dog's name!");
      },
    );
  } else if (dogAge.isEmpty) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return buildCustomAlertOKDialog(context, "Warning",
            "Please input your Dog's Age!");
      },
    );
  } else if (dogBreed.isEmpty) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return buildCustomAlertOKDialog(context, "Warning",
            "Please input your Dog's Breed!");
      },
    );
  } else {
    // call add dog function to add the new dog
    await addDog(userId, dogName, dogAge, dogBreed, dogHobby, dogPersonality);

    // TODO update firebase dogID
    CollectionReference dogsCollection = FirebaseFirestore.instance.collection("Dogs");
    await dogsCollection
        .where(FieldPath.documentId, isEqualTo: docID)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      print(querySnapshot.docs[0].get("dogId"));
    });

    List<Dog>? dogsList = await updateDogList(userId);
    if(dogsList != null) {
      DogsList.instance!.updateDogsList(dogsList);
    }

    // back to the main profile
    Navigator.of(context).pop("");
    return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
    return buildCustomAlertOKDialog(
    context, "", "Dog added successfully.");
    });
  }
}

Future<void>updateDogInfo(String dogId, String userId, String dogName, String dogAge, String dogBreed, String dogHobby, String dogPersonality, BuildContext context) async {
  if (dogName.isEmpty) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return buildCustomAlertOKDialog(context, "Warning",
            "Please input your Dog's name!");
      },
    );
  } else if (dogAge.isEmpty) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return buildCustomAlertOKDialog(context, "Warning",
            "Please input your Dog's Age!");
      },
    );
  } else if (dogBreed.isEmpty) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return buildCustomAlertOKDialog(context, "Warning",
            "Please input your Dog's Breed!");
      },
    );
  } else {
    // call update dog function to update the dog
    await updateDog(dogId, dogName, dogAge, dogBreed, dogHobby, dogPersonality);

    List<Dog>? dogsList = await updateDogList(userId);
    if(dogsList != null) {
      DogsList.instance!.updateDogsList(dogsList);
    }

    // back to the main profile
    Navigator.of(context).pop("");
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return buildCustomAlertOKDialog(
              context, "", "Dog updated successfully.");
        });
  }
}

Future<void> addDog(String userId, String dogName, String dogAge, String dogBreed, String dogHobby, String dogPersonality) async {
  try
  {
    await MongoDB.instance.addDogInfo(userId, dogName, dogAge, dogBreed, dogHobby, dogPersonality);
  }
  finally
  {}
}

Future<void> updateDog(String dogId, String dogName, String dogAge, String dogBreed, String dogHobby, String dogPersonality) async {
  try
  {
    await MongoDB.instance.updateDogInfo(dogId, dogName, dogAge, dogBreed, dogHobby, dogPersonality);
  }
  finally
  {}
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