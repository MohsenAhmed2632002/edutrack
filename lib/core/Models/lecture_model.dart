// ✅ LectureModel: Ensure toMap and fromMap are implemented
import 'package:hive/hive.dart';
part 'lecture_model.g.dart';

@HiveType(typeId: 0)
class LectureModel {
  @HiveField(0)
  final String subject;
  @HiveField(1)
  final String doctor;
  @HiveField(2)
  final String timeFrom;
  @HiveField(3)
  final String timeTo;
  @HiveField(4)
  final String date;
  @HiveField(5)
  final String location;
  @HiveField(6)
  final String dayOfWeek;

  LectureModel({
    required this.subject,
    required this.doctor,
    required this.timeFrom,
    required this.timeTo,
    required this.date,
    required this.location,
    required this.dayOfWeek,
  });

  factory LectureModel.fromMap(Map<String, dynamic> map, String day) {
    return LectureModel(
      subject: map['المادة'] ?? 'غير محدد',
      doctor: map['الدكتور'] ?? 'غير محدد',
      timeFrom: map['من'] ?? '',
      timeTo: map['إلى'] ?? '',
      location: map['المكان'] ?? 'غير محدد',
      date: map['date'] ?? '',
      dayOfWeek: day,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'المادة': subject,
      'الدكتور': doctor,
      'من': timeFrom,
      'إلى': timeTo,
      'المكان': location,
      'date': date,
    };
  }
}