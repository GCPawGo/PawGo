import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';

// Link to DB
final List data = [
  {'color': Colors.red},
  {'color': Colors.green,},
  {'color': Colors.blue,},
  {'color': Colors.orange,},
  {'color': Colors.yellow,},
  {'color': Colors.brown,},
  {'color': Colors.indigoAccent,},
];

class Tinder extends StatefulWidget {
  const Tinder({Key? key}) : super(key: key);

  @override
  State<Tinder> createState() => _TinderState();
}

class _TinderState extends State<Tinder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // This holds the items of the ListView
  final listItems = List.generate(200, (i) => "Item $i");

  // Used to generate random integers
  final random = Random();

  // Dynamically load cards from database
  List<Card> cards = [
    Card(
      data[0]['color'],
    ),
    Card(
      data[1]['color'],
    ),
    Card(
      data[2]['color'],
    ),
    Card(
      data[3]['color'],
    ),
    Card(
      data[4]['color'],
    ),
    Card(
      data[5]['color'],
    ),
    Card(
      data[6]['color'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.6,
      // Important to keep as a stack to have overlay of cards.
      child: Stack(
        children: cards,
      ),
    );
  }
}

class Card extends StatelessWidget {
  // Made to distinguish cards
  // Add your own applicable data here
  final Color color;
  Card(this.color);

  @override
  Widget build(BuildContext context) {
    return Swipable(
      // Set the swipable widget
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: color,
        ),
      ),

      // onSwipeRight, left, up, down, cancel, etc...
    );
  }
}

