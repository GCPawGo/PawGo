import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Room',
      theme: ThemeData(
        //!!!! - Color to be changed to match the app
        primarySwatch: Colors.orange,
      ),

      // can be changed to the person name
      home: const MyHomePage(title: 'Chat Room'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Message {
  final String text;
  final DateTime date;
  final bool sentByMe;

  const Message({
    required this.text,
    required this.date,
    required this.sentByMe,
  });
}
class _MyHomePageState extends State<MyHomePage> {

  //To control the text field to be cleared
  var _controller = TextEditingController();

  //Hardcoded List of Messages
  List<Message> messages = [
    Message(
      text: 'I think this works',
      date: DateTime.now().subtract(
          Duration(minutes: 1)
      ),
      sentByMe: true,
    ),
    Message(
      text: 'aaaaaa',
      date: DateTime.now().subtract(
          Duration(minutes: 1)
      ),
      sentByMe: false,
    ),
    Message(
      text: 'To see if the scroll date works',
      date: DateTime.now().subtract(
          Duration(minutes: 1)
      ),
      sentByMe: true,
    ),
    Message(
      text: 'Im just filling these in',
      date: DateTime.now().subtract(
          Duration(minutes: 1)
      ),
      sentByMe: true,
    ),
    Message(
      text: 'Thats fine! lmfao',
      date: DateTime.now().subtract(
          Duration(minutes: 1)
      ),
      sentByMe: false,
    ),
    Message(
      text: 'Sorry for the late reply, I have been busy :(',
      date: DateTime.now().subtract(
          Duration(minutes: 1)
      ),
      sentByMe: true,
    ),
    Message(
      text: 'Good and you?',
      date: DateTime.now().subtract(
          Duration(days: 3, minutes: 3)
      ),
      sentByMe: false,
    ),
    Message(
      text: 'Hi! how are you?',
      date: DateTime.now().subtract(Duration(days: 3, minutes: 4)),
      sentByMe: true,
    ),
    Message(
      text: 'Hello there!',
      date: DateTime.now().subtract(Duration(days: 4, minutes: 1)),
      sentByMe: false,
    ),
  ].reversed.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
            widget.title, // can be changed to the person name
            style: TextStyle(color: Colors.white),
        ),

          //Just a Back button - can take out if needed
          leading: IconButton(icon:Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed:() => Navigator.pop(context, false),
          )
      ),
      body: Center(
        child: Column(
          children:[
            Expanded(
                child: GroupedListView<Message, DateTime>(
                  padding: const EdgeInsets.all(8),
                  reverse: true,
                  order: GroupedListOrder.DESC,
                  //Date Stick to the Top of the Chat
                  useStickyGroupSeparators: true,
                  floatingHeader: true,
                  elements: messages,
                  groupBy: (message) => DateTime(
                    message.date.year,
                    message.date.month,
                    message.date.day,
                  ),
                  groupHeaderBuilder: (Message message) => SizedBox(
                    height: 40,
                    child: Center(
                      child: Card(
                        //!!!! - Color to be changed to match the app - to color theme
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            DateFormat.yMMMd().format(message.date),
                            style: const TextStyle(color: Colors.white),
                          )
                        )
                      )
                    ),
                  ),

                  //Align the Cards corresponds to who sent it
                  itemBuilder: (context, Message message) => Align(
                    alignment: message.sentByMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                    child: Card(
                      //!!!- color to be changed to theme
                      color: Colors.orange.shade100,
                      elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(message.text),
                      )
                    ),
                  ),
                ),
            ),
            Container(
              color: Colors.grey.shade300,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        //add a light color of orange - to color theme
                        color: Colors.orangeAccent, width: 5.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        //add a light color of orange - to color theme
                        color: Colors.orangeAccent, width: 3.0),
                  ),

                  //Clear the text
                  suffixIcon: IconButton(
                      onPressed: _controller.clear,
                      icon: const Icon(Icons.clear),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  fillColor: Colors.white,
                  hintText: 'Message...',
                ),

                onSubmitted: (text) {
                  final message = Message(
                      text: text,
                      date: DateTime.now(),
                      sentByMe: true,
                  );

                  //Add the inputted message to list
                  setState(() {
                    messages.add(message);
                  });

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
