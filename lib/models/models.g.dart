// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DBEntity _$DBEntityFromJson(Map<String, dynamic> json) {
  return DBEntity()..id = json['_id'] as String;
}

Map<String, dynamic> _$DBEntityToJson(DBEntity instance) => <String, dynamic>{
      '_id': instance.id,
    };

VideoDesc _$VideoDescFromJson(Map<String, dynamic> json) {
  return VideoDesc()
    ..id = json['_id'] as String
    ..videoKey = json['videoKey'] as String
    ..channelId = json['channelId'] as String
    ..description = json['description'] as String
    ..title = json['title'] as String
    ..hintTopic = json['hintTopic'] as String
    ..hintLesson = json['hintLesson'] as String
    ..markTag = json['markTag'] as int;
}

Map<String, dynamic> _$VideoDescToJson(VideoDesc instance) => <String, dynamic>{
      '_id': instance.id,
      'videoKey': instance.videoKey,
      'channelId': instance.channelId,
      'description': instance.description,
      'title': instance.title,
      'hintTopic': instance.hintTopic,
      'hintLesson': instance.hintLesson,
      'markTag': instance.markTag,
    };

ChannelDesc _$ChannelDescFromJson(Map<String, dynamic> json) {
  return ChannelDesc(
    json['channelId'] as String,
  )
    ..id = json['_id'] as String
    ..name = json['name'] as String
    ..channelType =
        _$enumDecodeNullable(_$ChannelTypeEnumMap, json['channelType']) ??
            ChannelType.Creator
    ..yt_thumnail_default_url = json['yt_thumnail_default_url'] as String
    ..yt_thumnail_medium_url = json['yt_thumnail_medium_url'] as String
    ..yt_thumnail_high_url = json['yt_thumnail_high_url'] as String
    ..yt_publishedAt = json['yt_publishedAt'] as String;
}

Map<String, dynamic> _$ChannelDescToJson(ChannelDesc instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'channelId': instance.channelId,
      'name': instance.name,
      'channelType': _$ChannelTypeEnumMap[instance.channelType],
      'yt_thumnail_default_url': instance.yt_thumnail_default_url,
      'yt_thumnail_medium_url': instance.yt_thumnail_medium_url,
      'yt_thumnail_high_url': instance.yt_thumnail_high_url,
      'yt_publishedAt': instance.yt_publishedAt,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ChannelTypeEnumMap = {
  ChannelType.Creator: 'Creator',
  ChannelType.Curator: 'Curator',
};

LessonVideo _$LessonVideoFromJson(Map<String, dynamic> json) {
  return LessonVideo()
    ..videoKey = json['videoKey'] as String
    ..title = json['title'] as String
    ..yt_title = json['yt_title'] as String
    ..yt_duration = json['yt_duration'] as String
    ..yt_thumnail_default_url = json['yt_thumnail_default_url'] as String
    ..yt_thumnail_medium_url = json['yt_thumnail_medium_url'] as String
    ..yt_thumnail_high_url = json['yt_thumnail_high_url'] as String
    ..yt_publishedAt = json['yt_publishedAt'] as String
    ..durationH = json['durationH'] as int
    ..durationM = json['durationM'] as int
    ..durationS = json['durationS'] as int;
}

Map<String, dynamic> _$LessonVideoToJson(LessonVideo instance) =>
    <String, dynamic>{
      'videoKey': instance.videoKey,
      'title': instance.title,
      'yt_title': instance.yt_title,
      'yt_duration': instance.yt_duration,
      'yt_thumnail_default_url': instance.yt_thumnail_default_url,
      'yt_thumnail_medium_url': instance.yt_thumnail_medium_url,
      'yt_thumnail_high_url': instance.yt_thumnail_high_url,
      'yt_publishedAt': instance.yt_publishedAt,
      'durationH': instance.durationH,
      'durationM': instance.durationM,
      'durationS': instance.durationS,
    };

LessonDesc _$LessonDescFromJson(Map<String, dynamic> json) {
  return LessonDesc(
    json['lessonId'] as String,
  )
    ..id = json['_id'] as String
    ..mainTopicId = json['mainTopicId'] as String
    ..subTopicId = json['subTopicId'] as String
    ..youtuberId = json['youtuberId'] as String
    ..title = json['title'] as String
    ..description = json['description'] as String
    ..detailDescription = json['detailDescription'] as String
    ..tags = (json['tags'] as List)?.map((e) => e as String)?.toSet()
    ..level = _$enumDecodeNullable(_$LessonLevelEnumMap, json['level'])
    ..recommanded = json['recommanded'] as int
    ..imageAssetPath = json['imageAssetPath'] as String
    ..publish = json['publish'] as int
    ..videoListEx = (json['videoListEx'] as List)
        ?.map((e) =>
            e == null ? null : LessonVideo.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$LessonDescToJson(LessonDesc instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'lessonId': instance.lessonId,
      'mainTopicId': instance.mainTopicId,
      'subTopicId': instance.subTopicId,
      'youtuberId': instance.youtuberId,
      'title': instance.title,
      'description': instance.description,
      'detailDescription': instance.detailDescription,
      'tags': instance.tags?.toList(),
      'level': _$LessonLevelEnumMap[instance.level],
      'recommanded': instance.recommanded,
      'imageAssetPath': instance.imageAssetPath,
      'publish': instance.publish,
      'videoListEx': instance.videoListEx,
    };

const _$LessonLevelEnumMap = {
  LessonLevel.Beginnger: 'Beginnger',
  LessonLevel.Intermediate: 'Intermediate',
  LessonLevel.Advanced: 'Advanced',
};

TopicDesc _$TopicDescFromJson(Map<String, dynamic> json) {
  return TopicDesc(
    json['topicId'] as String,
  )
    ..id = json['_id'] as String
    ..name = json['name'] as String
    ..section = json['section'] as String
    ..topicType = _$enumDecodeNullable(_$TopicTypeEnumMap, json['topicType']) ??
        TopicType.Category
    ..channelId = json['channelId'] as String;
}

Map<String, dynamic> _$TopicDescToJson(TopicDesc instance) => <String, dynamic>{
      '_id': instance.id,
      'topicId': instance.topicId,
      'name': instance.name,
      'section': instance.section,
      'topicType': _$TopicTypeEnumMap[instance.topicType],
      'channelId': instance.channelId,
    };

const _$TopicTypeEnumMap = {
  TopicType.Category: 'Category',
  TopicType.Curation: 'Curation',
};
