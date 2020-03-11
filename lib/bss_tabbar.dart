import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:flutterbsstabbar/bill_model.dart';
import 'package:flutterbsstabbar/bss_tab.dart';

class BSSTabBar extends StatefulWidget {
  @override
  _BSSTabBarState createState() => _BSSTabBarState();

}

class _BSSTabBarState extends State<BSSTabBar> with TickerProviderStateMixin{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ScrollController _scrollController = ScrollController();
  AnimationController animationController;
  var scaleAnimation;
  int _itemIndex;
  Timer delay;

  List<Bill> _list = [
    Bill(checked: true, number: "#001", opacity: false),
    Bill(checked: false, number: "#002", opacity: true),
    Bill(checked: false, number: "#003", opacity: true),
    Bill(checked: false, number: "#004", opacity: false),
  ];

  @override
  void initState() {
    super.initState();
    _itemIndex = 0;

    animationController = AnimationController(
        duration: Duration(milliseconds: 500),
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
      child: AnimatedList(
          key: _listKey,
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          initialItemCount: _list.length,
          itemBuilder: (context, index, animation){
            return _buildTabItem(context, index, animation);
          },
      ),

    );

  }

  _buildTabItem(BuildContext context, int index, animation) {
    return SizeTransition(
      sizeFactor: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
      child: InkWell(
        onTap: (){
          setState(() {
            //_scrollController.animateTo();
            //_scrollController.jumpTo(index.toDouble());
            _list.forEach((item) => item.checked = false);
            _list[index].checked = true;
            _itemIndex = index;
            refreshOpacity(index);
          });
        },
        child: TabItem(
          bill: _list[index],
          onRemoveTab: removeTab,
        ),
      ),
    );

  }

  addNewTab(){
    var newItem = new Bill(checked: true, number: "#00${_list.length+1}", opacity: false);
    _listKey.currentState.insertItem(_list.length, duration: Duration(microseconds: 500));
    setState(() {
      _list.forEach((item) => item.checked = false);
      _list.add(newItem);
    });
    _itemIndex = _list.length-1;
    //_scrollController.offset();
    refreshOpacity(_itemIndex);
  }

  removeTab(){
    int previousIndex;

    if(_itemIndex == 0) {
      previousIndex = _itemIndex;
    }
    else{
      previousIndex = _itemIndex - 1;
    }

    _listKey.currentState.removeItem(
          _itemIndex,
              (_, animation)=> _buildTabItem(context, _itemIndex, animation),
          duration: Duration(microseconds: 500)
    );

    setState(() {
      _list.removeAt(_itemIndex);
      _itemIndex = previousIndex;
      _list[_itemIndex].checked = true;
      refreshOpacity(_itemIndex);
    });

    _scrollController.jumpTo(_itemIndex.toDouble());

  }

  void refreshOpacity(int index){
    _list.forEach((item) => item.opacity = true);
    _list[_list.length-1].opacity = false;
    if(index == 0){
      _list[index].opacity = false;
    }
    else{
      _list[index-1].opacity = false;
      _list[index].opacity = false;
    }

  }


}
