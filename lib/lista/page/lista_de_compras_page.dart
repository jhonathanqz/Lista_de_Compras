import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lista_compras/lista/widgets/alert_delete_widget.dart';
import 'package:path_provider/path_provider.dart';

import '../../string_extension.dart';

class ListaDeCompras extends StatefulWidget {
  @override
  _ListaDeComprasState createState() => _ListaDeComprasState();
}

class _ListaDeComprasState extends State<ListaDeCompras> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _toDoController = TextEditingController();
  final primaryColor = Color(0xFFF21905);

  List _toDoList = [];

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });

    super.initState();
  }

  void _addToDo() {
    if (_toDoController.text.capitalizeFirstOfEach != '' &&
        _toDoController.text.capitalizeFirstOfEach.trim() != '') {
      setState(() {
        Map<String, dynamic> newToDo = Map();
        newToDo["title"] = _toDoController.text.capitalizeFirstOfEach.trim();
        _toDoController.text = "";
        newToDo["ok"] = false;
        _toDoList.add(newToDo);

        _saveData();
      });
    } else {}
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _toDoList.sort((a, b) {
        if (a["ok"] && !b["ok"])
          return 1;
        else if (!a["ok"] && b["ok"])
          return -1;
        else
          return 0;
      });

      _saveData();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Lista de Compras",
          style: GoogleFonts.lexendDeca(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              if (_toDoList.length > 0) {
                showConfirmDelete();
              } else {
                return null;
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    cursorColor: primaryColor,
                    controller: _toDoController,
                    decoration: InputDecoration(
                      labelText: "Adiconar a lista",
                      labelStyle: GoogleFonts.lexendDeca(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
                  RaisedButton(
                      color: primaryColor,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      textColor: Colors.white,
                      onPressed: _addToDo)
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.0),
                    itemCount: _toDoList.length,
                    itemBuilder: buildItem),
                backgroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: primaryColor,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["ok"],
        activeColor: primaryColor,
        secondary: CircleAvatar(
          backgroundColor: _toDoList[index]["ok"] ? Colors.black : primaryColor,
          child: Icon(
            _toDoList[index]["ok"] ? Icons.check : Icons.shopping_basket,
            color: Colors.white,
          ),
        ),
        onChanged: (c) {
          setState(() {
            _toDoList[index]["ok"] = c;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedPos = index;
          _toDoList.removeAt(index);

          _saveData();

          final snack = SnackBar(
            content: Text("Item \"${_lastRemoved["title"]}\" removido!"),
            action: SnackBarAction(
                label: "Desfazer",
                onPressed: () {
                  setState(() {
                    _toDoList.insert(_lastRemovedPos, _lastRemoved);
                    _saveData();
                  });
                }),
            duration: Duration(seconds: 3),
          );

          // ignore: deprecated_member_use
          Scaffold.of(context).removeCurrentSnackBar();
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);

    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  void showConfirmDelete() {
    _scaffoldKey.currentState.setState(() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDeleteList(
          function: () async {
            _toDoList = [];
            await _refresh();
            _saveData();
            Navigator.of(context).pop();
          },
        ),
      );
    });
  }
}
