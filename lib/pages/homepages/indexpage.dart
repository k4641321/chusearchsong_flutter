import 'package:chusearchsong_flutter/function/toolsfun/playerinfopagefun.dart';
import 'package:chusearchsong_flutter/function/writeandreadfun.dart';
import 'package:flutter/material.dart';

class Indexpage extends StatefulWidget {
  const Indexpage({super.key});

  @override
  State<Indexpage> createState() => _IndexpageState();
}

class _IndexpageState extends State<Indexpage> {
  Map<String, dynamic> playerInfoData = {};

  Future<void> init() async {
    playerInfoData = await (await ReadData.create()).readPlayerInfoData();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('主页'), backgroundColor: Colors.transparent),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Card(
              child: Padding(
                padding: EdgeInsetsGeometry.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PLAYER OVERVIEW', textAlign: TextAlign.left),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (playerInfoData['character'] != null)
                          Image.network(
                            width: 100,
                            height: 100,

                            'https://assets2.lxns.net/chunithm/character/${playerInfoData['character']['id']}.png',
                            errorBuilder: (context, error, stackTrace) =>
                                Text('错误 $error'),
                          ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${playerInfoData.isNotEmpty ? playerInfoData['name'] : null}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                // SizedBox(width: 10),
                                // Text('PLAYER NAME'),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                color: playerInfoData.isNotEmpty
                                    ? returnTrophyBackgroundColor(
                                        playerInfoData['trophy']?['color'],
                                      )
                                    : null,
                              ),
                              padding: EdgeInsets.all(6),
                              child: Text(
                                playerInfoData.isNotEmpty
                                    ? (playerInfoData['trophy']?['name'] ??
                                          'null')
                                    : 'null',

                                style: TextStyle(
                                  color: returnTrophyColor(
                                    playerInfoData.isNotEmpty
                                        ? (playerInfoData['trophy']?['color'])
                                        : null,
                                  ),
                                  shadows: [
                                    Shadow(
                                      color: returnTrophyColor(
                                        playerInfoData.isNotEmpty
                                            ? (playerInfoData['trophy']?['color'])
                                            : null,
                                      ),
                                      blurRadius: 3.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${playerInfoData.isNotEmpty ? playerInfoData['rating'] : null}',
                                  style: TextStyle(fontSize: 30),
                                ),
                                SizedBox(width: 10),
                                Text('TOTAL RATING'),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'LV. ${playerInfoData.isNotEmpty ? playerInfoData['level'] : null}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Row(
                    //   children: [
                    //     Text.rich(
                    //       TextSpan(
                    //         text: 'Best35',
                    //         children: [TextSpan(text: '154')],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
          Text(
            '热门歌曲',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              // Expanded(child: ,)s
            ],
          ),
        ],
      ),
    );
  }
}
