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
  }

  @override
  Widget build(BuildContext context) {
      return Transform.scale(
        scale: scaleAnimation,
        alignment: Alignment.bottomLeft,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                width: 120,
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
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      animationController.reverse().whenComplete((){
                        widget.bill.close = true;
                        widget.onRemoveTab();
                        animationController.forward(from: 1.0);
                      });
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

class BSSTabBar extends StatefulWidget {
  @override
  _BSSTabBarState createState() => _BSSTabBarState();

}

class _BSSTabBarState extends State<BSSTabBar> {
  ItemScrollController _itemScrollController = ItemScrollController();
  final int backgroundFocusColor = 0xff1E2E90;
  final int backgroundDefaultColor = 0xff2437AC;
  AnimationController animationController;
  double _widthTabItem, _sizeBoxWidth, _maxRowWidth;
  int _itemIndex;
  Timer delay;

  List<Bill> _list = [
    Bill(checked: true, number: "#001",bottomRight: false,bottomLeft: false, close: false ),
    Bill(checked: false, number: "#002", bottomLeft: false, bottomRight: false, close: false),
    Bill(checked: false, number: "#003", bottomRight: false, bottomLeft: false, close: false),
    Bill(checked: false, number: "#004", bottomRight: false, bottomLeft: false, close: false),
  ];

  @override
  void initState() {
    super.initState();
    _itemIndex = 0;
    _widthTabItem = 120;
    _sizeBoxWidth = (_list.length * _widthTabItem);
  }

  @override
  Widget build(BuildContext context) {
    _maxRowWidth = MediaQuery.of(context).size.width - 70;
    if(_sizeBoxWidth > _maxRowWidth){
      _sizeBoxWidth = _maxRowWidth;
    }
    else {
      _sizeBoxWidth = (_list.length * _widthTabItem);
    }

    return Container(
      margin: EdgeInsets.only(top: 50),
      color: Color(0xff2437AC),
      height: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildHeader(),
          _buildTab(),
          _buildBottom(),
        ],
      ),
    );
  }

  _buildTab() {

    return SizedBox(
      width: _sizeBoxWidth,
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
          _sizeBoxWidth = _getWidth();
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

    if(_itemIndex == 0){
      if(index == _itemIndex){
        opacity = false;
      }
      else{
        opacity = true;
      }
    }
    else{
      if(index == (_itemIndex - 1) || index == (_itemIndex)){
        opacity = false;
      }
      else{
        opacity = true;
      }
    }
    return Opacity(
      opacity: 1.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 14),
        child: Container(
          height: 20,
          width: opacity ? 1 : 0,
          color: Colors.grey[200],
        ),
      ),
    );
  }

  _buildHeader(){
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        width: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12),
          ),
          color: Color(backgroundFocusColor),
        ),
        child: Container(
          width: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: (_itemIndex == 0) ? Radius.circular(12) : Radius.circular(0),
            ),
            color: Color(backgroundDefaultColor),
          ),
        ),
      ),
    );
  }

  _buildBottom(){
    bool opacity;
    if(_itemIndex == _list.length - 1){
      opacity = true;
    }
    else{
      opacity = false;
    }
    return Row(
      children: <Widget>[
        /*Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 14),
          child: Center(
            child: Container(
              height: 30,
              width: opacity ? 0 : 1,
              color: Colors.grey[200],
            ),
          ),
        ),*/
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              child: Container(
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
              ),
            ),
            Container(
              width: 50,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                ),
                color: Color(backgroundFocusColor),
              ),
              child: Container(
                width: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: (_itemIndex == _list.length-1) ? Radius.circular(12) : Radius.circular(0),
                  ),
                  color: Color(backgroundDefaultColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  addNewTab(){
    var newItem = new Bill(checked: true, number: "#00${_list.length+1}", bottomRight: false, bottomLeft: false, close: false);
    setState(() {
      _refreshItem();
      _list.add(newItem);
      _sizeBoxWidth = _getWidth();
    });
    _itemIndex = _list.length-1;
    _list[_itemIndex -1].bottomRight = true;
  }

  removeTab(){
    int previousIndex;

    if(_itemIndex == 0) {
      if(_list.length == 1){
        setState(() {
          if(_list[_itemIndex].close){
            _list.removeAt(_itemIndex);
            _sizeBoxWidth = _getWidth();
          }
        });
      }
      else{
        previousIndex = _itemIndex;
        setState(() {
          if(_list[_itemIndex].close){
            _list.removeAt(_itemIndex);
            _itemIndex = previousIndex;
            _list[_itemIndex].checked = true;

            _sizeBoxWidth = _getWidth();
          }
        });
        //_itemScrollController.jumpTo(index: _itemIndex);
      }
    }
    else{
      previousIndex = _itemIndex - 1;
      setState(() {
        _list.removeAt(_itemIndex);
        _itemIndex = previousIndex;
        _list[_itemIndex].checked = true;

        _sizeBoxWidth = _getWidth();
      });
     // _itemScrollController.jumpTo(index: _itemIndex);
    }
  }

  _getWidth(){
    _maxRowWidth = MediaQuery.of(context).size.width - 60;
    if( (_list.length * _widthTabItem) > _maxRowWidth){
      _sizeBoxWidth = _maxRowWidth;
    }
    else {
      _sizeBoxWidth = (_list.length * _widthTabItem);
    }
    return _sizeBoxWidth;
  }

  void _refreshItem(){
    _list.forEach((item) => item.checked = false);
    _list.forEach((item) => item.bottomRight = false);
    _list.forEach((item) => item.bottomLeft = false);
  }

}

class Bill {
  bool checked;
  bool bottomLeft;
  bool bottomRight;
  bool close;
  String number;

  Bill({this.checked, this.number, this.bottomLeft, this.bottomRight, this.close});

}
