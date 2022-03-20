import 'package:flutter/material.dart';

class LoggedUser extends ChangeNotifier {
  String userId;
  NetworkImage image;
  String mail;
  String username;

  LoggedUser(this.userId, this.image, this.mail, this.username);

  static LoggedUser? instance;

  static initInstance(String userId, String imageUrl, String mail, String username) {
    instance = LoggedUser(userId, NetworkImage(imageUrl), mail, username);
  }


  void changeProfileImage(String url) {
    instance!.image=NetworkImage(url);
    notifyListeners();
  }

  void updateUsername(String un) {
    instance!.username = un;
    notifyListeners();
  }

}
