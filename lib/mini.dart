import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
// import 'package:window_manager/window_manager.dart';
import 'data/tmp_data.dart';

// @pragma('vm:entry-point') // 👈 required so Flutter can find this
// void mini(List<String> args) async {

//   // const options = WindowOptions(
//   //   size: Size(300, 200),
//   //   alwaysOnTop: true,
//   //   title: "Mini Player",
//   //   skipTaskbar: false,
//   // );

//   // windowManager.waitUntilReadyToShow(options, () async {
//   //   await windowManager.show();
//   //   await windowManager.focus();
//   // });

//   runApp(const MiniApp());
// }

class MiniApp extends StatefulWidget {
  // final int windowId;
  const MiniApp({super.key});

  @override
  State<MiniApp> createState() => MiniAppState();
}

class MiniAppState extends State<MiniApp> {
  final ScrollController _scrollController = ScrollController();

  var data = tmpData;
  var chapter = 0;
  var paragraph = 0;
  List<String> contents = [];

  @override
  void initState() {
    super.initState();
    // _setupMiniWindow();
    _startAutoScroll();

    contents.add(
      '${tmpData["chapters"][chapter]["Chapter 2077 Weak Point (Part 1)"][paragraph]}',
    );

    // Listen for messages from parent
    DesktopMultiWindow.setMethodHandler((call, fromWindoId) async {
      print("parent called recived.");
      if (call.method == "addParagraph") {
        addParagraph();
      }
      return null;
    });
  }

  void _startAutoScroll() async {
    await Future.delayed(Duration(seconds: 2));
    while (_scrollController.hasClients) {
      // If we're already at the bottom, stop scrolling
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        break;
      }

      await _scrollController.animateTo(
        _scrollController.offset + 50,
        duration: Duration(seconds: 3),
        curve: Curves.linear,
      );
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  void addParagraph() {
    print("contents lenght: ${contents.length}");
    var currentChap =
        tmpData["chapters"][chapter]["Chapter 2077 Weak Point (Part 1)"];
    if (paragraph < currentChap.length) {
      paragraph++;
      print("achoo ${currentChap[paragraph]}");

      setState(() {
        contents.add(currentChap[paragraph]);
      });
    }
  }

  // Future<void> _setupMiniWindow() async {
  //   await Future.delayed(const Duration(milliseconds: 50));

  //   await windowManager.ensureInitialized();
  //   await windowManager.setAlwaysOnTop(true);
  //   await windowManager.setSize(const Size(300, 200));
  //   await windowManager.setTitle("Mini Player");
  //   await windowManager.show();
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Window',
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Container(
          padding: EdgeInsets.fromLTRB(8, 22, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                child: GestureDetector(
                  onTap: () => {addParagraph()},
                  child: Text(
                    data["name"],
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: contents.length,
                  itemBuilder: (context, i) {
                    return Text(
                      contents[i],
                      style: const TextStyle(fontSize: 16.0),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
