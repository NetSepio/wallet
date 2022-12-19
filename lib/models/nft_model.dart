import 'package:hive/hive.dart';

part 'nft_model.g.dart'; 

@HiveType(typeId: 1)
class NFTModel {
  @HiveField(0)
  final String tokenName;
  @HiveField(1)
  final String symbol;
  @HiveField(2)
  final String tokenAddress;
  @HiveField(3)
  final int tokenID;
  @HiveField(4)
  final String currentNetwork;

  NFTModel({
    required this.tokenName,
    required this.symbol,
    required this.tokenAddress,
    required this.tokenID,
    required this.currentNetwork,
  });
}
