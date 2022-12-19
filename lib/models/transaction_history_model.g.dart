// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionHistoryAdapter extends TypeAdapter<TransactionHistory> {
  @override
  final int typeId = 2;

  @override
  TransactionHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionHistory(
      transactionHash: fields[0] as String,
      transactionIndex: fields[1] as String,
      blockHash: fields[2] as String,
      cumulativeGasUsed: fields[3] as String,
      blockNumber: fields[4] as String,
      contractAddress: fields[5] as String,
      status: fields[6] as String,
      from: fields[7] as String,
      to: fields[8] as String,
      gasUsed: fields[9] as String,
      effectiveGasPrice: fields[10] as String,
      currentNetwork: fields[11] as String,
      logs: fields[12] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionHistory obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.transactionHash)
      ..writeByte(1)
      ..write(obj.transactionIndex)
      ..writeByte(2)
      ..write(obj.blockHash)
      ..writeByte(3)
      ..write(obj.cumulativeGasUsed)
      ..writeByte(4)
      ..write(obj.blockNumber)
      ..writeByte(5)
      ..write(obj.contractAddress)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.from)
      ..writeByte(8)
      ..write(obj.to)
      ..writeByte(9)
      ..write(obj.gasUsed)
      ..writeByte(10)
      ..write(obj.effectiveGasPrice)
      ..writeByte(11)
      ..write(obj.currentNetwork)
      ..writeByte(12)
      ..write(obj.logs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
