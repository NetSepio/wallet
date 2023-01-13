import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:NetSepio/utils/theme.dart';
import 'package:NetSepio/view/widgets/common.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      checkLock(false, splash: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Container(
        width: Get.width,
        decoration: const BoxDecoration(
          gradient: SweepGradient(colors: [
            Colors.black87,
            Color(0xff0F2027),
            Colors.black87,
            Color(0xff0F2027),
            Colors.black87,
          ], tileMode: TileMode.mirror),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: Get.width * .5,
                child: Image.asset("assets/images/logo.png")),
            height(25),
            const Text(
              "NetSepio",
              style: TextStyle(
                  fontSize: 30, color: white, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
