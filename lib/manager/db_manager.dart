import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:http/http.dart' as http;
import 'package:mywebapp/manager/ChannelDataManager.dart';
import 'package:mywebapp/manager/TopicDataManager.dart';

import 'db_proxy.dart';
import '../models/models.dart';



class GlobalDataManager {

  static GlobalDataManager _singleton = GlobalDataManager._internal();

  GlobalDataManager._internal();

  factory GlobalDataManager.singleton() {
    return _singleton;
  }

  DBProxy _proxy = new DBProxy();

  Future loadInitializedData() async {
    await ChannelDataManager.singleton().loadChannelList();
    await TopicDataManager.singleton().loadTopicList();
  }
}
