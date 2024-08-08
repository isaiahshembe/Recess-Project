import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:touristapp/pages/main_page.dart';
import 'package:touristapp/pages/profile/profile_page.dart';
import 'package:touristapp/pages/settings/localprovider.dart';
import 'package:touristapp/pages/settings/themeprovider.dart';
import 'package:touristapp/pages/splash%20screen/splashscreen.dart';
import 'package:touristapp/pages/stay.dart';
 // Assuming you have this
import 'package:touristapp/localization/app_localizations.dart'; // Assuming you have this

void main() {
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tourist App',
      theme: ThemeData(
        brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: Colors.green,  // Primary color set to green
        hintColor: Colors.blue,    // Accent color set to blue
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.green,
          textTheme: ButtonTextTheme.primary,
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.green,
          iconTheme: IconThemeData(color: Colors.white),
          toolbarTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Colors.green,
          secondary: Colors.blue,
        ),
      ),
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
      home: const SplashScreen(), // Assuming you have this page
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Get.to(const StaysPage());
            },
            icon: const Icon(Icons.search, color: Colors.green),
          ),
          IconButton(
            onPressed: () {
              
            },
            icon: const Icon(Icons.book_online, color: Colors.green),
          ),
          IconButton(
            onPressed: () {
              Get.to(const MainPage());
            },
            icon: const Icon(Icons.home, color: Colors.green),
          ),
          IconButton(
            onPressed: () {
              Get.to(const ProfilePage());
            },
            icon: const Icon(Icons.person, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
