import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawgo/assets/custom_colors.dart';
import 'package:pawgo/models/dog.dart';
import 'package:pawgo/models/searchResult.dart';

import '../models/currentUser.dart';
import '../routes/chat_page.dart';
import '../services/mongodb_service.dart';
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
  List<SearchResult> searchResultList = [];

  Future<void> getSearchResultList() async {
    searchResultList = [];

    for (int i = 0; i < dogsFound.length; i++) {
      CollectionReference userCollection = FirebaseFirestore.instance
          .collection("Users");
      QuerySnapshot querySnapshot = await userCollection
          .where("userId", isEqualTo: dogsFound[i].userId)
          .get();

      CollectionReference dogCollection = FirebaseFirestore.instance.collection(
          "Dogs");
      QuerySnapshot dogQuerySnapshot = await dogCollection
          .where("dogId", isEqualTo: dogsFound[i].id)
          .get();

      if (querySnapshot.docs.isNotEmpty && dogQuerySnapshot.docs.isNotEmpty) {
        CurrentUser? current = await MongoDB.instance.getUser(
            querySnapshot.docs[0].get("userId"));

        Dog dog = dogsFound[i];
        dog.imageUrl = dogQuerySnapshot.docs[0].get("Image");

        SearchResult searchResult = SearchResult(
            querySnapshot.docs[0].get("userId"),
            querySnapshot.docs[0].get("Username"),
            querySnapshot.docs[0].get("Mail"),
            current!.userAge,
            current.userDesc,
            querySnapshot.docs[0].get("Image"),
            dog);

        searchResultList.add(searchResult);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    getSearchResultList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: searchResultList.length,
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
                                          image: NetworkImage(searchResultList[index].userImage),
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
                                        image: NetworkImage(searchResultList[index].dog.imageUrl),
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
                                searchResultList[index].userName,
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
                                searchResultList[index].userAge,
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
                              searchResultList[index].userDesc == "Update your desc here" ?
                              Text(
                                " - ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ) :
                              Text(
                                searchResultList[index].userDesc,
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
                                searchResultList[index].dog.dogName,
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
                                searchResultList[index].dog.dogAge,
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
                                searchResultList[index].dog.dogBreed,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ),
                              SizedBox(
                                height: 0.5 * SizeConfig.heightMultiplier!,
                              ),
                              Text(
                                "Dog's Hobbies:",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 2.5 * SizeConfig.textMultiplier!,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              searchResultList[index].dog.dogHobby == "What's your dog's hobbies?" ?
                              Text(
                                " - ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ) :
                              Text(
                                searchResultList[index].dog.dogHobby,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier!,
                              ),
                              Text(
                                "Dog's Personality:",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 2.5 * SizeConfig.textMultiplier!,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              searchResultList[index].dog.dogPersonality == "What's your dog's personality?"
                                  ?
                              Text(
                                " - ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ) :
                              Text(
                                searchResultList[index].dog.dogPersonality,
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
