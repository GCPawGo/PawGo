export 'package:firebase_auth/firebase_auth.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:flutter/material.dart';
export 'package:pawgo/routes/splashscreen_page.dart';
export 'package:pawgo/size_config.dart';
export 'package:flutter/services.dart';
export 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:pawgo/routes/sign_in.dart';
import 'package:pawgo/routes/sign_in_page.dart';
import 'package:pawgo/routes/start_page.dart';
import 'package:pawgo/routes/switching_page.dart';
import 'package:pawgo/routes/splashscreen_page.dart';
import 'package:pawgo/routes/profile_page.dart';
import 'package:pawgo/routes/profile_editing.dart';
import 'package:flutter/material.dart';

class Conditional {
  Future<void> initFireBase() async {
    await Firebase.initializeApp();
  }

  Widget startPage = SplashScreen();

  final routes = {
    'signInScreen': (context) => SignInScreen(),
    '/start': (context) => StartPage(),
    '/sign_in': (context) => SignInPage(),
    '/sign_in_page': (context) => SignInScreen(),
    '/switch_page': (context) => SwitchPage(),
    '/splash_page': (context) => SplashScreen(),
    '/profile': (context) => ProfilePage(),
    '/profile_editing': (context) => ProfileEditing(),
  };
}
