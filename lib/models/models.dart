
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

class KeyName {
  dynamic key;
  String value;

  KeyName(this.key, this.value);


  static KeyName findKeyValue(List<KeyName> list, dynamic key) {
    KeyName e;

    try {
      e = list.firstWhere((element) => element.key == key);
    } catch (ex) {
      e = list[0];
    }

    return e;
  }

  static void initList(List<KeyName> list) {
    list.clear();
    list.add(new KeyName('','none'));
  }

  static void initList_append(List<KeyName> list, List<KeyName> append) {
    list.clear();
    list.add(new KeyName('','none'));
    list.addAll(append);
  }
}

List<KeyName> markKeyName = [
  KeyName(0, '미분류'),
  KeyName(1, '처리'),
  KeyName(10, '삭제'),
];

List<KeyName> LessonLevelKeyNameList = [
  KeyName(LessonLevel.Beginnger, 'Beginnger'),
  KeyName(LessonLevel.Intermediate, 'Intermediate'),
  KeyName(LessonLevel.Advanced, 'Advanced'),
];

List<KeyName> ChannelTypeKeyNameList = [
  KeyName(ChannelType.Creator, 'Creator'),
  KeyName(ChannelType.Curator, '큐레이터'),
];

List<KeyName> TopicTypeKeyNameList = [
  KeyName(TopicType.Category, 'Category'),
  KeyName(TopicType.Curation, 'Curation'),
];



enum LessonLevel {
  Beginnger,
  Intermediate,
  Advanced,
}


enum ChannelType {
  Creator,
  Curator
}

enum TopicType {
  Category,
  Curation
}


@JsonSerializable()
class DBEntity {

  @JsonKey(name : '_id')
  String id;

  DBEntity();

  DBEntity.fromJson(Map<String, dynamic> map) : id = map['_id'];

  String get objectId {
    return id;
  }

}


@JsonSerializable()
class VideoDesc extends DBEntity {

  String videoKey;
  String channelId;
  String description;
  String title;

  String hintTopic;
  String hintLesson;
  int markTag;

  VideoDesc();


  factory VideoDesc.fromJson(Map<String, dynamic> json) => _$VideoDescFromJson(json);
  Map<String, dynamic> toJson() =>_$VideoDescToJson(this);
}


@JsonSerializable()
class ChannelDesc extends DBEntity {

  String channelId;
  String name;

  @JsonKey(defaultValue: ChannelType.Creator)
  ChannelType channelType;

  ChannelDesc(this.channelId);

  factory ChannelDesc.fromJson(Map<String, dynamic> json) => _$ChannelDescFromJson(json);
  Map<String, dynamic> toJson() =>_$ChannelDescToJson(this);
}


@JsonSerializable()
class LessonVideo {

  String videoKey;
  String title;

  String duration;
  String thumnail_url;

  LessonVideo();

  factory LessonVideo.fromJson(Map<String, dynamic> json) => _$LessonVideoFromJson(json);
  Map<String, dynamic> toJson() =>_$LessonVideoToJson(this);
}

@JsonSerializable()
class LessonDesc extends DBEntity {

  String lessonId;

  String mainTopicId;
  String subTopicId;

  String youtuberId;

  String title;
  String description;
  String detailDescription;

  Set<String> tags;

  LessonLevel level;
  int recommanded;

  String imageAssetPath;

  int publish;

  //List<String> videoList = List<String>();

  List<LessonVideo> videoListEx = new List<LessonVideo>();

  LessonDesc(this.lessonId);
  LessonDesc.gen(this.mainTopicId, this.lessonId);

  factory LessonDesc.fromJson(Map<String, dynamic> json) => _$LessonDescFromJson(json);
  Map<String, dynamic> toJson() =>_$LessonDescToJson(this);

}

@JsonSerializable()
class TopicDesc extends DBEntity {
  String topicId;
  String name;

  String section;

  @JsonKey(defaultValue: TopicType.Category)
  TopicType topicType;
  String channelId; //Creator or Curator Id

  TopicDesc(this.topicId);
  

  factory TopicDesc.fromJson(Map<String, dynamic> json) => _$TopicDescFromJson(json);
  Map<String, dynamic> toJson() =>_$TopicDescToJson(this);
}

//const List<String> topics = ['-', 'java','swift','flutter','etc'];

