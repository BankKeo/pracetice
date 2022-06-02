import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences prefs;
  List<String> entries = [];
  List<String> data = [];

  final textController = TextEditingController();

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('historyValue', entries);
    data = prefs.getStringList('historyValue')!;
    setState(() {});
  }

  @override
  void initState() async {
    super.initState();
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: textController,
          ),
        ),
        body: data.length > 0
            ? ListView.separated(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${data[index]}'),
                    onLongPress: () {
                      delete(index);
                    },
                    trailing: Icon(Icons.remove_circle_outline),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  color: Colors.black,
                ),
              )
            : Center(
                child: Text("No Groceries"),
              ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () {
            entries.add(textController.text);
            textController.clear();
            _saveData();
          },
        ),
      ),
    );
  }

  delete(val) async {
    prefs = await SharedPreferences.getInstance();
    var favoriteList = prefs.getStringList('historyValue') ?? [];
    favoriteList.removeWhere((item) => item == val);
    setState(() {});
  }
}
