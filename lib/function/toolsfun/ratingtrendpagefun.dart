import 'package:fl_chart/fl_chart.dart';

Future<List> returnSpot({required List data}) async {
  List result = [];
  List<FlSpot> spots = [];
  double maxY = 0;
  double maxX = 0;
  double index = 0;
  for (var i in data) {
    ++index;
    spots.add(FlSpot(index.toDouble(), i['rating'].toDouble()));
    if (i['bests_rating'] > maxY) {
      maxY = i['bests_rating'] + 3;
    }
  }
  result.add(spots);
  result.add(maxY);
  maxX = data.length.toDouble() + 1;
  result.add(maxX);

  return result;
}
