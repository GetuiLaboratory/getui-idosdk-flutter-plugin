
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:idoflutter/idoflutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _initIdoSdkResult = 'Unknown';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await IdoFlutter.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    IdoFlutter().addEventHandler(
        initIdoSdkCallBack: (String gtcId) async {
          print("flutter initIdoSdkCallBack: $gtcId");
          setState(() {
            _initIdoSdkResult = gtcId;
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: ListView(children: <Widget>[
            Container(
              child: Column(children: <Widget>[
                Text('Running on: $_platformVersion\n'),
                ElevatedButton(
                  onPressed: () {
                    IdoFlutter().setDebugEnable(true);
                  },
                  child: const Text('开启开发者模式，上线请关闭'),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          IdoFlutter().initIdoSdk("5xpxEg5qvI9PNGH2kQAia2");
                        },
                        child: const Text('初始化'),
                      ),
                      Expanded(child: Text('gtcId:  $_initIdoSdkResult')),
                    ]),

              ]),
            )
          ])),
    );
  }
}
