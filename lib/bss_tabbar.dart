import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

typedef RemoveTab = void Function();
typedef ScrollTab = void Function();

class TabItem extends StatefulWidget {
  final RemoveTab onRemoveTab;
  final ScrollTab onScrollTab;
  final bool showIconClose;
  BssTabItem bssTabItem;

  TabItem ({this.bssTabItem, this.onRemoveTab, this.onScrollTab, this.showIconClose});

  @override
  _TabItemState createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> with TickerProviderStateMixin{
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

    /// in creating new tab, tab use animation forward with lowerBound 0.0
    /// after created new tab, tab bar will scroll to new index
    animationController.forward(from: 0.0).whenComplete((){
      setState(() {
        widget.onScrollTab();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  ///nested 2 container to custom border tab
  /// 1 container above set decoration color is [backgroundDefaultColor]
  /// 1 container under set decoration color is [backgroundFocusColor]
  /// when current tab is selected: previous tab set bottomRight border = true, next tab set bottomLeft border = true

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

  /// custom container above decoration
  _decoration(){
    if(widget.bssTabItem.checked){
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
            bottomLeft: widget.bssTabItem.bottomLeft ? Radius.circular(12) : Radius.circular(0),
            bottomRight: widget.bssTabItem.bottomRight ? Radius.circular(12) : Radius.circular(0),
          ),
          color:Color(backgroundDefaultColor),
        );
    }
  }

  _buildContent(){
    if(widget.bssTabItem.checked){
      return Stack(
        children: <Widget>[
          widget.showIconClose ? Positioned(
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
                        widget.bssTabItem.close = true;
                        animationController.forward(from: 1.0);
                        widget.onRemoveTab();
                        //widget.onScrollTab();
                      });
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Image(
                      image: AssetImage('assets/ic_close.png'),
                    ),
                  ),
                ),
              )
          ) : Container(),
          Center(
            child: Container(
              child: Text(
                '${widget.bssTabItem.number}',
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
                '${widget.bssTabItem.number}',
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

typedef TabOnPressed = Function();

class BSSTabBar extends StatefulWidget {
  List<String> tabTitle;
  //TabOnPressed tabOnPressed;
  final bool showCloseIcon;

  BSSTabBar({this.tabTitle, this.showCloseIcon});


  @override
  _BSSTabBarState createState() => _BSSTabBarState();

}

class _BSSTabBarState extends State<BSSTabBar>{
  final int backgroundFocusColor = 0xff1E2E90;
  final int backgroundDefaultColor = 0xff2437AC;
  ItemScrollController _itemScrollController = ItemScrollController();
  double _widthTabItem, _sizeBoxWidth, _maxRowWidth;
  bool addTab = false, deleteTab = false;
  int _itemIndex;
  List<BssTabItem> _list;

  @override
  void initState() {
    super.initState();
    _itemIndex = 0;
    /// create list tab with [widget.tabTitle]
    _list = generateTab(widget.tabTitle);
    _list[0].checked = true;
  }

  generateTab(List<String> listTitle){
    return listTitle.map((title) => BssTabItem(
        checked: false,
        number: title,
        bottomRight: false,
        bottomLeft: false,
        close: false ),).toList();
  }

  @override
  Widget build(BuildContext context) {
    _sizeBoxWidth = _getWidth();

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
          _itemScrollController.scrollTo(index: _itemIndex, duration: Duration(milliseconds: 1));
        });
      },
      child: TabItem(
        bssTabItem: _list[index],
        onRemoveTab: removeTab,
        onScrollTab: scrollTab,
        showIconClose: widget.showCloseIcon,
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

  /// item header to set bottomRight border when first tab selected
  _buildHeader(){
    bool border = false;
    if(_itemIndex == 0 && _list.length > 0){
      border = true;
    }
    else{
      border = false;
    }

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
                bottomRight: border ? Radius.circular(12) : Radius.circular(0),
            ),
            color: Color(backgroundDefaultColor),
          ),
        ),
      ),
    );
  }

  /// item bottom to set bottomLeft border when last tab selected
  _buildBottom(){
    return Stack(
      children: <Widget>[
        Container(
          width: 50,
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
            ),
            color: Color(backgroundFocusColor),
          ),
          child: Container(
            width: 50,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: (_itemIndex == _list.length-1) ? Radius.circular(12) : Radius.circular(0),
              ),
              color: Color(backgroundDefaultColor),
            ),
          ),
        ),
        Container(
          height: 72,
          width: 50,
          margin: const EdgeInsets.only(top: 8),
          child: Center(
            child: IconButton(
              onPressed: addNewTab,
              icon: Icon(Icons.add_circle),
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }

  /// add new tab
  /// after add tab, refresh size box for list tab
  addNewTab(){
    var newItem = new BssTabItem(checked: true, number: "#00${_list.length+1}", bottomRight: false, bottomLeft: false, close: false);
    setState(() {
      _refreshItem();
      _list.add(newItem);
      _sizeBoxWidth = _getWidth();
      addTab = true;

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
            deleteTab = true;
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
            deleteTab = true;
            _sizeBoxWidth = _getWidth();
          }
        });
      }
    }
    else{
      previousIndex = _itemIndex - 1;
      setState(() {
        _list.removeAt(_itemIndex);
        _itemIndex = previousIndex;
        _list[_itemIndex].checked = true;
        deleteTab = true;
        _sizeBoxWidth = _getWidth();
      });
    }
  }

  scrollTab(){
    _sizeBoxWidth = _getWidth();
    if(addTab || deleteTab){
      _itemScrollController.scrollTo(index: _itemIndex, duration: Duration(milliseconds: 1));
      addTab = false;
      deleteTab = false;
    }
  }

  _getWidth(){
    _widthTabItem = 120;
    _maxRowWidth = MediaQuery.of(context).size.width - 70;
    setState(() {
      if( (_list.length * _widthTabItem) >= _maxRowWidth){
        _sizeBoxWidth = _maxRowWidth;
      }
      else {
        _sizeBoxWidth = (_list.length * _widthTabItem);
      }
    });
    return _sizeBoxWidth;
  }

  void _refreshItem(){
    _list.forEach((item) => item.checked = false);
    _list.forEach((item) => item.bottomRight = false);
    _list.forEach((item) => item.bottomLeft = false);
  }

}

class BssTabItem {
  bool checked;
  bool bottomLeft;
  bool bottomRight;
  bool close;
  String number;

  BssTabItem({this.checked, this.number, this.bottomLeft, this.bottomRight, this.close});

}
