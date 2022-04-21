import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawgo/assets/custom_colors.dart';
import 'package:pawgo/models/dog.dart';

import '../models/dogsList.dart';
import '../routes/chat_page.dart';
import '../size_config.dart';

class DogSearchButton extends StatefulWidget {
  List<Dog> dogsFound;
  DogSearchButton({Key? key, required List<Dog> dogsFound,}) : dogsFound=dogsFound,super(key: key);

  @override
  _DogSearchButtonState createState() => _DogSearchButtonState(dogsFound: dogsFound);
}

class _DogSearchButtonState extends State<DogSearchButton> {
  List<Dog> dogsFound;
  _DogSearchButtonState({required this.dogsFound});
  // List<CardUser> cardUserList = [];
  // CardUser cardUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: dogsFound.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, int index) {
          return Column(
            children: <Widget>[
          Padding(
          padding: EdgeInsets.only(left: 5 * SizeConfig.widthMultiplier!,
              right: 5 * SizeConfig.widthMultiplier!),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  color: Colors.grey.shade200,
                  border: Border.all(
                    color: Colors.black26.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5 * SizeConfig.heightMultiplier!,
                              bottom: 5 * SizeConfig.heightMultiplier!),
                          child: Column(
                            children: [
                              // Padding(
                              //   padding: EdgeInsets.all(5 * SizeConfig.heightMultiplier!),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(1.5),
                                    child: Container(
                                      height: 40 * SizeConfig.heightMultiplier!,
                                      width: 35 * SizeConfig.widthMultiplier!,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/gcpawgo.appspot.com/o/05840a23-576e-407a-966a-853beeaf44e4.jpg?alt=media&token=ea2a786f-5e91-4f4b-898c-078440753da8"),
                                          fit: BoxFit.cover,
                                          // alignment: Alignment(-0.3, 0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40 * SizeConfig.heightMultiplier!,
                                    width: 35 * SizeConfig.widthMultiplier!,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        // image: NetworkImage(widget.user.urlImage),
                                        // TODO: To be changed by to dog's breed search! :note by Panos
                                        image: NetworkImage(DogsList.instance!.dogsList[index].imageUrl),
                                        fit: BoxFit.cover,
                                        // alignment: Alignment(-0.3, 0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // ),
                              Text(
                                "Username:",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 2.5 * SizeConfig.textMultiplier!,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                "cardUser.userName",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ),
                              SizedBox(
                                height: 0.5 * SizeConfig.heightMultiplier!,
                              ),
                              Text(
                                "Age:",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 2.5 * SizeConfig.textMultiplier!,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                "cardUser.userAge",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ),
                              SizedBox(
                                height: 0.5 * SizeConfig.heightMultiplier!,
                              ),
                              Text(
                                "About Me:",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 2.5 * SizeConfig.textMultiplier!,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              "cardUser.userDesc" == "Update your desc here" ?
                              Text(
                                " - ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ) :
                              Text(
                                "cardUser.userDesc",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ),
                              SizedBox(
                                height: 0.5 * SizeConfig.heightMultiplier!,
                              ),
                              Text(
                                "Dog's Name:",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 2.5 * SizeConfig.textMultiplier!,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                DogsList.instance!.dogsList[index].dogName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ),
                              SizedBox(
                                height: 0.5 * SizeConfig.heightMultiplier!,
                              ),
                              Text(
                                "Dog's Age:",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 2.5 * SizeConfig.textMultiplier!,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                DogsList.instance!.dogsList[index].dogAge,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ),
                              SizedBox(
                                height: 0.5 * SizeConfig.heightMultiplier!,
                              ),
                              Text(
                                "Dog's Breed:",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 2.5 * SizeConfig.textMultiplier!,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                DogsList.instance!.dogsList[index].dogBreed,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ),
                              SizedBox(
                                height: 0.5 * SizeConfig.heightMultiplier!,
                              ),
                              Text(
                                "Dog's Hobby:",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 2.5 * SizeConfig.textMultiplier!,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                DogsList.instance!.dogsList[index].dogHobby,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ),
                              SizedBox(
                                height: 0.5 * SizeConfig.heightMultiplier!,
                              ),
                              Text(
                                "Dog's Personality:",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 2.5 * SizeConfig.textMultiplier!,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                DogsList.instance!.dogsList[index].dogPersonality,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 1 * SizeConfig.heightMultiplier!),
                                child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 250),
                                  child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 250),
                                    child: ElevatedButton(
                                      child: Text("Chat"),
                                      style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(
                                            Size(200, 35)),
                                        backgroundColor: MaterialStateProperty.all(
                                            CustomColors.pawrange),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18.0))),
                                      ),
                                      onPressed: () async {
                                        Navigator.push(context, CupertinoPageRoute(
                                          builder: (context) => ChatPage(),
                                        ));
                                        // setState(() {
                                        //
                                        // });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ),
              SizedBox(height: 3 * SizeConfig.heightMultiplier!,),
            ],
          );
        }
    );
  }
}
