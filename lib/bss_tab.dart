import 'package:flutter/material.dart';

class TabItem extends StatefulWidget {

  @override
  _TabItemState createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> {
  bool leftBorder = false, rightBorder = false, firstItem = false;
  String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        )
      ),
      child: Row(
        mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: Container(
              child: Image(
                image: AssetImage('ic_close.png') ,
              ),
            )
          ),
          Center(
            child: Text(
              '$title',
            ),
          )
        ],
      ),
    );
  }
}
