import 'package:flutter/material.dart';
import 'package:liquidlibrary/ui/dynamicmainpage.dart';

class MainPage extends StatelessWidget {
  const MainPage ({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DynamicMainPage(),
    );
  }
}
