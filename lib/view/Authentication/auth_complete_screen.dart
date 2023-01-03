import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nucleus/utils/theme.dart';
import 'package:nucleus/view/widgets/common.dart';

class AuthCompleteScreen extends StatelessWidget {
  const AuthCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(gradient: gradient2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SafeArea(
                  child: Icon(Icons.arrow_back_ios, color: white),
                ),
                height(Get.height * .1),
                Center(
                  child: SizedBox(
                      height: Get.height * .3,
                      child: Lottie.asset('assets/lottiefiles/2.json')),
                ),
                height(40),
                const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Text(
                      "You have successfully protected your nucleus. Keep your recovery passphrase safe. This is your responsibility!",
                      style: TextStyle(
                          color: white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                height(20),
                const Center(
                  child: Text("Additional Information",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: blue,
                        fontSize: 16,
                        color: Colors.blueAccent,
                      )),
                ),
                height(Get.height * .1),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            Get.offAllNamed("/dashboard");
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text("Done"),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
