import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pawgo/assets/custom_colors.dart';
import 'package:pawgo/size_config.dart';
import 'package:provider/provider.dart';
import 'package:pawgo/utils/card_provider.dart';
import 'package:pawgo/widget/tinder_card.dart';

class MatchPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => CardProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: title,
      home: MatchPages(),
      theme: ThemeData(
        primarySwatch: Colors.red,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(fontSize: 32),
            elevation: 8,
            primary: Colors.white,
            shape: CircleBorder(),
            minimumSize: Size.square(80),
          ),
        ),
      ),
    ),
  );
}

class MatchPages extends StatefulWidget {
  @override
  _MatchPagesState createState() => _MatchPagesState();
}

class _MatchPagesState extends State<MatchPages> {
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          CustomColors.pawrange,
          Colors.white,
        ],
      ),
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(
                  //   FontAwesomeIcons.dog,
                  //   color: Colors.white,
                  //   size: 36,
                  // ),
                  const SizedBox(width: 4),
                  Text(
                    'PawGo',
                    style: TextStyle(
                      fontSize: 7 * SizeConfig.textMultiplier!,
                      fontFamily: 'pawfont',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Expanded(child: buildCards()),
              const SizedBox(height: 5),
              buildButtons(),
            ],
          ),
        ),
      ),
    ),
  );

  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final userz = provider.userz;

    return userz.isEmpty
        ? Center(
      child: Text(
        '💔  The End.',
        style: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    )
        : Stack(
      children: userz
          .map((user) => TinderCard(
        user: user,
        isFront: userz.last == user,
      ))
          .toList(),
    );
  }

  Widget buildButtons() {
    final provider = Provider.of<CardProvider>(context);
    final userz = provider.userz;
    final status = provider.getStatus();
    final isLike = status == CardStatus.like;
    final isDislike = status == CardStatus.dislike;

    return userz.isEmpty
         ? ElevatedButton(
            onPressed: () {
              final provider =
              Provider.of<CardProvider>(context, listen: false);

              provider.resetUsers();
            },
            child: Text("Restart"),
            style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(
                    Size(200, 35)),
                backgroundColor: MaterialStateProperty.all(
                    CustomColors.pawrange),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            18.0)))),
              )
        : Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor:
                getColor(Colors.red, Colors.white, isDislike),
                backgroundColor:
                getColor(Colors.white, Colors.red, isDislike),
                side: getBorder(Colors.red, Colors.white, isDislike),
              ),
              child: Icon(Icons.clear, size: 46),
              onPressed: () {
                final provider =
                Provider.of<CardProvider>(context, listen: false);

                provider.dislike();
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: getColor(Colors.green, Colors.white, isLike),
                backgroundColor: getColor(Colors.white, Colors.green, isLike),
                side: getBorder(Colors.green, Colors.white, isLike),
              ),
              child: Icon(Icons.favorite, size: 46),
              onPressed: () {
                final provider =
                Provider.of<CardProvider>(context, listen: false);

                provider.like();
              },
            ),
      ],
    );
  }

  MaterialStateProperty<Color> getColor(
      Color color, Color colorPressed, bool force) {
    final getColor = (Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };

    return MaterialStateProperty.resolveWith(getColor);
  }

  MaterialStateProperty<BorderSide> getBorder(
      Color color, Color colorPressed, bool force) {
    final getBorder = (Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    };

    return MaterialStateProperty.resolveWith(getBorder);
  }
}
