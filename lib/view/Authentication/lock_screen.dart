import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:NetSepio/utils/theme.dart';
import 'package:NetSepio/view/Authentication/auth_controller.dart';
import 'package:NetSepio/view/widgets/common.dart';

class LockScreen extends StatelessWidget {
  final bool createPIN;
  final bool splash;
  final navigation;
  const LockScreen(
      {super.key,
      this.createPIN = true,
      this.splash = true,
      this.navigation = null});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: GetBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Container(
              width: Get.width,
              height: Get.height,
              decoration: BoxDecoration(gradient: gradient2),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (createPIN)
                          SafeArea(
                            child: IconButton(
                              onPressed: () => Get.back(),
                              icon: const Icon(Icons.arrow_back_ios,
                                  color: white),
                            ),
                          ),
                        height(40),
                        Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: Lottie.asset(
                            "assets/lottiefiles/locked.json",
                          ),
                        ),
                        Center(
                          child: Text(
                            createPIN ? 'Create PIN' : "Enter PIN",
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: white),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'This PIN will unlock your Wallet only on this device.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(.7),
                            ),
                          ),
                        ),
                        height(20),
                        TextField(
                          style: const TextStyle(color: white),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          keyboardAppearance: Brightness.dark,
                          controller: controller.pincontroller,
                          decoration: InputDecoration(
                            hintText: "Enter 6 digit PIN",
                            isDense: true,
                            hintStyle:
                                const TextStyle(color: grey, fontSize: 12),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(color: grey)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: grey),
                            ),
                          ),
                        ),
                        height(10),
                        createPIN
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Sign in with fingerprint?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.5,
                                        color: white),
                                  ),
                                  CupertinoSwitch(
                                    value: controller.isFingerprintOn,
                                    activeColor: lightAppcolor,
                                    onChanged: (value) async {
                                      await LocalAuthentication()
                                          .canCheckBiometrics
                                          .then(
                                            (a) => a
                                                ? controller
                                                    .toggleFingerprint(value)
                                                : Get.snackbar(
                                                    "Device not supported Fingerprint",
                                                    "Authenticate using PIN",
                                                    colorText: black,
                                                  ),
                                          );
                                    },
                                  ),
                                ],
                              )
                            : const Offstage(),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (createPIN) {
                              controller.savePin(fromImport: Get.arguments);
                            } else {
                              controller.checkPIN(context, splash,
                                  navigation: navigation);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(createPIN ? "Next" : "Done"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
