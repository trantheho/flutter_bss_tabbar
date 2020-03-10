import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:flutterbsstabbar/bill_model.dart';
import 'package:flutterbsstabbar/bss_tab.dart';

class BSSTabBar extends StatefulWidget {
  @override
  _BSSTabBarState createState() => _BSSTabBarState();

}

class _BSSTabBarState extends State<BSSTabBar> {
  ItemScrollController _scrollController = ItemScrollController();
  int _itemIndex;

  List<Bill> _list = [
    Bill(checked: true, number: "#001"),
    Bill(checked: false, number: "#002"),
    Bill(checked: false, number: "#003"),
    Bill(checked: false, number: "#004"),
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
              child: InkWell(
                onTap: () {
                  print("create new tab");
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
          itemScrollController: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: _list.length,
          itemBuilder: (context, index){
            return InkWell(
              onTap: (){
                setState(() {
                  _scrollController.scrollTo(index: index, duration: Duration(milliseconds: 500));
                  _list.forEach((item) => item.checked = false);
                  _list[index].checked = true;
                  _itemIndex = index;
                });
              },
                child: TabItem(_list[index]),
            );
          },
        separatorBuilder: (context, index){
            return _buildDivider(index);
        },
      ),

    );

  }

  _buildDivider(int index){
    double opacity;

    if(_itemIndex == 0){
      if(index == (_itemIndex)){
        opacity = 0.0;
      }
      else{
        opacity = 1.0;
      }
    }
    else{
      if(index == (_itemIndex - 1) || index == (_itemIndex)){
        opacity = 0.0;
      }
      else{
        opacity = 1.0;
      }
    }

    return Opacity(
      opacity: opacity,
      child: Padding(
        padding:const EdgeInsets.only(top: 14, bottom: 14),
        child: Center(
          child: Container(
            width: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
    );
  }





}
