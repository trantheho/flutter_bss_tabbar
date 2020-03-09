import 'package:flutter/material.dart';

class TabItem extends StatefulWidget {

  String title;

  TabItem (this.title);

  @override
  _TabItemState createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> {
  bool leftBorder = true, rightBorder = true, firstItem = false, focus = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: focus ? Radius.circular(8) : Radius.circular(0),
          topRight: focus ? Radius.circular(8) : Radius.circular(0),
          bottomLeft: leftBorder ? Radius.circular(8) : Radius.circular(0),
          bottomRight: rightBorder ? Radius.circular(8) : Radius.circular(0),
        ),
        color:Colors.white70,
      ),
      child: Row(
        mainAxisAlignment:  MainAxisAlignment.spaceAround,
        children: <Widget>[
          Center(
            child: Container(
              width: 20,
              height: 20,
              child: Image(
                image: AssetImage('assets/ic_close.png') ,
              ),
            )
          ),
          Center(
            child: Text(
              '${widget.title}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          )
        ],
      ),
    );
  }
}
