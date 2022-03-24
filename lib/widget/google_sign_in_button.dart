import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawgo/assets/custom_colors.dart';
import 'package:pawgo/models/loggedUser.dart';
import 'package:pawgo/routes/username_insert_page.dart';
import 'package:pawgo/services/authentication.dart';
import 'package:pawgo/services/mongodb_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  void initState() {
    super.initState();
    if(kIsWeb)
    {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool loggedIn=prefs.getBool("loggedIn")??false;
        if(loggedIn)
          {
            setState(() {
              _isSigningIn=true;
            });
          }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(CustomColors.pawrange),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(CustomColors.pawrange),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                if(!kIsWeb)
                  {
                    setState(() {
                      _isSigningIn = true;
                    });
                    try{
                      User? user =
                      await Authentication.signInWithGoogle(context: context);
                      /*setState(() {
                      _isSigningIn = false;
                    });*/
                      if (user != null) {
                        print(user.displayName);
                        CollectionReference usersCollection = FirebaseFirestore.instance.collection("Users");
                        QuerySnapshot querySnapshot = await usersCollection
                            .where("Mail", isEqualTo: user.email)
                            .get();
                        if (querySnapshot.docs.isNotEmpty) {
                          String? username = querySnapshot.docs[0].get("Username");
                          String? imageUrl= querySnapshot.docs[0].get("Image");
                          if (username != null) {
                            LoggedUser.initInstance(user.uid, imageUrl ?? "", user.email!, username);
                            await MongoDB.instance.initUser(user.uid);

                            Navigator.pushNamedAndRemoveUntil(
                                context, '/switch_page', (route) => false);
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        InsertUsernameScreen(user: user)));
                          }
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      InsertUsernameScreen(user: user)));
                        }
                      }
                    }
                    catch (e){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                          Text("Ouch! Something is wrong. Please try again!")));
                    }
                    finally
                    {
                      setState(() {
                        _isSigningIn = false;
                      });
                    }

                  }
                else
                  {
                    setState(() {
                      _isSigningIn = true;
                    });
                  }

              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("lib/assets/google_logo.png"),
                      height: 35.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
