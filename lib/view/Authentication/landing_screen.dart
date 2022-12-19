import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/utils/theme.dart';
import 'package:wallet/view/widgets/common.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Container(
        decoration: BoxDecoration(gradient: gradient2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png", height: Get.height * .3),
              const Text(
                "Secure and easy\n to use wallet",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              height(40),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed("/authenticate", arguments: false);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(13.0),
                        child: Text(
                          "CREATE A WALLET",
                          style: TextStyle(color: white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              height(10),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                        style: TextButton.styleFrom(
                            side: const BorderSide(color: blue)),
                        onPressed: () {
                          Get.toNamed("/authenticate", arguments: true);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "IMPORT WALLET  ",
                            style: TextStyle(color: white),
                          ),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
