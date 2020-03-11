import 'dart:async';
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

class _TabItemState extends State<TabItem> with TickerProviderStateMixin{
  bool leftBorder = true, rightBorder = true, firstItem = false, focus = true, remove = false;
  final int textCheckedColor = 0xFFFFFFFF;
  final int textDefaultColor = 0x8AFFFFFF;
  AnimationController animationController;
  var scaleAnimation;


  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 200),
        lowerBound: 0.0,
        upperBound: 1.0,
        vsync: this
    );
   animationController.addListener((){
    setState(() {
      scaleAnimation = animationController.value;
    });
   });

   animationController.forward(from: 0.0);
   remove = false;
  }

  @override
  Widget build(BuildContext context) {

    /*return CustomPaint(
      painter: widget.bill.checked ? ShapePainter() : null,
      child: Row(
        children: <Widget>[
          Container(
            width: 110,
            child: _buildContent(),
          ),
          Opacity(
            opacity: widget.bill.opacity ? 1 : 0,
            child: Padding(
              padding:const EdgeInsets.only(top: 14, bottom: 14),
              child: Center(
                child: Container(
                  width: 1,
                  color: Colors.grey[200],
                ),
              ),
            ),
          ),
        ],
      ),
    );*/

    return Transform.scale(
        scale: scaleAnimation,
        alignment: Alignment.bottomLeft,
        child: CustomPaint(
          painter: widget.bill.checked ? ShapePainter() : null,
          child: Row(
            children: <Widget>[
              Container(
                width: 110,
                child: _buildContent(),
              ),
              Opacity(
                opacity: widget.bill.opacity ? 1 : 0,
                child: Padding(
                  padding:const EdgeInsets.only(top: 14, bottom: 14),
                  child: Center(
                    child: Container(
                      width: 1,
                      color: Colors.grey[200],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                    //animationController.reverse();
                    remove = true;
                    setState(() {
                      if(remove){
                        widget.onRemoveTab();
                        remove = false;
                      }
                    });
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
