import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:NetSepio/models/nft_model.dart';
import 'package:NetSepio/models/token_model.dart';
import 'package:NetSepio/models/transaction_history_model.dart';
import 'package:NetSepio/view/Dashboard/dashboard.dart';
import 'package:NetSepio/view/Home/home.dart';
import 'package:NetSepio/view/Receive/receive_screen.dart';
import 'package:NetSepio/view/Home/home_ctr.dart';
import 'package:NetSepio/view/nft/nft.dart';
import 'package:NetSepio/view/send/history_details.dart';
import 'package:NetSepio/view/setting/about_wallet.dart';
import 'package:NetSepio/view/setting/addtoken_screen.dart';
import 'package:NetSepio/view/Authentication/auth_complete_screen.dart';
import 'package:NetSepio/view/Authentication/import_account_screen.dart';
import 'package:NetSepio/view/Authentication/intro_screen.dart';
import 'package:NetSepio/view/Authentication/lock_screen.dart';
import 'package:NetSepio/view/Authentication/generate_phrase_screen.dart';
import 'package:NetSepio/view/Authentication/verify_phrase_screen.dart';
import 'package:NetSepio/view/Authentication/splash_screen.dart';
import 'package:NetSepio/view/Authentication/landing_screen.dart';
import 'package:NetSepio/view/send/send_screen.dart';
import 'package:NetSepio/view/send/transaction_complete_screen.dart';
import 'package:NetSepio/view/setting/mywallet.dart';
import 'package:NetSepio/view/setting/setting.dart';
import 'package:NetSepio/utils/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:NetSepio/view/widgets/common.dart';

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
      title: 'NetSepio',
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
