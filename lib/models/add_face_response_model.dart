import 'package:json_annotation/json_annotation.dart';

part 'add_face_response_model.g.dart';

@JsonSerializable()
class AddFaceResponseModel {
  final String imageId;
  final String subject;

  const AddFaceResponseModel({required this.imageId, required this.subject});

  factory AddFaceResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AddFaceResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddFaceResponseModelToJson(this);
}
