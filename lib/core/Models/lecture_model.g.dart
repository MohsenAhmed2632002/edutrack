// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecture_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LectureModelAdapter extends TypeAdapter<LectureModel> {
  @override
  final int typeId = 0;

  @override
  LectureModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LectureModel(
      subject: fields[0] as String,
      doctor: fields[1] as String,
      timeFrom: fields[2] as String,
      timeTo: fields[3] as String,
      date: fields[4] as String,
      location: fields[5] as String,
      dayOfWeek: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LectureModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.subject)
      ..writeByte(1)
      ..write(obj.doctor)
      ..writeByte(2)
      ..write(obj.timeFrom)
      ..writeByte(3)
      ..write(obj.timeTo)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.dayOfWeek);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LectureModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
