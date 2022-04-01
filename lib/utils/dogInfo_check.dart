import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawgo/widget/custom_alert_dialog.dart';
import 'package:pawgo/services/mongodb_service.dart';

Future<void>addDogInfo(String userId, String dogName, String dogAge, String dogBreed, String dogHobby, String dogPersonality, BuildContext context) async {
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
    // call add dog function to add the new dog
    await addDog(userId, dogName, dogAge, dogBreed, dogHobby, dogPersonality);
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

Future<void> addDog(String userId, String dogName, String dogAge, String dogBreed, String dogHobby, String dogPersonality) async {
  try
  {
    // TODO call MongoDB API
    await MongoDB.instance.addDogInfo(userId, dogName, dogAge, dogBreed, dogHobby, dogPersonality);
  }
  finally
  {}
}
