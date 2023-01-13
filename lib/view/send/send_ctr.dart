import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:get/get.dart';
import 'package:NetSepio/models/send_transaction_model.dart';
import 'package:NetSepio/models/transaction_history_model.dart';
import 'package:NetSepio/utils/secure_storage.dart';
import 'package:NetSepio/web3dart/web3dart.dart';
import 'package:web3dart/web3dart.dart';

class SendController extends GetxController {
  TextEditingController accountController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final SecureStorage storage = SecureStorage();
  final Box<TransactionHistory> transactionOnCurrentNetwork =
      Boxes.getTransactionOnCurrentNetworkBox;
  @override
  void onClose() {
    accountController.clear();
    amountController.clear();
    super.onClose();
  }

  Future<void> scanQrCode() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      String? cameraScanResult = await scanner.scan();
      if (cameraScanResult != null) {
        accountController.text = cameraScanResult;
      } else {
        Get.snackbar("Scan Controller", 'Invalid QR Code. Try again!');
      }
    } else {
      throw 'Permissions denied';
    }
    update();
  }

  Future<bool> approvalCallback() async {
    return true;
  }

  Future<Map<String, TransactionReceipt>> sendTransaction() async {
    if (accountController.text.isNotEmpty && amountController.text.isNotEmpty) {
      num parsedAmount = num.parse(amountController.text);
      num calc = pow(10, 18);

      num givenAmount = parsedAmount * calc;

      Web3 web3 = Web3(approvalCallback);

      String senderAddress = await storage.getStoredValue("accountAddress") ??
          'No Account Address Found!';
      String pvtKey =
          await storage.getStoredValue("pvtKey") ?? 'No Private Key found!';
      await web3.setCredentials(pvtKey);
      return await web3
          .transfer(amountController, accountController, accountController.text,
              givenAmount, senderAddress)
          .then((value) {
        amountController.clear();
        accountController.clear();
        return value;
      });
    } else {
      Get.snackbar("Fields are empty", "Fill both text-filed");
      throw "Fields are empty";
    }
  }

  Future<String> sendTokenTransaction(
      String tokenAddress, sendTransModel) async {
    final SendTransactionModel sendTransactionModel = sendTransModel;
    debugPrint('tokenAddress => $tokenAddress');
    debugPrint('receiverAddress => ${sendTransactionModel.sendersAddress}');
    debugPrint('amount => ${sendTransactionModel.amount}');
    if (sendTransactionModel.sendersAddress != '' &&
        sendTransactionModel.amount != '') {
      num parsedAmount = num.parse(sendTransactionModel.amount);

      Web3 web3 = Web3(approvalCallback);

      String pvtKey =
          await storage.getStoredValue("pvtKey") ?? 'No Private Key found!';
      await web3.setCredentials(pvtKey);
      try {
        return await web3.tokenTransfer(
            tokenAddress, sendTransactionModel.sendersAddress, parsedAmount);
      } catch (e) {
        Get.snackbar(e.toString(), " ");
        rethrow;
      }
    } else {
      throw 'Fields are empty';
    }
  }
}
