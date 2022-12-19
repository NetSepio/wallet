import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/view/Authentication/auth_controller.dart';
import 'package:wallet/utils/theme.dart';
import 'package:wallet/view/widgets/common.dart';

class GenerateSeedPhrase extends StatefulWidget {
  final bool view;
  const GenerateSeedPhrase({super.key, this.view = false});

  @override
  State<GenerateSeedPhrase> createState() => _GenerateSeedPhraseState();
}

class _GenerateSeedPhraseState extends State<GenerateSeedPhrase> {

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
                decoration: BoxDecoration(gradient: gradient),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SafeArea(
                          child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.arrow_back_ios,
                                  color: white)),
                        ),
                        height(10),
                        if (!widget.view)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                              width(5),
                              const CircleAvatar(
                                backgroundColor: midnightBlue,
                                minRadius: 5,
                                maxRadius: 5,
                              ),
                            ],
                          ),
                        height(10),
                        const Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Text(
                              "This is your secret recovery phrase.\nwrite it down on a piece of paper and keep it in a safe place. You will be prompted to enter this phrase again (in the correct order) in the next step.",
                              style: TextStyle(color: white, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        height(40),
                        FutureBuilder<String?>(
                            future: controller.getMnemonic,
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                controller.phrase =
                                    snapshot.data!.toString().split(" ");
                                log(controller.phrase.toString());
                                return GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 16 / 10),
                                  itemCount: controller.phrase.length,
                                  itemBuilder: (_, index) => Container(
                                    width: Get.width / 4,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: blue)),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    padding: const EdgeInsets.only(
                                        left: 12, top: 10, bottom: 8),
                                    child: Text(
                                      "${index + 1}. ${controller.phrase[index]}",
                                      style: const TextStyle(
                                          color: white, fontSize: 12),
                                    ),
                                  ),
                                );
                              } else {
                                controller.phrase = controller.generateMnemonic
                                    .toString()
                                    .split(" ");
                                log(controller.phrase.toString());
                                return GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 16 / 9),
                                  itemCount: controller.phrase.length,
                                  itemBuilder: (_, index) => FittedBox(
                                    fit: BoxFit.fill,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color: blue)),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
                                      padding: const EdgeInsets.only(
                                        left: 12, top: 10, bottom: 8),
                                      child: Text(
                                        "${index + 1}. ${controller.phrase[index]}",
                                        style: const TextStyle(
                                            color: white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }),
                        height(Get.height * .1),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (widget.view) {
                                      Navigator.pop(context);
                                    } else {
                                      controller.privateKeyFromMnemonic().then(
                                          (_) => Get.toNamed("/verifyPhrase"));
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: Text(widget.view ? "Back" : "Next"),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}