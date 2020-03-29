
import 'dart:convert';

import 'package:flutter/material.dart';

import 'db_manager.dart';
import 'db_proxy.dart';
import '../models/models.dart';


class LessonDataManager extends DataManager with ChangeNotifier {
  static LessonDataManager _singleton = LessonDataManager._internal();

  LessonDataManager._internal();

  factory LessonDataManager.singleton() {
    return _singleton;
  }

  static const String LessonCollectionName = 'LessonCollection';

  /*****************************************************
   *
   *
   *
   *****************************************************/

  //final List<LessonDesc> lessonList = new List<LessonDesc>();

  Future<List<LessonDesc>> loadLessonList(dynamic where, int page, int pageCount) async {

    Map<String, dynamic> query = new Map<String, dynamic>();

    if(where !=null) {
      query["where"] = where;
    }

    if(page !=null && pageCount !=null) {
      query['page'] = {
        'page': page,
        'pageCount': pageCount
      };
    }

    String body = jsonEncode(query);
    print("loadLessonList Query:"+body);

    var jsonResponse = await super.proxy.request(LessonCollectionName, DbOpName.find, query);

    List<dynamic> list = jsonDecode(jsonResponse);

    List<LessonDesc> lessonList = new List<LessonDesc>();

    lessonList.clear();

    for (dynamic jsonObj in list) {
      LessonDesc desc = LessonDesc.fromJson(jsonObj);
      lessonList.add(desc);
    }

    print("loadLessonList items:" + lessonList.length.toString());

    return lessonList;
  }

  Future<List<KeyValue>> loadLessonListByTopic(String topicId) async {

    var where = {
      'mainTopicId' : topicId
    };

    var list = await  loadLessonList(where, null, null);

    return list.map((e) => new KeyValue(e.lessonId, e.title)).toList();
  }

  Future<bool> insertLesson(LessonDesc desc) async {
    Map<String, dynamic> query = new Map<String, dynamic>();
    query['doc'] = desc;
    var jsonResponse = await super.proxy.request(LessonCollectionName, DbOpName.insertOne, query);

   // await loadLessonList();
    return true;
  }

  Future<bool> updateLesson(LessonDesc desc) async {

    var doc = desc.toJson();

    Map<String, dynamic> query = new Map<String, dynamic>();
    query['where'] = {
      '_id' :doc['_id'],
    };
    query['set'] = doc;

    print('updateLesson');

    var jsonResponse = await super.proxy.request(LessonCollectionName, DbOpName.findOneAndUpdate, query);

    var jsonObj = jsonDecode(jsonResponse);
    var docJson = jsonObj['value'];

    // var newDoc = VideoDesc.fromJson(docJson);

    print("updateLesson response:" + jsonResponse);

    return true;
  }

  Future<bool> deleteLesson(LessonDesc desc) async {
    Map<String, dynamic> query = new Map<String, dynamic>();
    query['where'] = {
      '_id' : desc.objectId,
    };

    var jsonResponse = await super.proxy.request(LessonCollectionName, DbOpName.findOneAndDelete, query);

   // await loadChannelList();

    return true;
  }

  Future<int> countLesson(dynamic where) async {

    Map<String, dynamic> query = new Map<String, dynamic>();
    query['where'] = where;

    var jsonResponse = await super.proxy.request(LessonCollectionName, DbOpName.count, query);

    var jsonObj = jsonDecode(jsonResponse);
    var count =  jsonObj['count'];// int.parse(jsonResponse);

    print("countLesson response: $count");

    return count;
  }

  Future<int> countLessonInTopic(String topicId) async {

    Map<String, dynamic> query = new Map<String, dynamic>();
    query['where'] = {
      'mainTopicId' : topicId
    };

    var jsonResponse = await super.proxy.request(LessonCollectionName, DbOpName.count, query);

    var jsonObj = jsonDecode(jsonResponse);
    var count =  jsonObj['count'];// int.parse(jsonResponse);

    print("countLesson response: $count");

    return count;
  }
}