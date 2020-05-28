import 'package:customgraph/model/graph.dart';
import 'package:customgraph/utils/calculations.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ForegroundPainter extends CustomPainter {
  Graph _graph;
  Animation<double> _selectedFade;
  List<Color> _backgroundColors;
  List<Color> _foregroundColors;
  ForegroundPainter(Graph graph, Animation<double> selectedFade,
      List<Color> backgroundColors, List<Color> foregroundColors)
      : _graph = graph,
        _selectedFade = selectedFade,
        _backgroundColors = backgroundColors,
        _foregroundColors = foregroundColors,
        super(repaint: Listenable.merge([graph, selectedFade]));
  double dataY(List<double> values, int index) {
    final y = ((values[index] - _graph.rangeBegin) / _graph.rangeEnd) * 10;
    return y;
  }

  void paintChartData(
      Graph graph,
      int dataSetIndex,
      List<Color> backgroundColors,
      List<Color> foregroundColors,
      ui.Canvas canvas,
      Size size) {
    final range = graph.noOfValuestoShow - graph.xAxisLabelStart;

    final dataOffset = (int index) {
      final x =
          ((index.toDouble() - graph.xAxisLabelStart) / range) * size.width + 28;
      final y = dataY(graph.dataSets[dataSetIndex].values, index) * size.height;
      return Offset(x, y);
    };

    final path = Path();
    final start = graph.xAxisLabelStart;
    final end = graph.noOfValuestoShow;

    Offset offset0;
    if (start.floor() > 0) {
      offset0 = dataOffset(start.floor() - 1);
      path.moveTo(offset0.dx, offset0.dy);
    } else {
      offset0 = dataOffset(0);
      path.moveTo(0, offset0.dy);
    }

    for (int i = start.floor(); i < end.ceil(); ++i) {
      var offset1 = dataOffset(i);
      path.cubicTo(
          lerp(offset0.dx, offset1.dx, 0.5),
          offset0.dy,
          lerp(offset0.dx, offset1.dx, 0.5),
          offset1.dy,
          offset1.dx,
          offset1.dy);
      offset0 = offset1;
    }

    if (end.ceil() < graph.maxDomain.floor()) {
      var offset1 = dataOffset(end.ceil());
      path.cubicTo(
          lerp(offset0.dx, offset1.dx, 0.5),
          offset0.dy,
          lerp(offset0.dx, offset1.dx, 0.5),
          offset1.dy,
          offset1.dx,
          offset1.dy);
      offset0 = offset1;
    } else {
      var offset1 = dataOffset(end.ceil() - 1);
      path.lineTo(size.width, offset1.dy);
      offset0 = offset1;
    }

    canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..shader = ui.Gradient.linear(
            Offset(0, 0),
            Offset(size.width, 0),
            foregroundColors,
          ));

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    offset0 = dataOffset(0);
    path.lineTo(0, offset0.dy);

    canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.fill
          ..shader = ui.Gradient.linear(
            Offset(0, size.height),
            Offset(0, 0),
            backgroundColors,
            [
              0.5,
              1.0,
            ],
          ));
  }

  @override
  void paint(canvas, size) {
    canvas.translate(0.0, size.height);
    canvas.scale(1.0, -1.0);

    for (int i = 0; i < _graph.dataSets.length; ++i) {
      paintChartData(_graph, i, _backgroundColors.sublist(i * 2, i * 2 + 2),
          _foregroundColors.sublist(i * 2, i * 2 + 2), canvas, size);
    }

    if (_graph.startingIndicator != -1) {
      double maxY = 0;
      for (var dataSet in _graph.dataSets) {
        final y = dataY(dataSet.values, _graph.startingIndicator);
        if (y > maxY) maxY = y;
      }
      final range = _graph.noOfValuestoShow - _graph.xAxisLabelStart;
      final x =
          ((_graph.startingIndicator.toDouble() - _graph.xAxisLabelStart) / range) *
                  size.width +
              28;
      canvas.drawLine(Offset(x, 0), Offset(x, maxY * size.height),
          Paint()..color = Colors.white.withOpacity(_selectedFade.value));

      for (var dataSet in _graph.dataSets) {
        final y = dataY(dataSet.values, _graph.startingIndicator);

        final offset = Offset(x, y * size.height);

        canvas.drawCircle(
            offset,
            12.0,
            Paint()
              ..blendMode = BlendMode.plus
              ..shader = ui.Gradient.radial(
                offset,
                12.0,
                [
                  Colors.white.withOpacity(_selectedFade.value),
                  Colors.transparent
                ],
              ));
        canvas.drawCircle(offset, 4.8,
            Paint()..color = Colors.white.withOpacity(_selectedFade.value));
      }
    }
  }

  @override
  bool shouldRepaint(ForegroundPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(ForegroundPainter oldDelegate) => false;
}
