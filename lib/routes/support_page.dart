import 'package:audioplayers/audioplayers.dart';
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
  AudioCache player = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
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
              child: GestureDetector(
                onLongPress: () async {
                  // final result = await audioPlayer.play("D:/PawGo/lib/assets/sounds/1.mp3", isLocal: true);

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
                                      DefaultTextStyle(style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70, fontSize: 3 * SizeConfig.textMultiplier!),
                                          child: Text("Developed by:", textAlign: TextAlign.center)
                                      ),
                                      DefaultTextStyle(style: TextStyle(color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!),
                                          child: Text("\nFrontend Leader/Developer:", textAlign: TextAlign.center)
                                      ),
                                      DefaultTextStyle(style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 2.5 * SizeConfig.textMultiplier!),
                                          child: Text("PanosBabo", textAlign: TextAlign.center)
                                      ),
                                      DefaultTextStyle(style: TextStyle(color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!),
                                          child: Text("\nBackend Leader/Developer:", textAlign: TextAlign.center)
                                      ),
                                      DefaultTextStyle(style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 2.5 * SizeConfig.textMultiplier!),
                                          child: Text("Yushun", textAlign: TextAlign.center)
                                      ),
                                      DefaultTextStyle(style: TextStyle(color: Colors.white70, fontSize: 2 * SizeConfig.textMultiplier!),
                                          child: Text("\nFrontend Developer:", textAlign: TextAlign.center)
                                      ),
                                      DefaultTextStyle(style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 2.5 * SizeConfig.textMultiplier!),
                                          child: Text("Kim", textAlign: TextAlign.center)
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  );
                },
                child: Column(
                  children: [
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
