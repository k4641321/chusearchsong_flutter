import 'dart:developer';

import 'package:flutter/material.dart';
import '../tools/faulttoterantcomputationfun.dart';

class FaulttoterantcomputationPage extends StatefulWidget {
  const FaulttoterantcomputationPage({super.key});

  @override
  State<FaulttoterantcomputationPage> createState() =>
      _FaulttoterantcomputationPageState();
}

class _FaulttoterantcomputationPageState
    extends State<FaulttoterantcomputationPage> {
  List<DataRow> rows = [];
  final ScrollController _controller = ScrollController();
  final TextEditingController _textfieldController = TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('容错计算'),
        // backgroundColor: const Color.fromARGB(255, 255, 229, 84),
      ),
      body: Column(
        children: [
          Text(
            '提示: 1 Miss 约等于 2 ATTACK 约等于 4 JUSTICE \n 作者数学烂，此工具不能保证计算的准确性 \n 由于结果小数位数不同，可能有误差1个 \n M: Miss A: Attack J: Justice',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
                width: 250,

                child: ListTile(
                  leading: Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  title: Text('将结果全部减1'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('音符总量:'),
              Expanded(child: TextField(controller: _textfieldController)),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    int total = 0;
                    try {
                      total = int.parse(_textfieldController.text);
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('你看看你输的什么东西')));
                    }
                    setState(() {
                      rows = calculate(total: total, countdown: isChecked);
                    });
                  },
                  child: Text('计算'),
                ),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: Scrollbar(
              controller: _controller,
              child: SingleChildScrollView(
                controller: _controller,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('评级')),
                    DataColumn(label: Text('容错')),
                  ],
                  rows: rows,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
