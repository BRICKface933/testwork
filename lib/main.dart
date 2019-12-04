
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'show_code.dart';
import 'dart:convert';

class StudentInfo {
  final String id;
  final String name;
  final String score;

  StudentInfo({this.id, this.name, this.score});

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      id: json['id'],
      name: json['name'],
      score: json['score'],
    );
  }
}

class TestHttp extends StatefulWidget {
  final String url;

  TestHttp({String url}) : url = url;

  @override
  State<StatefulWidget> createState() => TestHttpState();
} // TestHttp

class TestHttpState extends State<TestHttp> {
  String _url;
  StudentInfo _studentInfo;

  @override
  void initState() {
    _url = widget.url;
    super.initState();
  } //initState

  _sendRequestGet() {
    //update form data
    http.get(_url).then((response) {
      _studentInfo = StudentInfo.fromJson(json.decode(response.body));

      setState(() {}); //reBuildWidget
    }).catchError((error) {
      _studentInfo = StudentInfo(
        id: '',
        name: error.toString(),
        score: '',
      );

      setState(() {}); //reBuildWidget
    });
  } //_sendRequestGet

  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                RaisedButton(
                    child: Text('Write student info'), onPressed: _sendRequestGet),
                SizedBox(height: 20.0),
                Text('Response status',
                    style: TextStyle(fontSize: 20.0, color: Colors.blue)),
                SizedBox(height: 20.0),
                Text(_studentInfo == null ? '' : _studentInfo.id,
                    style: TextStyle(fontSize: 15, color: Colors.green)),
                SizedBox(height: 10),
                Text(_studentInfo == null ? '' :_studentInfo.name,
                    style: TextStyle(fontSize: 20.0, color: Colors.blue)),
                SizedBox(height: 10),
                Text(_studentInfo == null ? '' :_studentInfo.score),
              ],
            )));
  } //build
} //TestHttpState

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Test HTTP API'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.code),
                tooltip: 'Code',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CodeScreen()));
                })
          ],
        ),
        body: TestHttp(
            url: 'https://raw.githubusercontent.com/PoojaB26/ParsingJSON-Flutter/master/assets/student.json'));
  }
}

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));