import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:NetSepio/models/nft_model.dart';
import 'package:NetSepio/models/token_model.dart';
import 'package:NetSepio/models/transaction_history_model.dart';
import 'package:NetSepio/utils/secure_storage.dart';
import 'package:NetSepio/web3dart/web3dart.dart';
import 'package:web3dart/web3dart.dart';

var box = Boxes.getdarkModeBox;

class HomeController extends GetxController {
  RxBool history = false.obs;
  RxBool showERC721 = false.obs;
  bool darkmode = box.get('isDarkMode') ?? Get.isDarkMode;
  final Box _currentNetwork = Boxes.getCurrentNetworkBox;
  final Box<TokenModel> _tokenOnCurrentNetwork =
      Boxes.getTokenOnCurrentNetworkBox;
  final Box<NFTModel> _nftOnCurrentNetwork = Boxes.getNFTOnCurrentNetworkBox;
  final Box<TransactionHistory> _transactionOnCurrentNetwork =
      Boxes.getTransactionOnCurrentNetworkBox;

  @override
  void onInit() {
    super.onInit();
    getAccountAddressAndBalance(istokenBalance: false);
  }

  Future<bool> approvalCallback() async {
    return true;
  }

  Web3 get web3 => Web3(approvalCallback);
  String get getCurrentNetwork =>
      _currentNetwork.get('current_network', defaultValue: 'Ethereum Mainnet');

  void setCurrentNetwork(String network) {
    _currentNetwork.put('current_network', network);
    update();
  }

  List<String> get networks => [
        'Ethereum Mainnet',
        'Ropsten Testnet', // uncomment them only for testing purposes...
        // 'Rinkeby Testnet',
        // 'Coerli Testnet',
        // 'Kovan Testnet',
        'Matic Mainnet',
        'Mumbai Testnet',
        'Binance Mainnet',
      ];

  String get currentNetworkLogoPath => Web3.getCurrentNetworkData['logo_path'];

  String get currentTickerSymbol => Web3.getCurrentNetworkData['symbol'];

  List<TokenModel>? get getTokenBasedOnCurrentNetwork {
    return _tokenOnCurrentNetwork.values
        .where((element) => element.currentNetwork == getCurrentNetwork)
        .toList();
  }

  List<NFTModel>? get getNFTBasedOnCurrentNetwork {
    return _nftOnCurrentNetwork.values
        .where((element) => element.currentNetwork == getCurrentNetwork)
        .toList();
  }

  List<TransactionHistory>? get getTransactionBasedOnCurrentNetwork {
    return _transactionOnCurrentNetwork.values
        .where((element) => element.currentNetwork == getCurrentNetwork)
        .toList();
  }

  String? accountAddress;
  String? pvtKey;
  Future<dynamic> getAccountAddressAndBalance(
      {required bool istokenBalance, String? tokenAddress}) async {
    final storage = SecureStorage();
    Web3 web3 = Web3(approvalCallback);
    accountAddress = await storage.getStoredValue("accountAddress");
    // print("accountAddress :- " + accountAddress.toString());
    pvtKey = await storage.getStoredValue('pvtKey');
    await web3.setCredentials(pvtKey!);
    if (istokenBalance) {
      try {
        BigInt amount1 = await web3.getTokenBalance(
          tokenAddress!,
          address: accountAddress,
        );
        num amu = amount1.toInt();
        EtherAmount amount =
            EtherAmount.fromUnitAndValue(EtherUnit.wei, BigInt.from(amu));
        if (amount.getValueInUnit(EtherUnit.ether) < 0.00000004) {
          update();

          return EtherAmount.zero().getValueInUnit(EtherUnit.ether);
        } else {
          update();
          return amount.getValueInUnit(EtherUnit.ether);
        }
      } catch (e) {
        Get.snackbar(e.toString(), "Token Balance");
        rethrow;
      }
    }
    EtherAmount balance = await web3.getBalance(address: accountAddress);
    if (balance.getValueInUnit(EtherUnit.ether) < 0.00000004) {
      update();
      return EtherAmount.zero();
    } else {
      update();
      return balance;
    }
  }
}
