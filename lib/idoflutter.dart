import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/services.dart';

typedef EventHandler = Future<dynamic> Function(String res);

class IdoFlutter {
  // 单例模式
  static final IdoFlutter _singleton = IdoFlutter._internal();
  factory IdoFlutter() {
    return _singleton;
  }
  IdoFlutter._internal();

  static IdoFlutter get instance => _singleton;

  static const MethodChannel _channel = MethodChannel('IdoFlutter');
  late EventHandler _initIdoSdkCallBack;

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  void setDebugEnable(bool isDebug) {
     _channel.invokeMethod('setDebugEnable', {"debugEnable": isDebug});
  }

  void initIdoSdk(String appId, String channelId) {
    if (Platform.isAndroid) {
      setAppId(appId);
      setInstallChannel(channelId);
      _channel.invokeMethod('init');
    } else {
      _channel.invokeMethod('init', {"appId": appId, "channelId": channelId});
    }
  }

  void preInitIdoSdk() {
    _channel.invokeMethod('preInit');
  }

  Future<String?> getGtcId() async {
     return await _channel.invokeMethod('getGtcId');
  }

  void trackCountEvent(String eventId, Map<String, dynamic>? map) {
    _channel.invokeMethod(
             'trackCountEvent', {"eventId": eventId, "jsonObject": map});
  }

  void onBeginEvent(String key, Map<String, dynamic>? map) {
    _channel
              .invokeMethod('onBeginEvent', {"eventId": key, "jsonObject": map});
  }

  void onEndEvent(String key, Map<String, dynamic>? map) {
    _channel.invokeMethod('onEndEvent', {"eventId": key, "jsonObject": map});
  }

  void setProfile(Map<String, dynamic> map) {
     _channel.invokeMethod('setProfile', {"jsonObject": map});
  }

  void addEventHandler({required EventHandler initIdoSdkCallBack}) {
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

  void setInstallChannel(String channel) {
     _channel.invokeMethod('setInstallChannel', {"channel": channel});
  }

  void setAppId(String appId) {
    _channel.invokeMethod('setAppId', {"appId": appId});
  }

  void setEventUploadInterval(Long timeMillis) {
   _channel.invokeMethod('setEventUploadInterval', {"timeMillis": timeMillis});

  }

  void setEventForceUploadSize(int size) {
       _channel.invokeMethod('setEventForceUploadSize', {"size": size});
  }

  void setProfileUploadInterval(Long timeMillis) {
     _channel
             .invokeMethod('setProfileUploadInterval', {"timeMillis": timeMillis});
  }

  void setProfileForceUploadSize(int size) {
      _channel.invokeMethod('setProfileForceUploadSize', {"size": size});
  }

  void setSessionTimeoutMillis(Long timeoutMillis) {
    _channel.invokeMethod(
          'setSessionTimeoutMillis', {"timeoutMillis": timeoutMillis});
  }

  void setMinAppActiveDuration(Long minAppActiveDuration) {
    _channel.invokeMethod('setMinAppActiveDuration',
            {"minAppActiveDuration": minAppActiveDuration});
  }

  void setMaxAppActiveDuration(Long maxAppActiveDuration) {
    _channel.invokeMethod('setMaxAppActiveDuration',
            {"maxAppActiveDuration": maxAppActiveDuration});
  }

  void setApplicationGroupIdentifier(String identifier) {
    if (Platform.isIOS) {
      _channel.invokeMethod(
          'setApplicationGroupIdentifier', {"identifier": identifier});
    } else {}
  }

  void registerEventProperties(Map<String, dynamic> map) {
    // if (Platform.isIOS) {
      _channel.invokeMethod('registerEventProperties', {"properties": map});
    // } else {}
  }

  Future<String?> onBridgeEvent(String data) async {
    // if (Platform.isAndroid) {
    return await _channel.invokeMethod('onBridgeEvent', {"data": data});
    // } else {
    //   return "";
    // }
  }
}
