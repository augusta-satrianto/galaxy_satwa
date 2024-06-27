import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galaxy_satwa/check_auth.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/theme.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  Intl.defaultLocale = 'id';
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("bed2d965-abd1-4e09-a624-d3d4fa6933e9");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Galaxy Satwa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: neutral07,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: neutral02,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: neutral07,
          titleTextStyle: plusJakartaSans.copyWith(
              color: neutral00, fontSize: 20, fontWeight: semiBold),
          elevation: 0,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: neutral00),
        ),
      ),
      localizationsDelegates: const [
        // ...delegasi lokal lainnya
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('id', 'ID'),
      ],
      home: const CheckAuth(),
    );
  }
}
