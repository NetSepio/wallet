// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NFTModelAdapter extends TypeAdapter<NFTModel> {
  @override
  final int typeId = 1;

  @override
  NFTModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NFTModel(
      tokenName: fields[0] as String,
      symbol: fields[1] as String,
      tokenAddress: fields[2] as String,
      tokenID: fields[3] as int,
      currentNetwork: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NFTModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.tokenName)
      ..writeByte(1)
      ..write(obj.symbol)
      ..writeByte(2)
      ..write(obj.tokenAddress)
      ..writeByte(3)
      ..write(obj.tokenID)
      ..writeByte(4)
      ..write(obj.currentNetwork);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NFTModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
