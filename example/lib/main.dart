import 'package:animated_reel/reel.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: SizedBox(
              height: 500,
              child: Reel(
                  height: 240,
                  duration: Duration(seconds:5),
                  iterations: 3,
                  children:
                      List.generate(10, (index) => Container(height:24, child:Text(index.toString()))))),
        ),
      ),
    );
  }
}
