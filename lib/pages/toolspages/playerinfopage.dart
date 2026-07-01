import 'package:chusearchsong_flutter/tools/playerinfopagefun.dart';
import 'package:flutter/material.dart';
import '../../tools/fun.dart';

class PlayerInfoPage extends StatefulWidget {
  const PlayerInfoPage({super.key, required this.playerdata});
  final Map<String, dynamic> playerdata;

  @override
  State<StatefulWidget> createState() => _PlayerInfoPageState();
}

class _PlayerInfoPageState extends State<PlayerInfoPage> {
  final ScrollController _controller = ScrollController();
  final ScrollController _rowcontroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.playerdata['name']} - 玩家信息')),
      body: Scrollbar(
        controller: _controller,
        child: SingleChildScrollView(
          controller: _controller,
          child: Center(
            child: Column(
              children: [
                Scrollbar(
                  controller: _rowcontroller,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _rowcontroller,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://assets2.lxns.net/chunithm/character/${widget.playerdata['character']['id']}.png',
                          errorBuilder: (context, error, stackTrace) =>
                              Text('错误 $error'),
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                color: returnTrophyBackgroundColor(
                                  widget.playerdata['trophy']['color'],
                                ),
                              ),
                              padding: EdgeInsets.all(6),
                              child: Text(
                                widget.playerdata['trophy']['name'],

                                style: TextStyle(
                                  color: returnTrophyColor(
                                    widget.playerdata['trophy']['color'],
                                  ),
                                  shadows: [
                                    Shadow(
                                      color: returnTrophyColor(
                                        widget.playerdata['trophy']['color'],
                                      ),
                                      blurRadius: 3.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Text(
                              '${widget.playerdata['name']}',
                              style: TextStyle(fontSize: 20),
                            ),
                            Row(
                              children: [
                                Text(
                                  '等级: ${widget.playerdata['level']}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Image.network(
                                  'https://maimai.lxns.net/assets/chunithm/class_emblem/medal/${widget.playerdata['class_emblem']['medal']}.webp',
                                  errorBuilder: (context, error, stackTrace) =>
                                      Text('错误 $error'),
                                  width: 50,
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: returnRatingBackgroundColor(
                                  widget.playerdata['rating'],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Rating: ${widget.playerdata['rating']}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: returnRatingColor(
                                    widget.playerdata['rating'],
                                  ),
                                  shadows: [
                                    Shadow(
                                      color: returnRatingColor(
                                        widget.playerdata['rating'],
                                      ),
                                      blurRadius: 3.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                InkWell(
                  onLongPress: () => copytext(
                    text: widget.playerdata['friend_code'].toString(),
                    context: context,
                  ),
                  child: Text('好友码：${widget.playerdata['friend_code']}'),
                ),
                Text('总游玩次数: ${widget.playerdata['total_play_count']}'),
                Text('总金币数: ${widget.playerdata['total_currency']}'),
                Text('当前金币数: ${widget.playerdata['currency']}'),
                Text('总 OVER POWER: ${widget.playerdata['over_power']}'),
                Text(
                  'OVER POWER 总进度: ${widget.playerdata['over_power_progress']}',
                ),
                Text('玩家等级突破次数: ${widget.playerdata['reborn_count']}'),
                Text(
                  '最后更新时间: ${DateTime.parse(widget.playerdata['upload_time']).toLocal()}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
