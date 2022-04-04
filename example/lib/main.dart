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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Container(
            height:100,
            color:Colors.grey,
              child: 
              Reel(
                  duration: Duration(seconds:5),
                  iterations: 3,
                  // itemCount:10,
                  height: 10 * 10,
                  children:List.generate(10, (index) => Text(index.toString(),key:ValueKey("candidate$index") )).cast<Widget>() ), 
        ),
      ),
    ));
  }
}
