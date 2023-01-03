import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nucleus/models/send_transaction_model.dart';
import 'package:nucleus/view/send/send_ctr.dart';
import 'package:nucleus/view/widgets/common.dart';

class TokenCompleteScreen extends StatelessWidget {
  final String tokenAddress;
  final SendTransactionModel sendTransactionModel;
  const TokenCompleteScreen(
      {super.key,
      required this.tokenAddress,
      required this.sendTransactionModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SendController>(
          init: SendController(),
          builder: (controller) {
            return FutureBuilder(
              future: controller.sendTokenTransaction(
                  tokenAddress, sendTransactionModel),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 200,
                            child: Lottie.asset(
                                "assets/lottiefiles/completed.json")),
                        const SizedBox(height: 20),
                        Text(
                          'Transaction Complete!',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/lottiefiles/loading.json",
                            height: 120),
                        height(20),
                        const Text('Transaction in process...'),
                      ],
                    ),
                  );
                }
              },
            );
          }),
    );
  }
}
