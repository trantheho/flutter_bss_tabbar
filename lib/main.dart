import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbsstabbar/bss_tab_bar.dart';
import 'package:flutterbsstabbar/bss_tabbar.dart';
import 'package:flutterbsstabbar/custom_painter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  /// 2437AC background color
  /// 1E2E90 focus color


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> title = ["#001", "#002"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BSSTabBar(
        tabTitle: title,
        showCloseIcon: false,
      ),
    );
  }
}
