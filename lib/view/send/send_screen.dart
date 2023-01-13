import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:NetSepio/models/send_transaction_model.dart';
import 'package:NetSepio/view/send/send_ctr.dart';
import 'package:NetSepio/view/send/token_complete.dart';
import 'package:NetSepio/utils/theme.dart';
import 'package:NetSepio/view/widgets/common.dart';

class SendScreen extends StatelessWidget {
  final bool isTokenTransfer;
  final String? tokenAddress;
  const SendScreen(
      {super.key, this.isTokenTransfer = false, this.tokenAddress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SendController>(
          init: SendController(),
          builder: (controller) {
            return Container(
              width: Get.width,
              height: Get.height,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                          ),
                          const Text("Send",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          InkWell(
                            onTap: () {
                              controller.scanQrCode();
                            },
                            child: const Icon(Icons.qr_code_scanner),
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: SizedBox(
                          height: Get.height * .15,
                          child:
                              Lottie.asset("assets/lottiefiles/ethereum.json")),
                    ),
                    Card(
                        color: Get.isDarkMode
                            ? midnightBlue.withOpacity(0.4)
                            : white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Address",
                                  style: TextStyle(color: blueGray)),
                              height(3),
                              TextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.streetAddress,
                                controller: controller.accountController,
                                decoration: InputDecoration(
                                    hintText: "Enter Address",
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                              ),
                              height(15),
                              const Text("Amount",
                                  style: TextStyle(color: blueGray)),
                              height(3),
                              TextField(
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                controller: controller.amountController,
                                decoration: InputDecoration(
                                    hintText: "Amount",
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                              ),
                            ],
                          ),
                        )),
                    height(Get.height * .25),
                    CustomButton(
                      onTap: () {
                        if (isTokenTransfer) {
                          Get.to(() => TokenCompleteScreen(
                              tokenAddress: tokenAddress!,
                              sendTransactionModel: SendTransactionModel(
                                  controller.accountController.text,
                                  controller.amountController.text)));
                        } else {
                          Get.toNamed("/transactionComplete");
                        }
                      },
                      title: "Send",
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
