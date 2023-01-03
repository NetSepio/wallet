import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:nucleus/utils/secure_storage.dart';
import 'package:nucleus/view/Home/home_ctr.dart';
import 'package:nucleus/utils/theme.dart';
import 'package:nucleus/view/Authentication/auth_controller.dart';
import 'package:nucleus/view/Authentication/generate_phrase_screen.dart';
import 'package:nucleus/view/Authentication/reset_password.dart';
import 'package:nucleus/view/widgets/common.dart';
import 'package:web3dart/web3dart.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (controller) {
            return Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    height(10),
                    const SafeArea(
                        child: Text("Setting",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ))),
                    SizedBox(
                        height: Get.height * .2,
                        child: Lottie.asset('assets/lottiefiles/wallet.json')),
                    height(10),
                    const Text(
                      "My Balance",
                      style: TextStyle(fontSize: 12),
                    ),
                    height(12),
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
                              ),
                            );
                          } else {
                            return Text(
                              '${amount.toStringAsFixed(3)} ${controller.currentTickerSymbol}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        } else {
                          return Text(
                            '0.0 ${controller.currentTickerSymbol}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    ),
                    height(10),
                    customTile(
                      trailing: CupertinoSwitch(
                          value: controller.darkmode,
                          onChanged: (value) {
                            Get.changeThemeMode(Get.isDarkMode
                                ? ThemeMode.light
                                : ThemeMode.dark);
                            controller.darkmode = Get.isDarkMode ? false : true;
                            box.put('isDarkMode', controller.darkmode);
                            controller.update();
                          }),
                      text: "Dark Mode",
                    ),
                    customTile(
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (controller.accountAddress != null)
                            Text(
                                controller.accountAddress
                                    .toString()
                                    .substring(0, 6),
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          const Icon(Icons.arrow_forward_ios, size: 18),
                        ],
                      ),
                      leading: const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Colors.green,
                      ),
                      text: "My Wallet",
                      ontap: () {
                        Get.toNamed("/myWalletScreen");
                      },
                    ),
                    height(10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "GENERAL",
                        style: TextStyle(fontSize: 10, color: grey),
                      ),
                    ),
                    height(10),
                    customTile(
                      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                      leading: const Icon(Icons.network_wifi_2_bar_sharp,
                          color: Colors.blueGrey),
                      text: "Select Networks",
                      subtitle: Text(controller.getCurrentNetwork),
                      ontap: () {
                        networkSelect(context, controller);
                      },
                    ),
                    customTile(
                      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                      leading: const Icon(Icons.token, color: midnightBlue),
                      text: "Add Tokens",
                      ontap: () {
                        Get.toNamed("/addTokenScreen", arguments: false);
                      },
                    ),
                    height(10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "SECURITY",
                        style: TextStyle(fontSize: 10, color: grey),
                      ),
                    ),
                    height(10),
                    customTile(
                      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                      leading: const Icon(
                        Icons.select_all,
                        color: Colors.brown,
                      ),
                      text: "Reveal Seed Phrase",
                      ontap: () {
                        checkLock(true,
                            splash: false,
                            navigation: Get.to(() => const GenerateSeedPhrase(
                                  view: true,
                                )));
                      },
                    ),
                    customTile(
                      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                      leading: const Icon(
                        Icons.lock,
                        color: Colors.teal,
                      ),
                      text: "Reset PIN",
                      ontap: () {
                        Get.to(() => const ResetPasswordScreen());
                      },
                    ),
                    GetBuilder<AuthController>(
                        init: AuthController(),
                        builder: (authcontroller) {
                          return customTile(
                            trailing: CupertinoSwitch(
                                value: authcontroller.isFingerprintOn,
                                onChanged: (value) async {
                                  final auth = LocalAuthentication();
                                  bool d = await auth.isDeviceSupported();
                                  if (d) {
                                    Get.showSnackbar(const GetSnackBar(
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.red,
                                      title:
                                          "Device is not capable of checking biometrics",
                                      messageText: Text(
                                        ".",
                                        style: TextStyle(fontSize: 1),
                                      ),
                                    ));
                                  } else {
                                    authcontroller.toggleFingerprint(value);
                                  }
                                }),
                            text: "Fingerprint Unlock",
                            ontap: () {},
                          );
                        }),
                    height(10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "SUPPORT",
                        style: TextStyle(fontSize: 10, color: grey),
                      ),
                    ),
                    height(10),
                    customTile(
                      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                      leading: const Icon(
                        Icons.info_outline,
                        color: blue,
                      ),
                      text: "About Nucleus",
                      ontap: () => Get.toNamed("/aboutWalletScreen"),
                    ),
                    height(10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "WE'LL MISS YOU",
                        style: TextStyle(fontSize: 10, color: grey),
                      ),
                    ),
                    height(10),
                    customTile(
                      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      text: "Delete Account",
                      ontap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: const Text("Delete Account"),
                              content: const Text(
                                  "Are you sure you want to delete your account?"),
                              actions: [
                                CupertinoDialogAction(
                                  child: const Text(
                                    "No",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                CupertinoDialogAction(
                                    onPressed: () async {
                                      final storage = SecureStorage();
                                      await storage.deleteAllStoredValues();
                                      // await Hive.deleteFromDisk();
                                      // box.erase();
                                      Get.toNamed("/introductionScreen");
                                    },
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.red),
                                    )),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    height(10),
                    const Text(
                      "Nucleus",
                      style: TextStyle(
                        fontSize: 18,
                        color: grey,
                      ),
                    ),
                    const Text(
                      "Copyright © nucleus 2022",
                      style: TextStyle(
                        fontSize: 12,
                        color: grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Container customTile(
      {required String text,
      Function()? ontap,
      Widget? leading,
      Widget? subtitle,
      Widget? trailing}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        onTap: ontap,
        dense: true,
        leading: leading,
        trailing: trailing,
        title: Text(text),
        subtitle: subtitle,
      ),
    );
  }
}
