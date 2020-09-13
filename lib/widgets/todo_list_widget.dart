import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_todo/todo_controller.dart';

class TodoList extends StatefulWidget {
  final _todoList;

  TodoList(this._todoList);

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  var todoController = TodoController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: widget._todoList.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(widget._todoList[index]["title"]),
                  subtitle: Text(widget._todoList[index]["finalDate"]),
                  value: widget._todoList[index]["status"],
                  secondary: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      widget._todoList[index]["status"]
                          ? Icons.check
                          : Icons.error,
                      color: Colors.amber,
                    ),
                  ),
                  onChanged: (bool value) {
                    setState(() {
                      todoController.updateActivitiesList(
                          value, index, widget._todoList);
                    });
                  },
                );
              }),
        )
      ],
    );
  }
}
