import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawgo/assets/custom_colors.dart';
import 'package:pawgo/models/loggedUser.dart';
import 'package:pawgo/models/dog.dart';
import 'package:pawgo/services/mongodb_service.dart';

class DogSearchButton extends StatefulWidget {
  const DogSearchButton({Key? key, required List<Dog> dogsFound,}) : dogsFound=dogsFound,super(key: key);
  final List<Dog> dogsFound;

  @override
  _DogSearchButtonState createState() => _DogSearchButtonState();
}

class _DogSearchButtonState extends State<DogSearchButton> {
  late List<Dog> dogsFound;

  @override
  void initState() {
    dogsFound=widget.dogsFound;


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: dogsFound.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return Container(
            height: MediaQuery.of(context).size.height * .2,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding:
              EdgeInsets.all(MediaQuery.of(context).size.width * (.02)),
              child: Material(
                child: InkWell(
                  onTap: () {
                    //TODO: retrieve data from mongoDB and open a new page
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset("lib/assets/app_logo.png"),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.1,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            begin: Alignment(0, -1),
                            end: Alignment(0, 0.5),
                            colors: [
                              const Color(0xCC000000).withOpacity(0.1),
                              const Color(0x00000000),
                              const Color(0x00000000),
                              const Color(0xCC000000).withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 9,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        dogsFound[i].dogName,
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                .size
                                                .width *
                                                (.05),
                                            color: Colors.white),
                                      ))),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(padding: const EdgeInsets.all(12),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child:
                                ElevatedButton(
                                  onPressed: () async {
                                    // if (await MongoDB.instance.joinTeam(toJoin.id, LoggedUser.instance!.userId)) {
                                    //   if (LoggedUser.instance!.teams == null)
                                    //     LoggedUser.instance!.teams = List.empty(growable: true);
                                    //   LoggedUser.instance!.teams!.add(toJoin);
                                    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    //     content: Text("Joined "+toJoin.name+" successfully!"),
                                    //   ));
                                    //   toJoin.membersId.cast<String>().add(LoggedUser.instance!.userId);
                                    //   teamsFound.remove(toJoin);
                                    //   LoggedUser.instance!.notifyListeners();
                                    //   setState(() {});
                                    // } else {
                                    //   ScaffoldMessenger.of(context)
                                    //       .showSnackBar(SnackBar(
                                    //     content: Text("Something wrong happened... Please try again."),
                                    //   ));
                                    // }
                            },
                              child: Text("Show Profile"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      CustomColors.pawrange),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0)))),
                            ),

                              ),
                            ),),),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }


}
