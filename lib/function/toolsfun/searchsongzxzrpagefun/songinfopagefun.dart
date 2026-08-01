import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:chusearchsong_flutter/pages/songinfopages/chartviewpage.dart';
import 'package:chusearchsong_flutter/pages/toolspages/faulttoterantcomputationpage.dart';
import 'package:flutter/material.dart';

Widget returanAlias({required List alias, required BuildContext context}) {
  List<Widget> result = [];
  for (var i in alias) {
    result.add(
      InkWell(
        onLongPress: () => copytext(text: i, context: context),
        child: Text('$i'),
      ),
    );
    // result.add(const Divider());
  }
  if (result.isEmpty) {
    result.add(Text('无'));
  }
  result.insert(0, Row(children: [Icon(Icons.label), Text('别名')]));
  return Card(
    color: Theme.of(context).colorScheme.secondaryContainer,
    child: Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: Column(children: result),
    ),
  );
}

List<Widget> returnDiffTabBar({required List charts}) {
  List<Widget> result = [];
  for (var i in charts) {
    result.add(Text(i['difficulty']));
  }
  return result;
}

int returnDiffIndex({required String diff}) {
  switch (diff) {
    case 'BAS':
      return 0;
    case 'ADV':
      return 1;
    case 'EXP':
      return 2;
    case 'MAS':
      return 3;
    case 'ULT':
      return 4;
    case 'WE':
      return 5;
    default:
      return 0;
  }
}

List<Widget> returnDiffTabBarView({
  required int songid,
  required List charts,
  required Color color,
  required BuildContext context,
}) {
  List<Widget> result = [];
  //添加谱面信息
  for (var i = 0; i < charts.length; i++) {
    var song2 = charts[i];
    List<Widget> result2 = [];
    result2.add(
      InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChartViewPage(
              songid: songid,
              diffindex: returnDiffIndex(diff: song2['difficulty']),
            ),
          ),
        ),
        onLongPress: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FaulttoterantcomputationPage(
              totaltap: song2['notecounts']['total'],
            ),
          ),
        ),
        child: Card(
          color: color,
          child: Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Column(
              children: [
                Row(children: [Icon(Icons.queue_music), Text('谱面信息')]),
                InkWell(
                  onLongPress: () =>
                      copytext(text: song2['note_designer'], context: context),
                  child: Text(
                    '谱师:       ${song2['charter']}',
                    textAlign: TextAlign.start,
                  ),
                ),
                const Divider(),
                Text(
                  '定数:      ${song2['const']}',
                  style: TextStyle(fontSize: 15),
                ),
                const Divider(),
                Text(
                  'Total:      ${song2['notecounts']['total']}',
                  style: TextStyle(fontSize: 15),
                ),
                const Divider(),
                Text(
                  'Tap:      ${song2['notecounts']['tap']}',
                  style: TextStyle(fontSize: 15),
                ),
                const Divider(),
                Text(
                  'Hold:      ${song2['notecounts']['hold']}',
                  style: TextStyle(fontSize: 15),
                ),
                const Divider(),
                Text(
                  'Slide:      ${song2['notecounts']['slide']}',
                  style: TextStyle(fontSize: 15),
                ),
                const Divider(),
                Text(
                  'Air:       ${song2['notecounts']['air']}',
                  style: TextStyle(fontSize: 15),
                ),
                const Divider(),
                Text(
                  'Flick:       ${song2['notecounts']['flick']}',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    result.add(Column(children: result2));
  }

  return result;
}

Widget returnChartInfoAndSocre({
  required int songid,
  required List charts,
  required Color color,
  required BuildContext context,
}) {
  if (!context.mounted) {
    return const Text('加载失败');
  }
  Widget result = DefaultTabController(
    length: charts.length,

    child: Column(
      children: [
        TabBar(tabs: returnDiffTabBar(charts: charts)),
        SizedBox(
          height: 700, //MediaQuery.of(context).size.height * 0.8,
          child: TabBarView(
            children: returnDiffTabBarView(
              songid: songid,
              charts: charts,
              color: color,
              context: context,
            ),
          ),
        ),
      ],
    ),
  );
  return result;
}
