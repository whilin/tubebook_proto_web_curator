
import 'dart:convert';

import 'package:flutter/cupertino.dart';
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

  KeyValue findChannelKeyValue(String channelId) {

    try {
      var desc = channelList.firstWhere((element) =>
      element.channelId == channelId);
      return new KeyValue(desc.channelId, desc.name);
    } catch (ex) {
      return new KeyValue(channelId, channelId);
    }
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
}