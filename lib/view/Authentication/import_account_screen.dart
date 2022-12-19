import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/utils/theme.dart';
import 'package:wallet/view/Authentication/auth_controller.dart';
import 'package:wallet/view/widgets/common.dart';

class ImportAccountScreen extends StatelessWidget {
  const ImportAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: GetBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) {
          return Container(
            width: Get.width,
            height: Get.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color(0xff0F2027),
                Colors.black87,
                Color.fromARGB(255, 14, 49, 65),
                Colors.black87,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            )),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SafeArea(
                    child: Icon(Icons.arrow_back_ios, color: white),
                  ),
                  height(50),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Enter your secret phrase",
                      style: TextStyle(color: white, fontSize: 18),
                    ),
                  ),
                  height(10),
                  const Center(
                    child: Text(
                      "Enter each word in the order",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: blueGray),
                    ),
                  ),
                  height(30),
                  TextField(
                    style: const TextStyle(color: white),
                    controller: controller.importAccountphrase,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    maxLines: 9,
                    decoration: InputDecoration(
                      hintText: "Phrase",
                      isDense: true,
                      hintStyle: const TextStyle(color: grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: grey),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: grey),
                      ),
                    ),
                  ),
                  height(90),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              controller.privateKeyFromMnemonic(
                                  newMnemonic: controller
                                      .importAccountphrase.text
                                      .trim());
                              Get.toNamed("/authCompleteScreen");
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text("Next"),
                            )),
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
