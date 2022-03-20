import 'package:flutter/material.dart';
import 'package:pawgo/assets/custom_colors.dart';
import 'package:pawgo/routes/sign_in_page.dart';

import 'package:pawgo/services/authentication.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 5;

  @override
  void initState() {
    initApp();
    super.initState();
  }

  void initApp() async {
    await Authentication.initializeFirebase(context: context);
  }

  void navigationPage() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => SignInScreen()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 7,
                child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'lib/assets/app_logo.png',
                          height: MediaQuery.of(context).size.height * (0.75),
                          width: MediaQuery.of(context).size.width * (0.75),
                        ),
                      ],
                    )),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(CustomColors.pawrange)),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}