import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


/// create tab

const double _kTabHeight = 46.0;

class BssTab extends StatelessWidget{
  const BssTab({
    Key key,
    this.child,
    this.text,
    this.topLeftIcon,
    this.topRightIcon,
  })  : assert (text != null || child != null || topLeftIcon != null || topRightIcon != null),
        assert(!(text != null && null != child)),
        super(key: key);

  final Widget child;
  final String text;
  final bool topRightIcon;
  final bool topLeftIcon;



  Widget _buildLabelText() {
    return child ?? Text(text, softWrap: false, overflow: TextOverflow.fade);
  }

  Widget _buildLeftIcon() {
    double opacity;
    if(topLeftIcon == null){
      opacity = 0.0;
    }
    else{
      opacity = 1.0;
    }
    return Opacity(
      opacity: opacity,
      child: Positioned(
          top: 5,
          left: 10,
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: InkWell(
              onTap: () {
                /// onDelete tab
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
    );

  }

  Widget _buildRightIcon() {
    double opacity;
    if(topRightIcon == null){
      opacity = 0.0;
    }
    else{
      opacity = 1.0;
    }
    return Opacity(
      opacity: opacity,
      child: Positioned(
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
                /// onDelete tab
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
    );
  }


  @override
  Widget build(BuildContext context) {
    double height;
    Widget label;
    height = _kTabHeight;


    label = Stack(
      children: <Widget>[
        _buildLeftIcon(),
        _buildRightIcon(),
        Center(
          child: _buildLabelText(),
        )
      ],
    );

    return SizedBox(
      height: height,
      child: Container(
        /// set border for tab selected
        decoration: BoxDecoration(

        ),
        child: label,
      ),
    );
  }


}

class _TabStyle extends AnimatedWidget {
  const _TabStyle({
    Key key,
    Animation<double> animation,
    this.selected,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    @required this.child,
  }) : super(key: key, listenable: animation);

  final TextStyle labelStyle;
  final TextStyle unselectedLabelStyle;
  final bool selected;
  final Color labelColor;
  final Color unselectedLabelColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TabBarTheme tabBarTheme = TabBarTheme.of(context);
    final Animation<double> animation = listenable;

    // To enable TextStyle.lerp(style1, style2, value), both styles must have
    // the same value of inherit. Force that to be inherit=true here.
    final TextStyle defaultStyle = (labelStyle
        ?? tabBarTheme.labelStyle
        ?? themeData.primaryTextTheme.body2
    ).copyWith(inherit: true);
    final TextStyle defaultUnselectedStyle = (unselectedLabelStyle
        ?? tabBarTheme.unselectedLabelStyle
        ?? labelStyle
        ?? themeData.primaryTextTheme.body2
    ).copyWith(inherit: true);
    final TextStyle textStyle = selected
        ? TextStyle.lerp(defaultStyle, defaultUnselectedStyle, animation.value)
        : TextStyle.lerp(defaultUnselectedStyle, defaultStyle, animation.value);

    final Color selectedColor = labelColor
        ?? tabBarTheme.labelColor
        ?? themeData.primaryTextTheme.body2.color;
    final Color unselectedColor = unselectedLabelColor
        ?? tabBarTheme.unselectedLabelColor
        ?? selectedColor.withAlpha(0xB2); // 70% alpha
    final Color color = selected
        ? Color.lerp(selectedColor, unselectedColor, animation.value)
        : Color.lerp(unselectedColor, selectedColor, animation.value);

    return DefaultTextStyle(
      style: textStyle.copyWith(color: color),
      child: IconTheme.merge(
        data: IconThemeData(
          size: 24.0,
          color: color,
        ),
        child: child,
      ),
    );
  }
}

typedef _LayoutCallback = void Function(List<double> xOffsets, TextDirection textDirection, double width);

class _TabLabelBarRenderer extends RenderFlex {
  _TabLabelBarRenderer({
    List<RenderBox> children,
    @required Axis direction,
    @required MainAxisSize mainAxisSize,
    @required MainAxisAlignment mainAxisAlignment,
    @required CrossAxisAlignment crossAxisAlignment,
    @required TextDirection textDirection,
    @required VerticalDirection verticalDirection,
    @required this.onPerformLayout,
  }) : assert(onPerformLayout != null),
        assert(textDirection != null),
        super(
        children: children,
        direction: direction,
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
      );

  _LayoutCallback onPerformLayout;

  @override
  void performLayout() {
    super.performLayout();
    // xOffsets will contain childCount+1 values, giving the offsets of the
    // leading edge of the first tab as the first value, of the leading edge of
    // the each subsequent tab as each subsequent value, and of the trailing
    // edge of the last tab as the last value.
    RenderBox child = firstChild;
    final List<double> xOffsets = <double>[];
    while (child != null) {
      final FlexParentData childParentData = child.parentData;
      xOffsets.add(childParentData.offset.dx);
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }
    assert(textDirection != null);
    switch (textDirection) {
      case TextDirection.rtl:
        xOffsets.insert(0, size.width);
        break;
      case TextDirection.ltr:
        xOffsets.add(size.width);
        break;
    }
    onPerformLayout(xOffsets, textDirection, size.width);
  }
}

// This class and its renderer class only exist to report the widths of the tabs
// upon layout. The tab widths are only used at paint time (see _IndicatorPainter)
// or in response to input.
class _TabLabelBar extends Flex {
  _TabLabelBar({
    Key key,
    List<Widget> children = const <Widget>[],
    this.onPerformLayout,
  }) : super(
    key: key,
    children: children,
    direction: Axis.horizontal,
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    verticalDirection: VerticalDirection.down,
  );

  final _LayoutCallback onPerformLayout;

  @override
  RenderFlex createRenderObject(BuildContext context) {
    return _TabLabelBarRenderer(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: getEffectiveTextDirection(context),
      verticalDirection: verticalDirection,
      onPerformLayout: onPerformLayout,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _TabLabelBarRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.onPerformLayout = onPerformLayout;
  }
}

double _indexChangeProgress(TabController controller) {
  final double controllerValue = controller.animation.value;
  final double previousIndex = controller.previousIndex.toDouble();
  final double currentIndex = controller.index.toDouble();

  // The controller's offset is changing because the user is dragging the
  // TabBarView's PageView to the left or right.
  if (!controller.indexIsChanging)
    return (currentIndex - controllerValue).abs().clamp(0.0, 1.0);

  // The TabController animation's value is changing from previousIndex to currentIndex.
  return (controllerValue - currentIndex).abs() / (currentIndex - previousIndex).abs();
}

class _ChangeAnimation extends Animation<double> with AnimationWithParentMixin<double> {
  _ChangeAnimation(this.controller);

  final TabController controller;

  @override
  Animation<double> get parent => controller.animation;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (parent != null)
      super.removeStatusListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    if (parent != null)
      super.removeListener(listener);
  }

  @override
  double get value => _indexChangeProgress(controller);
}

class _DragAnimation extends Animation<double> with AnimationWithParentMixin<double> {
  _DragAnimation(this.controller, this.index);

  final TabController controller;
  final int index;

  @override
  Animation<double> get parent => controller.animation;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (parent != null)
      super.removeStatusListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    if (parent != null)
      super.removeListener(listener);
  }

  @override
  double get value {
    assert(!controller.indexIsChanging);
    return (controller.animation.value - index.toDouble()).abs().clamp(0.0, 1.0);
  }
}

class _TabBarScrollPosition extends ScrollPositionWithSingleContext {
  _TabBarScrollPosition({
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition oldPosition,
    this.tabBar,
  }) : super(
    physics: physics,
    context: context,
    initialPixels: null,
    oldPosition: oldPosition,
  );

  final _BssTabBarState tabBar;

  bool _initialViewportDimensionWasZero;

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    bool result = true;
    if (_initialViewportDimensionWasZero != true) {
      // If the viewport never had a non-zero dimension, we just want to jump
      // to the initial scroll position to avoid strange scrolling effects in
      // release mode: In release mode, the viewport temporarily may have a
      // dimension of zero before the actual dimension is calculated. In that
      // scenario, setting the actual dimension would cause a strange scroll
      // effect without this guard because the super call below would starts a
      // ballistic scroll activity.
      assert(viewportDimension != null);
      _initialViewportDimensionWasZero = viewportDimension != 0.0;
      //correctPixels(tabBar._initialScrollOffset(viewportDimension, minScrollExtent, maxScrollExtent));
      result = false;
    }
    return super.applyContentDimensions(minScrollExtent, maxScrollExtent) && result;
  }
}

// This class, and TabBarScrollPosition, only exist to handle the case
// where a scrollable TabBar has a non-zero initialIndex.
class _TabBarScrollController extends ScrollController {
  _TabBarScrollController(this.tabBar);

  final _BssTabBarState tabBar;

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition oldPosition) {
    return _TabBarScrollPosition(
      physics: physics,
      context: context,
      oldPosition: oldPosition,
      tabBar: tabBar,
    );
  }
}


class BssTabBar extends StatefulWidget implements PreferredSizeWidget {

  const BssTabBar({
    Key key,
    @required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.labelColor,
    this.labelStyle,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.onTap,
  });

  final List<Widget> tabs;
  final TabController controller;
  final bool isScrollable;
  final Color labelColor;
  final Color unselectedLabelColor;
  final TextStyle labelStyle;
  final TextStyle unselectedLabelStyle;
  final DragStartBehavior dragStartBehavior;
  final  ValueChanged<int> onTap;

  @override
  Size get preferredSize {
    for (Widget item in tabs) {
      if (item is Tab) {
        final Tab tab = item;
        if (tab.text != null && tab.icon != null)
          return Size.fromHeight(_kTabHeight);
      }
    }
    return Size.fromHeight(_kTabHeight);
  }

  @override
  _BssTabBarState createState() => _BssTabBarState();

}

class _BssTabBarState extends State<BssTabBar> {
  ScrollController _scrollController;
  TabController _controller;
  int _currentIndex;
  double _tabStripWidth;
  List<GlobalKey> _tabKeys;

  @override
  void initState() {
    super.initState();
    // If indicatorSize is TabIndicatorSize.label, _tabKeys[i] is used to find
    // the width of tab widget i. See _IndicatorPainter.indicatorRect().
    _tabKeys = widget.tabs.map((Widget tab) => GlobalKey()).toList();
  }


  Widget _buildStyledTab(Widget child, bool selected, Animation<double> animation) {
    return _TabStyle(
      animation: animation,
      selected: selected,
      labelColor: widget.labelColor,
      unselectedLabelColor: widget.unselectedLabelColor,
      labelStyle: widget.labelStyle,
      unselectedLabelStyle: widget.unselectedLabelStyle,
      child: child,
    );
  }

  void _handleTap(int index) {
    assert(index >= 0 && index < widget.tabs.length);
    _controller.animateTo(index);
    if (widget.onTap != null) {
      widget.onTap(index);
    }
  }

  @override
  Widget build(BuildContext context) {

    assert(debugCheckHasMaterialLocalizations(context));
    assert(() {
      if (_controller.length != widget.tabs.length) {
        throw FlutterError(
            'Controller\'s length property (${_controller.length}) does not match the \n'
                'number of tabs (${widget.tabs.length}) present in TabBar\'s tabs property.'
        );
      }
      return true;
    }());
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);

    final List<Widget> wrappedTabs = List<Widget>(widget.tabs.length);
    for (int i = 0; i < widget.tabs.length; i += 1) {
      wrappedTabs[i] = Center(
        heightFactor: 1.0,
        child: KeyedSubtree(
          key: _tabKeys[i],
          child: widget.tabs[i],
        ),
      );

    }


    final int tabCount = widget.tabs.length;
    for (int index = 0; index < tabCount; index += 1) {
      wrappedTabs[index] = InkWell(
        onTap: () { _handleTap(index); },
        child: Stack(
          children: <Widget>[
            wrappedTabs[index],
            Semantics(
              selected: index == _currentIndex,
              label: localizations.tabLabel(tabIndex: index + 1, tabCount: tabCount),
            ),
          ],
        ),
      );
      if (!widget.isScrollable)
        wrappedTabs[index] = Expanded(child: wrappedTabs[index]);
    }

    return Container(


    );
  }

  /*double _tabScrollOffset(int index, double viewportWidth, double minExtent, double maxExtent) {
    if (!widget.isScrollable)
      return 0.0;
    double tabCenter = _indicatorPainter.centerOf(index);
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        tabCenter = _tabStripWidth - tabCenter;
        break;
      case TextDirection.ltr:
        break;
    }
    return (tabCenter - viewportWidth / 2.0).clamp(minExtent, maxExtent);
  }

  double _initialScrollOffset(double viewportWidth, double minExtent, double maxExtent) {
    return _tabScrollOffset(_currentIndex, viewportWidth, minExtent, maxExtent);
  }*/
}
