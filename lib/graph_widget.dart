import 'package:customgraph/handlers.dart';
import 'package:customgraph/model/graph.dart';
import 'package:customgraph/painters/background_painter.dart';
import 'package:customgraph/painters/foreground_painter.dart';
import 'package:customgraph/utils/calculations.dart';
import 'package:customgraph/utils/get_graph.dart';
import 'package:customgraph/widgets/column_text.dart';
import 'package:customgraph/widgets/label_widget.dart';
import 'package:flutter/material.dart';

class GraphWidget extends StatefulWidget {
  final List<double> percentages;
  final List<String> xAxisValues;
  final List<String> yAxisValues;

  final double rangeBegin;
  final double rangeEnd;

  final double xAxisLabelStart;
  final double noOfValuestoShow;

  final List<Color> foregroundColors;
  final List<Color> backgroundColors;

  final Duration duration;

  final TextStyle textRowStyle;
  final TextStyle indicatorTextStyle;

  final Color indicatorTextColor;

  final int indicatorTextMultiplier;
  final int startingIndicator;

  const GraphWidget(
      {Key key,
      @required this.percentages,
      @required this.xAxisValues,
      @required this.yAxisValues,
      @required this.rangeBegin,
      @required this.rangeEnd,
      @required this.xAxisLabelStart,
      @required this.noOfValuestoShow,
      this.startingIndicator = 0,
      this.duration = const Duration(milliseconds: 2500),
      this.textRowStyle = const TextStyle(
        color: Color(0xFFC4C8D9),
        fontSize: 12,
        fontWeight: FontWeight.w200,
      ),
      this.indicatorTextColor = const Color(0xFFDCE2F5),
      this.indicatorTextStyle = const TextStyle(
        color: Color(0xFFDCE2F5),
        fontSize: 10,
      ),
      this.indicatorTextMultiplier = 100,
      this.foregroundColors = const [
        Color(0xFF4A78ED),
        Color(0xFF5DB391),
        Color(0xFFA74CBA),
        Color(0xFFF287A6)
      ],
      this.backgroundColors = const [
        Color(0x4C4AC3E5),
        Color(0x005290C7),
        Color(0x4CDEACD0),
        Color(0x00DEACD0)
      ]})
      : super(key: key);

  @override
  _GraphWidgetState createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _initialRange;
  Graph graph;
  @override
  void initState() {
    graph = getGraph(
        widget.percentages,
        widget.rangeBegin,
        widget.rangeEnd,
        widget.xAxisLabelStart,
        widget.noOfValuestoShow,
        widget.startingIndicator);
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Handlers handlers = Handlers();

  @override
  Widget build(BuildContext context) {
    final List<String> yAxisLabels = widget.yAxisValues;
    String labelText;
    if (graph.startingIndicator != -1) {
      labelText = nTos((graph.dataSets[0].values[graph.startingIndicator] *
          widget.indicatorTextMultiplier));
    }

    final appSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTapUp: (details) =>
          handlers.handleTap(appSize, details, graph, _controller),
      onHorizontalDragStart: (_) => handlers.handleStartInteraction(context),
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: (_) => handlers.handleEndInteraction(context),
      onScaleStart: (details) {
        handlers.handleStartInteraction(context);
        handlers.handleStartZoom(details, graph, _initialRange);
      },
      onScaleUpdate: (_) => handlers.handleZoom(
          ScaleUpdateDetails(), _initialRange, graph, _controller),
      onScaleEnd: (_) => handlers.handleEndInteraction(context),
      child: Container(
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height / 48) * 15,
              child: CustomPaint(
                foregroundPainter: ForegroundPainter(graph, _controller,
                    widget.backgroundColors, widget.foregroundColors),
                painter: BackgroundPainter(graph, widget.xAxisValues),
              ),
            ),
            ColumnText(
                appSize: appSize,
                yAxisLabels: yAxisLabels,
                textRowStyle: widget.textRowStyle,
                leftPosition: 5.0),
            ColumnText(
                appSize: appSize,
                yAxisLabels: yAxisLabels,
                textRowStyle: widget.textRowStyle,
                leftPosition: appSize.width - 25.0),
            if (graph.startingIndicator != -1) ...{
              LabelWidget(
                appSize: appSize,
                graph: graph,
                controller: _controller,
                indicatorTextColor: widget.indicatorTextColor,
                text: labelText,
                style: widget.indicatorTextStyle,
              ),
            },
          ],
        ),
      ),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final d =
        -details.primaryDelta / 150 * (graph.noOfValuestoShow - graph.xAxisLabelStart);
    if (graph.xAxisLabelStart + d < 0 || graph.noOfValuestoShow + d >= graph.maxDomain)
      return;
    if (d < 0) {
      graph.xAxisLabelStart += d;
      graph.noOfValuestoShow += d;
    } else {
      graph.noOfValuestoShow += d;
      graph.xAxisLabelStart += d;
    }
    _controller.reverse();
  }
}
