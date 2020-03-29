import 'package:mongo_dart/mongo_dart.dart';

class DBEntity {
  ObjectId _id;
}

class _VideoDesc extends DBEntity {
  String videoKey;
  String channelId;
  String description;
  String title;
}


//https://pub.dev/packages/mongo_dart#-readme-tab-

class _DbManager  {
  static _DbManager _singleton = _DbManager._internal();

  _DbManager._internal();

  factory _DbManager.singleton() {
    return _singleton;
  }

  Db db = new Db("mongodb://127.0.0.1:27017/MyTubeBook");

  Future<List<_VideoDesc>> loadVideoList() async {
    await db.open();
    var coll = db.collection('VideoCollection');

    var list = await coll.find().toList();

    print("Collection >"+list.length.toString());

    return null;
  }
}