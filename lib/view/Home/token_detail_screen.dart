import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nucleus/models/token_model.dart';
import 'package:nucleus/utils/theme.dart';
import 'package:nucleus/view/Home/home_ctr.dart';
import 'package:nucleus/view/send/send_screen.dart';

class TokenDetailScreen extends StatelessWidget {
  final TokenModel token;

  TokenDetailScreen({super.key, required this.token});
  final controller = Get.put<HomeController>(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(token.tokenName),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/wallet.png',
                        height: 80,
                      ),
                      const SizedBox(height: 20),
                      FutureBuilder<dynamic>(
                          future: controller.getAccountAddressAndBalance(
                            istokenBalance: true,
                            tokenAddress: token.tokenAddress,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              return Column(
                                children: [
                                  Text(
                                    '${snapshot.data.toStringAsFixed(3)}',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    token.tokenName,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            } else {
                              return Text(
                                '0 ${token.tokenName}',
                                style: Theme.of(context).textTheme.headline5,
                              );
                            }
                          }),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .2,
                            child: OutlinedButton(
                              child: const Text('Send'),
                              onPressed: () => Get.to(() => SendScreen(
                                    isTokenTransfer: true,
                                    tokenAddress: token.tokenAddress,
                                  )),
                            ),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            child: const Text('Receive'),
                            onPressed: () => Get.toNamed("/receiveScreen"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: grey),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'You have no transaction!',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
