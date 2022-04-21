import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawgo/assets/custom_colors.dart';
import 'package:pawgo/size_config.dart';
import 'package:flutter/services.dart';



class SupportPage extends StatefulWidget {
  SupportPage({Key? key}) : super(key: key);
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
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
              child: Column(
                children: <Widget>[
                  Padding(
                  padding: EdgeInsets.only(top: 10 * SizeConfig.heightMultiplier!),
                    child: Text(
                      'Support Page',
                      style: TextStyle(
                        fontSize: 5 * SizeConfig.textMultiplier!,
                        fontFamily: 'pawfont',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    height: 20 * SizeConfig.heightMultiplier!,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 5 * SizeConfig.heightMultiplier!),
                            child: Column(
                              children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "Tap to copy to clipboard:",
                                            style: TextStyle(
                                              fontSize: 2 * SizeConfig.textMultiplier!,
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 1 * SizeConfig.heightMultiplier!),
                                          GestureDetector(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(text: "gcpawgo@gmail.com")).then((_){
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email address copied to clipboard", textAlign: TextAlign.center)));
                                              });
                                            },
                                            child: Text(
                                              "gcpawgo@gmail.com",
                                              style: TextStyle(
                                                fontSize: 3 * SizeConfig.textMultiplier!,
                                                fontWeight: FontWeight.bold,
                                                decoration: TextDecoration.underline,
                                                color: Colors.white60,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                              ],
                            ),
                          ),
                        ],
                      ),

                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
