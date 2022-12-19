// ignore_for_file: unused_field, no_leading_underscores_for_local_identifiers, unnecessary_this
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet/utils/secure_storage.dart';
import 'package:wallet/view/Authentication/generate_phrase_screen.dart';
import 'package:wallet/view/Authentication/lock_screen.dart';
import 'package:wallet/web3dart/web3dart.dart';

class AuthController extends GetxController {
  final storage = SecureStorage();
  bool loading = false;
  bool _isFingerprintOn = false;
  final fingerprintBox = Boxes.getFingerprintBox;

  bool get isFingerprintOn => fingerprintBox.get('fingerPrint') ?? false;
  TextEditingController pincontroller = TextEditingController();
  TextEditingController oldPINcontroller = TextEditingController();
  TextEditingController newPINcontroller = TextEditingController();
  TextEditingController confirmPINcontroller = TextEditingController();
  TextEditingController importAccountphrase = TextEditingController();
  TextEditingController word1 = TextEditingController();
  TextEditingController word4 = TextEditingController();
  TextEditingController word8 = TextEditingController();
  TextEditingController word12 = TextEditingController();
  late String _mnemonic;
  List phrase = [];

  @override
  void onClose() {
    pincontroller.clear();
    oldPINcontroller.clear();
    newPINcontroller.clear();
    confirmPINcontroller.clear();
    importAccountphrase.clear();
    super.onClose();
  }

  Future<bool> approvalCallback() async {
    return true;
  }

  Future<void> toggleFingerprint(bool value) async {
    _isFingerprintOn = value;
    await fingerprintBox.put('fingerPrint', value);
    update();
  }

  String get mnemonic => _mnemonic;

  String get generateMnemonic => _mnemonic = bip39.generateMnemonic();

  Future<String?> get getMnemonic async {
    String? _mnemonic = await storage.getStoredValue('mnemonic');
    return _mnemonic;
  }

  Future<void> privateKeyFromMnemonic({String? newMnemonic}) async {
    if (newMnemonic != null) {
      this._mnemonic = newMnemonic;
    }
    await storage.writeStoredValues('mnemonic', _mnemonic);
    String pvtKey = Web3.privateKeyFromMnemonic(_mnemonic);
    await storage.writeStoredValues('pvtKey', pvtKey);
    Web3 web3 = Web3(approvalCallback);
    await web3.setCredentials(pvtKey);
    String accountAddress = await web3.getAddress();
    await storage.writeStoredValues("accountAddress", accountAddress);
  }

  void savePin({required bool fromImport}) async {
    if (pincontroller.text.isNotEmpty) {
      if (pincontroller.text.length >= 6) {
        await storage.writeStoredValues('PIN', pincontroller.text);
        fromImport
            ? Get.toNamed("/importAccount")
            : Get.toNamed("/phraseScreen");
        pincontroller.clear();
      } else {
        Get.snackbar("Enter a 6 digit PIN", "For a security pin is required");
      }
    } else {
      Get.snackbar("Enter a PIN", "For a security pin is required");
    }
  }

  Future<void> resetPIN({
    required BuildContext context,
  }) async {
    if (newPINcontroller.text == confirmPINcontroller.text) {
      String? originalPin = await storage.getStoredValue('PIN');
      if (originalPin == oldPINcontroller.text) {
        await storage.writeStoredValues('PIN', newPINcontroller.text);
        Get.snackbar("Your PIN has been changed successfully!", "");
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        Get.snackbar("Incorrect Old PIN", "");
      }
    } else {
      Get.snackbar("Incorrect confirm PIN", "");
    }
  }

  Future<void> checkFingerprint(splash) async {
    final isAuthenticated = await LocalAuthApi.authenticate();
    if (isAuthenticated) {
      Get.toNamed("/dashboard");
    } else {
      // Get.snackbar("Error!", "Your device doesn't support Biometrics!");
      Get.off(() => LockScreen(createPIN: false, splash: splash));
    }
  }

  Future<void> checkPIN(BuildContext context, bool tohome, {navigation}) async {
    final storage = SecureStorage();
    final String pin = await storage.getStoredValue('PIN') ?? 'No PIN';
    if (pin == pincontroller.text) {
      if (tohome) {
        Get.offNamed("/dashboard");
      } else {
        if (navigation) {
          navigation;
        }
        Get.back();
      }
      pincontroller.clear();
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Wrong PIN!'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                      height: Get.height * .3,
                      child: Lottie.asset("assets/lottiefiles/failed.json")),
                  const Text('Please enter correct PIN.'),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('TRY AGAIN!'),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      );
    }
  }
}

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException {
      rethrow;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (_) {
      return <BiometricType>[];
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await _auth.canCheckBiometrics;
    if (!isAvailable) return false;
    try {
      return await _auth.authenticate(
        localizedReason: 'Wallet needs fingerprint to authenticate',
        options: const AuthenticationOptions(
          biometricOnly: false,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (_) {
      return false;
    }
  }
}
