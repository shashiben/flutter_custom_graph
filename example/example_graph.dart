import 'package:customgraph/graph_widget.dart';
import 'package:flutter/material.dart';

class TestExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GraphWidget(
          percentages: [2.0, 3.0, 4.0, 7.0, 8.0],
          xAxisValues: ["A", "B", "C", "D", "E"],
          yAxisValues: ["2", "4", "6", "8", "10"],
          rangeBegin: 0,
          rangeEnd: 8,
          xAxisLabelStart: 0,
          noOfValuestoShow: 4),
    );
  }
}
