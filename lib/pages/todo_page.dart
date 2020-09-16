import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:my_todo/todo_controller.dart';
import 'package:my_todo/widgets/todo_list_widget.dart';

class TodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: StatefulTodoPage(),
      ),
    );
  }
}

class StatefulTodoPage extends StatefulWidget {
  @override
  StatefulTodoPageState createState() => StatefulTodoPageState();
}

class StatefulTodoPageState extends State<StatefulTodoPage> {
  var _todoList = [];
  var displayingBottomSheet = false;
  final _todoNameController = TextEditingController();
  final _todoTimeController = TextEditingController();
  var todoController = TodoController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    todoController.getTodoList().then((todoList) {
      setState(() {
        _todoList = json.decode(todoList);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.amber,
            mini: true,
            child: Icon(
              Icons.add,
              size: 20,
            ),
            onPressed: () {
              displayBottomSheet();
            },
          ),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Atividades",
              style: TextStyle(color: Colors.grey[800]),
            ),
            backgroundColor: Colors.white,
          ),
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[buildActivitiesList()],
          )),
    );
  }

  displayBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: StatefulBuilder(
          builder: (context, stateSetter) => Transform.scale(
            scale: 0.90,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: Theme(
                    data: ThemeData(
                      hintColor: Colors.amber,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _todoNameController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.amber,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.amber,
                              width: 1.0,
                            ),
                          ),
                          contentPadding: EdgeInsets.only(top: 5, left: 10),
                          labelText: "Nome da Atividade",
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Theme(
                          data: ThemeData(
                            hintColor: Colors.amber,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () {
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      onChanged: (date) {
                                    updateDatePicker(stateSetter, date);
                                  }, onConfirm: (date) {
                                    updateDatePicker(stateSetter, date);
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.pt);
                                },
                                child: Text(_todoTimeController.text == null ||
                                        _todoTimeController.text.isEmpty
                                    ? "Escolher uma data"
                                    : _todoTimeController.text)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: Colors.amber[700],
                            onPressed: () {
                              setState(() {
                                todoController.addTodoActivity(
                                    _todoNameController.text,
                                    _todoTimeController.text,
                                    _todoList);

                                _todoNameController.clear();
                                _todoTimeController.clear();
                              });
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Adicionar",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildActivitiesList() {
    return TodoList();
  }

  updateDatePicker(stateSetter, date) {
    setState(() {
      _todoTimeController.text =
          DateFormat.yMMMMd('pt_BR')
              .format(date)
              .toString();
    });
    stateSetter(() {
      _todoTimeController.text =
          DateFormat.yMMMMd('pt_BR')
              .format(date)
              .toString();
    });
  }
}
