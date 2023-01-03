import 'package:flutter/material.dart';
import 'package:nucleus/utils/theme.dart';
import 'package:nucleus/view/widgets/common.dart';

class NftDetails extends StatelessWidget {
  final Map data;
  const NftDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data["name"]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image(
                    image: NetworkImage(data["image"].toString().replaceFirst(
                        'ipfs://', r'https://nftstorage.link/ipfs/')),
                  ),
                ),
              ),
              height(5),
              const Text("Description", style: TextStyle(color: grey)),
              height(5),
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Text("Description", style: TextStyle(color: grey)),
                      height(5),
                      Text(data["description"]),
                    ],
                  ),
                ),
              ),
              height(5),
              const Text("Attributes", style: TextStyle(color: grey)),
              height(5),
              Card(
                child: ListView.builder(
                    itemCount: data["attributes"].length,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return Column(
                        children: [
                          ListTile(
                            dense: true,
                            title: Text(data["attributes"][index]["trait_type"]
                                .toString()),
                            trailing: Text(
                                data["attributes"][index]["value"].toString()),
                          ),
                          const Divider(endIndent: 10, indent: 10),
                        ],
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
