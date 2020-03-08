import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            bottom: TabBar(
                labelColor: Colors.redAccent,
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                  /*borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),),*/
                  border: Border(
                      left: BorderSide(
                      color: Colors.white70, width: 1, style: BorderStyle.solid)),
                ),
                indicatorPadding: EdgeInsets.only(top: 4, bottom: 4),
                tabs: [
                  Tab(
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff283593),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                )
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 2, right: 2),
                                  child: IconButton(
                                    icon: Icon(Icons.clear, color: Colors.red,),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text("#002",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                  color: Color(0xff283593),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff283593),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                )
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 2, right: 2),
                                  child: IconButton(
                                    icon: Icon(Icons.clear, color: Colors.red,),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text("#002",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                  color: Color(0xff283593),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  /*Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("GAMES"),
                    ),
                  ),*/
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
            Icon(Icons.apps),
            Icon(Icons.movie),
            Icon(Icons.games),
          ]),
        )
    );
  }
}
