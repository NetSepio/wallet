import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet/view/Home/home_ctr.dart';

class HistoryDetails extends StatelessWidget {
  const HistoryDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        centerTitle: true,
      ),
      body: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (controller) {
            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Column(
                            children: [
                              Lottie.asset("assets/lottiefiles/history.json"),
                              Table(
                                border: TableBorder.symmetric(
                                    inside: const BorderSide(
                                        color: Colors.black26)),
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: [
                                  TableRow(children: [
                                    const Text("Network"),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(controller
                                          .getTransactionBasedOnCurrentNetwork![
                                              0]
                                          .currentNetwork),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    const Text("From"),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(controller
                                          .getTransactionBasedOnCurrentNetwork![
                                              0]
                                          .from),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    const Text("To"),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(controller
                                          .getTransactionBasedOnCurrentNetwork![
                                              0]
                                          .to),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    const Text("Gas Used"),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(controller
                                          .getTransactionBasedOnCurrentNetwork![
                                              0]
                                          .gasUsed),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    const Text("Cumulative Gas Used"),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(controller
                                          .getTransactionBasedOnCurrentNetwork![
                                              0]
                                          .cumulativeGasUsed),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    const Text("Effective Gas Price"),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(controller
                                          .getTransactionBasedOnCurrentNetwork![
                                              0]
                                          .effectiveGasPrice),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    const Text("Transaction Hash"),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(controller
                                          .getTransactionBasedOnCurrentNetwork![
                                              0]
                                          .transactionHash),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    const Text("Transaction Index"),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(controller
                                          .getTransactionBasedOnCurrentNetwork![
                                              0]
                                          .transactionIndex),
                                    ),
                                  ]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
