import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:window_manager/window_manager.dart";
// ignore: unused_import
import 'package:todo_list/mini.dart';

class Todo {
  int id;
  String title;
  bool completed;

  Todo({required this.id, required this.title, this.completed = false});
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<MiniAppState> miniPageKey = GlobalKey<MiniAppState>();

  var miniWindowID = 0;

  List<Todo> todos = [];

  void _addTodo() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      todos.add(
        Todo(
          id: DateTime.now().millisecondsSinceEpoch,
          title: _controller.text.trim(),
        ),
      );
      _controller.clear();
      DesktopMultiWindow.invokeMethod(miniWindowID, "addParagraph");
    });
  }

  void _toggleComplete(int id) {
    setState(() {
      final todo = todos.firstWhere((t) => t.id == id);
      todo.completed = !todo.completed;
    });
  }

  void _deleteTodo(int id) {
    setState(() {
      todos.removeWhere((t) => t.id == id);
    });
  }

  void _editTodoDialog(Todo todo) {
    final editController = TextEditingController(text: todo.title);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Edit Todo"),
          content: TextField(controller: editController, autofocus: true),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  todo.title = editController.text.trim();
                });
                Navigator.pop(ctx);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Basic Todo", style: GoogleFonts.tangerine(fontSize: 19)),
      ),
      body: Column(
        children: [
          ElevatedButton(
            child: const Text("Open Floating Text"),
            onPressed: () async {
              // create a new window using the "mini" entrypoint
              final window = await DesktopMultiWindow.createWindow(
                jsonEncode({'name': 'mini'}),
              );
              window
                ..setFrame(const Offset(100, 100) & const Size(420, 200))
                ..setTitle("Mini Player")
                ..show();

              setState(() {
                miniWindowID = window.windowId;
              });

              // Give Flutter time to render, then force always-on-top
              // Future.delayed(const Duration(milliseconds: 0), () async {
              //   await windowManager.setAlwaysOnTop(true);
              // });
            },
          ),
          // Input row
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Enter a task",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _addTodo, child: const Text("Add")),
              ],
            ),
          ),

          // List of todos
          Expanded(
            child:
                todos.isEmpty
                    ? const Center(child: Text("No todos yet"))
                    : ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (ctx, i) {
                        final todo = todos[i];
                        return ListTile(
                          leading: Checkbox(
                            value: todo.completed,
                            onChanged: (_) => _toggleComplete(todo.id),
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              decoration:
                                  todo.completed
                                      ? TextDecoration.lineThrough
                                      : null,
                            ),
                          ),
                          onTap: () => _editTodoDialog(todo),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteTodo(todo.id),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
