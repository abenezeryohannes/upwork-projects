// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeEntity _$NoticeEntityFromJson(Map<String, dynamic> json) => NoticeEntity(
      noticeFor: json['noticeFor'] as String?,
      text: json['text'] as String,
    );

Map<String, dynamic> _$NoticeEntityToJson(NoticeEntity instance) =>
    <String, dynamic>{
      'noticeFor': instance.noticeFor,
      'text': instance.text,
    };
