// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recognize_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecognizeResponseModel _$RecognizeResponseModelFromJson(
        Map<String, dynamic> json) =>
    RecognizeResponseModel(
      result: (json['result'] as List<dynamic>)
          .map((e) => Result.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecognizeResponseModelToJson(
        RecognizeResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      box: Box.fromJson(json['box'] as Map<String, dynamic>),
      subjects: (json['subjects'] as List<dynamic>)
          .map((e) => Subject.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'box': instance.box,
      'subjects': instance.subjects,
    };

Box _$BoxFromJson(Map<String, dynamic> json) => Box(
      probability: (json['probability'] as num).toDouble(),
      xMax: (json['x_max'] as num).toInt(),
      yMax: (json['y_max'] as num).toInt(),
      xMin: (json['x_min'] as num).toInt(),
      yMin: (json['y_min'] as num).toInt(),
    );

Map<String, dynamic> _$BoxToJson(Box instance) => <String, dynamic>{
      'probability': instance.probability,
      'x_max': instance.xMax,
      'y_max': instance.yMax,
      'x_min': instance.xMin,
      'y_min': instance.yMin,
    };

Subject _$SubjectFromJson(Map<String, dynamic> json) => Subject(
      subject: json['subject'] as String,
      similarity: (json['similarity'] as num).toDouble(),
    );

Map<String, dynamic> _$SubjectToJson(Subject instance) => <String, dynamic>{
      'subject': instance.subject,
      'similarity': instance.similarity,
    };
