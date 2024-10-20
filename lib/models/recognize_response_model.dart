import 'package:json_annotation/json_annotation.dart';

part 'recognize_response_model.g.dart';

@JsonSerializable()
class RecognizeResponseModel {
  final List<Result> result;

  const RecognizeResponseModel({required this.result});

  factory RecognizeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RecognizeResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecognizeResponseModelToJson(this);
}

@JsonSerializable()
class Result {
  final Box box;
  final List<Subject> subjects;

  const Result({required this.box, required this.subjects});

  factory Result.fromJson(Map<String, dynamic> json) =>
      _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable()
class Box {
  final double probability;
  final int xMax;
  final int yMax;
  final int xMin;
  final int yMin;

  const Box({
    required this.probability,
    required this.xMax,
    required this.yMax,
    required this.xMin,
    required this.yMin,
  });

  factory Box.fromJson(Map<String, dynamic> json) => _$BoxFromJson(json);

  Map<String, dynamic> toJson() => _$BoxToJson(this);
}

@JsonSerializable()
class Subject {
  final String subject;
  final double similarity;

  const Subject({required this.subject, required this.similarity});

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectToJson(this);
}
