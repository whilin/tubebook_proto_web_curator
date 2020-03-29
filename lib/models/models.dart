
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

class KeyValue {
  String key;
  String value;

  KeyValue(this.key, this.value);


  static KeyValue findKeyValue(List<KeyValue> list, String key) {
    KeyValue e;

    try {
      e = list.firstWhere((element) => element.key == key);
    } catch (ex) {
      e = list[0];
    }

    return e;
  }

  static void initList(List<KeyValue> list) {
    list.clear();
    list.add(new KeyValue('','none'));
  }

  static void initList_append(List<KeyValue> list, List<KeyValue> append) {
    list.clear();
    list.add(new KeyValue('','none'));
    list.addAll(append);
  }
}


@JsonSerializable()
class DBEntity {
  String _id;

  DBEntity();

  DBEntity.fromJson(Map<String, dynamic> map) : _id = map['_id'];

  String get objectId {
    return _id;
  }

}


class VideoDesc extends DBEntity {
  String videoKey;
  String channelId;
  String description;
  String title;

  String hintTopic;
  String hintLesson;

  VideoDesc();

  VideoDesc.fromJson(Map<String, dynamic> map) :
    videoKey = map['videoKey'],
    channelId = map['channelId'],
    description = map['description'],
    title = map['title'],
        hintTopic = map['hintTopic'],
        hintLesson = map['hintLesson'],

      super.fromJson(map);

  Map<String, dynamic> toJson() {
    var map = {
      '_id' : objectId,
      'videoKey' :  videoKey,
      'channelId' :  channelId,
      'description':  description,
      'title':  title,
      'hintTopic': hintTopic,
      'hintLesson': hintLesson,

    };

    return map;
  }
}


class ChannelDesc extends DBEntity {

  String channelId;
  String name;

  ChannelDesc(this.channelId);

  ChannelDesc.fromJson(Map<String, dynamic> map) :
        channelId = map['channelId'],
        name = map['name'],
        super.fromJson(map);

  Map<String, dynamic> toJson() {
    var map = {
      '_id' : objectId,
      'channelId' :  channelId,
      'name':  name,
    };

    return map;
  }
}


enum LessonLevel {
  Beginnger,
  Intermediate,
  Advanced,
}


@JsonSerializable()
class LessonVideo {
  String videoKey;
  String title;

  LessonVideo();

  factory LessonVideo.fromJson(Map<String, dynamic> json) => _$LessonVideoFromJson(json);
  Map<String, dynamic> toJson() =>_$LessonVideoToJson(this);
}

@JsonSerializable()
class LessonDesc extends DBEntity {

  String lessonId;

  String mainTopicId;
  String youtuberId;

  String title;
  String description;
  Set<String> tags;

  LessonLevel level;
  int recommanded;

  String imageAssetPath;

  List<String> videoList = List<String>();

  List<LessonVideo> videoListEx = new List<LessonVideo>();

  LessonDesc(this.lessonId);
  LessonDesc.gen(this.mainTopicId, this.lessonId);

  factory LessonDesc.fromJson(Map<String, dynamic> json) => _$LessonDescFromJson(json);
  Map<String, dynamic> toJson() =>_$LessonDescToJson(this);

}

class TopicDesc extends DBEntity {
  String topicId;
  String name;
  String section;

  TopicDesc(this.topicId);

  TopicDesc.fromJson(Map<String, dynamic> map) :
        topicId = map['topicId'],
        name = map['name'],
        section = map['section'],
        super.fromJson(map);

  Map<String, dynamic> toJson() {
    var map = {
      '_id' : objectId,
      'topicId' :  topicId,
      'name':  name,
      'section' : section,
    };

    return map;
  }
}

//const List<String> topics = ['-', 'java','swift','flutter','etc'];

