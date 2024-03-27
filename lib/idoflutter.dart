import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
typedef Future<dynamic> EventHandler(String res);

class IdoFlutter {
  static const MethodChannel _channel = MethodChannel('IdoFlutter');
  late EventHandler _initIdoSdkCallBack;

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  void setDebugEnable(bool isDebug) {
    if (Platform.isAndroid) {
      _channel.invokeMethod('setDebugEnable', {"debugEnable": isDebug});
    } else {
      _channel.invokeMethod('setDebugEnable', {"debugEnable": isDebug});
    }
  }

  void initIdoSdk(String appId) {
    if (Platform.isAndroid) {
      _channel.invokeMethod('init');
    } else {
      _channel.invokeMethod('init', {"appId": appId});
    }
  }

  void preInitIdoSdk() {
    if (Platform.isAndroid) {
      _channel.invokeMethod('preInit');
    } else {
      _channel.invokeMethod('preInit');
    }
  }

  Future<String?> getGtcId() async {
    if (Platform.isAndroid) {
      return _channel.invokeMethod('getGtcId');
    } else {
      return _channel.invokeMethod('getGtcId');
    }
  }

  void onEvent(String eventId, Map<String, Object> map) {
    if (Platform.isAndroid) {
      _channel.invokeMethod('onEvent', {"eventId": eventId, "jsonObject": map});
    } else {
      _channel.invokeMethod('onEvent', {"eventId": eventId, "jsonObject": map});
    }
  }

  void setProfile(Map<String, Object> map) {
    if (Platform.isAndroid) {
      _channel.invokeMethod('setProfile', {"jsonObject": map});
    } else {
      _channel.invokeMethod('setProfile', {"jsonObject": map});
    }
  }

  void addEventHandler(
      {required EventHandler initIdoSdkCallBack}) {
    _initIdoSdkCallBack = initIdoSdkCallBack;
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future _handleMethod(MethodCall call) async {
    print("MethodCall : ${call.method} : ${call.arguments}");
    switch (call.method) {
      case "gtcIdCallback":
        return _initIdoSdkCallBack(call.arguments);
      default:
        throw UnsupportedError("Unrecongnized Event");
    }
  }
}
