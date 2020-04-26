
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mywebapp/manager/YoutubeApi.dart';
import 'VideoDataManager.dart';
import 'db_manager.dart';
import 'db_proxy.dart';
import '../models/models.dart';
import 'db_proxy.dart';


class ChannelDataManager extends DataManager with ChangeNotifier {

  static ChannelDataManager _singleton = ChannelDataManager._internal();

  ChannelDataManager._internal();

  factory ChannelDataManager.singleton() {
    return _singleton;
  }

  static const String ChannelCollectionName = 'ChannelCollection';


  /*****************************************************
   *
   *
   *
   *****************************************************/

  final List<ChannelDesc> channelList = new  List<ChannelDesc>();

//  ChannelDesc findChannel(String channelId) {
//    return channelList.firstWhere((element) => element.channelId == channelId);
//  }

  KeyName findChannelKeyValue(String channelId) {

    try {
      var desc = channelList.firstWhere((element) =>
      element.channelId == channelId);

      return new KeyName(desc.channelId,(desc.channelType == ChannelType.Curator ? "(큐레이터)" : "") + desc.name);
    } catch (ex) {
      return new KeyName(channelId, channelId);
    }
  }

  List<KeyName> findCuratorKeyValues() {

      var descList = channelList.where((element) => element.channelType == ChannelType.Curator).toList();

      var desc = descList.map((element) =>
      new KeyName(element.channelId,(element.channelType == ChannelType.Curator ? "(큐레이터)" : "") + element.name)).toList();
      return desc;

  }



  List<KeyName> findChannelKeyValues() {

    var desc = channelList.map((element) =>
    //new KeyName(element.channelId, element.name)).toList();
    new KeyName(element.channelId,(element.channelType == ChannelType.Curator ? "(큐레이터)" : "") + element.name)).toList();

    return desc;
  }


  Future<List<ChannelDesc>> loadChannelList() async {
    Map<String, dynamic> query = new Map<String, dynamic>();

    String body = jsonEncode(query);
    print("loadChannelList Query:"+body);

    var jsonResponse = await super.proxy.request(ChannelCollectionName, DbOpName.find, query);

    List<dynamic> list = jsonDecode(jsonResponse);

    channelList.clear();

    for (dynamic jsonObj in list) {
      ChannelDesc desc = ChannelDesc.fromJson(jsonObj);
      channelList.add(desc);
    }

    print("loadChannelList items:" + channelList.length.toString());

    return channelList;
  }

  Future<bool> insertChannel(ChannelDesc desc) async {

    Map<String, dynamic> query = new Map<String, dynamic>();
    query['doc'] = desc;
    var jsonResponse = await super.proxy.request(ChannelCollectionName, DbOpName.insertOne, query);

    await loadChannelList();
    return true;

  }

  Future<bool> updateChannel(ChannelDesc desc) async {
    Map<String, dynamic> query = new Map<String, dynamic>();
    query['where'] = {
      '_id' : desc.objectId,
    };
    query['set'] = desc;

    var jsonResponse = await super.proxy.request(ChannelCollectionName, DbOpName.findOneAndUpdate, query);

    return true;
  }

  Future<bool> deleteChannel(ChannelDesc desc) async {
    Map<String, dynamic> query = new Map<String, dynamic>();
    query['where'] = {
      '_id' : desc.objectId,
    };

    var jsonResponse = await super.proxy.request(ChannelCollectionName, DbOpName.findOneAndDelete, query);

    await loadChannelList();

    return true;
  }

  Future<bool> loadChannelInfoFromYoutube(ChannelDesc desc) async {

    YoutubeChannelData data = await YoutubeApi.singleton().getChannelInfo(desc.channelId);

    if(data !=null) {
       desc.yt_publishedAt = data.publishedAt;
       desc.yt_thumnail_default_url = data.getThumnail(level: 0);
       desc.yt_thumnail_medium_url = data.getThumnail(level: 1);
       desc.yt_thumnail_high_url = data.getThumnail(level: 2);

       return true;
    } else {
      return false;
    }
  }
}