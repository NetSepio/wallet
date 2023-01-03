import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:nucleus/models/nft_model.dart';
import 'package:nucleus/models/token_model.dart';
import 'package:nucleus/models/transaction_history_model.dart';
import 'package:nucleus/view/dashboard/dashboard.dart';
import 'package:nucleus/view/Home/home_ctr.dart';
import 'package:nucleus/view/nft/nft.dart';
import 'package:nucleus/view/send/history_details.dart';
import 'package:nucleus/view/setting/about_wallet.dart';
import 'package:nucleus/view/setting/addtoken_screen.dart';
import 'package:nucleus/view/receive/receive_screen.dart';
import 'package:nucleus/view/Authentication/auth_complete_screen.dart';
import 'package:nucleus/view/Authentication/import_account_screen.dart';
import 'package:nucleus/view/Authentication/intro_screen.dart';
import 'package:nucleus/view/Authentication/lock_screen.dart';
import 'package:nucleus/view/Authentication/generate_phrase_screen.dart';
import 'package:nucleus/view/Authentication/verify_phrase_screen.dart';
import 'package:nucleus/view/Authentication/splash_screen.dart';
import 'package:nucleus/view/Authentication/landing_screen.dart';
import 'package:nucleus/view/home/home.dart';
import 'package:nucleus/view/send/send_screen.dart';
import 'package:nucleus/view/send/transaction_complete_screen.dart';
import 'package:nucleus/view/setting/mywallet.dart';
import 'package:nucleus/view/setting/setting.dart';
import 'package:nucleus/utils/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nucleus/view/widgets/common.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TokenModelAdapter());
  Hive.registerAdapter(NFTModelAdapter());
  Hive.registerAdapter(TransactionHistoryAdapter());
  await Hive.openBox('darkModeBox');
  await Hive.openBox('fingerprintBox');
  await Hive.openBox('network_config');
  await Hive.openBox('current_network');
  await Hive.openBox<NFTModel>('nft_on_Network');
  await Hive.openBox<TokenModel>('tokens_on_Network');
  await Hive.openBox<TransactionHistory>('transaction_on_Network');
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log(state.name);
    switch (state) {
      case AppLifecycleState.resumed:
        //Execute the code here when user come back the app.
        //In my case, I needed to show if user active or not,
        checkLock(true, splash: false);
        break;
      case AppLifecycleState.detached:
        checkLock(true, splash: false);
        break;
      case AppLifecycleState.inactive:
        // checkLock();
        break;
      default:
        break;
    }
  }

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Nucleus',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: box.get('isDarkMode') != null
          ? box.get('isDarkMode')
              ? ThemeMode.dark
              : ThemeMode.light
          : ThemeMode.dark,
      initialRoute: "splash",
      routes: {
        "splash": (_) => const SplashScreen(),
        "/introductionScreen": (_) => const IntroductionScreen(),
        "/landingScreen": (_) => const LandingScreen(),
        "/authenticate": (_) => const LockScreen(),
        "/phraseScreen": (_) => const GenerateSeedPhrase(),
        "/verifyPhrase": (_) => const VerifyPhraseScreen(),
        "/importAccount": (_) => const ImportAccountScreen(),
        "/authCompleteScreen": (_) => const AuthCompleteScreen(),
        "/dashboard": (_) => const Dashboard(),
        "/home": (_) => const HomeScreen(),
        "/setting": (_) => const SettingScreen(),
        "/sendScreen": (_) => const SendScreen(),
        "/receiveScreen": (_) => const ReceiveScreen(),
        "/addTokenScreen": (_) => const AddTokenScreen(),
        "/transactionComplete": (_) => const TransactionCompleteScreen(),
        "/myWalletScreen": (_) => const MyWalletScreen(),
        "/aboutWalletScreen": (_) => const AboutWalletScreen(),
        "/NFTScreen": (_) => const NFTScreen(),
        "/historyDetails": (_) => const HistoryDetails(),
      },
    );
  }
}
