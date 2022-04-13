import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pawgo/assets/custom_colors.dart';
import 'package:pawgo/models/currentUser.dart';
import 'package:pawgo/models/dogsList.dart';
import 'package:pawgo/models/loggedUser.dart';
import 'package:pawgo/utils/mobile_library.dart';
import 'package:provider/provider.dart';
import 'package:pawgo/models/cardUser.dart';
import 'package:pawgo/utils/card_provider.dart';

import '../services/mongodb_service.dart';
import '../size_config.dart';

class TinderCard extends StatefulWidget {
  final CardUser cardUser;
  final bool isFront;

  TinderCard({Key? key, required this.cardUser, required this.isFront}) : super(key: key);

  @override
  _TinderCardState createState() => _TinderCardState(cardUser: cardUser);
}

class _TinderCardState extends State<TinderCard> {
  CardUser cardUser;
  _TinderCardState({required this.cardUser});
  String userAge = "";
  String userDesc = "";

  @override
  void initState() {
    this.getUser();
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  Future<void> getUser() async {
    CurrentUser? currentUser = await MongoDB.instance.getUser(cardUser.userId);
    if(currentUser != null) {
      userAge = currentUser.getUserAge();
      userDesc = currentUser.getUserDesc();
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox.expand(
        child: widget.isFront ? buildFrontCard() : buildCard(),
      );

  Widget buildFrontCard() => GestureDetector(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final provider = Provider.of<CardProvider>(context);
            final position = provider.position;
            final milliseconds = provider.isDragging ? 0 : 400;

            final center = constraints.smallest.center(Offset.zero);
            final angle = provider.angle * pi / 180;
            final rotatedMatrix = Matrix4.identity()
              ..translate(center.dx, center.dy)
              ..rotateZ(angle)
              ..translate(-center.dx, -center.dy);

            return AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: milliseconds),
              transform: rotatedMatrix..translate(position.dx, position.dy),
              child: Stack(
                children: [
                  buildCard(),
                  buildStamps(),
                  buildName(),
                  buildDog(),
                ],
              ),
            );
          },
        ),
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.endPosition();
        },
      );

  Widget buildCard() => buildCardShadow(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(1.5),
                //USER
                child: Container(
                  height: 80 * SizeConfig.heightMultiplier!,
                  width: 44 * SizeConfig.widthMultiplier!,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      // image: NetworkImage(widget.user.urlImage),
                      image: NetworkImage(cardUser.userImage),
                      fit: BoxFit.cover,
                      // alignment: Alignment(-0.3, 0),
                    ),
                  ),
                  child: Container(
                    child: GestureDetector(
                      onTap: () {
                        showDialog<void>(
                            context: context,
                            barrierDismissible: true, // user must tap button!
                            builder: (BuildContext context) {
                              return Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8 * SizeConfig.heightMultiplier!),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Username:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text(cardUser.userName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text("Age:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text(userAge, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            Text("About me:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
                                            userDesc == "Update your desc here" ? Text(" - ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)) :
                                            Text(userDesc, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        stops: [0.2, 1],
                      ),
                    ),
                  ),
                ),
               ),

                //DOG
                Container(
                  height: 67.5 * SizeConfig.heightMultiplier!,
                  width: 44.8 * SizeConfig.widthMultiplier!,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      // image: NetworkImage(widget.user.urlImage),
                      image: NetworkImage(cardUser.dog.imageUrl),
                      fit: BoxFit.cover,
                      // alignment: Alignment(-0.3, 0),
                    ),
                  ),
                  child: Container(
                    child: GestureDetector(
                    onTap: () {
                      showDialog<void>(
                          context: context,
                          barrierDismissible: true, // user must tap button!
                          builder: (BuildContext context) {
                            return Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8 * SizeConfig.heightMultiplier!),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Name:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
                                          Text(cardUser.dog.dogName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
                                          Text("Age:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
                                          Text(cardUser.dog.dogAge, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
                                          Text("Breed:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
                                          Text(cardUser.dog.dogBreed, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
                                          Text("Hobby:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
                                          cardUser.dog.dogHobby == "What's your dog's hobbies?"
                                              ? Text(" - ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!))
                                              : Text(cardUser.dog.dogHobby, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
                                          Text("Personality:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
                                          cardUser.dog.dogPersonality == "What's your dog's personality?"
                                              ? Text(" - ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!))
                                              : Text(cardUser.dog.dogPersonality, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        stops: [0.2, 1],
                      ),
                    ),
                  ),
                ),
          ],
        ),
        ),
      );

  Widget buildCardShadow({required Widget child}) => ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.white12,
              ),
            ],
          ),
          child: child,
        ),
      );

  Widget buildStamps() {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final opacity = provider.getStatusOpacity();

    switch (status) {
      case CardStatus.like:
        final child = buildStamp(
          angle: -0.5,
          color: Colors.green,
          text: 'LIKE',
          opacity: opacity,
        );

        return Positioned(top: 64, left: 50, child: child);
      case CardStatus.dislike:
        final child = buildStamp(
          angle: 0.5,
          color: Colors.red,
          text: 'NOPE',
          opacity: opacity,
        );
        return Positioned(top: 64, right: 50, child: child);

      default:
        return Container();
    }
  }

  Widget buildStamp({
    double angle = 0,
    required Color color,
    required String text,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 4),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDog() =>
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 45 * SizeConfig.widthMultiplier!),
                      SizedBox(height: 10 * SizeConfig.heightMultiplier!),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cardUser.dog.dogName,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                            // textAlign: TextAlign.justify,
                          ),
                          // const SizedBox(width: 8),
                          Text(
                            cardUser.dog.dogAge,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                            // textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ],
                ),
              ],
      );

  Widget buildName() =>
      Container(
        height: 80 * SizeConfig.heightMultiplier!,
        width: 44 * SizeConfig.widthMultiplier!,
        child: Column(
         mainAxisAlignment: MainAxisAlignment.end,
          children: [
              Text(
                cardUser.userName,
                // widget.user.name,
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                userAge,
                // '${widget.user.age}',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2 * SizeConfig.heightMultiplier!),
            ],
        ),
      );
}
