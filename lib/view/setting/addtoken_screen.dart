import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:NetSepio/models/nft_model.dart';
import 'package:NetSepio/models/token_model.dart';
import 'package:NetSepio/utils/theme.dart';
import 'package:NetSepio/utils/secure_storage.dart';
import 'package:NetSepio/view/Home/home_ctr.dart';
import 'package:NetSepio/web3dart/web3dart.dart';
import 'package:NetSepio/view/widgets/common.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class AddTokenController extends GetxController {
  HomeController homeController = Get.put<HomeController>(HomeController());
  TextEditingController _tokenAddressController = TextEditingController();
  TextEditingController tokeIdController = TextEditingController();
  TextEditingController get tokenAddressController => _tokenAddressController;
  bool scanToken = true;
  String tokenName = "";
  String tokenSymbol = "";
  String decimal = "";
  TokenModel? tokenValue;
  NFTModel? nftValue;
  @override
  void onClose() {
    _tokenAddressController.clear();
    tokeIdController.clear();
    super.onClose();
  }

  final Box<TokenModel> _tokenOnCurrentNetwork =
      Boxes.getTokenOnCurrentNetworkBox;
  final Box<NFTModel> _nftOnCurrentNetwork = Boxes.getNFTOnCurrentNetworkBox;

  Future<bool> approvalCallback() async {
    return true;
  }

  Future<void> insertIntoDB() async {
    if (Get.arguments) {
      await _nftOnCurrentNetwork.add(nftValue!);
    } else {
      await _tokenOnCurrentNetwork.add(tokenValue!);
    }
  }

  searchToken() async {
    if (Get.arguments) {
      nftValue = await getNFT();
    } else {
      tokenValue = await getToken();
    }
  }

  Future<TokenModel> getToken() async {
    try {
      Web3 web3 = Web3(approvalCallback);
      dynamic name = await web3.getTokenName(_tokenAddressController.text);
      dynamic symbol = await web3.getTokenSymbol(_tokenAddressController.text);
      dynamic newDecimals =
          await web3.getTokenDecimals(_tokenAddressController.text);
      decimal = newDecimals.toString().replaceAll('{', '').replaceAll('}', '');
      tokenName = name.toString().replaceAll('{', '').replaceAll('}', '');
      tokenSymbol = symbol.toString().replaceAll('{', '').replaceAll('}', '');
      scanToken = false;
      update();
      return TokenModel(
        tokenName: tokenName,
        symbol: tokenSymbol,
        decimal: decimal,
        tokenAddress: _tokenAddressController.text,
        currentNetwork: HomeController().getCurrentNetwork,
      );
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        titleText: Text(e.toString()),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        messageText: const Text(
          ".",
          style: TextStyle(fontSize: 1),
        ),
      ));
      rethrow;
    }
  }

  Future<NFTModel> getNFT() async {
    try {
      Web3 web3 = Web3(approvalCallback);
      dynamic name = await web3.getTokenName(_tokenAddressController.text);
      dynamic symbol = await web3.getTokenSymbol(_tokenAddressController.text);
      tokenName = name.toString().replaceAll('{', '').replaceAll('}', '');
      tokenSymbol = symbol.toString().replaceAll('{', '').replaceAll('}', '');
      scanToken = false;
      update();
      return NFTModel(
        tokenName: tokenName,
        symbol: tokenSymbol,
        tokenID: int.parse(tokeIdController.text),
        tokenAddress: _tokenAddressController.text,
        currentNetwork: HomeController().getCurrentNetwork,
      );
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        titleText: Text(e.toString()),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        messageText: const Text(
          ".",
          style: TextStyle(fontSize: 1),
        ),
      ));
      rethrow;
    }
  }

  Future<void> scanQR() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      String? cameraScanResult = await scanner.scan();
      if (cameraScanResult != null) {
        _tokenAddressController = TextEditingController(text: cameraScanResult);
      } else {
        Get.snackbar('Invalid QR Code.', "Try again!");
      }
    } else {
      throw 'Permissions denied';
    }
    update();
  }
}

class AddTokenScreen extends StatelessWidget {
  const AddTokenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Custom Token"),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: GetBuilder<AddTokenController>(
            init: AddTokenController(),
            builder: (controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  height(15),
                  Card(
                    color:
                        Get.isDarkMode ? midnightBlue.withOpacity(0.4) : white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          height(15),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              onTap: () {
                                HomeController homeController =
                                    Get.find<HomeController>();
                                networkSelect(context, homeController)
                                    .then((value) => controller.update());
                              },
                              dense: true,
                              title: const Text("Network"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(controller
                                      .homeController.getCurrentNetwork),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: grey),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller:
                                          controller.tokenAddressController,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        hintText: "Contract Address",
                                        hintStyle: TextStyle(color: grey),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        ClipboardData? cdata =
                                            await Clipboard.getData(
                                                Clipboard.kTextPlain);

                                        controller._tokenAddressController =
                                            TextEditingController(
                                                text: cdata!.text);
                                        controller.update();
                                      },
                                      child: const Text("PAST",
                                          style: TextStyle(color: blue)),
                                    ),
                                    width(10),
                                    InkWell(
                                      onTap: () {
                                        controller.scanQR();
                                      },
                                      child: const Icon(
                                          CupertinoIcons.qrcode_viewfinder,
                                          color: blue),
                                    ),
                                    width(13),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          height(15),
                          if (Get.arguments)
                            TextField(
                              textInputAction: TextInputAction.done,
                              controller: controller.tokeIdController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                hintText: "Token Id",
                                hintStyle: const TextStyle(color: grey),
                              ),
                            ),
                          if (Get.arguments) height(15),
                        ],
                      ),
                    ),
                  ),
                  if (controller.tokenName != "")
                    Card(
                      color: Get.isDarkMode
                          ? midnightBlue.withOpacity(0.4)
                          : white,
                      child: ListTile(
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  " Symbol : ",
                                  style: TextStyle(
                                    color: grey,
                                  ),
                                ),
                                Text(controller.tokenSymbol),
                              ],
                            ),
                            if (!Get.arguments)
                              Row(
                                children: [
                                  const Text(
                                    "Decimal : ",
                                    style: TextStyle(
                                      color: grey,
                                    ),
                                  ),
                                  Text(controller.decimal),
                                ],
                              ),
                          ],
                        ),
                        title: Row(
                          children: [
                            const Text(
                              " Name : ",
                              style: TextStyle(
                                color: grey,
                              ),
                            ),
                            Text(controller.tokenName),
                          ],
                        ),
                        isThreeLine: Get.arguments ? false : true,
                      ),
                    ),
                  height(40),
                  Row(
                    children: [
                      if (controller.scanToken)
                        Expanded(
                          child: CustomButton(
                            title: "Scan Token",
                            onTap: () async {
                              await controller.searchToken();
                            },
                          ),
                        ),
                      if (!controller.scanToken)
                        Expanded(
                          child: CustomButton(
                            title: Get.arguments ? "Add NFT" : "Add Token",
                            onTap: () async {
                              controller
                                  .insertIntoDB()
                                  .then((value) => Get.back());
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
