import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbsstabbar/bill_model.dart';
import 'package:flutterbsstabbar/custom_painter.dart';

typedef RemoveTab = void Function();

class TabItem extends StatefulWidget {
  final RemoveTab onRemoveTab;
  Bill bill;

  TabItem ({this.bill, this.onRemoveTab});

  @override
  _TabItemState createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> {
  bool leftBorder = true, rightBorder = true, firstItem = false, focus = true;
  final int textCheckedColor = 0xFFFFFFFF;
  final int textDefaultColor = 0x8AFFFFFF;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: widget.bill.checked ? ShapePainter() : null,
      child: Container(
        width: 110,
        child: _buildContent(),
      ),
    );
  }

  _buildContent(){
    if(widget.bill.checked){
      return Stack(
        children: <Widget>[
          Positioned(
              top: 5,
              right: 10,
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      /// using transform.scale to hide widget and remove item after that
                    });
                    widget.onRemoveTab();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Image(
                      image: AssetImage('assets/ic_close.png') ,
                    ),
                  ),
                ),
              )
          ),
          Center(
            child: Container(
              child: Text(
                '${widget.bill.number}',
                style: TextStyle(
                  color: Color(textCheckedColor),
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      );
    }
    else{
      return Row(
        mainAxisAlignment:  MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              child: Text(
                '${widget.bill.number}',
                style: TextStyle(
                  color:Color(textDefaultColor),
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      );
    }
  }

}
