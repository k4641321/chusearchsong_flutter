import 'package:flutter/material.dart';
import 'lxnssyncwebview.dart';

class UpdateScorePage extends StatefulWidget {
  const UpdateScorePage({super.key});

  @override
  State<StatefulWidget> createState() => _UpdateScorePageState();
}

class _UpdateScorePageState extends State<UpdateScorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('更新成绩')),
      body: Center(
        child: Column(
          children: [
            Text('打开网页后，点击最上面的开关，根据网页提示操作，开关打开期间无法正常访问其他网页'),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LxnsSyncWebView(),
                      ),
                    ),
                    child: Text('打开落雪成绩更新网页'),
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
