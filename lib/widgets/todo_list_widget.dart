import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/todo_controller.dart';

class TodoList extends StatefulWidget {
  final todoList;
  TodoList(this.todoList);

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  var todoController = TodoController();
  var removedItem;
  var removedItemPosition;
  var _todoList = [];

  @override
  void initState() {
    super.initState();
    _todoList = widget.todoList;
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _todoList.sort((a, b) {
        if (a["status"] && !b["status"]) {
          return 1;
        } else if (!a["status"] && b["status"]) {
          return -1;
        } else {
          return 0;
        }
      });

      todoController.updateTodoListFile(_todoList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: _todoList.length,
              itemBuilder: buildItemList,
            ),
          ),
        )
      ],
    );
  }

  Widget buildItemList(context, index) {
    return Dismissible(
      background: Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.delete),
        ),
      ),
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        onItemDismiss(direction, index);
      },
      child: CheckboxListTile(
        title: Text(_todoList[index]["title"]),
        subtitle: Text(
          _todoList[index]["finalDate"],
          style: TextStyle(
              color:
                  todoController.itsCloseToLimit(_todoList[index]["finalDate"])
                      ? Colors.red
                      : Colors.grey[700]),
        ),
        value: _todoList[index]["status"],
        secondary: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            _todoList[index]["status"] ? Icons.check : Icons.error,
            color: Colors.amber,
          ),
        ),
        onChanged: (bool value) {
          setState(() {
            todoController.updateActivitiesList(value, index, _todoList);
          });
        },
      ),
    );
  }

  void onItemDismiss(direction, index) {
    setState(() {
      removedItem = Map.from(_todoList[index]);
      removedItemPosition = index;

      _todoList.removeAt(index);
      print(_todoList);

      todoController.updateTodoListFile(_todoList);

      final snackBar = SnackBar(
        duration: Duration(seconds: 4),
        content: Text("Atividade \"${removedItem["title"]}\" removida."),
        action: SnackBarAction(
          label: "Desfazer",
          textColor: Colors.blue,
          onPressed: () {
            setState(() {
              _todoList.insert(removedItemPosition, removedItem);
              todoController.updateTodoListFile(_todoList);
            });
          },
        ),
      );

      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }
}
