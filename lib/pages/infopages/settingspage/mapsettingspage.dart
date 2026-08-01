import 'package:chusearchsong_flutter/function/infopagefun/settingspagefun.dart';
import 'package:flutter/material.dart';

class MapSettingsPage extends StatefulWidget {
  const MapSettingsPage({super.key});

  @override
  State<MapSettingsPage> createState() => _MapSettingsPageState();
}

class _MapSettingsPageState extends State<MapSettingsPage> {
  String _selectedMap = 'amap';

  Future<void> _saveSettings() async {
    await saveMapConfig(_selectedMap, context);
  }

  Future<void> _loadSettings() async {
    String selectedMap = await loadmapconfig(context);
    if (!mounted) return;
    setState(() {
      _selectedMap = selectedMap;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('地图设置')),
      body: Center(
        child: Column(
          children: [
            RadioMenuButton<String>(
              value: 'amap',
              groupValue: _selectedMap,
              onChanged: (value) => setState(() => _selectedMap = value!),
              child: const Text('高德地图'),
            ),
            RadioMenuButton<String>(
              value: 'baidu',
              groupValue: _selectedMap,
              onChanged: (value) => setState(() => _selectedMap = value!),
              child: const Text('百度地图'),
            ),
            RadioMenuButton<String>(
              value: 'tencent',
              groupValue: _selectedMap,
              onChanged: (value) => setState(() => _selectedMap = value!),
              child: const Text('腾讯地图'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async => await _saveSettings(),
                    child: Text('保存设置'),
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
