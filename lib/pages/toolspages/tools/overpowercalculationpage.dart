import 'dart:developer';

import 'package:chusearchsong_flutter/function/toolsfun/ratingcalculatorpagefun.dart';
import 'package:flutter/material.dart';

class Overpowercalculationpage extends StatefulWidget {
  const Overpowercalculationpage({super.key});

  @override
  State<Overpowercalculationpage> createState() =>
      _OverpowercalculationpageState();
}

class _OverpowercalculationpageState extends State<Overpowercalculationpage> {
  String _select = 'None';

  Widget result = SizedBox.shrink();
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();

  void calculateOverpower() {
    try {
      int score = int.parse(_scoreController.text);
      double level = double.parse(_levelController.text);
      double xz1 = 0;
      double xz2 = (score - 1007500) * 0.0015;
      //補正1…FCで0.5、AJで1.0、AJCで1.25
      //補正2…(スコア-1,007,500)×0.0015 = SSS~理論値までの間で最大3.75
      switch (_select) {
        case 'FC':
          xz1 = 0.5;
          break;
        case 'AJ':
          xz1 = 1.0;
          break;
        case 'AJC':
          xz1 = 1.25;
          break;
        case 'None':
          xz1 = 0;
          break;
      }

      //AJC
      if (score == 1010000) {
        setState(() {
          result = Text('Over Power: ${(level + 2) * 5 + (1.25 + 3.75)}');
        });
        return;
      } else if (score >= 1007501) {
        setState(() {
          result = Text('Over Power: ${(level + 2) * 5 + xz1 + xz2}');
        });
        return;
      } else {
        setState(() {
          result = Text(
            'Over Power: ${calculatorRating(scorestr: _scoreController.text, diffstr: _levelController.text) * 5 + xz1}',
          );
        });
        return;
      }
    } catch (e, strack) {
      log('$e\n$strack');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('看看哪里输错了')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Over Power计算')),
      body: Column(
        children: [
          Row(
            children: [
              Text('分数：'),
              Expanded(
                child: TextField(
                  controller: _scoreController,
                  decoration: InputDecoration(hintText: '输入分数'),
                ),
              ),
              Text('定数：'),
              Expanded(
                child: TextField(
                  controller: _levelController,
                  decoration: InputDecoration(hintText: '输入定数'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: RadioMenuButton(
                  groupValue: _select,
                  value: 'None',
                  onChanged: (value) => setState(() {
                    _select = value.toString();
                  }),
                  child: Text('None'),
                ),
              ),
              Expanded(
                child: RadioMenuButton(
                  groupValue: _select,
                  value: 'FC',
                  onChanged: (value) => setState(() {
                    _select = value.toString();
                  }),
                  child: Text('FC'),
                ),
              ),
              Expanded(
                child: RadioMenuButton(
                  groupValue: _select,
                  value: 'AJ',
                  onChanged: (value) => setState(() {
                    _select = value.toString();
                  }),
                  child: Text('AJ'),
                ),
              ),
              Expanded(
                child: RadioMenuButton(
                  groupValue: _select,
                  value: 'AJC',
                  onChanged: (value) => setState(() {
                    _select = value.toString();
                  }),
                  child: Text('AJC'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => calculateOverpower(),
                  child: Text('计算'),
                ),
              ),
            ],
          ),
          result,
        ],
      ),
    );
  }
}
