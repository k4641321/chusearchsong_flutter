import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:flutter/material.dart';

class Baseinfopage extends StatelessWidget {
  const Baseinfopage({super.key});

  Widget buildWidget(String title, List<Widget> children) {
    children.insert(
      0,
      Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
    return Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: Card(
        child: Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget buildTextWidget(
    BuildContext context,
    IconData icon,
    String title,
    String text,
  ) {
    return InkWell(
      onTap: () => copytext(text: text, context: context),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: 4),
          SizedBox(
            width: 80,
            child: Text(title, style: TextStyle(fontSize: 15)),
          ),
          SizedBox(width: 50),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('基础信息')),
      body: Center(
        child: ListView(
          children: [
            buildWidget('前提条件', [
              buildTextWidget(
                context,
                Icons.description,
                '原文描述：',
                'レーティング5.00に到達*1し、かつX-VERSE以降に配信された任意の課題曲マップ(VERSE ep.ORIGIN以降の課題曲マップ)をクリアすると、次TRACKの選曲画面で特殊演出が発生し、タブ「Linked VERSE」が解放される。',
              ),
              const Divider(),
              buildTextWidget(
                context,
                Icons.translate,
                '机器翻译：',
                '达到等级5. 00 *1，并且清除X-VERSE以后发送的任意的课题曲地图（VERSE ep. ORIGIN以后的课题曲地图）的话，在下一个TRACK的选曲画面中发生特殊演出，标签“Linked VERSE”被解放。',
              ),
            ]),

            buildWidget('门打开', [
              buildTextWidget(
                context,
                Icons.description,
                '原文描述：',
                'Linked VERSEモードの解禁楽曲をプレイするためには、特定の条件を満たすと現れるゲートの発見と、対応するアクセスカードによる開放が必要となる。*2ゲート発見または開放時では特殊演出を用意されている。ただし、何かの理由でLinked VERSEモードに入ることはできない(後述)場合は、ゲートの発現・開放は次クレジットに持ち越し。1クレジット中で複数のゲートの発現・開放が可能。2026/7/2(Mate)以降、定期的にゲートの発現条件が緩和されている。解禁条件に関して、以下の点に注意が必要。一部の条件を達成するためにCHUNITHM-NETへの加入が必須となっている。スタンダードコースへの加入は必須ではない。ゲートとアクセスカードの解禁条件は別々に集計されるため、ゲート発見前にそのゲートのアクセスカードの入手条件を満たしていれば、ゲート発見時点で開放済み状態となり、そのまま解禁楽曲を挑戦可能。例えばLinked GATE AMAZONの場合、ゲート未発見の状態で特定楽曲をプレイしても条件達成のフラグが立ち、ゲートの発見と同時に開放される。「(特定)楽曲をプレイ」という条件が設けられている場合、特記事項がない場合は下記の共通条件が適用される。ゲート実装以前でのプレイ分(例ればLinked GATE ORIGINの場合、2025/7/15(VERSE)以前のプレイ分)は全て条件集計対象外。タブ「Linked VERSE」解放以前のプレイは、ゲート実装後のプレイであれば集計対象になる模様。難易度・スコア・キャラなどのプレイ条件・成績は原則不問。WORLD\'S END譜面でのプレイは集計対象外。トラックスキップ、スキルによる強制終了の場合も集計対象となる。全国対戦の場合は、自選曲のみ集計対象。',
              ),
              const Divider(),
              buildTextWidget(
                context,
                Icons.translate,
                '机器翻译：',
                'Linked VERSE模式的解除为了播放歌曲，有必要找到满足特定条件时出现的门，并通过相应的访问卡打开门。* 2在发现或开放门时准备了特殊演出。但是，如果由于某种原因不能进入Linked VERSE模式（见下文），门的表达/打开将转移到下一个信用。在1个信用中可以发现·开放多个门。2026/7/2（Mate）以后，门的表达条件定期得到缓和。关于解禁条件，需要注意以下几点。为了达到部分条件，必须加入CHUNITHM-NET。参加标准课程不是强制性的。由于门和访问卡的解禁条件是分别统计的，所以如果在发现门之前满足该门的访问卡的获得条件，则在发现门时处于开放状态，可以直接挑战解禁乐曲。例如Linked GATE AMAZON的情况下，即使在未发现门的状态下播放特定乐曲，也会出现条件达成的标志，在发现门的同时被开放。在设置了“播放（特定）乐曲”这一条件的情况下，没有特别记载事项的情况下，适用以下的共同条件。门安装以前的游戏部分（例如Linked GATE ORIGIN的情况下，2025/7/15（VERSE）以前的游戏部分）全部不属于条件合计对象。标签“Linked VERSE”释放前的游戏，如果是门安装后的游戏，将成为汇总对象。难易度、得分、角色等比赛条件、成绩原则上不问问题。WORLD\'S END乐谱上的游戏不属于统计对象。跳过轨迹，根据技能强制结束的情况也成为统计对象。全国对战的情况下，只统计自选曲。',
              ),
            ]),
            buildWidget('门打开后', [
              buildTextWidget(
                context,
                Icons.description,
                '原文描述：',
                'ゲート開放後、リアルタイムで全国のプレイヤー最大4人と同時にそのゲートに対応する解禁楽曲を挑戦することができる。プレイ中は「Link GAUGE」という特殊なゲージを使用する。UNLOCK CHALLENGEやクラス認定のライフシステムに似ているが、マッチングした誰かが生き残っている限りは続行可能。加えて、コンボを繋ぐことで自分以外の仲間のGAUGEを回復することができる。自分のGAUGEが0になると脱落となるが、その場合でも仲間のGAUGE回復は行える。ただし、回復できるのはGAUGEが1以上残っているメンバーのみ。0になって脱落したメンバーを復帰させることはできない。全員のライフが0になった(全滅した)時点で強制終了となる。1人でもGAUGEを残せばクリアとなる。以上のことから、マッチング人数が多い程クリアしやすくなるシステムとなっている。',
              ),
              const Divider(),
              buildTextWidget(
                context,
                Icons.translate,
                '机器翻译：',
                '门开放后，可以实时与全国最多4名玩家同时挑战对应该门的解禁乐曲。游戏中使用名为“Link GAUGE”的特殊量规。类似于UNLOCK CHALLENGE或认证的生命系统，但只要匹配的人还活着，就可以继续。再加上，通过连接组合，可以恢复自己以外的同伴的GAUGE。如果自己的GAUGE变为0，就会被淘汰，即使在这种情况下，也可以进行同伴的GAUGE恢复。但是，只有剩下1个以上GAUGE的成员才能恢复。变为0而被淘汰的成员不能返回。全员的生命变为0（全灭）时强制结束。即使是1个人，只要留下GAUGE就可以清除。综上所述，匹配人数越多，就越容易清除。',
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
