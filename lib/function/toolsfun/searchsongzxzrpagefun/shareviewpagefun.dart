import 'package:flutter/material.dart';

Widget returnSongShareView({required Map<String, dynamic> songdata}) {
  List<Widget> result = [];

  // String returndiffenglish({required int diffindex}) {
  //   switch (diffindex) {
  //     case 0:
  //       return 'BASIC';
  //     case 1:
  //       return 'ADVANCED';
  //     case 2:
  //       return 'EXPERT';
  //     case 3:
  //       return 'MASTER';
  //     case 4:
  //       return 'ULTIMATE';
  //     case 5:
  //       return 'WORLD\'S END';
  //     default:
  //       return 'ERROR';
  //   }
  // }

  Color returndiffbgcolor({required String diffindex}) {
    switch (diffindex) {
      case 'BAS':
        return Colors.lightGreen;
      case 'ADV':
        return Colors.yellow;
      case 'EXP':
        return Colors.red;
      case 'MAS':
        return Colors.purple;
      case 'ULT':
        return Colors.black;
      case 'WE':
        return Colors.pink;
      default:
        return Colors.white;
    }
  }

  String cutNoteDesigner({required String designer}) {
    if (designer.length > 7) {
      return '${designer.substring(0, 7)}...';
    } else {
      return designer;
    }
  }

  String cutartist({required String artist}) {
    if (artist.length > 25) {
      return '${artist.substring(0, 25)}...';
    } else {
      return artist;
    }
  }

  //曲名
  result.add(
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: const Color.fromARGB(205, 254, 254, 254),
          child: Padding(
            padding: EdgeInsetsGeometry.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 10,
            ),
            child: Text(
              songdata['title'],
              style: TextStyle(color: Colors.black, fontSize: 60),
              maxLines: 1,
              textWidthBasis: TextWidthBasis.longestLine,
            ),
          ),
        ),
      ],
    ),
  );

  List<Widget> result2 = [];
  //曲绘加载
  result2.add(
    Padding(
      padding: EdgeInsetsGeometry.all(60),
      child: Image.network(
        songdata['jacket_url'],
        height: 700,
        width: 700,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) {
          return Text(
            '错误 $error\n$stackTrace',
            style: TextStyle(color: Colors.black),
          );
        },
      ),
    ),
  );

  List<Widget> result3 = [];
  //曲目信息
  result3.add(
    Text(
      '曲师：${cutartist(artist: songdata['artist'])}',
      style: TextStyle(color: Colors.black, fontSize: 45),
      maxLines: 1,
    ),
  );
  result3.add(
    Text(
      '分类：${songdata['genre']}',
      style: TextStyle(color: Colors.black, fontSize: 45),
    ),
  );
  result3.add(
    Text(
      'BPM：${songdata['bpm']}',
      style: TextStyle(color: Colors.black, fontSize: 45),
    ),
  );
  result3.add(
    Text(
      '版本：${songdata['version']}',
      style: TextStyle(color: Colors.black, fontSize: 45),
    ),
  );
  result3.add(
    Text(
      '上线情况：国际服：${songdata['availability']['intl']} 日服：${songdata['availability']['jp']}',
      style: TextStyle(color: Colors.black, fontSize: 45),
    ),
  );
  result3.add(
    Text(
      '上线日期：${songdata['release_date']}',
      style: TextStyle(color: Colors.black, fontSize: 45),
    ),
  );

  //谱面信息构建
  List<DataColumn> dataColumn = [
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text('难度', style: TextStyle(color: Colors.black, fontSize: 30)),
      ),
    ),
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text('定数', style: TextStyle(color: Colors.black, fontSize: 30)),
      ),
    ),
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text('谱师', style: TextStyle(color: Colors.black, fontSize: 30)),
      ),
    ),
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text(
          'Total',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
    ),
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text('Tap', style: TextStyle(color: Colors.black, fontSize: 30)),
      ),
    ),
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text(
          'Hold',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
    ),
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text(
          'Slide',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
    ),
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text('Air', style: TextStyle(color: Colors.black, fontSize: 30)),
      ),
    ),
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text(
          'Flick',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
    ),
  ];

  List<DataRow> dataRow = [];
  for (var i in songdata['charts']) {
    dataRow.add(
      DataRow(
        cells: [
          DataCell(
            SizedBox(
              width: double.infinity,
              child: Container(
                color: returndiffbgcolor(diffindex: i['difficulty']),
                alignment: Alignment.center,
                padding: EdgeInsetsGeometry.only(
                  top: 8,
                  bottom: 8,
                  left: 15,
                  right: 15,
                ),
                child: Text(
                  i['difficulty'],
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['const'].toString(),
                textAlign: TextAlign.end,
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                cutNoteDesigner(designer: i['charter']),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['notecounts']['total'].toString(),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['notecounts']['tap'].toString(),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['notecounts']['hold'].toString(),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['notecounts']['slide'].toString(),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['notecounts']['air'].toString(),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['notecounts']['flick'].toString(),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
  DataTable difftable = DataTable(
    decoration: BoxDecoration(color: Colors.white),
    border: TableBorder.all(color: Colors.black),
    horizontalMargin: 0,
    columnSpacing: 0,
    dataRowMinHeight: 0,
    dataRowMaxHeight: 80,
    columns: dataColumn,
    rows: dataRow,
  );
  // result3.add(const SizedBox(height: 100));
  result3.add(difftable);

  result2.add(
    Column(mainAxisAlignment: MainAxisAlignment.start, children: result3),
  );
  result.add(
    Row(mainAxisAlignment: MainAxisAlignment.start, children: result2),
  );

  result.add(
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            '   #${songdata['id']}     此歌曲信息成绩由chusearchsong生成，生成时间 ${DateTime.now().toString()}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    ),
  );
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    // crossAxisAlignment: CrossAxisAlignment.center,
    children: result,
  );
}
