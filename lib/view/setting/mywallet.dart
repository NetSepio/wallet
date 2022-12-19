import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wallet/utils/theme.dart';
import 'package:wallet/view/Home/home_ctr.dart';
import 'package:wallet/view/widgets/common.dart';
import 'package:web3dart/web3dart.dart';

class MyWalletScreen extends StatelessWidget {
  const MyWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wallet"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: Get.width,
        child: GetBuilder<HomeController>(
            init: HomeController(),
            builder: (controller) {
              return Column(
                children: [
                  SizedBox(
                      height: Get.height * .2,
                      child: Lottie.asset('assets/lottiefiles/wallet.json')),
                  Card(
                    color: white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        height(10),
                        width(Get.width - 50),
                        const Text(
                          "My Balance",
                          style: TextStyle(
                            fontSize: 20,
                            color: appcolor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        height(12),
                        FutureBuilder(
                          future: controller.getAccountAddressAndBalance(
                              istokenBalance: false),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              double amount = snapshot.data!
                                  .getValueInUnit(EtherUnit.ether);
                              if (amount == 0.0) {
                                return Text(
                                  '$amount ${controller.currentTickerSymbol}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: appcolor,
                                  ),
                                );
                              } else {
                                return Text(
                                  '${amount.toStringAsFixed(3)} ${controller.currentTickerSymbol}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: appcolor,
                                  ),
                                );
                              }
                            } else {
                              return Text(
                                '0.0 ${controller.currentTickerSymbol}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: appcolor,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(
                            width: 250, child: Divider(color: appcolor)),
                        QrImage(
                          data: controller.accountAddress ?? "",
                          version: QrVersions.auto,
                          foregroundColor: appcolor,
                          // embeddedImage: AssetImage(controller.currentNetworkLogoPath),
                          dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.circle),
                          size: 250.0,
                        ),
                        const SizedBox(
                            width: 250, child: Divider(color: appcolor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: SizedBox(
                            width: 250,
                            child: Text(
                              controller.accountAddress ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14, color: appcolor),
                            ),
                          ),
                        ),
                        const SizedBox(
                            width: 250, child: Divider(color: appcolor)),
                        height(10),
                        Text(
                          controller.getCurrentNetwork,
                          style: const TextStyle(color: appcolor),
                        ),
                        height(20),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
