
import 'dart:convert';

import 'package:flutter/material.dart';

import 'db_proxy.dart';
import '../models/models.dart';
import 'db_manager.dart';

class TopicDataManager extends DataManager with ChangeNotifier {

  static TopicDataManager _singleton = TopicDataManager._internal();

  TopicDataManager._internal();

  factory TopicDataManager.singleton() {
    return _singleton;
  }

  static const String VideoCollectionName = 'TopicCollection';

  final List<TopicDesc> topicList = new  List<TopicDesc>();

  /*****************************************************
   *
   * Topic
   *
   *****************************************************/

//  ChannelDesc findChannel(String channelId) {
//    return channelList.firstWhere((element) => element.channelId == channelId);
//  }

  KeyName findTopicKeyValue(String channelId) {

    try {
      var desc = topicList.firstWhere((element) =>
      element.topicId == channelId);
      return new KeyName(desc.topicId, desc.name);
    }catch(ex) {
      return new KeyName(channelId, channelId);
    }
  }


  List<KeyName> findTopicKeyValuesAtCategory() {
    var descList = topicList.where((element) => element.topicType == TopicType.Category).toList();

    var desc = descList.map((element) =>
     new KeyName(element.topicId, element.name)).toList();
    return desc;
  }


  List<KeyName> findTopicKeyValuesAtCuration() {
    var descList = topicList.where((element) => element.topicType == TopicType.Curation).toList();

    var desc = descList.map((element) =>
    new KeyName(element.topicId, element.name)).toList();
    return desc;
  }



  Future<List<TopicDesc>> loadTopicList() async {
    Map<String, dynamic> query = new Map<String, dynamic>();

    String body = jsonEncode(query);
    print("loadTopicList Query:"+body);

    var jsonResponse = await super.proxy.request('TopicCollection', DbOpName.find, query);

    List<dynamic> list = jsonDecode(jsonResponse);

    topicList.clear();

    for (dynamic jsonObj in list) {
      TopicDesc desc = TopicDesc.fromJson(jsonObj);
      topicList.add(desc);
    }

    print("loadTopicList items:" + topicList.length.toString());

    return topicList;
  }

  Future<bool> insertTopic(TopicDesc desc) async {

    Map<String, dynamic> query = new Map<String, dynamic>();
    query['doc'] = desc;
    var jsonResponse = await super.proxy.request('TopicCollection', DbOpName.insertOne, query);

    await loadTopicList();
    return true;
  }

  Future<bool> updateTopic(TopicDesc desc) async {
    Map<String, dynamic> query = new Map<String, dynamic>();
    query['where'] = {
      '_id' : desc.objectId,
    };
    query['set'] = desc;

    var jsonResponse = await super.proxy.request('TopicCollection', DbOpName.findOneAndUpdate, query);

    return true;
  }

  Future<bool> deleteTopic(TopicDesc desc) async {
    Map<String, dynamic> query = new Map<String, dynamic>();
    query['where'] = {
      '_id' : desc.objectId,
    };

    var jsonResponse = await super.proxy.request('TopicCollection', DbOpName.findOneAndDelete, query);

    await loadTopicList();
    return true;
  }
}