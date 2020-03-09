
import 'package:flutter/material.dart';
import 'package:flutterbsstabbar/bss_tab.dart';

class BSSTabBar extends StatefulWidget {
  @override
  _BSSTabBarState createState() => _BSSTabBarState();

}

class _BSSTabBarState extends State<BSSTabBar> {

  List<Widget> _widgets = List();
  List<String> _list = ["#001", "#002", "#003",];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      color: Color(0xff2437AC),
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _buildTab(),
      ),
    );
  }

  List<Widget> _buildTab() {
    int cout = 0;
    for(int i = 0; i < _list.length; i++){
      cout++;
      _widgets.add(Expanded(
        /// add tab item with number title
        child: TabItem(_list[i]),
      ));

      _widgets.add(Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Container(
            width: 2,
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
          ),
        ),
      ));

      print("$cout");
    }

 /*   /// create new tab button
    _widgets.add(Center(
      child: InkWell(
        onTap: () {
          print("create new tab");
        },
        child: Icon(
          Icons.add_circle,
          color: Colors.white70,
        ),
      ),
    ));*/

    return _widgets;
  }





}
