
import 'dart:convert';

import 'package:flutter/material.dart';

import 'db_manager.dart';
import 'db_proxy.dart';
import '../models/models.dart';


class VideoDataManager extends DataManager with ChangeNotifier {
  static VideoDataManager _singleton = VideoDataManager._internal();

  VideoDataManager._internal();

  factory VideoDataManager.singleton() {
    return _singleton;
  }

  static const String VideoCollectionName = 'VideoCollection';

  /*****************************************************
   *
   *
   *
   *****************************************************/

  final List<VideoDesc> videoList = new List<VideoDesc>();

  Future<List<VideoDesc>> loadVideoList(dynamic where, int page, int pageCount) async {

    Map<String, dynamic> query = new Map<String, dynamic>();
    query["where"] = where;
    query['page'] = {
      'page' : page,
      'pageCount' : pageCount
    };

    String body = jsonEncode(query);
    print("loadVideoList Query:"+body);

    var jsonResponse = await super.proxy.request(VideoCollectionName, DbOpName.find, query);

    List<dynamic> list = jsonDecode(jsonResponse);

    List<VideoDesc> videoList = new List<VideoDesc>();

    for (dynamic jsonObj in list) {
      VideoDesc desc = VideoDesc.fromJson(jsonObj);
      videoList.add(desc);
    }

    print("loadVideoList items:" + videoList.length.toString());

    return videoList;
  }


  Future<VideoDesc> findVideo(String videoKey) async {

    Map<String, dynamic> query = new Map<String, dynamic>();
    query["where"] = {
      'videoKey' : videoKey
    };

    String body = jsonEncode(query);
    print("loadVideoList Query:"+body);

    var jsonResponse = await super.proxy.request(VideoCollectionName, DbOpName.find, query);

    List<dynamic> list = jsonDecode(jsonResponse);
    List<VideoDesc> videoList = new List<VideoDesc>();

    for (dynamic jsonObj in list) {
      VideoDesc desc = VideoDesc.fromJson(jsonObj);
      print('findVideo get: $videoKey');
      return desc;
    }

    print('findVideo faild: $videoKey');
    return null;
  }

  Future<bool> insertVideo(VideoDesc desc) async {
    Map<String, dynamic> query = new Map<String, dynamic>();
    query['doc'] = desc;
    var jsonResponse = await super.proxy.request(VideoCollectionName, DbOpName.insertOne, query);

    // await loadLessonList();
    return true;
  }

  Future<bool> updateVideo(VideoDesc desc) async {

    var doc = desc.toJson();

    Map<String, dynamic> query = new Map<String, dynamic>();
    query['where'] = {
      '_id' :doc['_id'],
    };
    query['set'] = doc;

    print('updateVideo');

    var jsonResponse = await super.proxy.request(VideoCollectionName, DbOpName.findOneAndUpdate, query);

    var jsonObj = jsonDecode(jsonResponse);
    var docJson = jsonObj['value'];

    // var newDoc = VideoDesc.fromJson(docJson);

    print("updateVideo response:" + jsonResponse);

    return true;
  }

  Future<bool> deleteVideo(VideoDesc desc) async {
    Map<String, dynamic> query = new Map<String, dynamic>();
    query['where'] = {
      '_id' : desc.objectId,
    };

    var jsonResponse = await super.proxy.request(VideoCollectionName, DbOpName.findOneAndDelete, query);

    //await loadTopicList();
    return true;
  }

  Future<int> countVideoList(dynamic where) async {

    Map<String, dynamic> query = new Map<String, dynamic>();
    query['where'] = where;

    var jsonResponse = await super.proxy.request(VideoCollectionName, DbOpName.count, query);

    var jsonObj = jsonDecode(jsonResponse);
    var count =  jsonObj['count'];// int.parse(jsonResponse);

    print("countVideoList response: $count");

    return count;
  }

  Future<List<String>> getUniqueChannels() async {

    Map<String, dynamic> query = new Map<String, dynamic>();
    query['group'] = {
      '_id' : {
        'channelId' : '\$channelId'
      },
      'count' : { '\$sum' : 1}
    };
    query['project'] = {
      'channelId' : '\$channelId',
      'count' : '\$count'
    };

    var jsonResponse = await super.proxy.request(VideoCollectionName, DbOpName.group, query);
    var jsonList = jsonDecode(jsonResponse);

    List<String> tolist = new List<String>();

    for(var jsonObj in jsonList) {
      String channelId  = jsonObj['_id']['channelId'];
      String channelName  =  channelId;//jsonObj['_id']['description'];

      int count = jsonObj['count'];
      tolist.add(channelId);//new KeyValue(channelId, channelName));
    }

    return tolist;
  }


  Future<int> countVideoInChannel(String channelId) async {

    Map<String, dynamic> query = new Map<String, dynamic>();
    query['where'] = {
      'channelId' : channelId
    };

    var jsonResponse = await super.proxy.request(VideoCollectionName, DbOpName.count, query);

    var jsonObj = jsonDecode(jsonResponse);
    var count =  jsonObj['count'];// int.parse(jsonResponse);

    print("countVideoList response: $count");

    return count;
  }
}