import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:idoflutter/idoflutter.dart';
import 'dart:io';
import 'WebViewPage.dart';

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
  final TextEditingController _controllerEventIDTime = TextEditingController();
  final TextEditingController _controllerKeyTime = TextEditingController();
  final TextEditingController _controllerValueTime = TextEditingController();
  final TextEditingController _controllerEventIDCount = TextEditingController();
  final TextEditingController _controllerKeyCount = TextEditingController();
  final TextEditingController _controllerValueCount = TextEditingController();
  final TextEditingController _controllerKeyProperty = TextEditingController();
  final TextEditingController _controllerValueProperty =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    IdoFlutter.instance.preInitIdoSdk();
  }

  void jumpWebView() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WebViewPage()));
    });
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
    //if (Platform.isAndroid) {
    IdoFlutter.instance.addEventHandler(
        initIdoSdkCallBack: (String gtcId) async {
      print("flutter initIdoSdkCallBack: $gtcId");
      setState(() {
        _initIdoSdkResult = gtcId;
      });
    });
    //}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(builder: (BuildContext context) {
          return ListView(
            children: <Widget>[
              Container(
                // height: 200,
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Text('Running on: $_platformVersion\n'),
                    Row(children: [
                      ElevatedButton(
                          onPressed: () {
                            IdoFlutter.instance.setDebugEnable(true);
                          },
                          child: const Text('开启开发者模式，上线请关闭')),
                    ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              IdoFlutter.instance.initIdoSdk(
                                  "5xpxEg5qvI9PNGH2kQAia2", "flutter");
                              getGtcId();
                            },
                            child: const Text('初始化'),
                          ),
                          Expanded(child: Text(' gtcId:  $_initIdoSdkResult')),
                        ]),
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "计时事件：",
                          style: TextStyle(
                              fontSize: 16.0, color: Color(0xFF333333)),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _controllerEventIDTime,
                      decoration:
                          const InputDecoration(hintText: "请输入 Event ID"),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: TextField(
                              controller: _controllerKeyTime,
                              decoration:
                                  const InputDecoration(hintText: "请输入 Key"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextField(
                              controller: _controllerValueTime,
                              decoration:
                                  const InputDecoration(hintText: "请输入 Value"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              onBeginEvent(context);
                            },
                            child: const Text("事件开始",
                                style: TextStyle(
                                    textBaseline: TextBaseline.alphabetic)),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              onEndEvent();
                            },
                            child: const Text("事件结束",
                                style: TextStyle(
                                    textBaseline: TextBaseline.alphabetic)),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 28.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "计数事件：",
                          style: TextStyle(
                              fontSize: 16.0, color: Color(0xFF333333)),
                        ),
                      ),
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(hintText: "请输入 Event ID"),
                      controller: _controllerEventIDCount,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextField(
                              controller: _controllerKeyCount,
                              decoration:
                                  const InputDecoration(hintText: "请输入 Key"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextField(
                              controller: _controllerValueCount,
                              decoration:
                                  const InputDecoration(hintText: "请输入 Value"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        countEvent();
                      },
                      child: const Text("计数事件统计",
                          style:
                              TextStyle(textBaseline: TextBaseline.alphabetic)),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextField(
                              controller: _controllerKeyProperty,
                              decoration:
                                  const InputDecoration(hintText: "请输入 Key"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextField(
                              controller: _controllerValueProperty,
                              decoration:
                                  const InputDecoration(hintText: "请输入 Value"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setProperty();
                      },
                      child: const Text("用户属性",
                          style:
                              TextStyle(textBaseline: TextBaseline.alphabetic)),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebViewPage()));
                        },
                        child: const Text("跳转webview页面",
                            style: TextStyle(
                                textBaseline: TextBaseline.alphabetic))),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  void onBeginEvent(BuildContext context) {
    //开发者可以自行设置全局事件属性
    Map<String, dynamic> map = {"key1": "value1"};
    IdoFlutter.instance.registerEventProperties(map);

    var eventId = _controllerEventIDTime.text;
    if (eventId.isEmpty) {
      print("请设置自定义事件 Event ID");
      const snackBar = SnackBar(
        content: Text('请设置自定义事件 Event ID'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    var key = _controllerKeyTime.text;
    var value = _controllerValueTime.text;
    if (value.isNotEmpty) {
      Map<String, dynamic> map = {key: value};
      IdoFlutter.instance.onBeginEvent(eventId, map);
    } else {
      IdoFlutter.instance.onBeginEvent(eventId, null);
    }
  }

  void onEndEvent() {
    var eventId = _controllerEventIDTime.text;
    if (eventId.isEmpty) {
      print("请设置自定义事件 Event ID");
      const snackBar = SnackBar(
        content: Text('请设置自定义事件 Event ID'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    var key = _controllerKeyTime.text;
    var value = _controllerValueTime.text;
    if (value.isNotEmpty && key.isNotEmpty) {
      Map<String, dynamic> map = {key: value};
      IdoFlutter.instance.onEndEvent(eventId, map);
    } else {
      IdoFlutter.instance.onEndEvent(eventId, null);
    }
  }

  void countEvent() {
    var eventId = _controllerEventIDCount.text;
    if (eventId.isEmpty) {
      print("请设置自定义事件 Event ID");
      const snackBar = SnackBar(
        content: Text('请设置自定义事件 Event ID'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    var key = _controllerKeyCount.text;
    var value = _controllerValueCount.text;
    if (value.isNotEmpty && key.isNotEmpty) {
      Map<String, dynamic> map = {key: value};
      IdoFlutter.instance.trackCountEvent(eventId, map);
    } else {
      IdoFlutter.instance.trackCountEvent(eventId, null);
    }
  }

  void setProperty() {
    var key = _controllerKeyProperty.text;
    var value = _controllerValueProperty.text;
    if (value.isNotEmpty && key.isNotEmpty) {
      Map<String, dynamic> map = {key: value};
      IdoFlutter.instance.setProfile(map);
    }
  }

  Future<void> getGtcId() async {
    String? gtcId = await IdoFlutter.instance.getGtcId();
    print("flutter getGtcId: $gtcId");
    setState(() {
      _initIdoSdkResult = gtcId!;
    });
  }
}
