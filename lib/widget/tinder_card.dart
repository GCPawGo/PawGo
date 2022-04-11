import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pawgo/models/currentUser.dart';
import 'package:pawgo/models/dogsList.dart';
import 'package:pawgo/models/loggedUser.dart';
import 'package:provider/provider.dart';
import 'package:pawgo/models/user.dart';
import 'package:pawgo/utils/card_provider.dart';

import '../size_config.dart';

class TinderCard extends StatefulWidget {
  final User user;
  final bool isFront;

  const TinderCard({
    Key? key,
    required this.user,
    required this.isFront,
  }) : super(key: key);

  @override
  State<TinderCard> createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
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
              padding: EdgeInsets.all(1),
                //USER
                child: Container(
                  height: 80 * SizeConfig.heightMultiplier!,
                  width: 45 * SizeConfig.widthMultiplier!,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      // image: NetworkImage(widget.user.urlImage),
                      image: NetworkImage(LoggedUser.instance!.image.url),
                      fit: BoxFit.cover,
                      alignment: Alignment(-0.3, 0),
                    ),
                  ),
                  child: Container(
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
                  height: 80 * SizeConfig.heightMultiplier!,
                  width: 45 * SizeConfig.widthMultiplier!,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      // image: NetworkImage(widget.user.urlImage),
                      image: NetworkImage(DogsList.instance!.dogsList[0].imageUrl,),
                      fit: BoxFit.cover,
                      alignment: Alignment(-0.3, 0),
                    ),
                  ),
                  child: Container(
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


            // TODO: To implement user&dog same container
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     SizedBox(
            //       width: 3 * SizeConfig.widthMultiplier!,
            //     ),
            //     //USER
            //     Padding(
            //       padding: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier!),
            //       child: GestureDetector(
            //         onTap: () {
            //           showDialog<void>(
            //               context: context,
            //               barrierDismissible: true, // user must tap button!
            //               builder: (BuildContext context) {
            //                 return Container(
            //                   child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       Padding(
            //                         padding: EdgeInsets.all(8 * SizeConfig.heightMultiplier!),
            //                         child: GestureDetector(
            //                           onTap: () {
            //                             Navigator.of(context).pop();
            //                           },
            //                           child: Column(
            //                             mainAxisAlignment: MainAxisAlignment.center,
            //                             children: [
            //                               Text("Username:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
            //                               Text(LoggedUser.instance!.username, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
            //                               Text("Age:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
            //                               Text(CurrentUser.instance!.userAge, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
            //                               Text("About me:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
            //                               Text(CurrentUser.instance!.userDesc, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
            //                             ],
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 );
            //                 /*return buildCustomAlertOKDialog(
            //                       context, "User Info",
            //                       "Username: " + LoggedUser.instance!.username + "\n" +
            //                       "Age: " + CurrentUser.instance!.userAge + "\n" +
            //                       "About Me: " + CurrentUser.instance!.userDesc + "\n"
            //                   );*/
            //               });
            //         },
            //         child: Container(
            //           height: 50 * SizeConfig.heightMultiplier!,
            //           width: 40 * SizeConfig.widthMultiplier!,
            //           // child: ClipPath(
            //           //   clipper: TriangleClipperUser(),
            //           child: ClipRRect(
            //             //borderRadius: BorderRadius.circular(80),
            //             child: Image.network(
            //               LoggedUser.instance!.image.url,
            //               fit: BoxFit.cover,
            //               errorBuilder: (BuildContext context, Object object,
            //                   StackTrace? stacktrace) {
            //                 return Image.asset("lib/assets/app_icon.png");
            //               },
            //               loadingBuilder: (BuildContext context, Widget child,
            //                   ImageChunkEvent? loadingProgress) {
            //                 if (loadingProgress == null) return child;
            //                 return Center(
            //                   child: CircularProgressIndicator(
            //                     color: Colors.white,
            //                     value: loadingProgress.expectedTotalBytes != null
            //                         ? loadingProgress.cumulativeBytesLoaded /
            //                         (loadingProgress.expectedTotalBytes as num)
            //                         : null,
            //                   ),
            //                 );
            //               },
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //
            //     // DOG
            //     Padding(
            //       padding: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier!),
            //       child: GestureDetector(
            //         onTap: () {
            //           showDialog<void>(
            //               context: context,
            //               barrierDismissible: true, // user must tap button!
            //               builder: (BuildContext context) {
            //                 return Container(
            //                   child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       Padding(
            //                         padding: EdgeInsets.all(8 * SizeConfig.heightMultiplier!),
            //                         child: GestureDetector(
            //                           onTap: () {
            //                             Navigator.of(context).pop();
            //                           },
            //                           child: Column(
            //                             mainAxisAlignment: MainAxisAlignment.center,
            //                             children: [
            //                               Text("Name:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
            //                               Text(DogsList.instance!.dogsList[0].dogName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
            //                               Text("Age:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
            //                               Text(DogsList.instance!.dogsList[0].dogAge, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
            //                               Text("Breed:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
            //                               Text(DogsList.instance!.dogsList[0].dogBreed, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
            //                               Text("Hobby:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
            //                               Text(DogsList.instance!.dogsList[0].dogHobby, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
            //                               Text("Personality:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!)),
            //                               Text(DogsList.instance!.dogsList[0].dogPersonality, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier!)),
            //                             ],
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 );
            //               });
            //         },
            //         child: Container(
            //           height: 50 * SizeConfig.heightMultiplier!,
            //           width: 40 * SizeConfig.widthMultiplier!,
            //           // child: ClipPath(
            //           //   clipper: TriangleClipperDog(),
            //           child: ClipRRect(
            //             //borderRadius: BorderRadius.circular(80),
            //             child: Image.network(
            //               DogsList.instance!.dogsList[0].imageUrl,
            //               fit: BoxFit.cover,
            //               errorBuilder: (BuildContext context, Object object,
            //                   StackTrace? stacktrace) {
            //                 return Image.asset("lib/assets/app_icon.png");
            //               },
            //               loadingBuilder: (BuildContext context, Widget child,
            //                   ImageChunkEvent? loadingProgress) {
            //                 if (loadingProgress == null) return child;
            //                 return Center(
            //                   child: CircularProgressIndicator(
            //                     color: Colors.white,
            //                     value: loadingProgress.expectedTotalBytes != null
            //                         ? loadingProgress.cumulativeBytesLoaded /
            //                         (loadingProgress.expectedTotalBytes as num)
            //                         : null,
            //                   ),
            //                 );
            //               },
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       width: 5 * SizeConfig.widthMultiplier!,
            //     ),
            //   ],
            // ),
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     // image: NetworkImage(widget.user.urlImage),
            //     image: NetworkImage(LoggedUser.instance!.image.url),
            //     fit: BoxFit.cover,
            //     alignment: Alignment(-0.3, 0),
            //   ),
            // ),
            // child: Container(
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: [Colors.transparent, Colors.black54],
            //       begin: Alignment.center,
            //       end: Alignment.bottomCenter,
            //       stops: [0.2, 1],
            //     ),
            //   ),
            //   padding: EdgeInsets.all(20),
            //   child: Column(
            //     children: [
            //       Spacer(),
            //       buildName(),
            //       const SizedBox(height: 8),
            //       buildActive(),
            //     ],
            //   ),
            // ),

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

  Widget buildActive() => Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            width: 12,
            height: 12,
          ),
          const SizedBox(width: 8),
          Text(
            DogsList.instance!.dogsList[0].dogName,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(
            DogsList.instance!.dogsList[0].dogAge,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      );

  Widget buildName() => Row(
        children: [
          Text(
            LoggedUser.instance!.username,
            // widget.user.name,
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            CurrentUser.instance!.userAge,
            // '${widget.user.age}',
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
            ),
          ),
        ],
      );
}
