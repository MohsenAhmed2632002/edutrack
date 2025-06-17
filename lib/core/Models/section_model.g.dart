// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SectionModelAdapter extends TypeAdapter<SectionModel> {
  @override
  final int typeId = 1;

  @override
  SectionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SectionModel(
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
  void write(BinaryWriter writer, SectionModel obj) {
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
      other is SectionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
