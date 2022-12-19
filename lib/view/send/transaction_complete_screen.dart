import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet/models/transaction_history_model.dart';
import 'package:wallet/utils/theme.dart';
import 'package:wallet/view/Home/home_ctr.dart';
import 'package:wallet/view/send/send_ctr.dart';
import 'package:wallet/view/widgets/common.dart';
import 'package:web3dart/web3dart.dart';

class TransactionCompleteScreen extends StatelessWidget {
  const TransactionCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Transaction",
          style: TextStyle(
            color: !Get.isDarkMode ? black : white,
          ),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: !Get.isDarkMode ? black : white),
        centerTitle: true,
        backgroundColor: Get.isDarkMode ? black : white,
      ),
      body: GetBuilder<SendController>(
          init: SendController(),
          builder: (controller) {
            return FutureBuilder<Map<String, TransactionReceipt>>(
                future: controller.sendTransaction(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Column(
                      children: [
                        SizedBox(
                            height: Get.height * .4,
                            child:
                                Lottie.asset("assets/lottiefiles/failed.json")),
                        height(20),
                        Center(
                          child: Text(
                            snapshot.error.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        height(50),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      child: Text("Back"),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Lottie.asset("assets/lottiefiles/loading.json",
                            height: 120));
                  }
                  if (snapshot.hasData) {
                    TransactionHistory transactionHistory = TransactionHistory(
                        transactionHash: snapshot.data!.keys.first.toString(),
                        transactionIndex: snapshot
                            .data!.values.first.transactionIndex
                            .toString(),
                        blockHash:
                            snapshot.data!.values.first.blockHash.toString(),
                        cumulativeGasUsed: snapshot
                            .data!.values.first.cumulativeGasUsed
                            .toString(),
                        contractAddress: snapshot
                            .data!.values.first.contractAddress
                            .toString(),
                        status: snapshot.data!.values.first.status.toString(),
                        from: snapshot.data!.values.first.from.toString(),
                        to: snapshot.data!.values.first.to.toString(),
                        gasUsed: snapshot.data!.values.first.gasUsed
                            .toString(),
                        effectiveGasPrice: snapshot
                            .data!.values.first.effectiveGasPrice
                            .toString(),
                        currentNetwork: HomeController().getCurrentNetwork);
                    controller.transactionOnCurrentNetwork
                        .add(transactionHistory);
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                SizedBox(
                                    height: Get.height * .4,
                                    child: Lottie.asset(
                                        "assets/lottiefiles/completed.json")),
                                const Text(
                                  'Transaction Complete!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.green),
                                ),
                                height(5),
                                const Text(
                                  'Details of transaction are included below',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: grey),
                                ),
                                height(15),
                                const Divider(color: grey),
                                height(15),
                                ListTile(
                                  dense: true,
                                  title: const Text(
                                    'TRANSACTIONS HASH',
                                  ),
                                  subtitle: Text(
                                    snapshot.data!.keys.first,
                                    style: const TextStyle(color: grey),
                                  ),
                                ),
                                const Divider(height: 3),
                                ListTile(
                                  dense: true,
                                  title: const Text(
                                    'TRANSACTIONS BLOCK NUMBER',
                                  ),
                                  subtitle: Text(
                                    snapshot.data!.values.first.blockNumber
                                        .toString(),
                                    style: const TextStyle(color: grey),
                                  ),
                                ),
                                const Divider(height: 3),
                                ListTile(
                                  dense: true,
                                  title: const Text('TOTAL GAS USED'),
                                  subtitle: Text(
                                    snapshot.data!.values.first.gasUsed
                                        .toString(),
                                    style: const TextStyle(color: grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text("Data Not found"),
                    );
                  }
                });
          }),
    );
  }
}
