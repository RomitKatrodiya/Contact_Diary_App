import 'package:contact_diary_app/screens/add_page.dart';
import 'package:contact_diary_app/screens/detail_page.dart';
import 'package:contact_diary_app/screens/edit_page.dart';
import 'package:contact_diary_app/screens/home_page.dart';
import 'package:contact_diary_app/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    myApp(),
  );
}

class myApp extends StatefulWidget {
  myApp({Key? key}) : super(key: key);

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: (AppTheme.isDark == false) ? ThemeMode.light : ThemeMode.dark,
      routes: {
        "/": (context) => Home_Page(),
        "add_page": (context) => Add_Page(),
        "detail_page": (context) => Detail_Page(),
        "edit_page": (context) => const Edit_Page(),
      },
    );
  }
}
