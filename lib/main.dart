import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbsstabbar/custom_painter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.redAccent,
            elevation: 0,
            /// custom list item like tab
            bottom: TabBar(
                isScrollable: true,
                labelColor: Colors.redAccent,
                unselectedLabelColor: Colors.white,
                indicator: BoxDecoration(
                  /*borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),),*/
                  border: Border(
                      left: BorderSide(
                      color: Colors.white70, width: 1, style: BorderStyle.solid)),
                ),
                tabs: [
                  Tab(
                    child: CustomPaint(
                      painter: ShapePainter(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            child: Text("x",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Align(
                            child: Text("#002",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: CustomPaint(
                      painter: ShapePainter(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Align(
                            child: Text("x",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Align(
                            child: Text("#002",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                      onPressed: (){
                        print("add new tab");
                      },
                      child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200]
                          ),
                          child: Icon(Icons.add)))
                ]
            ),
          ),
          body: TabBarView(children: [
            CustomPaint(
              painter: ShapePainter(),
            ),
            Icon(Icons.movie),
            Icon(Icons.games),
          ]),
        )
    );
  }
}
