import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wallet/utils/theme.dart';
import 'package:wallet/utils/secure_storage.dart';
import 'package:wallet/view/widgets/common.dart';

class ReceiveScreen extends StatelessWidget {
  const ReceiveScreen({super.key});
  Future<String?> getAddress() async {
    SecureStorage storage = SecureStorage();
    String? address = await storage.getStoredValue('accountAddress');
    return address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receive"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: FutureBuilder<String?>(
          future: getAddress(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Column(
                      children: [
                        height(15),
                        QrImage(
                          data: snapshot.data!,
                          version: QrVersions.auto,
                          foregroundColor: appcolor,
                          dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.circle),
                          size: 250.0,
                        ),
                        const SizedBox(
                            width: 250, child: Divider(color: appcolor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: SizedBox(
                            width: 250,
                            child: Text(
                              snapshot.data!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14, color: appcolor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  height(20),
                  const Text(
                    "Share Qr code for Receive payment",
                    style: TextStyle(color: grey),
                  ),
                  height(50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: snapshot.data))
                              .then(
                            (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Address copied to clipboard"),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(Icons.copy, color: appcolor),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await FlutterShare.share(
                              title: snapshot.data!, text: snapshot.data);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(Icons.share, color: appcolor),
                        ),
                      ),
                    ],
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
