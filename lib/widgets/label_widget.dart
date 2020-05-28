import 'package:customgraph/model/graph.dart';
import 'package:flutter/material.dart';

class LabelWidget extends StatelessWidget {
  final Size appSize;
  final Graph graph;
  final AnimationController controller;
  final Color indicatorTextColor;
  final String text;
  final TextStyle style;

  const LabelWidget(
      {Key key, this.appSize,this.graph, this.controller, this.indicatorTextColor,this.text,this.style})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: appSize.width * graph.selectedX() + 8,
      top: 10,
      width: 40,
      child: Container(
        color: Color(0x99252B40)
            .withOpacity(controller.value < 0.6 ? controller.value : 0.6),
        padding: EdgeInsets.all(4),
        child: Text(text,
            textAlign: TextAlign.center,
            style: style.copyWith(
                color:
                    indicatorTextColor.withOpacity(controller.value))),
      ),
    );
  }
}
