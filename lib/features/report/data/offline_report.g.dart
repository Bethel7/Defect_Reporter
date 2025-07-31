// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_report.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineReportAdapter extends TypeAdapter<OfflineReport> {
  @override
  final int typeId = 0;

  @override
  OfflineReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineReport(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      imagePath: fields[3] as String,
      createdAt: fields[4] as DateTime,
      location: fields[5] as String,
      status: fields[6] as String? ?? 'pending',
    );
  }

  @override
  void write(BinaryWriter writer, OfflineReport obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
