import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pawgo/models/loggedUser.dart';
import 'package:tuple/tuple.dart';

import '../models/currentUser.dart';

class MongoDB {
  //Backend developers make the functions for the mongo api calls here,
  //Frontend developers can then use these functions in the flutter project

  static final MongoDB instance = new MongoDB();

  http.Client _serverClient = http.Client();
  String baseUri = "https://pawgo.herokuapp.com";
  // local connection
  // String baseUri = "http://10.0.2.2:8000";
  static var _dateFormatter = DateFormat("yyyy-MM-ddTHH:mm:ss");

  Map<String, String> _headers = {
    'Content-type': 'application/json; charset=utf-8',
    'Accept': 'application/json',
    'Host': 'pawgo.herokuapp.com'
    // local connection
    // 'Host': '10.0.2.2:8000'
  };

  //Use to convert Dart DateTime object to a string whose format matches the one of the backend
  //returns the date in the following UTC format: 2021-12-03T03:30:40.000Z
  static String formatDate(DateTime date) {
    return _dateFormatter.format(date.toUtc()) + ".000Z";
  }

  //Use to convert a string matching the database date format to Dart DateTime.
  //Note that the string must have the following UTC format: 2021-12-03T03:30:40.000Z
  static DateTime parseDate(String dateStr) {
    return _dateFormatter.parse(dateStr, true).toLocal();
  }

  void localDebug() {
    baseUri = "http://localhost:8000";
    LoggedUser.initInstance('testUser', 'imageUrl', 'mail', 'testUser');
  }

  Future<bool> initUser(String userId) async {
    var url = Uri.parse(baseUri + '/users/initUser');
    var response = await _serverClient.post(url, headers: _headers, body: json.encode({'userId': userId}));
    if (response.statusCode == 200) {
      var decodedBody = json.decode(response.body);
      print("Received events json from the initUser");
      print(decodedBody["joinedEvents"]);
      return true;
    } else
      return false;
  }

  //Returns from Firebase the username of a user with id = userId
  Future<String> getUsername(String userId) async {
    QuerySnapshot querySnapshot = await (FirebaseFirestore.instance
        .collection("Users")
        .where("userId", isEqualTo: userId)
        .get());
    return querySnapshot.docs.first.get("Username");
  }

  Future<CurrentUser?> getUser(String userId) async {
    var url = Uri.parse(baseUri + '/users/getUser').replace(queryParameters: {'userId': userId});
    var response = await _serverClient.get(url, headers: _headers);
    if (response.statusCode == 200) {
      var decodedBody = json.decode(response.body);
      print("Received events json from the getUser");
      print(decodedBody);
      CurrentUser currentUser = CurrentUser.fromJson(decodedBody);
      return currentUser;
    } else
      return null;
  }

  Future<bool> updateUserInfo(String userId, String userAge, String userDesc) async {
    var url = Uri.parse(baseUri + '/users/updateUserInfo');
    var response = await _serverClient.post(url, headers: _headers, body: json.encode({'userId': userId, 'userAge': userAge, 'userDesc': userDesc}));
    if (response.statusCode == 200) {
      var decodedBody = json.decode(response.body);
      print("Received events json from the updateUserInfo");
      print(decodedBody["joinedEvents"]);
      return true;
    } else
      return false;
  }
}
