import 'package:flutter/material.dart';
import '../tools/scsorehistorypagefun.dart';

class ScoreHistoryPage extends StatefulWidget {
  final int songid;
  final int diffindex;
  const ScoreHistoryPage({
    super.key,
    required this.songid,
    required this.diffindex,
  });

  @override
  State<ScoreHistoryPage> createState() => _ScoreHistoryPageState();
}

class _ScoreHistoryPageState extends State<ScoreHistoryPage> {
  Widget lineChat = Text('加载中');
  Widget historyCard = Text('加载中');
  late Widget historyCardBackup;
  final ScrollController _scrollController = ScrollController();

  Future<void> _init() async {
    List<Widget> result = await getLineChartAndCard(
      context: context,
      id: widget.songid,
      diffindex: widget.diffindex,
      corlor: Theme.of(context).colorScheme.onSecondary,
    );
    historyCardBackup = result[1];
    if (!mounted) return;
    setState(() {
      lineChat = result[0];
      historyCard = result[1];
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('历史成绩')),
      body: Center(
        child: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                lineChat,
                // Row(
                //   children: [
                //     Expanded(
                //       child: TextButton(
                //         onPressed: () => setState(() {
                //           historyCard = historyCardBackup;
                //         }),
                //         child: Text('显示全部成绩'),
                //       ),
                //     ),
                //   ],
                // ),
                const Divider(),
                historyCard,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
