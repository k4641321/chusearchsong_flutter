import 'package:flutter/material.dart';
import 'lxnssyncwebview.dart';
import '../../tools/updatescorepagefun.dart';
import 'package:flutter_singbox_client/flutter_singbox_client.dart';
import 'package:flutter/services.dart';

class UpdateScorePage extends StatefulWidget {
  const UpdateScorePage({super.key});

  @override
  State<StatefulWidget> createState() => _UpdateScorePageState();
}

class _UpdateScorePageState extends State<UpdateScorePage> {
  bool _switchValue = false;
  final SingboxClient singbox = SingboxClient();

  Future<void> exit() async {
    ServiceState state = await singbox.getServiceState();
    if (state == ServiceState.starting || state == ServiceState.started) {
      singbox.disconnect();
    }
    singbox.dispose();
  }

  Future<void> init() async {
    await singbox.initialize();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    exit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('更新成绩')),
      body: Center(
        child: Column(
          children: [
            Text('打开下面的开关，打开网页，根据网页提示操作，开关打开期间可能无法正常访问其他网页'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('打开代理'),
                Switch(
                  value: _switchValue,
                  onChanged: (value) async {
                    // String link =
                    //     "vmess://ew0KICAidiI6ICIyIiwNCiAgInBzIjogIjEiLA0KICAiYWRkIjogInByb3h5Lm1haW1haS5seG5zLm5ldCIsDQogICJwb3J0IjogIjgwODAiLA0KICAiaWQiOiAiZGNjM2UzZmYtNjlmNC00NDk0LWI1NDgtMTc0ZWY1ODQ5OWE5IiwNCiAgImFpZCI6ICIwIiwNCiAgInNjeSI6ICJhdXRvIiwNCiAgIm5ldCI6ICJ0Y3AiLA0KICAidHlwZSI6ICJub25lIiwNCiAgInRscyI6ICIiLA0KICAiYWxwbiI6ICIiLA0KICAiaW5zZWN1cmUiOiAiMCINCn0=";
                    // String link = await rootBundle.loadString(
                    //   'res/maimaiproxy.json',
                    // );
                    // print(link);
                    if (value) {
                      // if (!await singbox.requestVPNPermission()) return;
                      await connect(client: singbox);
                    } else {
                      await singbox.disconnect();
                      await singbox.dispose();
                    }
                    setState(() {
                      _switchValue = value;
                    });
                  },
                ),
              ],
            ),
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
