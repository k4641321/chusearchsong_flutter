import 'package:chusearchsong_flutter/function/commonfun.dart';
import 'package:flutter/material.dart';

//AI美化过这个界面了
class Baseinfopage extends StatelessWidget {
  const Baseinfopage({super.key});

  // ───────── 章节卡片 ─────────
  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 标题栏（左侧色条 + 图标 + 文字） ──
            Row(
              children: [
                Container(
                  width: 4,
                  height: 22,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.info_outline_rounded, size: 20, color: cs.primary),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // ── 条目列表 ──
            ...items,
          ],
        ),
      ),
    );
  }

  // ───────── 单条信息（原文 / 翻译） ─────────
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String text,
  }) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => copytext(text: text, context: context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标签行
            Row(
              children: [
                Icon(icon, size: 16, color: cs.primary),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: cs.primary,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.copy_rounded,
                  size: 14,
                  color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 正文
            Text(
              text,
              style: TextStyle(fontSize: 14, height: 1.6, color: cs.onSurface),
            ),
          ],
        ),
      ),
    );
  }

  // ───────── 分隔线 ─────────
  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        height: 1,
        color: Theme.of(
          context,
        ).colorScheme.outlineVariant.withValues(alpha: 0.3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('基础信息'),
        centerTitle: true,
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _buildSection(context, '前提条件', [
            _buildInfoRow(
              context,
              icon: Icons.description_rounded,
              label: '原文描述',
              text:
                  'レーティング5.00に到達*1し、かつX-VERSE以降に配信された任意の課題曲マップ'
                  '(VERSE ep.ORIGIN以降の課題曲マップ)をクリアすると、次TRACKの選曲画面で'
                  '特殊演出が発生し、タブ「Linked VERSE」が解放される。',
            ),
            _buildDivider(context),
            _buildInfoRow(
              context,
              icon: Icons.translate_rounded,
              label: '机器翻译',
              text:
                  '达到等级5.00*1，并且清除X-VERSE以后发送的任意的课题曲地图'
                  '（VERSE ep.ORIGIN以后的课题曲地图）的话，在下一个TRACK的选曲画面中'
                  '发生特殊演出，标签\u201cLinked VERSE\u201d被解放。',
            ),
          ]),

          _buildSection(context, '门打开', [
            _buildInfoRow(
              context,
              icon: Icons.description_rounded,
              label: '原文描述',
              text:
                  'Linked VERSEモードの解禁楽曲をプレイするためには、特定の条件を満たすと現れる'
                  'ゲートの発見と、対応するアクセスカードによる開放が必要となる。*2'
                  'ゲート発見または開放時では特殊演出を用意されている。ただし、何かの理由で'
                  'Linked VERSEモードに入ることはできない(後述)場合は、ゲートの発現・開放は'
                  '次クレジットに持ち越し。1クレジット中で複数のゲートの発現・開放が可能。'
                  '2026/7/2(Mate)以降、定期的にゲートの発現条件が緩和されている。'
                  '解禁条件に関して、以下の点に注意が必要。一部の条件を達成するために'
                  'CHUNITHM-NETへの加入が必須となっている。スタンダードコースへの加入は必須ではない。'
                  'ゲートとアクセスカードの解禁条件は別々に集計されるため、ゲート発見前に'
                  'そのゲートのアクセスカードの入手条件を満たしていれば、ゲート発見時点で'
                  '開放済み状態となり、そのまま解禁楽曲を挑戦可能。例えばLinked GATE AMAZONの場合、'
                  'ゲート未発見の状態で特定楽曲をプレイしても条件達成のフラグが立ち、'
                  'ゲートの発見と同時に開放される。「(特定)楽曲をプレイ」という条件が設けられている場合、'
                  '特記事項がない場合は下記の共通条件が適用される。ゲート実装以前でのプレイ分'
                  '(例ればLinked GATE ORIGINの場合、2025/7/15(VERSE)以前のプレイ分)は全て'
                  '条件集計対象外。タブ「Linked VERSE」解放以前のプレイは、ゲート実装後のプレイで'
                  'あれば集計対象になる模様。難易度・スコア・キャラなどのプレイ条件・成績は原則不問。'
                  "WORLD'S END譜面でのプレイは集計対象外。トラックスキップ、スキルによる強制終了の場合も"
                  '集計対象となる。全国対戦の場合は、自選曲のみ集計対象。',
            ),
            _buildDivider(context),
            _buildInfoRow(
              context,
              icon: Icons.translate_rounded,
              label: '机器翻译',
              text:
                  'Linked VERSE模式的解除为了播放歌曲，有必要找到满足特定条件时出现的门，'
                  '并通过相应的访问卡打开门。*2在发现或开放门时准备了特殊演出。但是，如果由于某种原因'
                  '不能进入Linked VERSE模式（见下文），门的表达/打开将转移到下一个信用。'
                  '在1个信用中可以发现·开放多个门。2026/7/2（Mate）以后，门的表达条件定期得到缓和。'
                  '关于解禁条件，需要注意以下几点。为了达到部分条件，必须加入CHUNITHM-NET。'
                  '参加标准课程不是强制性的。由于门和访问卡的解禁条件是分别统计的，所以如果在发现门之前'
                  '满足该门的访问卡的获得条件，则在发现门时处于开放状态，可以直接挑战解禁乐曲。'
                  '例如Linked GATE AMAZON的情况下，即使在未发现门的状态下播放特定乐曲，也会出现'
                  '条件达成的标志，在发现门的同时被开放。在设置了\u201c播放（特定）乐曲\u201d这一条件的情况下，'
                  '没有特别记载事项的情况下，适用以下的共同条件。门安装以前的游戏部分'
                  '（例如Linked GATE ORIGIN的情况下，2025/7/15（VERSE）以前的游戏部分）'
                  '全部不属于条件合计对象。标签\u201cLinked VERSE\u201d释放前的游戏，如果是门安装后的游戏，'
                  '将成为汇总对象。难易度、得分、角色等比赛条件、成绩原则上不问问题。'
                  "WORLD'S END乐谱上的游戏不属于统计对象。跳过轨迹，根据技能强制结束的情况也成为"
                  '统计对象。全国对战的情况下，只统计自选曲。',
            ),
          ]),

          _buildSection(context, '门打开后', [
            _buildInfoRow(
              context,
              icon: Icons.description_rounded,
              label: '原文描述',
              text:
                  'ゲート開放後、リアルタイムで全国のプレイヤー最大4人と同時にそのゲートに対応する'
                  '解禁楽曲を挑戦することができる。プレイ中は「Link GAUGE」という特殊なゲージを使用する。'
                  'UNLOCK CHALLENGEやクラス認定のライフシステムに似ているが、マッチングした誰かが'
                  '生き残っている限りは続行可能。加えて、コンボを繋ぐことで自分以外の仲間のGAUGEを'
                  '回復することができる。自分のGAUGEが0になると脱落となるが、その場合でも仲間の'
                  'GAUGE回復は行える。ただし、回復できるのはGAUGEが1以上残っているメンバーのみ。'
                  '0になって脱落したメンバーを復帰させることはできない。全員のライフが0になった'
                  '(全滅した)時点で強制終了となる。1人でもGAUGEを残せばクリアとなる。以上のことから、'
                  'マッチング人数が多い程クリアしやすくなるシステムとなっている。',
            ),
            _buildDivider(context),
            _buildInfoRow(
              context,
              icon: Icons.translate_rounded,
              label: '机器翻译',
              text:
                  '门开放后，可以实时与全国最多4名玩家同时挑战对应该门的解禁乐曲。'
                  '游戏中使用名为\u201cLink GAUGE\u201d的特殊量规。类似于UNLOCK CHALLENGE或认证的生命系统，'
                  '但只要匹配的人还活着，就可以继续。再加上，通过连接组合，可以恢复自己以外的同伴的GAUGE。'
                  '如果自己的GAUGE变为0，就会被淘汰，即使在这种情况下，也可以进行同伴的GAUGE恢复。'
                  '但是，只有剩下1个以上GAUGE的成员才能恢复。变为0而被淘汰的成员不能返回。'
                  '全员的生命变为0（全灭）时强制结束。即使是1个人，只要留下GAUGE就可以清除。'
                  '综上所述，匹配人数越多，就越容易清除。',
            ),
          ]),
        ],
      ),
    );
  }
}
