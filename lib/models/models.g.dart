// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DBEntity _$DBEntityFromJson(Map<String, dynamic> json) {
  return DBEntity();
}

Map<String, dynamic> _$DBEntityToJson(DBEntity instance) => <String, dynamic>{};

LessonVideo _$LessonVideoFromJson(Map<String, dynamic> json) {
  return LessonVideo()
    ..videoKey = json['videoKey'] as String
    ..title = json['title'] as String;
}

Map<String, dynamic> _$LessonVideoToJson(LessonVideo instance) =>
    <String, dynamic>{
      'videoKey': instance.videoKey,
      'title': instance.title,
    };

LessonDesc _$LessonDescFromJson(Map<String, dynamic> json) {
  return LessonDesc(
    json['lessonId'] as String,
  )
    .._id = json['_id'] as String
    ..mainTopicId = json['mainTopicId'] as String
    ..youtuberId = json['youtuberId'] as String
    ..title = json['title'] as String
    ..description = json['description'] as String
    ..tags = (json['tags'] as List)?.map((e) => e as String)?.toSet()
    ..level = _$enumDecodeNullable(_$LessonLevelEnumMap, json['level'])
    ..recommanded = json['recommanded'] as int
    ..imageAssetPath = json['imageAssetPath'] as String
    ..videoList = (json['videoList'] as List)?.map((e) => e as String)?.toList()
    ..videoListEx = (json['videoListEx'] as List)
        ?.map((e) =>
            e == null ? null : LessonVideo.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$LessonDescToJson(LessonDesc instance) =>
    <String, dynamic>{
      '_id' : instance._id,
      'lessonId': instance.lessonId,
      'mainTopicId': instance.mainTopicId,
      'youtuberId': instance.youtuberId,
      'title': instance.title,
      'description': instance.description,
      'tags': instance.tags?.toList(),
      'level': _$LessonLevelEnumMap[instance.level],
      'recommanded': instance.recommanded,
      'imageAssetPath': instance.imageAssetPath,
      'videoList': instance.videoList,
      'videoListEx': instance.videoListEx,
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

const _$LessonLevelEnumMap = {
  LessonLevel.Beginnger: 'Beginnger',
  LessonLevel.Intermediate: 'Intermediate',
  LessonLevel.Advanced: 'Advanced',
};
