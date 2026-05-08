import 'package:flutter/material.dart';

class ScoreCalculation extends StatefulWidget {
  const ScoreCalculation({super.key});

  @override
  State<ScoreCalculation> createState() => _ScoreCalculation();
}

class _ScoreCalculation extends State<ScoreCalculation> {
  // final TextEditingController _totalController = TextEditingController();
  final TextEditingController _jcController = TextEditingController();
  final TextEditingController _jController = TextEditingController();
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _mController = TextEditingController();
  final TextEditingController _resultcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('分数计算'),
        backgroundColor: const Color.fromARGB(255, 255, 229, 84),
      ),
      body: Center(
        child: Column(
          children: [
            // Row(
            //   children: [
            //     Text('Total: '),
            //     Expanded(child: TextField(controller: _totalController)),
            //   ],
            // ),
            Row(
              children: [
                Text('JUSTICE CRITICAL: '),
                Expanded(child: TextField(controller: _jcController)),
              ],
            ),
            Row(
              children: [
                Text('JUSTICE: '),
                Expanded(child: TextField(controller: _jController)),
              ],
            ),
            Row(
              children: [
                Text('ATTACK: '),
                Expanded(child: TextField(controller: _aController)),
              ],
            ),
            Row(
              children: [
                Text('MISS: '),
                Expanded(child: TextField(controller: _mController)),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // String totalstr = _totalController.text;
                      String jcstr = _jcController.text;
                      String jstr = _jController.text;
                      String astr = _aController.text;
                      String mstr = _mController.text;
                      double jc, j, a, m, score;
                      try {
                        jc = double.parse(jcstr);
                        j = double.parse(jstr);
                        a = double.parse(astr);
                        m = double.parse(mstr);
                        score =
                            10000 /
                            (jc + j + a + m) *
                            (101 * jc + 100 * j + 50 * a);
                        _resultcontroller.text = score.toString();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('看看你哪里输入错误了')),
                        );
                      }
                    },
                    child: Text(
                      '计算',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '结果',
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                Expanded(
                  child: TextField(
                    controller: _resultcontroller,
                    readOnly: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
