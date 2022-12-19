import 'package:flutter/material.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet/utils/theme.dart';

final pages = [
  PageData(
    icon: Lottie.asset('assets/lottiefiles/2.json'),
    title: "Secure and easy\n to use wallet",
    bgColor: black,
    textColor: Colors.white,
  ),
  PageData(
    icon: Lottie.asset('assets/lottiefiles/1.zip'),
    title: "Get real-time\n graphs info",
    textColor: white,
    bgColor: darkblue,
  ),
  PageData(
    icon: Lottie.asset('assets/lottiefiles/3.json'),
    title: "Way to manage\n your fund",
    bgColor: white,
    textColor: black,
  ),
];

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ConcentricPageView(
        colors: pages.map((p) => p.bgColor).toList(),
        radius: screenWidth * 0.1,
        nextButtonBuilder: (context) => Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(
            Icons.navigate_next,
            color: pages.map((p) => p.bgColor).toList().last,
            size: screenWidth * 0.1,
          ),
        ),
        onChange: (value) {
          if (value == 3) {
            Get.toNamed("/landingScreen");
          }
        },
        itemBuilder: (index) {
          final page = pages[index % pages.length];
          return SafeArea(
            child: _Page(page: page),
          );
        },
      ),
    );
  }
}

class PageData {
  final String? title;
  // ignore: prefer_typing_uninitialized_variables
  final icon;
  final Color bgColor;
  final Color textColor;

  const PageData({
    this.title,
    this.icon,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
  });
}

class _Page extends StatelessWidget {
  final PageData page;

  const _Page({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    space(double p) => SizedBox(height: screenHeight * p / 100);
    return Column(
      children: [
        space(10),
        SizedBox(height: Get.height * .4, child: page.icon),
        space(8),
        Text(
          page.title ?? '',
          style: TextStyle(
            color: page.textColor,
            fontWeight: FontWeight.w600,
            fontFamily: 'Helvetica',
            letterSpacing: 0.0,
            fontSize: 25,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
