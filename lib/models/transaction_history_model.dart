import 'package:hive/hive.dart';
part 'transaction_history_model.g.dart';

@HiveType(typeId: 2)
class TransactionHistory {
  @HiveField(0)
  final String transactionHash;
  @HiveField(1)
  final String transactionIndex;
  @HiveField(2)
  final String blockHash;
  @HiveField(3)
  final String cumulativeGasUsed;
  @HiveField(4)
  final String blockNumber;
  @HiveField(5)
  final String contractAddress;
  @HiveField(6)
  final String status;
  @HiveField(7)
  final String from;
  @HiveField(8)
  final String to;
  @HiveField(9)
  final String gasUsed;
  @HiveField(10)
  final String effectiveGasPrice;
  @HiveField(11)
  final String currentNetwork;
  @HiveField(12)
  // ignore: prefer_typing_uninitialized_variables
  var logs;

  TransactionHistory({
    required this.transactionHash,
    required this.transactionIndex,
    required this.blockHash,
    required this.cumulativeGasUsed,
    this.blockNumber = "",
    required this.contractAddress,
    required this.status,
    required this.from,
    required this.to,
    required this.gasUsed,
    required this.effectiveGasPrice,
    required this.currentNetwork,
    this.logs = const [],
  });
}
