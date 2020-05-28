import 'package:flutter/material.dart';

class ColumnText extends StatelessWidget {
  final Size appSize;
  final List<String> yAxisLabels;
  final TextStyle textRowStyle;
  final double leftPosition;

  const ColumnText(
      {Key key,
      @required this.appSize,
      @required this.yAxisLabels,
      @required this.textRowStyle,
      @required this.leftPosition})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: leftPosition,
      height: (150) * (appSize.height / 480),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: yAxisLabels
            .map((label) => Text(label, style: textRowStyle))
            .toList(),
      ),
    );
  }
}
