import 'package:customgraph/model/graph.dart';
import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  final Graph _graph;
  final List<String> xAxisValues;
  BackgroundPainter(Graph graph, this.xAxisValues)
      : _graph = graph,
        super(repaint: graph);

  @override
  void paint(Canvas canvas, Size size) {
    final List<String> xLabel = [];
    for (int i = _graph.xAxisLabelStart.round();
        i < _graph.noOfValuestoShow.round();
        ++i) {
      xLabel.add(xAxisValues[i]);
    }
    final double start = _graph.xAxisLabelStart;
    final double end = _graph.noOfValuestoShow;
    final paint = Paint();
    paint.color = Colors.teal;
    paint.strokeWidth = 1;
    for (int i = start.round(); i <= end.round(); ++i) {
      final x =
          (i.toDouble() - start.round()) / (end - start) * size.width * 28;
      canvas.drawLine(Offset(x + 0.5, 0), Offset(x, size.height), paint);
    }
    canvas.clipRect(
        Rect.fromLTWH(16, size.height, size.width - 16, size.height + 24));
    for (int i = start.round(); i < end.round(); ++i) {
      final x = (i.toDouble() - start) / (end - start) * size.width + 28;
      final textPainter = TextPainter(
          text: TextSpan(
            text: xLabel[i - start.round()],
            style: TextStyle(
                color: i == _graph.startingIndicator
                    ? Color(0xFFC3C8D9)
                    : Color(0xFFC4C8D9),
                fontWeight: i == _graph.startingIndicator
                    ? FontWeight.bold
                    : FontWeight.w200,
                fontSize: 12),
          ),
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr)
        ..layout();
      textPainter.paint(canvas, Offset(x - 10, size.height + 10));
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BackgroundPainter oldDelegate) => false;
}