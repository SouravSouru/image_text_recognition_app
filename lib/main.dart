import 'package:flutter/material.dart';
import 'package:image_text_recognition_app/contoller/homePageContoller.dart';
import 'package:image_text_recognition_app/screen/homeScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomePageController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark
        ),
        home: HomeScreen()
      ),
    );
  }
}
