import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawgo/models/cardUser.dart';
import 'package:pawgo/models/loggedUser.dart';

import '../models/dog.dart';
import '../services/mongodb_service.dart';

enum CardStatus { like, dislike }

class CardProvider extends ChangeNotifier {
  List<CardUser> _cardUserList = [];
  List<String> addedDogList = [];
  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;

  List<CardUser> get cardUserList => _cardUserList;
  bool get isDragging => _isDragging;
  Offset get position => _position;
  double get angle => _angle;

  CardProvider() {
    this.resetUsers();
  }

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    _isDragging = true;

    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;

    notifyListeners();
  }

  void endPosition(String favouriteUserId, String favouriteUserDogId) {
    _isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    switch (status) {
      case CardStatus.like:
        like(favouriteUserId, favouriteUserDogId);
        break;
      case CardStatus.dislike:
        dislike();
        break;
      default:
        resetPosition();
    }
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;

    notifyListeners();
  }

  double getStatusOpacity() {
    final delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;

    return min(opacity, 1);
  }

  CardStatus? getStatus({bool force = false}) {
    final x = _position.dx;
    final y = _position.dy;

    if (force) {
      final delta = 100;

      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    } else {
      final delta = 20;

      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    }
  }

  void dislike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();

    notifyListeners();
  }

  void like(String favouriteUserId, String favouriteUserDogId) {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _nextCard();

    this.addFavouriteUser(favouriteUserId, favouriteUserDogId);

    notifyListeners();
  }

  Future _nextCard() async {
    if (cardUserList.isEmpty) return;

    await Future.delayed(Duration(milliseconds: 200));
    _cardUserList.removeLast();
    resetPosition();
  }

  void resetUsers() async {
    await this.getCardUser();
    notifyListeners();
  }

  // Future<void> getCardUser() async {
  //   CollectionReference usersCollection = FirebaseFirestore.instance.collection("Users");
  //   await usersCollection
  //       .get()
  //       .then((QuerySnapshot querySnapshot) async {
  //     for(int i = 0; i < querySnapshot.size; i++) {
  //       // skip if the matchmaking card is yourself
  //       if (querySnapshot.docs[i].get("userId") == LoggedUser.instance!.userId) continue;
  //
  //       // get user dog list and skip if the dog list is empty
  //       List<Dog>? dogList = await MongoDB.instance.getDogsByUserId(querySnapshot.docs[i].get("userId"));
  //       if(dogList == null) continue;
  //
  //       dogList.forEach((dog) {
  //         CardUser cardUser = CardUser(
  //           querySnapshot.docs[i].get("userId"),
  //           querySnapshot.docs[i].get("Username"),
  //           "userAge",
  //           querySnapshot.docs[i].get("Image"),
  //           "userDesc",
  //           dog);
  //         _cardUserList.add(cardUser);
  //       });
  //     }
  //   });
  // }

  Future<void> getCardUser() async {
    // reset the array for next time use
    addedDogList = [];
    _cardUserList = [];

    CollectionReference usersCollection = FirebaseFirestore.instance.collection("Users");
    await usersCollection
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for(int i = 0; i < querySnapshot.size; i = Random().nextInt(querySnapshot.size)) {
        // matchmaking system should only have 5 cards
        if(_cardUserList.length == 5) break;

        // skip if the matchmaking card is yourself
        if (querySnapshot.docs[i].get("userId") == LoggedUser.instance!.userId) continue;

        // get user dog list and skip if the dog list is empty
        List<Dog>? dogList = await MongoDB.instance.getDogsByUserId(querySnapshot.docs[i].get("userId"));

        // skip if user do not have dog
        if(dogList == null) continue;

        for (int j = 0; j < dogList.length; j++) {
          // continue if the dog has already added
          if (addedDogList.contains(dogList[j].id)) {
            continue;
          } else {
            CardUser cardUser = CardUser(
                querySnapshot.docs[i].get("userId"),
                querySnapshot.docs[i].get("Username"),
                "userAge",
                querySnapshot.docs[i].get("Image"),
                "userDesc",
                dogList[j]);
            addedDogList.add(dogList[j].id);
            _cardUserList.add(cardUser);
            break;
          }
        }
      }
    });
  }

  Future<void> addFavouriteUser(String favouriteUserId, String favouriteUserDogId) async {
      await MongoDB.instance.addFavouriteUser(LoggedUser.instance!.userId, favouriteUserId, favouriteUserDogId);
  }

  // CardUser(
  // "123",
  // 'Steffi',
  // "20",
  // 'https://images.unsplash.com/photo-1648978147652-b5450ef30dab?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDQ5fHRvd0paRnNrcEdnfHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80',
  // "123",
  // Dog("123", "123", "123", "123", "123", "123", "123", "123")
  // ),
  // CardUser(
  // "123",
  // 'Johanna',
  // "21",
  // 'https://images.unsplash.com/photo-1563178406-4cdc2923acbc?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=396&q=80',
  // "123",
  // Dog("123", "123", "123", "123", "123", "123", "123", "123")
  // ),
  // CardUser(
  // "123",
  // 'Sarah',
  // "24",
  // 'https://images.unsplash.com/photo-1574701148212-8518049c7b2c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=386&q=80',
  // "123",
  // Dog("123", "123", "123", "123", "123", "123", "123", "123")
  // ),
  // CardUser(
  // "123",
  // 'Emma',
  // "22",
  // 'https://images.unsplash.com/photo-1648978147703-589308311049?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDUwfHRvd0paRnNrcEdnfHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80',
  // "123",
  // Dog("123", "123", "123", "123", "123", "123", "123", "123")
  // ),
  // CardUser(
  // "123",
  // 'Emily',
  // "29",
  // 'https://i.imgur.com/5VPySm5.jpg',
  // "123",
  // Dog("123", "123", "123", "123", "123", "123", "123", "123")
  // ),
  // CardUser(
  // "123",
  // 'Hillary',
  // "29",
  // 'https://images.unsplash.com/photo-1562904403-a5106bef8319?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=387&q=80',
  // "123",
  // Dog("123", "123", "123", "123", "123", "123", "123", "123")
  // ),
  // CardUser(
  // "123",
  // "Ashley",
  // "29",
  // 'https://images.unsplash.com/photo-1647996217624-d6d7212f3929?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDgwfHRvd0paRnNrcEdnfHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80',
  // "123",
  // Dog("123", "123", "123", "123", "123", "123", "123", "123")
  // ),
}
