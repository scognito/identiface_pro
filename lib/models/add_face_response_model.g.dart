// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_face_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddFaceResponseModel _$AddFaceResponseModelFromJson(
        Map<String, dynamic> json) =>
    AddFaceResponseModel(
      imageId: json['image_id'] as String,
      subject: json['subject'] as String,
    );

Map<String, dynamic> _$AddFaceResponseModelToJson(
        AddFaceResponseModel instance) =>
    <String, dynamic>{
      'image_id': instance.imageId,
      'subject': instance.subject,
    };
