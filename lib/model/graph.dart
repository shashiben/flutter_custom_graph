import 'package:customgraph/utils/dataset.dart';
import 'package:flutter/material.dart';

class Graph extends ChangeNotifier {
  List<DataSet> _dataSets;
  double _xAxisLabelStart, _noOfValuestoShow, _maxDomain;
  double _rangeBegin, _rangeEnd;

  final String xAxisUnit;
  final String yAxisUnit;

  int _startingIndicator;

  Graph(List<DataSet> dataSets, this.xAxisUnit, this.yAxisUnit)
      : _dataSets = dataSets,
        _xAxisLabelStart = 0,
        _noOfValuestoShow = 0 {
    _maxDomain = double.maxFinite;
    for (var dataSet in _dataSets) {
      if (dataSet.values.length < _maxDomain)
        _maxDomain = dataSet.values.length.toDouble();
    }
    _noOfValuestoShow = _maxDomain;
    _startingIndicator = -1;

    _rangeBegin = min();
    _rangeEnd = max();
  }

  double min() {
    double result = double.maxFinite;
    for (var dataSet in _dataSets)
      for (var value in dataSet.values
          .sublist(_xAxisLabelStart.round(), _noOfValuestoShow.round()))
        if (value < result) result = value;
    return result;
  }

  double median(int setIndex) {
    assert(setIndex >= 0 && setIndex < _dataSets.length);

    final sortedValues = _dataSets[setIndex]
        .values
        .sublist(_xAxisLabelStart.round(), _noOfValuestoShow.round())
          ..sort();

    double result;
    if (sortedValues.length < 2) {
      result = sortedValues[0];
    } else {
      final int mid = sortedValues.length ~/ 2;
      result = sortedValues[mid];
      if (sortedValues.length & 1 == 0) {
        result += sortedValues[mid - 1];
        result /= 2;
      }
    }

    return result;
  }

  double max() {
    double result = 0;
    for (var dataSet in _dataSets)
      for (var value in dataSet.values
          .sublist(_xAxisLabelStart.round(), _noOfValuestoShow.round()))
        if (value > result) result = value;
    return result;
  }

  double mean(int setIndex) {
    final values = _dataSets[setIndex]
        .values
        .sublist(_xAxisLabelStart.round(), _noOfValuestoShow.round());
    return values.fold(0.0, (a, b) => a + b) / values.length;
  }

  set xAxisLabelStart(double xAxisLabelStart) {
    if (xAxisLabelStart == _xAxisLabelStart) return;

    _xAxisLabelStart = xAxisLabelStart.clamp(0, _noOfValuestoShow - 1.2);
    notifyListeners();
  }

  set noOfValuestoShow(double noOfValuestoShow) {
    if (noOfValuestoShow == _noOfValuestoShow) return;
    _noOfValuestoShow = noOfValuestoShow;

    notifyListeners();
  }

  set rangeBegin(double rangeBegin) {
    if (rangeBegin < _rangeEnd) {
      _rangeBegin = rangeBegin;
      notifyListeners();
    }
  }

  set rangeEnd(double rangeEnd) {
    if (rangeEnd > _rangeBegin) {
      _rangeEnd = rangeEnd;
      notifyListeners();
    }
  }

  set startingIndicator(int index) {
    if (index >= 0 && index < _maxDomain) {
      _startingIndicator = index;
      notifyListeners();
    }
  }

  double get xAxisLabelStart => _xAxisLabelStart;

  double get noOfValuestoShow => _noOfValuestoShow;

  double get maxDomain => _maxDomain;

  double get rangeBegin => _rangeBegin;

  double get rangeEnd => _rangeEnd;

  List<DataSet> get dataSets => _dataSets;

  int get startingIndicator => _startingIndicator;

  double selectedY(int dataSetIndex) {
    if (_startingIndicator == -1) return 0;
    final y =
        ((_dataSets[dataSetIndex].values[_startingIndicator] - rangeBegin) /
            rangeEnd);
    return y;
  }

  double selectedX() {
    if (_startingIndicator == -1) return 0;
    final range = _noOfValuestoShow - _xAxisLabelStart;
    final x = ((_startingIndicator.toDouble() - _xAxisLabelStart) / range);
    return x;
  }
}
