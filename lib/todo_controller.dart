import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class TodoController {

  ///Pega o path para o diretório e retorna o arquivo da lista de afazeres.
   _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return File("${directory.path}/data.json");
  }

  Future<File> addTodoActivity(String title, String finalDate, _todoList) {
    Map<String, dynamic> newActivity = Map();
    newActivity["title"] = title;
    newActivity["status"] = false;
    newActivity["finalDate"] = finalDate;

    _todoList.add(newActivity);
    return updateTodoListFile(_todoList);
  }

  void updateActivitiesList(value, index, _todoList) {
    _todoList[index]["status"] = value;
    updateTodoListFile(_todoList);
  }

  ///Salva uma nova lista de afazeres e sobrescreve esta na lista antiga.
  Future<File> updateTodoListFile(_todoList) async {
    String todoList = json.encode(_todoList);
    final file = await _getFile();
    return file.writeAsString(todoList);
  }

  ///Função para ler a lista de afazeres.
  Future<String> getTodoList() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      print("Erro ao ler lista de afazeres...");
      return null;
    }
  }

  itsCloseToLimit(String dateLimit) {
     var now = DateTime.now();
     if ( now == DateFormat.yMMMMd('pt_BR').parse(dateLimit)) {
       return true;
     } else if ( DateFormat.yMMMMd('pt_BR').parse(dateLimit).isBefore(now) ) {
       return true;
     } else {
       return false;
     }
  }
}
