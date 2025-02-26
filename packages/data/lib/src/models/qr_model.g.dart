// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QRModelAdapter extends TypeAdapter<QRModel> {
  @override
  final int typeId = 0;

  @override
  QRModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QRModel(
      code: fields[0] as String,
      timestamp: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, QRModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QRModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
