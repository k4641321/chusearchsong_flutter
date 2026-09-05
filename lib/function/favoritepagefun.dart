import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

Future<void> exportFavoriteSong({required BuildContext context}) async {
  try {
    Map<String, dynamic> favoriteSongs = await loadFavoriteSong();
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        List<Widget> children = [];
        for (var i in favoriteSongs.keys.toList()) {
          children.add(
            ListTile(
              title: Text(i),
              onTap: () async {
                if (!context.mounted) return;
                Navigator.pop(context);
                final Uint8List dataBytes = utf8.encode(
                  jsonEncode({i: favoriteSongs[i]}),
                );
                String? outputPath = await FilePicker.saveFile(
                  dialogTitle: '请选择收藏文件保存位置',
                  fileName: '$i.json', // 默认文件名
                  type: FileType.custom,
                  bytes: dataBytes,
                  allowedExtensions: ['json'],
                );
                if (outputPath == null) {
                  log('取消导出');
                  return;
                }
              },
            ),
          );
        }
        return SimpleDialog(title: Text('选择要导出的收藏夹'), children: children);
      },
    );
  } catch (e) {
    log('$e', name: 'favoritepagefun.dart', level: 1000);
  }
}

Future<void> importFavoriteSong({required BuildContext context}) async {
  final path = await getApplicationSupportDirectory();

  try {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.isEmpty) {
      log('取消选择');
      return;
    }
    final filePath = result.files.single.path;
    if (filePath == null) {
      return;
    }
    final file = File(filePath);
    final String content = await file.readAsString();
    try {
      Map<String, dynamic> importFavoriteSongs = jsonDecode(content);
      if (!context.mounted) return;
      await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController controller = TextEditingController();
          controller.text = importFavoriteSongs.keys.first;
          return AlertDialog(
            title: Text('输入收藏夹名'),
            content: TextField(controller: controller),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('取消'),
              ),
              TextButton(
                onPressed: () async {
                  Map<String, dynamic> favoriteSongs = await loadFavoriteSong();
                  List favoriteListSongsKeys = favoriteSongs.keys.toList();
                  if (favoriteListSongsKeys.contains(controller.text)) {
                    if (!context.mounted) return;

                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('提示'),
                        content: Text('已存在同名文件夹，是否覆盖'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('取消'),
                          ),
                          TextButton(
                            onPressed: () {
                              favoriteSongs[controller.text] =
                                  importFavoriteSongs.values.first;
                              File(
                                '${path.path}/files/favorite.json',
                              ).writeAsStringSync(jsonEncode(favoriteSongs));
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text('确定'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    favoriteSongs[controller.text] =
                        importFavoriteSongs.values.first;
                    File(
                      '${path.path}/files/favorite.json',
                    ).writeAsStringSync(jsonEncode(favoriteSongs));
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  }
                },
                child: Text('确定'),
              ),
            ],
          );
        },
      );
    } catch (e, stackTrace) {
      log('$e\n$stackTrace');
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('错误，可能格式不正确\n$e\n$stackTrace')));
      return;
    }
  } catch (e, stackTrace) {
    log('$e\n$stackTrace', name: 'favoritepagefun.dart', level: 1000);
  }
}
