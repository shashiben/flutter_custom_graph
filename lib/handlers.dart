import 'package:customgraph/model/graph.dart';
import 'package:customgraph/notification.dart';
import 'package:customgraph/utils/calculations.dart';
import 'package:flutter/material.dart';

class Handlers {
  void handleTap(Size appSize, TapUpDetails details, Graph graph,
      AnimationController controller) {
    final x = (details.localPosition.dx - 28) / appSize.width;
    final offset = lerp(graph.xAxisLabelStart, graph.noOfValuestoShow, x);
    if (offset.round() != graph.startingIndicator) {
      graph.startingIndicator = offset.round();
      controller.forward(from: 0.0);
    }
  }

  void handleStartInteraction(BuildContext context) {
    NotificationInteract(stop: false)..dispatch(context);
  }

  void handleEndInteraction(BuildContext context) {
    NotificationInteract(stop: true)..dispatch(context);
  }

  void handleStartZoom(
      ScaleStartDetails details, Graph graph, double initialRange) {
    initialRange = graph.noOfValuestoShow - graph.xAxisLabelStart;
  }

  void handleZoom(ScaleUpdateDetails details, double initialRange, Graph graph,
      AnimationController controller) {
    double d = 1.0 / details.scale;
    if (d == 0) return;
    final targetRange = initialRange * d;
    final range = graph.noOfValuestoShow - graph.xAxisLabelStart;
    final scale = targetRange - range;

    if (range + scale < 13.0) {
      if (graph.noOfValuestoShow != graph.maxDomain) {
        graph.noOfValuestoShow += scale;
      } else {
        graph.xAxisLabelStart -= scale;
      }
    }

    controller.reverse();
  }
}
