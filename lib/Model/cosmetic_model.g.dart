// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cosmetic_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CosmeticModelAdapter extends TypeAdapter<CosmeticModel> {
  @override
  final int typeId = 0;

  @override
  CosmeticModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CosmeticModel(
      id: fields[0] as int?,
      brand: fields[1] as String?,
      name: fields[2] as String?,
      price: fields[3] as String?,
      priceSign: fields[4] as String?,
      imageLink: fields[5] as String?,
      productLink: fields[6] as String?,
      websiteLink: fields[7] as String?,
      description: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CosmeticModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.brand)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.priceSign)
      ..writeByte(5)
      ..write(obj.imageLink)
      ..writeByte(6)
      ..write(obj.productLink)
      ..writeByte(7)
      ..write(obj.websiteLink)
      ..writeByte(8)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CosmeticModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
