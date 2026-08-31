import 'dart:convert';
import 'dart:developer';
import 'package:pub_semver/pub_semver.dart';
import 'package:chusearchsong_flutter/function/request.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchgithub({required BuildContext context}) async {
  final githuburl = Uri.parse(
    'https://github.com/k4641321/chusearchsong_flutter',
  );
  try {
    if (!await launchUrl(githuburl)) {
      if (!context.mounted) return;

      throw Exception('Could not launch $githuburl');
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('无法打开链接')));
  }
}

Future<void> openQQ({required BuildContext context}) async {
  final Uri qqurl = Uri.parse(
    'myqqapi://card/show_pslcard?src_type=internal&version=1&card_type=group&uin=309546141',
  );
  final Uri qqurl2 = Uri.parse(
    'mqq://card/show_pslcard?src_type=internal&version=1&card_type=group&uin=309546141',
  );
  try {
    if (await canLaunchUrl(qqurl)) {
      await launchUrl(qqurl);
      return;
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('无法打开链接，尝试第二种')));
    if (await canLaunchUrl(qqurl2)) {
      log('尝试第二种');
      await launchUrl(qqurl2);
    } else if (!await canLaunchUrl(qqurl2)) {
      throw Exception('Could not launch $qqurl2');
    }
  } catch (e) {
    log('$e', name: 'infopage', level: 500);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('无法打开链接')));
  }
}

Future<bool> checkforupdates() async {
  Map<String, dynamic> result = jsonDecode(await requestVersion());
  final packageinfo = await PackageInfo.fromPlatform();
  String oldversion = packageinfo.version;
  // log(oldversion);
  String newversion = result['version'];
  // log(newversion);
  log('开始检查');
  if (Version.parse(oldversion) < Version.parse(newversion)) {
    log('发现新版本');
    return true;
  } else {
    log('已是最新版本');
    return false;
  }
}

Future<void> lanuchdownload({required BuildContext context}) async {
  try {
    try {
      Uri githuburl = jsonDecode(await requestVersion())['download_url'];
      if (!await launchUrl(githuburl)) {
        if (!context.mounted) return;
        throw Exception('Could not launch $githuburl');
      }
    } catch (e) {
      Uri githuburl = Uri.parse(
        'https://github.com/k4641321/chusearchsong_flutter/releases/latest',
      );
      if (!await launchUrl(githuburl)) {
        if (!context.mounted) return;
        throw Exception('Could not launch $githuburl');
      }
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('无法打开链接')));
  }
}

Future<void> lanuchhelpdocs({required BuildContext context}) async {
  final githuburl = Uri.parse(
    'https://blog.devintom.top/chusearchsong_flutter/',
  );
  try {
    if (!await launchUrl(githuburl)) {
      if (!context.mounted) return;
      throw Exception('Could not launch $githuburl');
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('无法打开链接')));
  }
}

Future<void> lanuchifdian({required BuildContext context}) async {
  final githuburl = Uri.parse('https://ifdian.net/a/k4641321');
  try {
    if (!await launchUrl(githuburl)) {
      if (!context.mounted) return;
      throw Exception('Could not launch $githuburl');
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('无法打开链接')));
  }
}
