// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watering_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WateringTaskAdapter extends TypeAdapter<WateringTask> {
  @override
  final int typeId = 2;

  @override
  WateringTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WateringTask(
      id: fields[0] as String,
      plantId: fields[1] as String,
      scheduledFor: fields[2] as DateTime,
      isDone: fields[3] as bool,
      completedAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, WateringTask obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.plantId)
      ..writeByte(2)
      ..write(obj.scheduledFor)
      ..writeByte(3)
      ..write(obj.isDone)
      ..writeByte(4)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WateringTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
