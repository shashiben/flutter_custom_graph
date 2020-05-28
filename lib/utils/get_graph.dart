import 'package:customgraph/model/graph.dart';
import 'package:customgraph/utils/dataset.dart';

getGraph(List<double> percentages, double rangeBegin, double rangeEnd,
    double xAxisLabelStart, double noOfValuestoShow, int startingIndicator) {
  DataSet dataSet = DataSet(percentages);
  Graph graph = Graph([dataSet], "", "%");
  graph.xAxisLabelStart = xAxisLabelStart;
  graph.noOfValuestoShow = noOfValuestoShow;
  graph.rangeBegin = rangeBegin;
  graph.rangeEnd = rangeEnd;
  graph.startingIndicator = startingIndicator;
  return graph;
}
