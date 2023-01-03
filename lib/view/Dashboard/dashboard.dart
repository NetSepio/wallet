import 'package:flutter/material.dart';
import 'package:nucleus/utils/theme.dart';
import 'package:nucleus/view/Home/home.dart';
import 'package:nucleus/view/nft/nft.dart';
import 'package:nucleus/view/setting/setting.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    NFTScreen(),
    SettingScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: appcolor, borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                child: Image.asset(
                  "assets/images/wallet.png",
                  height: 30,
                  width: 50,
                )),
            InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                child: Image.asset("assets/images/nft.png", height: 30)),
            InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                child: Image.asset("assets/images/setting2.png", height: 30)),
          ],
        ),
      ),
    );
  }
}
