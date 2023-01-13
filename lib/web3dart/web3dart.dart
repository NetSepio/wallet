// ignore_for_file: depend_on_referenced_packages, deprecated_member_use
import 'dart:math';
import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:NetSepio/view/Home/home_ctr.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';
import 'dart:async';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Web3 {
  late Credentials _credentials;
  late Web3Client _client;
  late Future<bool> _approveCb;
  late int _networkId;
  Web3(
    Future<bool> Function() approveCb, {
    String? url,
    int? networkId,
    String? defaultCommunityAddress,
    String? communityManagerAddress,
    String? transferManagerAddress,
    String? daiPointsManagerAddress,
    int? defaultGasLimit,
  }) {
    _client = Web3Client(getCurrentNetworkData['rpc_url'], Client());
    _networkId = networkId ?? getCurrentNetworkData['network_id'];
    _approveCb = approveCb();
  }

  static Map<String, dynamic> get getCurrentNetworkData {
    HomeController homeController = HomeController();
    switch (homeController.getCurrentNetwork) {
      case 'Ethereum Mainnet':
        return {
          'rpc_url': dotenv.env["Ethereum_Mainnet"],
          'network_id': 1,
          'logo_path': 'assets/images/ethereum_logo.png',
          'symbol': 'ETH',
        };
      case 'Ropsten Testnet':
        return {
          'rpc_url': dotenv.env["Ropsten_Testnet"],
          'network_id': 3,
          'logo_path': 'assets/images/ethereum_logo.png',
          'symbol': 'ETH',
        };
      case 'Rinkeby Testnet':
        return {
          'rpc_url': dotenv.env["Rinkeby_Testnet"],
          'network_id': 4,
          'logo_path': 'assets/images/ethereum_logo.png',
          'symbol': 'ETH',
        };
      case 'Coerli Testnet':
        return {
          'rpc_url': dotenv.env["Coerli_Testnet"],
          'network_id': 5,
          'logo_path': 'assets/images/ethereum_logo.png',
          'symbol': 'ETH',
        };
      case 'Kovan Testnet':
        return {
          'rpc_url': dotenv.env["Kovan_Testnet"],
          'network_id': 42,
          'logo_path': 'assets/images/ethereum_logo.png',
          'symbol': 'ETH',
        };
      case 'Matic Mainnet':
        return {
          'rpc_url': dotenv.env["Matic_Mainnet"],
          'network_id': 137,
          'logo_path': 'assets/images/matic_logo.png',
          'symbol': 'MATIC',
        };
      case 'Mumbai Testnet':
        return {
          'rpc_url': dotenv.env["Mumbai_Testnet"],
          'network_id': 80001,
          'logo_path': 'assets/images/matic_logo.png',
          'symbol': 'MATIC',
        };
      case 'Binance Mainnet':
        return {
          'rpc_url': 'https://bsc-dataseed.binance.org/',
          'network_id': 65,
          'logo_path': 'assets/images/Binance-Icon-Logo.png',
          'symbol': 'BNB',
        };
      default:
        return {
          'rpc_url': dotenv.env["Default_rpc_url"],
          'network_id': 56,
          'logo_path': 'assets/images/ethereum_logo.png',
          'symbol': 'ETH',
        };
    }
  }

  static String privateKeyFromMnemonic(String mnemonic, {int childIndex = 0}) {
    String seed = bip39.mnemonicToSeedHex(mnemonic);
    bip32.BIP32 root =
        bip32.BIP32.fromSeed(Uint8List.fromList(HEX.decode(seed)));
    bip32.BIP32 child = root.derivePath("m/44'/60'/0'/0/$childIndex");
    String privateKey = HEX.encode(child.privateKey!.toList());
    return privateKey;
  }

  Future<void> setCredentials(String privateKey) async {
    _credentials = await _client.credentialsFromPrivateKey(privateKey);
  }

  Future<String> getAddress() async {
    return (await _credentials.extractAddress()).toString();
  }

  Future<EtherAmount> getBalance({String? address}) async {
    EthereumAddress a;
    if (address != null && address.isNotEmpty) {
      a = EthereumAddress.fromHex(address);
    } else {
      a = EthereumAddress.fromHex(await getAddress());
    }

    return await _client.getBalance(a);
  }

  Future<Map<String, TransactionReceipt>> transfer(
      amountController,
      accountController,
      String receiverAddress,
      num amountInWei,
      String senderAddress) async {
    debugPrint(
        'transferring --> receiver: $receiverAddress, sender: $senderAddress amountInWei: $amountInWei');

    bool isApproved = await _approveCb;
    if (!isApproved) {
      throw 'transaction not approved';
    }
    try {
      EthereumAddress receiver = EthereumAddress.fromHex(receiverAddress);
      EthereumAddress sender = EthereumAddress.fromHex(senderAddress);
      EtherAmount amount =
          EtherAmount.fromUnitAndValue(EtherUnit.wei, BigInt.from(amountInWei));

      Map<String, TransactionReceipt> transactionMap =
          await _sendTransactionAndWaitForReceipt(Transaction(
        to: receiver,
        value: amount,
        from: sender,
        maxGas: 100000,
      ));
      debugPrint('transaction ${transactionMap.keys} successful');
      return transactionMap;
    } on RPCError {
      Get.snackbar("insufficient funds", "Add some amount");
      amountController.clear();
      accountController.clear();
      throw "insufficient funds";
    } catch (e) {
      Get.snackbar(e.toString(), "");
      throw e.toString();
    }
  }

  Future<Map<String, TransactionReceipt>> _sendTransactionAndWaitForReceipt(
      Transaction transaction) async {
    debugPrint('sendTransactionAndWaitForReceipt');
    String txHash = await _client.sendTransaction(
      _credentials,
      transaction,
      chainId: _networkId,
    );
    TransactionReceipt? receipt;
    try {
      receipt = await _client.getTransactionReceipt(txHash);
    } catch (err) {
      debugPrint('could not get $txHash receipt, try again');
    }
    debugPrint('Receipt ==> $receipt');
    int delay = 1;
    int retries = 10;
    while (receipt == null) {
      debugPrint('waiting for receipt');
      await Future.delayed(Duration(seconds: delay));
      delay *= 2;
      retries--;
      if (retries == 0) {
        throw 'transaction $txHash not mined yet...';
      }
      try {
        receipt = await _client.getTransactionReceipt(txHash);
      } catch (err) {
        debugPrint('could not get $txHash receipt, try again');
      }
    }
    debugPrint('Transaction successful Status => ${receipt.status}');
    return {txHash: receipt};
  }

  Future<DeployedContract> _contract(
      String contractName, String contractAddress) async {
    String abi = await rootBundle.loadString('assets/abi.json');
    DeployedContract contract = DeployedContract(
      ContractAbi.fromJson(abi, contractName),
      EthereumAddress.fromHex(contractAddress),
    );
    return contract;
  }

  Future<List<dynamic>> _readFromContract(String contractName,
      String contractAddress, String functionName, List<dynamic> params) async {
    DeployedContract contract = await _contract(contractName, contractAddress);
    return await _client.call(
        contract: contract,
        function: contract.function(functionName),
        params: params);
  }

  Future<String> _callContract(String contractName, String contractAddress,
      String functionName, List<dynamic> params) async {
    bool isApproved = await _approveCb;
    if (!isApproved) {
      throw 'transaction not approved';
    }
    DeployedContract contract = await _contract(contractName, contractAddress);
    Transaction tx = Transaction.callContract(
        contract: contract,
        function: contract.function(functionName),
        parameters: params);
    Map<String, TransactionReceipt> map =
        await _sendTransactionAndWaitForReceipt(tx);
    return map.keys.first;
  }

  Future<dynamic> getTokenName(String tokenAddress) async {
    try {
      return {
        (await _readFromContract('BasicToken', tokenAddress, 'name', [])).first,
      };
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> getTokenSymbol(String tokenAddress) async {
    try {
      return {
        (await _readFromContract('BasicToken', tokenAddress, 'symbol', []))
            .first,
      };
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Map> getImageFromToken(
      {required int token, required String address}) async {
    List<dynamic> result = await _readFromContract(
        'BasicToken', address, 'tokenURI', [BigInt.from(token)]);
    String json = result[0];
    String url = json
        .toString()
        .replaceFirst(r'ipfs://', r'https://nftstorage.link/ipfs/');
    var resp = await Client().get(Uri.parse(url));
    var decodeRes = jsonDecode(resp.body);
    return decodeRes;
  }

  Future<dynamic> getTokenDecimals(String tokenAddress) async {
    try {
      return {
        (await _readFromContract('BasicToken', tokenAddress, 'decimals', []))
            .first
      };
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> getTokenDetails(String tokenAddress) async {
    return {
      "name": (await _readFromContract('BasicToken', tokenAddress, 'name', []))
          .first,
      "symbol":
          (await _readFromContract('BasicToken', tokenAddress, 'symbol', []))
              .first,
      "decimals":
          (await _readFromContract('BasicToken', tokenAddress, 'decimals', []))
              .first
    };
  }

  Future<dynamic> getTokenBalance(String tokenAddress,
      {String? address}) async {
    List<dynamic> params = [];
    if (address != null && address != "") {
      params = [EthereumAddress.fromHex(address)];
    } else {
      params = [EthereumAddress.fromHex(await getAddress())];
    }
    return (await _readFromContract(
            'BasicToken', tokenAddress, 'balanceOf', params))
        .first;
  }

  Future<String> tokenTransfer(
      String tokenAddress, String receiverAddress, num tokensAmount) async {
    EthereumAddress receiver = EthereumAddress.fromHex(receiverAddress);
    dynamic tokenDetails = await getTokenDetails(tokenAddress);
    int tokenDecimals = int.parse(tokenDetails["decimals"].toString());
    Decimal tokensAmountDecimal = Decimal.parse(tokensAmount.toString());
    Decimal decimals = Decimal.parse(pow(10, tokenDecimals).toString());
    BigInt amount = BigInt.parse((tokensAmountDecimal * decimals).toString());
    return await _callContract(
        'BasicToken', tokenAddress, 'transfer', [receiver, amount]);
  }
}
