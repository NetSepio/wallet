import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:NetSepio/view/Authentication/auth_controller.dart';
import 'package:NetSepio/utils/theme.dart';
import 'package:NetSepio/view/widgets/common.dart';

class VerifyPhraseScreen extends StatelessWidget {
  const VerifyPhraseScreen({super.key});

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
            decoration: BoxDecoration(gradient: gradient2),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeArea(
                      child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child:
                              const Icon(Icons.arrow_back_ios, color: white)),
                    ),
                    height(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          backgroundColor: midnightBlue,
                          minRadius: 5,
                          maxRadius: 5,
                        ),
                        width(5),
                        const CircleAvatar(
                          backgroundColor: blueGray,
                          minRadius: 5,
                          maxRadius: 5,
                        ),
                        width(5),
                        const CircleAvatar(
                          backgroundColor: midnightBlue,
                          minRadius: 5,
                          maxRadius: 5,
                        ),
                      ],
                    ),
                    height(40),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Confirm the recovery secret phrase",
                        style: TextStyle(color: white, fontSize: 18),
                      ),
                    ),
                    height(10),
                    const Center(
                      child: Text("Enter each word in the order",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: blueGray)),
                    ),
                    height(30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: Get.width * .3,
                          child: TextField(
                            style: const TextStyle(color: white),
                            controller: controller.word1,
                            textAlign: TextAlign.center,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                hintText: "word 1",
                                isDense: true,
                                hintStyle: const TextStyle(color: grey),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: grey)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: grey))),
                          ),
                        ),
                        SizedBox(
                          width: Get.width * .3,
                          child: TextField(
                            controller: controller.word4,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: white),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                hintText: "word 4",
                                isDense: true,
                                hintStyle: const TextStyle(color: grey),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: grey)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: grey))),
                          ),
                        ),
                      ],
                    ),
                    height(30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: Get.width * .3,
                          child: TextField(
                            style: const TextStyle(color: white),
                            textInputAction: TextInputAction.next,
                            textAlign: TextAlign.center,
                            controller: controller.word8,
                            decoration: InputDecoration(
                                hintText: "word 8",
                                isDense: true,
                                hintStyle: const TextStyle(color: grey),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: grey)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: grey))),
                          ),
                        ),
                        SizedBox(
                          width: Get.width * .3,
                          child: TextField(
                            controller: controller.word12,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: white),
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                hintText: "word 12",
                                isDense: true,
                                hintStyle: const TextStyle(color: grey),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: grey)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: grey))),
                          ),
                        ),
                      ],
                    ),
                    height(Get.height * .12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                              onPressed: () => Get.back(),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text("Back"),
                              )),
                        ),
                      ],
                    ),
                    height(20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                if (controller.phrase[0] ==
                                        controller.word1.text.trim() &&
                                    controller.phrase[3] ==
                                        controller.word4.text.trim() &&
                                    controller.phrase[7] ==
                                        controller.word8.text.trim() &&
                                    controller.phrase[11] ==
                                        controller.word12.text.trim()) {
                                  Get.toNamed("/authCompleteScreen");
                                } else {
                                  Get.snackbar("Word Not match",
                                      "Enter each word in order!");
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text("Next"),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
