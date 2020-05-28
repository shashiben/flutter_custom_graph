class DataSet {
  DataSet(List<double> values) : _values = values;

  List<double> _values;
  List<double> get values => _values;

  List<double> valuesInDomain(double domainStart, double domainEnd) {
    final start = domainStart < 0 ? 0 : domainStart;
    final end = domainEnd > _values.length ? _values.length : domainEnd;
    if (end <= start) {
      return <double>[];
    }
    return _values.sublist(start.round(), end.round());
  }
}
