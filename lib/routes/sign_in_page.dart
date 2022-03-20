import 'package:flutter/material.dart';
import 'package:pawgo/widget/google_sign_in_button.dart';

import '../size_config.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    print("sign_in_page");
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "PawGo",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'pawfont',
                              fontSize: 8 * SizeConfig.textMultiplier!),
                        ),
                      Flexible(
                        flex: 1,
                        child: Image.asset(
                          'lib/assets/app_logo.png',
                          height: MediaQuery.of(context).size.width * (0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                GoogleSignInButton(),
              ],
            ),
          ),
        ),
      );
  }
}
