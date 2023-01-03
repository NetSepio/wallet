import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';
import 'package:nucleus/utils/theme.dart';

class AboutWalletScreen extends StatefulWidget {
  const AboutWalletScreen({super.key});

  @override
  State<AboutWalletScreen> createState() => _AboutWalletScreenState();
}

class _AboutWalletScreenState extends State<AboutWalletScreen> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    FutureBuilder(
      future: rootBundle.loadString('assets/privacy_policy.md', cache: true),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Markdown(
            data: snapshot.data.toString(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ),
    FutureBuilder(
      future:
          rootBundle.loadString('assets/terms_and_conditions.md', cache: true),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Markdown(
            data: snapshot.data.toString(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("About Nucleus"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: appcolor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Privacy Policy '),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'Terms of Service'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: white,
        onTap: _onItemTapped,
      ),
    );
  }
}
