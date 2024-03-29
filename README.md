# idoflutter

# 1、引用

增加依赖：

```shell
flutter pub add idoflutter
```

或者手动在工程 pubspec.yaml 中加入 dependencies：

```yaml
dependencies:
  idoflutter: ^0.0.1
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

配置依赖，最新版本见官网： https://docs.getui.com/geyan/mobile/android/init/

```groovy
dependencies {
    //用户运营sdk
    implementation 'com.getui:gsido:1.4.6.0'
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
*/
IdoFlutter().initIdoSdk("5xpxEg5qvI9PNGH2kQAia2","flutter");


/**
 * 开启SDK日志，默认false，上线需要关闭
 */
IdoFlutter().setDebugEnable(false);

/**
 *获取gtcid
 */
IdoFlutter().getGtcId(false);

/**
 * 计数统计
 *  eventId：自定义事件 Id ，用于标识事件的唯一
 *  map: 自定义属性，用于扩展统计需求
 * 
 */
IdoFlutter().trackCountEvent(String eventId, Map<String, dynamic>? map);

/**
 * 计时统计开始
 *  eventId：自定义事件 Id ，用于标识事件的唯一
 *  map: 自定义属性，用于扩展统计需求
 */
IdoFlutter().onBeginEvent(String eventId, Map<String, dynamic>? map);

/**
 * 计时统计结束
 *  eventId：自定义事件 Id ，用于标识事件的唯一
 *  map: 自定义属性，用于扩展统计需求
 */
IdoFlutter().onEndEvent(String eventId, Map<String, dynamic>? map);


/**
 * 用户属性设置
 *  map: 自定义用户属性，用于扩展统计需求
 */
IdoFlutter().setProfile(Map<String, dynamic>? map);

/**
 * 设置计数事件上传频率
 * timeMillis：设置的eventUploadInterval值，单位毫秒。
 * 默认值为10秒
 */
IdoFlutter().setEventUploadInterval(Long timeMillis);


/**
 * 设置计数事件事件强制上传条数
 * size：设置计数事件的强制上传条数eventForceUploadSize
 * 默认数量为30条；
 */
IdoFlutter().setEventForceUploadSize(int size);

/**
 * 设置用户属性事件上传频率
 * timeMillis：单位毫秒。设置用户属性事件传频率profileUploadInterval
 * 默认值为5秒
 */
IdoFlutter().setProfileUploadInterval(Long timeMillis)

/**
 * 设置用户属性事件强制上传条数
 * size 设置用户属性事件的强制上传条数profileForceUploadSize
 * 默认数量为5条
 */
IdoFlutter().setProfileForceUploadSize(int size);

/**
 * IOS 特有
 * 设置App Groups ID
 * 通过苹果开发者后台创建Group Identify， 用于App主包和Extension之间的数据打通。
 * 
 */
IdoFlutter().setApplicationGroupIdentifier(String identifier) 

```
