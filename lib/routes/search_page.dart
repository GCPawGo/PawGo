import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawgo/assets/custom_colors.dart';
import 'package:pawgo/models/dogsList.dart';
import 'package:pawgo/models/loggedUser.dart';
import 'package:pawgo/models/dog.dart';
import 'package:pawgo/services/mongodb_service.dart';
import 'package:pawgo/size_config.dart';
import 'package:pawgo/widget/dogs_search_info_cards.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class DogSearchPage extends StatefulWidget {
  DogSearchPage({Key? key}) : super(key: key);
  @override
  _DogSearchPageState createState() => _DogSearchPageState();
}

class _DogSearchPageState extends State<DogSearchPage> {
  LoggedUser? user;
  List<Dog>? foundDogs;
  late bool hasSearched, loading;
  final dogSearchController = TextEditingController();

  @override
  void initState() {
    user = LoggedUser.instance!;
    user!.addListener(() {setState((){});});
    hasSearched = false;
    loading = false;
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
                      'Dog Search',
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
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 30.0,
                          right: 30.0,
                          top: 3 * SizeConfig.heightMultiplier!),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 5 * SizeConfig.heightMultiplier!),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 20.0,
                                      //top: 1 * SizeConfig.heightMultiplier!,
                                      right: 20),
                                  child: TextField(
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        counterStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide:
                                          BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide:
                                          BorderSide(color: CustomColors.pawrange),
                                        ),
                                        hintText: "Search for dog breeds",
                                        hintStyle:
                                        TextStyle(color: Colors.white)),
                                    controller: dogSearchController,
                                    onSubmitted: (value) async {
                                      setState(() {
                                        hasSearched = true;
                                        loading = true;
                                      });
                                      // TODO: Retrieve data from MongoDB
                                      // foundDogs = await MongoDB.instance.searchDog(dogSearchController.text);
                                      setState(() {
                                        loading = false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedSwitcher(duration: const Duration(milliseconds: 250),
                    child: !hasSearched
                        ? SizedBox()
                        : loading
                        ?  Container(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height:25,
                                width: 25,
                                child: CircularProgressIndicator()),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(
                                  child: Text("Loading...", textAlign: TextAlign.center,style: TextStyle(
                                    color: Colors.black54,
                                  ),),
                                ),
                              ],
                            ),
                          ],
                        ))
                        : (foundDogs != null && foundDogs!.length > 0
                        ? Column(
                      children: [
                        DogSearchButton(dogsFound: foundDogs!),
                        Divider(
                          color: Colors.grey[500],
                        ),
                      ],
                    )
                    : Container(
                    height: 100,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text("No dogs found", textAlign: TextAlign.center,style: TextStyle(
                            color: Colors.black54,
                          ),),
                        ),
                      ],
                    ))),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
