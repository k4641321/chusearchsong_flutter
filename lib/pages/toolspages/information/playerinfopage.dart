import 'package:chusearchsong_flutter/function/toolsfun/playerinfopagefun.dart';
import 'package:flutter/material.dart';
import '../../../function/fun.dart';

class PlayerInfoPage extends StatefulWidget {
  const PlayerInfoPage({super.key, required this.playerdata});
  final Map<String, dynamic> playerdata;

  @override
  State<StatefulWidget> createState() => _PlayerInfoPageState();
}

class _PlayerInfoPageState extends State<PlayerInfoPage> {
  final ScrollController _controller = ScrollController();
  final ScrollController _rowcontroller = ScrollController();
  Widget characterimage = SizedBox.shrink();

  @override
  void initState() {
    super.initState();
    if (widget.playerdata['character'] != null) {
      setState(() {
        characterimage = Image.network(
          'https://assets2.lxns.net/chunithm/character/${widget.playerdata['character']['id']}.png',
          errorBuilder: (context, error, stackTrace) => Text('错误 $error'),
        );
      });
    }
  }

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
                        characterimage,
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
                                      SizedBox.shrink(),
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
                Padding(
                  padding: EdgeInsetsGeometry.all(8),
                  child: Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(height: 10),
                          InkWell(
                            onLongPress: () => copytext(
                              text: widget.playerdata['friend_code'].toString(),
                              context: context,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.people,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                const SizedBox(
                                  width: 100,
                                  child: Text(
                                    '好友码：',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                const SizedBox(width: 50),
                                Expanded(
                                  child: Text(
                                    '${widget.playerdata['friend_code']}',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Icon(
                                Icons.play_circle,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  '总游玩次数：',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              const SizedBox(width: 50),
                              Expanded(
                                child: Text(
                                  '${widget.playerdata['total_play_count']}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Icon(
                                Icons.savings,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  '总金币数：',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              const SizedBox(width: 50),
                              Expanded(
                                child: Text(
                                  '${widget.playerdata['total_currency']}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Icon(
                                Icons.paid,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  '当前金币数：',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              const SizedBox(width: 50),
                              Expanded(
                                child: Text(
                                  '${widget.playerdata['currency']}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Icon(
                                Icons.bolt,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  '总 OVER POWER：',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              const SizedBox(width: 50),
                              Expanded(
                                child: Text(
                                  '${widget.playerdata['over_power']}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Icon(
                                Icons.show_chart,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  'OP 总进度：',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              const SizedBox(width: 50),
                              Expanded(
                                child: Text(
                                  '${widget.playerdata['over_power_progress']}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Icon(
                                Icons.replay,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  '突破次数：',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              const SizedBox(width: 50),
                              Expanded(
                                child: Text(
                                  '${widget.playerdata['reborn_count']}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Icon(
                                Icons.cloud_upload,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  '最后更新：',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              const SizedBox(width: 50),
                              Expanded(
                                child: Text(
                                  DateTime.parse(
                                    widget.playerdata['upload_time'],
                                  ).toLocal().toString().substring(0, 16),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
