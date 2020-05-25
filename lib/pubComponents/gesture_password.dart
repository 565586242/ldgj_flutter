import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'circle_item_painter.dart';

class GesturePassword extends StatefulWidget {
  final ValueChanged<String> successCallback;
  final ValueChanged<String> selectedCallback;
  final VoidCallback failCallback;
  final ItemAttribute attribute;
  final double height;
  final double width;
  final double showLineTimer;

  GesturePassword(
      {@required this.successCallback,
        this.failCallback,
        this.selectedCallback,
        this.attribute: ItemAttribute.normalAttribute,
        this.height: 300.0,
        this.width,
        this.showLineTimer: 1.0
      });

  @override
  _GesturePasswordState createState() => new _GesturePasswordState();
}

class _GesturePasswordState extends State<GesturePassword> {
  Offset touchPoint = Offset.zero;
  List<Circle> circleList = new List<Circle>();
  List<Circle> lineList = new List<Circle>();
  Timer _timer;

  @override
  void initState() {
    num hor = (widget.width??MediaQueryData.fromWindow(ui.window).size.width) / 6;
    num ver = widget.height / 6;
    //每个圆的中心点
    for (int i = 0; i < 9; i++) {
      num tempX = (i % 3 + 1) * 2 * hor - hor;
      num tempY = (i ~/ 3 + 1) * 2 * ver - ver;
      circleList.add(new Circle(new Offset(tempX, tempY), i.toString()));
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = new Size(
        widget.width??MediaQueryData.fromWindow(ui.window).size.width, widget.height);
    return new GestureDetector(
      onPanDown: (DragDownDetails details) {
        paintCircle(details);
      },
      onPanUpdate: (DragUpdateDetails details) {
        paintCircle(details);
      },
      onPanEnd: (DragEndDetails details) {
        setState(() {
          if (circleList
              .where((Circle itemCircle) => itemCircle.isSelected())
              .length >=
              4) {
            widget.successCallback(getPassword());
          } else {
            if (widget.failCallback != null) {
              widget.failCallback();
            }
          }
          //剩余多少秒后清除画线
          double hasTime = widget.showLineTimer;
          final call = (timer) {
            setState(() {
              if (hasTime < 1) {
                _timer.cancel();
                touchPoint = Offset.zero;
                lineList.clear();
                for (int i = 0; i < circleList.length; i++) {
                  Circle circle = circleList[i];
                  circle.setState(Circle.circleNormal);
                }
              } else {
                hasTime -= 1;
              }
            });
          };
          _timer = Timer.periodic(Duration(seconds: 1), call);
        });
      },
      child: new CustomPaint(
          size: size,
          painter: new CircleItemPainter(
            widget.attribute,
            touchPoint,
            circleList,
            lineList,
          )),
    );
  }

  ///判断是否在圈里
  Circle getOuterCircle(Offset offset) {
    for (int i = 0; i < 9; i++) {
      var cross = offset - circleList[i].offset;
      if (cross.dx.abs() < widget.attribute.focusDistance &&
          cross.dy.abs() < widget.attribute.focusDistance) {
        return circleList[i];
      }
    }
    return null;
  }

  //绘画
  paintCircle(details) {
    setState(() {
      RenderBox box = context.findRenderObject();
      touchPoint = box.globalToLocal(details.globalPosition);
      //防止绘画越界
      if (touchPoint.dy < 0) {
        touchPoint = new Offset(touchPoint.dx, 0.0);
      }
      if (touchPoint.dy > widget.height) {
        touchPoint = new Offset(touchPoint.dx, widget.height);
      }
      Circle circle = getOuterCircle(touchPoint);
      if (circle != null) {
        if (circle.isUnSelected()) {
          lineList.add(circle);
          circle.setState(Circle.circleSelected);
          if (widget.selectedCallback != null) {
            widget.selectedCallback(getPassword());
          }
        }
      }
    });
  }

  String getPassword() {
    return lineList
        .map((selectedItem) => selectedItem.index.toString())
        .toList()
        .fold("", (s, str) {
      return s + str;
    });
  }
}

class Circle {
  static final circleSelected = 1;
  static final circleNormal = 0;
  Offset offset;
  String index;
  int state = circleNormal;

  Circle(this.offset, this.index);

  int getState() {
    return state;
  }

  setState(int state) {
    this.state = state;
  }

  bool isSelected() {
    return state == circleSelected;
  }

  bool isUnSelected() {
    return state == circleNormal;
  }
}

class ItemAttribute {
  final Color selectedColor;
  final Color normalColor;
  final double lineStrokeWidth;
  final double circleStrokeWidth;
  final double smallCircleR;
  final double bigCircleR;
  final double focusDistance;
  static const ItemAttribute normalAttribute = const ItemAttribute(
      normalColor: const Color(0xFFBBDEFB),
      selectedColor: const Color(0xFF1565C0));

  const ItemAttribute({
    this.normalColor,
    this.selectedColor,
    this.lineStrokeWidth: 2.0,
    this.circleStrokeWidth: 2.0,
    this.smallCircleR: 10.0,
    this.bigCircleR: 30.0,
    this.focusDistance: 25.0,
  });
}
