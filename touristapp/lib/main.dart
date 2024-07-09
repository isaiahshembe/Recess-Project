import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:touristapp/localization/app_localizations.dart';
import 'package:touristapp/pages/settings/localprovider.dart';
import 'package:touristapp/pages/settings/themeprovider.dart';
import 'package:touristapp/pages/splash%20screen/splashscreen.dart';

void main() {
<<<<<<< HEAD
  runApp(const MyApp());
=======
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: MyApp(),
    ),
  );
>>>>>>> 16779a3ac9759173de7cbabb6b8f77eaec2260c6
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return  const GetMaterialApp(
=======
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    
    return  GetMaterialApp(
>>>>>>> 16779a3ac9759173de7cbabb6b8f77eaec2260c6
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.blue,
      ),
      locale: localeProvider.locale,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: SplashScreen(),

    );
  }
}