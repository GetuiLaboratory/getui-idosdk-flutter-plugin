# idoflutter

# 1、引用

增加依赖：

```shell
flutter pub add idoflutter
```

或者手动在工程 pubspec.yaml 中加入 dependencies：

```yaml
dependencies:
  idoflutter: ^0.0.5
```
下载依赖：

```shell
flutter pub get
flutter run
```

# 2、配置

## 2.1 Android配置

##### 2.1.1 app的build.gradle配置

到个推官网申请appID、配置签名文件

```groovy
defaultConfig {
        applicationId "自己填"
        //.......
        manifestPlaceholders = [
                GETUI_APPID         : "自己填",//请填写开发者在 https://dev.getui.com/ 申请的GETUI_APPID
                GT_INSTALL_CHANNEL: "getui",//请填写开发者需要的channel
        ]
    }
```

配置依赖，最新版本见官网： https://docs.getui.com/ido/mobile/android/init/

```groovy
dependencies {
    //用户运营sdk
    implementation 'com.getui:gsido:1.4.11.0'
    //个推核心组件
    implementation 'com.getui:gtc:3.2.13.0'
}
```

##### 2.1.2 project的build.gradle配置

```groovy
allprojects {
    repositories {
        maven {
           //仓库配置
            url "https://mvn.getui.com/nexus/content/repositories/releases/"
        }
       //....
    }
}
```

### 2.2 HarmonyOS 配置
*  引入插件, 见上文
* 使用鸿蒙定制版 Flutter，否则报错依赖缺失, 下载地址: [OpenHarmony Flutter](https://gitcode.com/openharmony-tpc/flutter_flutter) 及 [使用教程](https://developer.huawei.com/consumer/cn/blog/topic/03178381351651116)。
* [启动应用教程](https://gitcode.com/openharmony-tpc/flutter_flutter#%E6%9E%84%E5%BB%BA%E6%AD%A5%E9%AA%A4)



#### 2.2.1 配置 `build-profile.json5`
ohos工程需要兼容字节码包,在项目级build-profile.json5:
```yaml
    "buildOption": {
      "strictMode": {
         "useNormalizedOHMUrl": true
      }
    }
```
#### 2.2.2 配置 `module.json5`
在项目中配置：
```yaml
"requestPermissions": [
    {"name": "ohos.permission.INTERNET"},
    {"name": "ohos.permission.GET_NETWORK_INFO"},
    {
        "name": "ohos.permission.APP_TRACKING_CONSENT",
        "reason": "$string:tracking_reason",
        "usedScene": {
            "abilities": ["EntryAbility"]
        }
    }
],
"metadata": [
    {"name": "GETUI_APPID", "value": "aXJsKBst3i9WK3E7etwBL5"},//你的appid
]
```

#### 2.3.3 注册插件
运行 fvm flutter build hap 后自动生成 GeneratedPluginRegistrant



#  3、使用

```dart
import 'package:idoflutter/idoflutter.dart';
```

## 3.1 API

```dart
/**
* 初始化
* appId: appid（ios)
* channelID: channel（ios)
* iOS环境下，IDO SDK>=2.0.7.0，会有gtcIdCallback回调
*/
IdoFlutter.instance.initIdoSdk("5xpxEg5qvI9PNGH2kQAia2","flutter");


/**
 * 开启SDK日志，默认false，上线需要关闭
 */
IdoFlutter.instance.setDebugEnable(false);

/**
 *获取gtcid
 */
IdoFlutter.instance.getGtcId(false);

/**
 * 计数统计
 *  eventId：自定义事件 Id ，用于标识事件的唯一
 *  map: 自定义属性，用于扩展统计需求
 * 
 */
IdoFlutter.instance.trackCountEvent(String eventId, Map<String, dynamic>? map);

/**
 * 计时统计开始
 *  eventId：自定义事件 Id ，用于标识事件的唯一
 *  map: 自定义属性，用于扩展统计需求
 */
IdoFlutter.instance.onBeginEvent(String eventId, Map<String, dynamic>? map);

/**
 * 计时统计结束
 *  eventId：自定义事件 Id ，用于标识事件的唯一
 *  map: 自定义属性，用于扩展统计需求
 */
IdoFlutter.instance.onEndEvent(String eventId, Map<String, dynamic>? map);


/**
 * 用户属性设置
 *  map: 自定义用户属性，用于扩展统计需求
 */
IdoFlutter.instance.setProfile(Map<String, dynamic>? map);

/**
 * 设置计数事件上传频率
 * timeMillis：设置的eventUploadInterval值，单位毫秒。
 * 默认值为10秒
 */
IdoFlutter.instance.setEventUploadInterval(Long timeMillis);


/**
 * 设置计数事件事件强制上传条数
 * size：设置计数事件的强制上传条数eventForceUploadSize
 * 默认数量为30条；
 */
IdoFlutter.instance.setEventForceUploadSize(int size);

/**
 * 设置用户属性事件上传频率
 * timeMillis：单位毫秒。设置用户属性事件传频率profileUploadInterval
 * 默认值为5秒
 */
IdoFlutter.instance.setProfileUploadInterval(Long timeMillis)

/**
 * 设置用户属性事件强制上传条数
 * size 设置用户属性事件的强制上传条数profileForceUploadSize
 * 默认数量为5条
 */
IdoFlutter.instance.setProfileForceUploadSize(int size);

/**
 * IOS 特有
 * 设置App Groups ID
 * 通过苹果开发者后台创建Group Identify， 用于App主包和Extension之间的数据打通。
 * 
 */
IdoFlutter.instance.setApplicationGroupIdentifier(String identifier) 

```


### 3.2 Android demo

https://github.com/GetuiLaboratory/getui-idosdk-flutter-plugin/tree/main/example


### 3.3 IOS demo

- GCIDOSDK>=2.0.7.0版本，需要使用最新插件版本
- GCIDOSDK<2.0.7.0版本，需要使用插件版本0.0.1
https://github.com/GetuiLaboratory/getui-idosdk-flutter-plugin/tree/main/example

### 3.2 ohos demo
https://github.com/GetuiLaboratory/getui-idosdk-flutter-plugin/tree/main/example
