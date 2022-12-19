import 'package:hive/hive.dart';

part 'token_model.g.dart';

@HiveType(typeId: 0)
class TokenModel {
  @HiveField(0)
  final String tokenName;
  @HiveField(1)
  final String symbol;
  @HiveField(2)
  final String decimal;
  @HiveField(3)
  final String tokenAddress;
  @HiveField(4)
  final String currentNetwork;

  TokenModel({
    required this.tokenName,
    required this.symbol,
    required this.decimal,
    required this.tokenAddress,
    required this.currentNetwork,
  });
}
