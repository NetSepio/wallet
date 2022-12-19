import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet/utils/theme.dart';
import 'package:wallet/utils/secure_storage.dart';
import 'package:wallet/view/Authentication/generate_phrase_screen.dart';
import 'package:wallet/view/Home/home_ctr.dart';
import 'package:wallet/view/Authentication/auth_controller.dart';
import 'package:wallet/view/Authentication/lock_screen.dart';

height(double height) => SizedBox(height: height);
width(double width) => SizedBox(width: width);

void checkLock(bool check, {required bool splash, navigation}) async {
  final storage = SecureStorage();
  AuthController authController = Get.put(AuthController());
  await storage.getStoredValue('PIN').then((value) async {
    if (value != null) {
      if (authController.isFingerprintOn && navigation == null) {
        final isAuthenticated = await LocalAuthApi.authenticate();
        if (isAuthenticated) {
          check ? null : Get.offAllNamed("/dashboard");
        } else {
          authController.checkFingerprint(splash);
        }
      } else {
        if (navigation != null) {
          Get.off(() => LockScreen(
              createPIN: false, splash: splash, navigation: navigation));
        } else {
          Get.to(() => LockScreen(createPIN: false, splash: splash));
        }
      }
    } else {
      Get.offAllNamed("/introductionScreen");
    }
  });
}

Future<dynamic> networkSelect(BuildContext context, HomeController controller) {
  return showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
          title: const Text("Select Network"),
          content: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                height(20),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.networks.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text(controller.networks[index]),
                            dense: true,
                            trailing: controller.getCurrentNetwork ==
                                    controller.networks[index]
                                ? const Icon(Icons.check)
                                : null,
                            onTap: () {
                              controller.setCurrentNetwork(
                                  controller.networks[index].toString());
                              Get.back();
                              controller.update();
                            },
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          )
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Expanded(
          //       child: TextButton(
          //         onPressed: () => Navigator.of(context).pop(),
          //         child: Container(
          //           height: 48,
          //           alignment: Alignment.center,
          //           decoration: const BoxDecoration(
          //             color: appcolor,
          //             borderRadius: BorderRadius.only(
          //               bottomLeft: Radius.circular(8),
          //               bottomRight: Radius.circular(8),
          //             ),
          //           ),
          //           child: Text(
          //             'CLOSE',
          //             style: Theme.of(context)
          //                 .textTheme
          //                 .headline4!
          //                 .copyWith(fontSize: 15, color: Colors.white),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          );
    },
  );
}

class NoData extends StatelessWidget {
  const NoData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset("assets/lottiefiles/nodata.json", height: 130),
      ],
    ));
  }
}

class CustomButton extends StatelessWidget {
  final Function() onTap;
  final String title;
  const CustomButton({Key? key, required this.onTap, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: appcolor, borderRadius: BorderRadius.circular(10)),
        child: Text(
          title,
          style: const TextStyle(color: white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
