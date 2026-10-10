import 'dart:convert';
import 'dart:developer';
import 'package:flutter_local_db/flutter_local_db.dart';
import 'request.dart';

class WriteData {
  WriteData._();

  static Future<WriteData> create() async {
    return WriteData._();
  }

  Future<void> writeLinkedVerseData() async {
    String result = await requestLinkedVerseData();
    await LocalDB.Post('LinkedVerseData', jsonDecode(result));
    log('LinkedVerse完成');
  }

  Future<void> writePlateData() async {
    String result = await requestPlatesData();
    await LocalDB.Post('PlatesData', jsonDecode(result));
    log('名牌版完成');
  }

  Future<void> writeIconsData() async {
    String result = await requestIconsData();
    await LocalDB.Post('IconsData', jsonDecode(result));
    log('头像完成');
  }

  Future<void> writeTrophiesData() async {
    String result = await requestTrophiesData();
    await LocalDB.Post('TrophiesData', jsonDecode(result));
    log('称号完成');
  }

  Future<void> writeCharactersData() async {
    String result = await requestCharactersData();
    await LocalDB.Post('CharactersData', jsonDecode(result));
    log('角色完成');
  }

  Future<void> writeSongsData() async {
    String result = await requestSongData();
    await LocalDB.Post('SongsData', jsonDecode(result));
    log('歌曲数据完成');
  }

  Future<void> writeWahlapLobbyData() async {
    String result = await requestWahlapLobbyData();
    await LocalDB.Post('WahlapLobbyData', {
      "WahlapLobbyData": jsonDecode(result),
    });
    log('华立机厅数据完成');
  }

  Future<void> writeAliasData() async {
    String result = await requestAliasData();
    await LocalDB.Post('AliasData', jsonDecode(result));
    log('别名完成');
  }

  Future<void> writezxzrSongsData() async {
    log('请求reiwaf5sisongs');
    List zxzrsongslist = await requestreiwaf5sisongs();
    List chunirecall = jsonDecode(zxzrsongslist[1]);
    List chunithmrecord = jsonDecode(zxzrsongslist[0]);
    log('请求beerpsisongs');
    List beerpsisongs = jsonDecode(await requestbeerpsisongs());

    log('添加未拥有的曲目');
    List intlidList = [];
    int idx = -1;
    for (var i in beerpsisongs) {
      intlidList.add(i['id']);
    }
    for (var i in chunirecall) {
      if (!(i['meta'] as Map).containsKey('idx')) {
        List chartsList = [];
        List chartdiffList = (i['data'] as Map).keys.toList();
        for (var j in chartdiffList) {
          chartsList.add({
            "difficulty": j,
            "level": "${i['data'][j]['level']}",
            "const": i['data'][j]['const'],
            "charter": null,
            "version": null,
            "sdvxin_url": null,
            "available": true,
            "notecounts": {
              "total": i['data'][j]['maxcombo'],
              "tap": null,
              "hold": null,
              "slide": null,
              "air": null,
              "flick": null,
            },
          });
        }
        beerpsisongs.add({
          "id": idx,
          "chunirec_id": i['meta']['id'],
          "title": i['meta']['title'],
          "aliases": [],
          "artist": i['meta']['artist'],
          "genre": i['meta']['genre'],
          "release": i['meta']['release'],
          "version": null,
          "jacket_url":
              "https://chunithm-net-eng.com/mobile/img/${i['meta']['img']}.jpg",
          "duration": null,
          "bpm": {
            "min": i['meta']['bpm'],
            "max": i['meta']['bpm'],
            "mode": i['meta']['bpm'],
          },
          "availability": {"intl": false, "jp": true},
          "charts": chartsList,
        });
        idx--;
        continue;
      }
      if (!intlidList.contains(int.parse(i['meta']['idx']))) {
        List chartsList = [];
        List chartdiffList = (i['data'] as Map).keys.toList();
        for (var j in chartdiffList) {
          chartsList.add({
            "difficulty": j,
            "level": "${i['data'][j]['level']}",
            "const": i['data'][j]['const'],
            "charter": null,
            "version": null,
            "sdvxin_url": null,
            "available": true,
            "notecounts": {
              "total": i['data'][j]['maxcombo'],
              "tap": null,
              "hold": null,
              "slide": null,
              "air": null,
              "flick": null,
            },
          });
        }
        beerpsisongs.add({
          "id": int.parse(i['meta']['idx']),
          "chunirec_id": i['meta']['id'],
          "title": i['meta']['title'],
          "aliases": [],
          "artist": i['meta']['artist'],
          "genre": i['meta']['genre'],
          "release_date": i['meta']['release'],
          "version": null,
          "jacket_url":
              "https://new.chunithm-net.com/chuni-mobile/html/mobile/img/${i['meta']['img']}.jpg",
          "duration": null,
          "bpm": {
            "min": i['meta']['bpm'],
            "max": i['meta']['bpm'],
            "mode": i['meta']['bpm'],
          },
          "availability": {"intl": false, "jp": true},
          "charts": chartsList,
        });
      }
    }
    for (var i in chunithmrecord) {
      if (!intlidList.contains(int.parse(i['idx']))) {
        for (var j in beerpsisongs) {
          if (j['id'] == int.parse(i['idx'])) {
            j['version'] = i['version'];
          }
        }
      }
    }
    await LocalDB.Post('zxzrSongsData', {"zxzrsongs": beerpsisongs});

    log('最新最热歌曲完成');
  }

  Future<void> writeNearcadeAllShopAndNearcadeGames() async {
    int page = 1;
    List shopsList = [];
    bool hasNext = true;
    while (hasNext) {
      final rawJson = await requestNearcadeAllShop(page: page); // 请求当前页
      final result = await jsonDecode(rawJson) as Map<String, dynamic>;

      if (result.containsKey('shops')) {
        shopsList.addAll(result['shops']);
      }
      hasNext = result['hasNextPage'];
      log('有下一页');
      page++;
    }
    Map<String, dynamic> gameList = {};
    for (var i in shopsList) {
      for (var j in i['games']) {
        gameList['${j['titleId']}'] = '${j['name']}';
      }
    }
    await LocalDB.Post('NearcadeAllShop', {"NearcadeAllShopData": shopsList});
    log('Nearcade店铺完成');
    await LocalDB.Post('NearcadeGamesData', gameList);
    log('Nearcade游戏完成');
  }

  Future<void> writeSegaCharaData() async {
    String result = await requestSegaCharaData();
    await LocalDB.Post('SegaCharaData', jsonDecode(result));
    log('Sega角色完成');
  }

  Future<void> writeConfig(Map<String, dynamic> config) async {
    await LocalDB.Post('Config', config);
  }

  Future<void> writeLatestVersion() async {
    String result = await requestLatestVersion();
    await LocalDB.Post('LatestVersion', jsonDecode(result));
    log('最新版本号获取完成');
  }

  Future<void> writePlayerB50Data() async {
    String result = await requestB50();
    await LocalDB.Post('PlayerB50Data', jsonDecode(result));
    log('B50完成');
  }

  Future<void> writePlayerInfoData() async {
    String result = await requestPlayerInfo();
    await LocalDB.Post('PlayerInfoData', jsonDecode(result));
    log('玩家信息完成');
  }

  Future<void> writePlayerRatingTrendData() async {
    String result = await requestTrend();
    await LocalDB.Post('PlayerRatingTrendData', jsonDecode(result));
    log('Rating趋势完成');
  }

  Future<void> writePlayerAllScoreData() async {
    String result = await requestPlayerAllScore();
    await LocalDB.Post('PlayerAllScoreData', jsonDecode(result));
    log('所有成绩完成');
  }

  Future<void> writeFavoriteSongs(Map<String, dynamic> favorite) async {
    await LocalDB.Post('FavoriteSongs', favorite);
  }

  Future<void> writeRandomMusicHistory(List history) async {
    await LocalDB.Post('RandomMusicHistory', {"randomMusicHistory": history});
  }
}

class ReadData {
  ReadData._();

  static Future<ReadData> create() async {
    return ReadData._();
  }

  Future<Map<String, dynamic>> readLinkedVerseData() async {
    final result = await LocalDB.GetById('LinkedVerseData');
    final model = result.getOrDefault(null);
    return model?.data ?? {};
  }

  Future<Map<String, dynamic>> readPlateData() async {
    final result = await LocalDB.GetById('PlatesData');
    final model = result.getOrDefault(null);
    return model?.data ?? {};
  }

  Future<Map<String, dynamic>> readIconsData() async {
    final result = await LocalDB.GetById('IconsData');
    final model = result.getOrDefault(null);
    return model?.data ?? {};
  }

  Future<Map<String, dynamic>> readTrophiesData() async {
    final result = await LocalDB.GetById('TrophiesData');
    final model = result.getOrDefault(null);
    return model?.data ?? {};
  }

  Future<Map<String, dynamic>> readCharactersData() async {
    final result = await LocalDB.GetById('CharactersData');
    final model = result.getOrDefault(null);
    return model?.data ?? {};
  }

  Future<Map<String, dynamic>> readSongsData() async {
    final result = await LocalDB.GetById('SongsData');
    final model = result.getOrDefault(null);
    return model?.data ?? {};
  }

  Future<List> readWahlapLobbyData() async {
    final result = await LocalDB.GetById('WahlapLobbyData');
    final model = result.getOrDefault(null);
    return (model?.data['WahlapLobbyData'] as List?) ?? [];
  }

  Future<Map<String, dynamic>> readAliasData() async {
    final result = await LocalDB.GetById('AliasData');
    final model = result.getOrDefault(null);
    return model?.data ?? {};
  }

  Future<List> readzxzrSongsData() async {
    final result = await LocalDB.GetById('zxzrSongsData');
    final model = result.getOrDefault(null);
    return (model?.data['zxzrSongsData'] as List?) ?? [];
  }

  Future<List> readNearcadeAllShop() async {
    final result = await LocalDB.GetById('NearcadeAllShop');
    final model = result.getOrDefault(null);
    return (model?.data['NearcadeAllShopData'] as List?) ?? [];
  }

  Future<Map<String, dynamic>> readNearcadeGamesMapData() async {
    final result = await LocalDB.GetById('NearcadeGamesMap');
    final model = result.getOrDefault(null);
    return model?.data ?? {};
  }

  Future<List> readSegaCharaData() async {
    final result = await LocalDB.GetById('SegaCharaData');
    final model = result.getOrDefault(null);
    return (model?.data['SegaCharaData'] as List?) ?? [];
  }

  Future<Map<String, dynamic>> readConfig() async {
    final result = await LocalDB.GetById('Config');
    final model = result.getOrDefault(null);
    return model?.data ?? {};
  }

  Future<Map<String, dynamic>> readLatestVersion() async {
    final result = await LocalDB.GetById('LatestVersion');
    final model = result.getOrDefault(null);
    return model?.data ?? {};
  }

  Future<Map<String, dynamic>> readPlayerB50Data() async {
    final result = await LocalDB.GetById('PlayerB50Data');
    final model = result.getOrDefault(null);
    return model?.data ?? {};
  }

  Future<Map<String, dynamic>> readPlayerInfoData() async {
    final result = await LocalDB.GetById('PlayerInfoData');
    final model = result.getOrDefault(null);
    return (model?.data['data'] as Map<String, dynamic>?) ?? {};
  }

  Future<List> readPlayerRatingTrendData() async {
    final result = await LocalDB.GetById('PlayerRatingTrendData');
    final model = result.getOrDefault(null);
    return (model?.data['PlayerRatingTrendData'] as List?) ?? [];
  }

  Future<List> readPlayerAllScoreData() async {
    final result = await LocalDB.GetById('PlayerAllScoreData');
    final model = result.getOrDefault(null);
    return (model?.data['PlayerAllScoreData'] as List?) ?? [];
  }

  Future<Map<String, dynamic>> readFavoriteSongs() async {
    final result = await LocalDB.GetById('FavoriteSongs');
    final model = result.getOrDefault(null);
    return model?.data ?? {};
  }

  Future<List> readRandomMusicHistory() async {
    final result = await LocalDB.GetById('RandomMusicHistory');
    final model = result.getOrDefault(null);
    return (model?.data['RandomMusicHistory'] as List?) ?? [];
  }
}

class SongDataStore {
  SongDataStore._();
  static final SongDataStore instance = SongDataStore._();

  Map<String, dynamic> songsData = {};
  Map<String, dynamic> aliasData = {};
  Map<String, dynamic> playerInfoData = {};
  Map<String, dynamic> playerB50Data = {};
  List playerRatingTrendData = [];
  List playerAllScore = [];
  Map<String, dynamic> collectionTrophies = {};
  Map<String, dynamic> collectionCharacters = {};
  Map<String, dynamic> collectionPlate = {};
  Map<String, dynamic> collectionIcons = {};
  Map<String, dynamic> latestVersion = {};

  List zxzrSongsData = [];
  List segaCharacters = [];
  bool loaded = false;

  Future<void> loadAll() async {
    final read = await ReadData.create();
    songsData = await read.readSongsData();
    aliasData = await read.readAliasData();
    zxzrSongsData = await read.readzxzrSongsData();
    playerAllScore = await read.readPlayerAllScoreData();
    collectionTrophies = await read.readTrophiesData();
    collectionCharacters = await read.readCharactersData();
    collectionPlate = await read.readPlateData();
    collectionIcons = await read.readIconsData();
    segaCharacters = await read.readSegaCharaData();
    playerInfoData = await read.readPlayerInfoData();
    playerB50Data = await read.readPlayerB50Data();
    latestVersion = await read.readLatestVersion();
    playerRatingTrendData = await read.readPlayerRatingTrendData();
    loaded = true;
  }
}
