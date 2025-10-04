import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/first.dart';
import 'package:todo_list/mini.dart';
import 'package:todo_list/todo.dart';
// import "package:window_manager/window_manager.dart";

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  // await windowManager.ensureInitialized();

  if (args.isNotEmpty) {
    final arg = jsonDecode(args.last);
    final name = arg['name'];

    if (name == 'mini') {
      runApp(const MiniApp());
      return;
    }
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: TodoPage(),
      ),
    );
  }
}
