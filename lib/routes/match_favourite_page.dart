import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawgo/models/currentUser.dart';
import 'package:pawgo/models/loggedUser.dart';
import 'package:pawgo/utils/mobile_library.dart';

import '../assets/custom_colors.dart';
import '../models/dogsList.dart';

class MatchFavouritePage extends StatefulWidget {
  String? data;
  MatchFavouritePage({Key? key, this.data}) : super(key: key);

  @override
  _MatchFavouritePageState createState() => _MatchFavouritePageState(data: data);
}

class _MatchFavouritePageState extends State<MatchFavouritePage> {
  String? data;

  _MatchFavouritePageState({this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pawrange,
      body: Column(
        children: <Widget>[
          Container(
            child: Expanded(
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
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        usersInfo(),
                        SizedBox(
                          height: 3 * SizeConfig.heightMultiplier!,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget usersInfo() {
    return Container(
        child: DogsList.instance!.dogsList.isEmpty
            ? SizedBox()
            : Container(
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5 * SizeConfig.heightMultiplier!),
                    child: Text(
                      'Users Like Me',
                      style: TextStyle(
                        fontSize: 6 * SizeConfig.textMultiplier!,
                        fontFamily: 'pawfont',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  displayInfo(),
                ],
              )
          ),)
    );
  }

  Widget displayInfo() {
    return ListView.builder(
        itemCount: DogsList.instance!.dogsList.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
                Container(
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
                                          width: 30 * SizeConfig.widthMultiplier!,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(LoggedUser.instance!.image.url),
                                              fit: BoxFit.cover,
                                              // alignment: Alignment(-0.3, 0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 40 * SizeConfig.heightMultiplier!,
                                        width: 30 * SizeConfig.widthMultiplier!,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            // image: NetworkImage(widget.user.urlImage),
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
                                  LoggedUser.instance!.username,
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
                                  CurrentUser.instance!.userAge,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 2.2 * SizeConfig.textMultiplier!,
                                  ),
                                ),
                                SizedBox(
                                  height: 0.5 * SizeConfig.heightMultiplier!,
                                ),
                                Text(
                                  "Email:",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 2.5 * SizeConfig.textMultiplier!,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                Text(
                                  LoggedUser.instance!.mail,
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
                                CurrentUser.instance!.userDesc == "Update your desc here" ?
                                Text(
                                  " - ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 2.2 * SizeConfig.textMultiplier!,
                                  ),
                                ) :
                                Text(
                                  CurrentUser.instance!.userDesc,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 2.2 * SizeConfig.textMultiplier!,
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
              SizedBox(height: 3 * SizeConfig.heightMultiplier!,),
            ],
          );
        });
  }
}
