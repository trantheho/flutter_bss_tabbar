import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

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
  final int backgroundFocusColor = 0xff1E2E90;
  final int backgroundDefaultColor = 0xff2437AC;
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

    return Transform.scale(
      scale: scaleAnimation,
      alignment: Alignment.bottomLeft,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
                color: Color(backgroundFocusColor),
              ),
              child: Container(
                decoration: _decoration(),
                child: _buildContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _decoration(){
    if(widget.bill.checked){
      return BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
        color: Color(backgroundFocusColor),
      );
    }
    else{
        return BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: widget.bill.bottomLeft ? Radius.circular(12) : Radius.circular(0),
            bottomRight: widget.bill.bottomRight ? Radius.circular(12) : Radius.circular(0),
          ),
          color:Color(backgroundDefaultColor),
        );
    }
  }

  _buildContent(){
    if(widget.bill.checked){
      return Stack(
        children: <Widget>[
          Positioned(
              top: 0,
              right: 0,
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
                      //animationController.reverse();
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

class BSSTabBar extends StatefulWidget {
  @override
  _BSSTabBarState createState() => _BSSTabBarState();

}

class _BSSTabBarState extends State<BSSTabBar> {
  ItemScrollController _itemScrollController = ItemScrollController();
  final int backgroundFocusColor = 0xff1E2E90;
  AnimationController animationController;
  int _itemIndex;
  Timer delay;

  List<Bill> _list = [
    Bill(checked: true, number: "#001",bottomRight: false,bottomLeft: false ),
    Bill(checked: false, number: "#002", bottomLeft: false, bottomRight: false),
    Bill(checked: false, number: "#003", bottomRight: false, bottomLeft: false),
    Bill(checked: false, number: "#004", bottomRight: false, bottomLeft: false),
  ];

  @override
  void initState() {
    super.initState();
    _itemIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      color: Color(0xff2437AC),
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildTab(),
          Container(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  addNewTab();
                },
                child: Icon(
                  Icons.add_circle,
                  color: Colors.white70,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildTab() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 70,
      child: ScrollablePositionedList.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _list.length,
          itemScrollController: _itemScrollController,
          itemBuilder: (context, index){
            return _buildTabItem(index);
          },
        separatorBuilder: (context, index) => _buildDivider(index),
      ),

    );

  }

  _buildTabItem(int index) {
    return InkWell(
      onTap: (){
        setState(() {
          _refreshItem();
          _list[index].checked = true;
          if(index != 0){
            _list[index - 1].bottomRight = true;
          }
          if(index < _list.length-1){
            _list[index + 1].bottomLeft = true;
          }
          _itemIndex = index;
          //_itemScrollController.jumpTo(index: _itemIndex);
        });
      },
      child: TabItem(
        bill: _list[index],
        onRemoveTab: removeTab,
      ),
    );

  }

  _buildDivider(int index){
    bool opacity;
    double _opacity;

    if(_itemIndex == 0){
      if(index == _itemIndex){
        opacity = false;
        _opacity = 1.0;
      }
      else{
        opacity = true;
        _opacity = 0.0;
      }
    }
    else{
      if(index == (_itemIndex - 1) || index == (_itemIndex)){
        opacity = false;
        _opacity = 1.0;
      }
      else{
        opacity = true;
        _opacity = 0.0;
      }
    }
    return Opacity(
      opacity: 1.0,
      child: Padding(
        padding: EdgeInsets.only(top: 16, bottom: 14),
        child: Center(
          child: Container(
            width: opacity ? 1 : 0,
            color: Colors.grey[200],
          ),
        ),
      ),
    );
  }

  addNewTab(){
    var newItem = new Bill(checked: true, number: "#00${_list.length+1}",bottomRight: false, bottomLeft: false);
    setState(() {
      _refreshItem();
      _list.add(newItem);
    });
    _itemIndex = _list.length-1;
    _list[_itemIndex -1].bottomRight = true;
  }

  void _refreshItem(){
    _list.forEach((item) => item.checked = false);
    _list.forEach((item) => item.bottomRight = false);
    _list.forEach((item) => item.bottomLeft = false);
  }

  removeTab(){
    int previousIndex;

    if(_itemIndex == 0) {
      previousIndex = _itemIndex;
    }
    else{
      previousIndex = _itemIndex - 1;
    }

    setState(() {
      _list.removeAt(_itemIndex);
      _itemIndex = previousIndex;
      _list[_itemIndex].checked = true;
    });
    //_itemScrollController.jumpTo(index: _itemIndex);
  }

}

class Bill {
  bool checked;
  bool bottomLeft;
  bool bottomRight;
  String number;

  Bill({this.checked, this.number, this.bottomLeft, this.bottomRight});

}
