import 'package:cloud_firestore/cloud_firestore.dart';

class GraduationProjectModel {
  final String projectName;
  final String projectIdea;
  final String projectLink;
  final String supervisorName;
  final DateTime? createdAt; // اختيارية: وقت الإنشاء

  GraduationProjectModel({
    required this.projectName,
    required this.projectIdea,
    required this.projectLink,
    required this.supervisorName,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'projectName': projectName,
      'projectIdea': projectIdea,
      'projectLink': projectLink,
      'supervisorName': supervisorName,
      'createdAt': createdAt != null ? createdAt!.toUtc() : null,
    };
  }

  factory GraduationProjectModel.fromJson(Map<String, dynamic> json) {
    return GraduationProjectModel(
      projectName: json['projectName'] ?? '',
      projectIdea: json['projectIdea'] ?? '',
      projectLink: json['projectLink'] ?? '',
      supervisorName: json['supervisorName'] ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
    );
  }
}
