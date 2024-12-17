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
    if (Platform.isAndroid) {
      _channel.invokeMethod('setDebugEnable', {"debugEnable": isDebug});
    } else {
      _channel.invokeMethod('setDebugEnable', {"debugEnable": isDebug});
    }
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
    if (Platform.isAndroid) {
      _channel.invokeMethod('preInit');
    } else {}
  }

  Future<String?> getGtcId() async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('getGtcId');
    } else {
      return await _channel.invokeMethod('getGtcId');
    }
  }

  void trackCountEvent(String eventId, Map<String, dynamic>? map) {
    if (Platform.isAndroid) {
      _channel.invokeMethod(
          'trackCountEvent', {"eventId": eventId, "jsonObject": map});
    } else {
      _channel.invokeMethod(
          'trackCountEvent', {"eventId": eventId, "jsonObject": map});
    }
  }

  void onBeginEvent(String key, Map<String, dynamic>? map) {
    if (Platform.isAndroid) {
      _channel
          .invokeMethod('onBeginEvent', {"eventId": key, "jsonObject": map});
    } else {
      _channel
          .invokeMethod('onBeginEvent', {"eventId": key, "jsonObject": map});
    }
  }

  void onEndEvent(String key, Map<String, dynamic>? map) {
    if (Platform.isAndroid) {
      _channel.invokeMethod('onEndEvent', {"eventId": key, "jsonObject": map});
    } else {
      _channel.invokeMethod('onEndEvent', {"eventId": key, "jsonObject": map});
    }
  }

  void setProfile(Map<String, dynamic> map) {
    if (Platform.isAndroid) {
      _channel.invokeMethod('setProfile', {"jsonObject": map});
    } else {
      _channel.invokeMethod('setProfile', {"jsonObject": map});
    }
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
    if (Platform.isAndroid) {
      _channel.invokeMethod('setInstallChannel', {"channel": channel});
    } else {}
  }

  void setAppId(String appId) {
    if (Platform.isAndroid) {
      _channel.invokeMethod('setAppId', {"appId": appId});
    } else {}
  }

  void setEventUploadInterval(Long timeMillis) {
    if (Platform.isAndroid) {
      _channel
          .invokeMethod('setEventUploadInterval', {"timeMillis": timeMillis});
    } else {
      _channel
          .invokeMethod('setEventUploadInterval', {"timeMillis": timeMillis});
    }
  }

  void setEventForceUploadSize(int size) {
    if (Platform.isAndroid) {
      _channel.invokeMethod('setEventForceUploadSize', {"size": size});
    } else {
      _channel.invokeMethod('setEventForceUploadSize', {"size": size});
    }
  }

  void setProfileUploadInterval(Long timeMillis) {
    if (Platform.isAndroid) {
      _channel
          .invokeMethod('setProfileUploadInterval', {"timeMillis": timeMillis});
    } else {
      _channel
          .invokeMethod('setProfileUploadInterval', {"timeMillis": timeMillis});
    }
  }

  void setProfileForceUploadSize(int size) {
    if (Platform.isAndroid) {
      _channel.invokeMethod('setProfileForceUploadSize', {"size": size});
    } else {
      _channel.invokeMethod('setProfileForceUploadSize', {"size": size});
    }
  }

  void setSessionTimeoutMillis(Long timeoutMillis) {
    if (Platform.isAndroid) {
      _channel.invokeMethod(
          'setSessionTimeoutMillis', {"timeoutMillis": timeoutMillis});
    } else {}
  }

  void setMinAppActiveDuration(Long minAppActiveDuration) {
    if (Platform.isAndroid) {
      _channel.invokeMethod('setMinAppActiveDuration',
          {"minAppActiveDuration": minAppActiveDuration});
    } else {}
  }

  void setMaxAppActiveDuration(Long maxAppActiveDuration) {
    if (Platform.isAndroid) {
      _channel.invokeMethod('setMaxAppActiveDuration',
          {"maxAppActiveDuration": maxAppActiveDuration});
    } else {}
  }

  void setApplicationGroupIdentifier(String identifier) {
    if (Platform.isIOS) {
      _channel.invokeMethod(
          'setApplicationGroupIdentifier', {"identifier": identifier});
    } else {}
  }

  Future<String?> onBridgeEvent(String data) async {
    // if (Platform.isAndroid) {
    return await _channel.invokeMethod('onBridgeEvent', {"data": data});
    // } else {
    //   return "";
    // }
  }
}
