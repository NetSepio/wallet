import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nucleus/view/Home/home_ctr.dart';
import 'package:nucleus/utils/theme.dart';
import 'package:nucleus/view/Home/token_detail_screen.dart';
import 'package:nucleus/view/widgets/common.dart';
import 'package:web3dart/web3dart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (controller) {
            return SafeArea(
              child: Column(
                children: [
                  header(),
                  walletTile(controller, context),
                  height(15),
                  dataCard(controller),
                  middleNavBar(controller),
                  if (!controller.history.value &&
                          controller.getTokenBasedOnCurrentNetwork == null ||
                      !controller.history.value &&
                          controller.getTokenBasedOnCurrentNetwork!.isEmpty)
                    const NoData(),
                  if (!controller.history.value &&
                      controller.getTokenBasedOnCurrentNetwork != null)
                    tokenList(controller),
                  if (controller.history.value &&
                          controller.getTransactionBasedOnCurrentNetwork ==
                              null ||
                      controller.history.value &&
                          controller
                              .getTransactionBasedOnCurrentNetwork!.isEmpty)
                    const NoData(),
                  if (controller.history.value) historyList(controller),
                  addToken(controller),
                ],
              ),
            );
          }),
    );
  }

  Padding addToken(HomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ListTile(
        onTap: () => Get.toNamed("/addTokenScreen", arguments: false)!
            .whenComplete(() => controller.update()),
        dense: true,
        shape: const OutlineInputBorder(borderSide: BorderSide(color: grey)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 20),
            width(10),
            const Text("Add Token"),
          ],
        ),
      ),
    );
  }

  Expanded historyList(HomeController controller) {
    return Expanded(
        child: ListView.builder(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      itemCount: controller.getTransactionBasedOnCurrentNetwork!.length,
      itemBuilder: (context, index) {
        return Card(
          color: Get.isDarkMode ? appcolor : white,
          child: ListTile(
            onTap: () {
              Get.toNamed("/historyDetails",
                      arguments: controller
                          .getTransactionBasedOnCurrentNetwork![index])!
                  .whenComplete(() => controller.update());
            },
            leading: const CircleAvatar(
                foregroundImage: AssetImage("assets/images/logo.png"),
                backgroundColor: Colors.transparent),
            title: Text(
              "To : ${controller.getTransactionBasedOnCurrentNetwork![index].to}",
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            trailing: Column(
              children: [
                height(8),
                const Text("Index", style: TextStyle(fontSize: 12)),
                height(4),
                Text(
                    controller.getTransactionBasedOnCurrentNetwork![index]
                        .transactionIndex,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            subtitle: Text(
              "GasUsed : ${controller.getTransactionBasedOnCurrentNetwork![index].gasUsed}",
              style: const TextStyle(fontSize: 12),
            ),
          ),
        );
      },
    ));
  }

  Expanded tokenList(HomeController controller) {
    return Expanded(
        child: ListView.builder(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      itemCount: controller.getTokenBasedOnCurrentNetwork!.length,
      itemBuilder: (context, index) {
        return Card(
          color: Get.isDarkMode ? appcolor : white,
          child: ListTile(
            onTap: () {
              Get.to(() => TokenDetailScreen(
                      token: controller.getTokenBasedOnCurrentNetwork![index]))!
                  .whenComplete(() => controller.update());
            },
            leading: const CircleAvatar(
                foregroundImage: AssetImage("assets/images/logo.png"),
                backgroundColor: Colors.transparent),
            title: Text(
              controller.getTokenBasedOnCurrentNetwork![index].tokenName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            trailing: Text(
                controller.getTokenBasedOnCurrentNetwork![index].symbol,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            subtitle: Text(
              controller.getTokenBasedOnCurrentNetwork![index].decimal,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        );
      },
    ));
  }

  Container middleNavBar(HomeController controller) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              controller.history.value = false;
              controller.update();
            },
            child: Column(
              children: [
                height(5),
                Text(
                  "Token",
                  style: TextStyle(
                    color: controller.history.value ? grey : blue,
                    fontWeight: !controller.history.value
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                height(15),
                if (!controller.history.value)
                  Container(
                    height: 2,
                    width: Get.width / 4,
                    color: blueGray,
                  )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.history.value = true;
              controller.update();
            },
            child: Column(
              children: [
                height(5),
                Text(
                  "History",
                  style: TextStyle(
                    color: controller.history.value ? blue : grey,
                    fontWeight: controller.history.value
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                height(15),
                if (controller.history.value)
                  Container(
                    height: 2,
                    width: Get.width / 4,
                    color: blueGray,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding dataCard(HomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: Get.height * .22,
        width: Get.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0F2027),
              Color(0xff2C5364),
              Color(0xff203A43),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  controller.currentNetworkLogoPath,
                  height: 70,
                  width: 40,
                ),
                width(5),
                FutureBuilder(
                  future: controller.getAccountAddressAndBalance(
                      istokenBalance: false),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      double amount =
                          snapshot.data!.getValueInUnit(EtherUnit.ether);
                      if (amount == 0.0) {
                        return Text(
                          '$amount ${controller.currentTickerSymbol}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
                        );
                      } else {
                        return Text(
                          '${amount.toStringAsFixed(3)} ${controller.currentTickerSymbol}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
                        );
                      }
                    } else {
                      return Text(
                        '0.0 ${controller.currentTickerSymbol}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: white,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            height(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed("/sendScreen");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: appcolor.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            width(5),
                            const Icon(
                              CupertinoIcons.arrow_up_to_line_alt,
                              size: 16,
                              color: white,
                            ),
                            width(10),
                            const Text(
                              "Send",
                              style: TextStyle(fontSize: 12, color: white),
                            ),
                            width(5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: (() {
                    Get.toNamed("/receiveScreen");
                  }),
                  child: Container(
                    decoration: BoxDecoration(
                      color: appcolor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        width(5),
                        const Icon(
                          CupertinoIcons.arrow_down_to_line_alt,
                          size: 16,
                          color: white,
                        ),
                        width(10),
                        const Text(
                          "Receive",
                          style: TextStyle(fontSize: 12, color: white),
                        ),
                        width(5)
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Padding walletTile(HomeController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ListTile(
        onTap: () {
          Get.toNamed("/myWalletScreen");
        },
        dense: true,
        shape: OutlineInputBorder(
            borderSide: const BorderSide(color: grey),
            borderRadius: BorderRadius.circular(10)),
        leading: const CircleAvatar(
          foregroundImage: AssetImage("assets/images/logo.png"),
          maxRadius: 15,
        ),
        trailing: IconButton(
            onPressed: () {
              Clipboard.setData(
                      ClipboardData(text: controller.accountAddress ?? ""))
                  .then(
                (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Address copied to clipboard"),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.copy)),
        title: Text(controller.accountAddress ?? "",
            maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(controller.getCurrentNetwork),
      ),
    );
  }

  Padding header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 24),
          const Text("Nucleus",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          InkWell(
            onTap: () => Get.toNamed("/setting"),
            child: const Icon(
              CupertinoIcons.settings,
            ),
          ),
        ],
      ),
    );
  }
}
