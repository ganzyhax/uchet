// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LiverOffline.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonAdapter extends TypeAdapter<Person> {
  @override
  final int typeId = 0;

  @override
  Person read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Person(
      counter: fields[0] as String?,
      fullName: fields[1] as String?,
      id: fields[2] as String?,
      uchetId: fields[3] as String?,
      pokazanie: fields[4] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Person obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.counter)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.uchetId)
      ..writeByte(4)
      ..write(obj.pokazanie);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LiverIdAdapter extends TypeAdapter<LiverId> {
  @override
  final int typeId = 1;

  @override
  LiverId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LiverId(
      allId: fields[0] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, LiverId obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.allId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiverIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
