import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';


class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class NewHome extends StatelessWidget {
  const NewHome({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      body: Column(
        children: [
          Text("A random idea:"),
          Text(appState.current.asLowerCase),
          ElevatedButton(
            onPressed: () {
              print("button pressed");
            },
            child: Text("Next"),
          ),
        ],
      ),
    );
  }
}

