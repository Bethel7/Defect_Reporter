// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportModelAdapter extends TypeAdapter<ReportModel> {
  @override
  final int typeId = 0;

  @override
  ReportModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    final dynamic rawTimestamp = fields[5];
    DateTime timestamp;
    if (rawTimestamp is DateTime) {
      timestamp = rawTimestamp;
    } else if (rawTimestamp is String) {
      timestamp = DateTime.tryParse(rawTimestamp) ?? DateTime.now();
    } else {
      timestamp = DateTime.now();
    }
    return ReportModel(
      localId: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      status: fields[3] as String,
      imageUrl: fields[4] as String,
      timestamp: timestamp,
      latitude: fields[6] as double?,
      longitude: fields[7] as double?,
      locationName: fields[8] as String?,
      locationId: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ReportModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.localId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.latitude)
      ..writeByte(7)
      ..write(obj.longitude)
      ..writeByte(8)
      ..write(obj.locationName)
      ..writeByte(9)
      ..write(obj.locationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
