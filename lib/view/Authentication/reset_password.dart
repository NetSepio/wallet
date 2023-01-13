import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:NetSepio/utils/theme.dart';
import 'package:NetSepio/view/Authentication/auth_controller.dart';
import 'package:NetSepio/view/widgets/common.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reset PIN",
          style: TextStyle(fontSize: 18),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: GetBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Card(
              color: white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Old PIN",
                      style: TextStyle(color: midnightBlue),
                    ),
                    height(5),
                    TextField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      controller: controller.oldPINcontroller,
                      style: const TextStyle(color: appcolor),
                      decoration: InputDecoration(
                        hintText: "Enter Old PIN",
                        isDense: true,
                        hintStyle: const TextStyle(color: grey, fontSize: 12),
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
                    height(15),
                    const Text(
                      "New PIN",
                      style: TextStyle(color: midnightBlue),
                    ),
                    height(5),
                    TextField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      controller: controller.newPINcontroller,
                      style: const TextStyle(color: appcolor),
                      decoration: InputDecoration(
                        hintText: "Enter New PIN",
                        isDense: true,
                        hintStyle: const TextStyle(color: grey, fontSize: 12),
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
                    height(15),
                    const Text(
                      "Confirm PIN",
                      style: TextStyle(color: midnightBlue),
                    ),
                    height(5),
                    TextField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      controller: controller.confirmPINcontroller,
                      style: const TextStyle(color: appcolor),
                      decoration: InputDecoration(
                        hintText: "Confirm PIN",
                        isDense: true,
                        hintStyle: const TextStyle(color: grey, fontSize: 12),
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
                    height(50),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              controller.resetPIN(context: context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text("RESET PIN"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    height(20),
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
