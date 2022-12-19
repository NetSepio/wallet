import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet/utils/theme.dart';
import 'package:wallet/view/Home/home_ctr.dart';
import 'package:wallet/view/nft/nft_details.dart';
import 'package:wallet/view/widgets/common.dart';

Future<bool> approvalCallback() async {
  return true;
}

class NFTScreen extends StatelessWidget {
  const NFTScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("NFT Collection"),
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      // ),
      body: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (homeController) {
            return homeController.getNFTBasedOnCurrentNetwork == null
                ? const Center(child: Text("Can't find any NFT"))
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: SafeArea(
                      child: Column(
                        children: [
                          const Text("NFT Collection",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          height(20),
                          Row(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  homeController.showERC721.value = false;
                                  homeController.update();
                                },
                                child: Column(
                                  children: [
                                    height(5),
                                    Text(
                                      "Assets",
                                      style: TextStyle(
                                        color: homeController.showERC721.value
                                            ? grey
                                            : blue,
                                        fontWeight:
                                            !homeController.showERC721.value
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    height(15),
                                    if (!homeController.showERC721.value)
                                      Container(
                                        height: 2,
                                        color: blueGray,
                                      )
                                  ],
                                ),
                              )),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  homeController.showERC721.value = true;
                                  homeController.update();
                                },
                                child: Column(
                                  children: [
                                    height(5),
                                    Text(
                                      "History",
                                      style: TextStyle(
                                        color: homeController.showERC721.value
                                            ? blue
                                            : grey,
                                        fontWeight:
                                            homeController.showERC721.value
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    height(15),
                                    if (homeController.showERC721.value)
                                      Container(
                                        height: 2,
                                        color: blueGray,
                                      ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                          height(10),
                          if (!homeController.showERC721.value &&
                                  homeController.getNFTBasedOnCurrentNetwork ==
                                      null ||
                              homeController
                                  .getNFTBasedOnCurrentNetwork!.isEmpty)
                            const NoData(),
                          if (!homeController.showERC721.value)
                            Expanded(
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  itemCount: homeController
                                      .getNFTBasedOnCurrentNetwork!.length,
                                  itemBuilder: (_, int index) {
                                    return FutureBuilder(
                                      future: homeController
                                          .web3
                                          .getImageFromToken(
                                              address: homeController
                                                  .getNFTBasedOnCurrentNetwork![
                                                      index]
                                                  .tokenAddress,
                                              token: homeController
                                                  .getNFTBasedOnCurrentNetwork![
                                                      index]
                                                  .tokenID),
                                      builder: (context, snapshot) {
                                        if (snapshot.error != null) {
                                          return Center(
                                            child:
                                                Text(snapshot.error.toString()),
                                          );
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: Lottie.asset(
                                                "assets/lottiefiles/loading.json",
                                                height: 40),
                                          );
                                        }
                                        if (snapshot.hasData) {
                                          log(snapshot.data!.toString());
                                          return GestureDetector(
                                            onTap: () {
                                              Get.to(() => NftDetails(
                                                        data: snapshot.data!,
                                                      ))!
                                                  .whenComplete(() =>
                                                      homeController.update());
                                            },
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: FittedBox(
                                                  child: Image(
                                                    image: NetworkImage(
                                                      snapshot.data!["image"]
                                                          .toString()
                                                          .replaceFirst(
                                                            r'ipfs://',
                                                            r'https://nftstorage.link/ipfs/',
                                                          ),
                                                    ),
                                                    height: Get.height * .3,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const Text(
                                              '\n\n\n   Retrieving Data ...\n\n\n');
                                        }
                                      },
                                    );
                                  }),
                            ),
                          if (homeController.showERC721.value &&
                              homeController.getNFTBasedOnCurrentNetwork ==
                                  null)
                            const NoData(),
                          if (homeController.showERC721.value)
                            Expanded(
                                child: ListView.builder(
                              itemCount: homeController
                                  .getNFTBasedOnCurrentNetwork!.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  color: Get.isDarkMode ? appcolor : white,
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                        foregroundImage:
                                            AssetImage("assets/images/nft.png"),
                                        backgroundColor: Colors.transparent),
                                    title: Text(
                                      homeController
                                          .getNFTBasedOnCurrentNetwork![index]
                                          .tokenName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    trailing: Text(
                                        homeController
                                            .getNFTBasedOnCurrentNetwork![index]
                                            .symbol,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12)),
                                  ),
                                );
                              },
                            )),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: ListTile(
                              onTap: () => Get.toNamed("/addTokenScreen",
                                      arguments: true)!
                                  .whenComplete(() => homeController.update()),
                              dense: true,
                              shape: const OutlineInputBorder(
                                  borderSide: BorderSide(color: grey)),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add, size: 20),
                                  width(10),
                                  const Text("Add NFT"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          }),
    );
  }
}
