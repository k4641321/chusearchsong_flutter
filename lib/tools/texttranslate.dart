import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String> translateText({
  required String sourceText,
  required BuildContext context,
}) async {
  if (sourceText.isEmpty) {
    return 'Null';
  }
  //读取SecretId和SecretKey
  final configpath = await getApplicationSupportDirectory();
  final configfile = File('${configpath.path}/config.json');
  final String tencentSecretId;
  final String tencentSecretKey;
  try {
    final String configstr = await configfile.readAsString();
    Map<String, dynamic> config = json.decode(configstr);
    tencentSecretId = config['texttranslate']['secretId'];
    tencentSecretKey = config['texttranslate']['secretKey'];
    // print(tencentSecretId);
    // print(tencentSecretKey);
  } catch (e) {
    if (!context.mounted) return 'Error';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('错误，读取SecretId和SecretKey失败，请检查是否配置正确')),
    );
    return 'Error';
  }
  //定义必要参数
  final token = '';

  final service = 'tmt';
  final host = 'tmt.tencentcloudapi.com';
  final endpoint = 'https://$host';
  final region = 'ap-guangzhou';
  final action = 'TextTranslate';
  final version = '2018-03-21';
  final algorithm = 'TC3-HMAC-SHA256';
  final timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).toInt();
  final date = DateFormat(
    'yyyy-MM-dd',
  ).format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true));

  // ************* 步骤 1：拼接规范请求串 *************
  final httpRequestMethod = 'POST';
  final canonicalUri = '/';
  final canonicalQuerystring = '';
  final ct = 'application/json; charset=utf-8';
  // final payload =
  //     "{\"SourceText\":\ "hello\",\"Source\":\"ja\",\"Target\":\"zh\",\"ProjectId\":0}";
  Map<String, dynamic> payloadMap = {
    "SourceText": sourceText,
    "Source": "ja",
    "Target": "zh",
    "ProjectId": 0,
  };
  final payload = json.encode(payloadMap);
  final canonicalHeaders =
      'content-type:$ct\nhost:$host\nx-tc-action:${action.toLowerCase()}\n';
  final signedHeaders = 'content-type;host;x-tc-action';
  final hashedRequestPayload = sha256.convert(utf8.encode(payload));
  final canonicalRequest =
      '''
$httpRequestMethod
$canonicalUri
$canonicalQuerystring
$canonicalHeaders
$signedHeaders
$hashedRequestPayload''';
  print(canonicalRequest);

  // ************* 步骤 2：拼接待签名字符串 *************
  final credentialScope = '$date/$service/tc3_request';
  final hashedCanonicalRequest = sha256.convert(utf8.encode(canonicalRequest));
  final stringToSign =
      '''
$algorithm
$timestamp
$credentialScope
$hashedCanonicalRequest''';
  print(stringToSign);

  // ************* 步骤 3：计算签名 *************
  List<int> sign(List<int> key, String msg) {
    final hmacSha256 = Hmac(sha256, key);
    return hmacSha256.convert(utf8.encode(msg)).bytes;
  }

  final secretDate = sign(utf8.encode('TC3$tencentSecretKey'), date);
  final secretService = sign(secretDate, service);
  final secretSigning = sign(secretService, 'tc3_request');
  final signature = Hmac(
    sha256,
    secretSigning,
  ).convert(utf8.encode(stringToSign)).toString();
  print(signature);

  // ************* 步骤 4：拼接 Authorization *************
  final authorization =
      '$algorithm Credential=$tencentSecretId/$credentialScope, SignedHeaders=$signedHeaders, Signature=$signature';
  print(authorization);

  // ************* 步骤 5：构造并发起请求 *************
  final response = await http.post(
    Uri.parse(endpoint),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': authorization,
      'X-TC-Action': action,
      'X-TC-Version': version,
      'X-TC-Region': region,
      'X-TC-Timestamp': timestamp.toString(),
      'X-TC-Token': token.toString(),
    },
    body: payload,
  );
  Map<String, dynamic> result = json.decode(response.body);
  print(json.decode(utf8.decode(response.bodyBytes)));

  return result['Response']['TargetText'];
}
