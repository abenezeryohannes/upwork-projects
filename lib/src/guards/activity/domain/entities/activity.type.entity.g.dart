// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.type.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityTypeEntity _$ActivityTypeEntityFromJson(Map<String, dynamic> json) =>
    ActivityTypeEntity(
      color: json['color'] as String?,
      needApproval: json['needApproval'] as bool? ?? true,
      name: json['name'] as String,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$ActivityTypeEntityToJson(ActivityTypeEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'icon': instance.icon,
      'color': instance.color,
      'needApproval': instance.needApproval,
    };
