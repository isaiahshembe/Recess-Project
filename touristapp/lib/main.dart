import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:touristapp/firebase_options.dart';
import 'package:touristapp/pages/admin/admin_page.dart';
import 'package:touristapp/pages/main_page.dart';
import 'package:touristapp/pages/settings/localprovider.dart';
import 'package:touristapp/pages/settings/themeprovider.dart';
import 'package:touristapp/pages/splash%20screen/splashscreen.dart';
import 'package:touristapp/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tourist App',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const MainPage(), // Use your splash screen here
    );
  }
}
