#import "GetuiIdoSdkFlutterPlugin.h"
#import <GTCountSDK/GTCountSDK.h>

@interface GetuiIdoSdkFlutterPlugin () {
    BOOL _started;
    NSDictionary *_launchOptions;
    NSDictionary *_launchNotification;
    NSDictionary *_apnsSlienceUserInfo;
}
@end

@implementation GetuiIdoSdkFlutterPlugin

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:@"IdoFlutter"
                  binaryMessenger:[registrar messenger]];
    GetuiIdoSdkFlutterPlugin *instance = [[GetuiIdoSdkFlutterPlugin alloc] init];
    instance.channel = channel;
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (id)init {
    self = [super init];
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"setDebugEnable" isEqualToString:call.method]) {
        [self setDebugEnable:call result:result];
    } else if ([@"setApplicationGroupIdentifier" isEqualToString:call.method]) {
        [self setApplicationGroupIdentifier:call result:result];
    } else if ([@"setEventUploadInterval" isEqualToString:call.method]) {
        [self setEventUploadInterval:call result:result];
    } else if ([@"setEventForceUploadSize" isEqualToString:call.method]) {
        [self setEventForceUploadSize:call result:result];
    } else if ([@"setProfileUploadInterval" isEqualToString:call.method]) {
        [self setProfileUploadInterval:call result:result];
    } else if ([@"setProfileForceUploadSize" isEqualToString:call.method]) {
        [self setProfileForceUploadSize:call result:result];
    } else if ([@"init" isEqualToString:call.method]) {
        [self startSdk:call result:result];
    } else if ([@"getGtcId" isEqualToString:call.method]) {
        [self getGtcId:call result:result];
    } else if ([@"onBeginEvent" isEqualToString:call.method]) {
        [self onBeginEvent:call result:result];
    } else if ([@"onEndEvent" isEqualToString:call.method]) {
        [self onEndEvent:call result:result];
    } else if ([@"trackCountEvent" isEqualToString:call.method]) {
        [self trackCountEvent:call result:result];
    } else if ([@"setProfile" isEqualToString:call.method]) {
        [self setProfile:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)startSdk:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSString *appId = ConfigurationInfo[@"appId"];
    NSString *channelId = ConfigurationInfo[@"channelId"];
    [GTCountSDK startSDKWithAppId:appId withChannelId:channelId];
    NSLog(@"startSdk,appId : %@", appId);
}


- (void)setDebugEnable:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    BOOL debugEnable = ConfigurationInfo[@"debugEnable"];
    [GTCountSDK setDebugEnable:debugEnable];
    NSLog(@"setDebugEnable,debugEnable : %@", @(debugEnable));
}

- (void)onBeginEvent:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSString *eventId = ConfigurationInfo[@"eventId"];
    [GTCountSDK trackCustomKeyValueEventBegin:eventId];
    NSLog(@"onBeginEvent,eventId : %@", eventId);
}

- (void)onEndEvent:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSString *eventId = ConfigurationInfo[@"eventId"];
    NSMutableDictionary *dictionary = ConfigurationInfo[@"jsonObject"];
    NSString *ext = ConfigurationInfo[@"withExt"];
    if (dictionary && [dictionary isKindOfClass:[NSMutableDictionary class]] &&
        dictionary.count > 0) {
        [GTCountSDK trackCustomKeyValueEventEnd:eventId withArgs:dictionary withExt:ext];
    } else {
        [GTCountSDK trackCustomKeyValueEventEnd:eventId withArgs:nil withExt:ext];
    }
    NSLog(@"eventEndWithArg,eventId : %@, args : %@", eventId, dictionary);
}

- (void)trackCountEvent:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSString *eventId = ConfigurationInfo[@"eventId"];
    NSMutableDictionary *dictionary = ConfigurationInfo[@"jsonObject"];
    NSString *ext = ConfigurationInfo[@"withExt"];
    if (dictionary && [dictionary isKindOfClass:[NSMutableDictionary class]] &&
        dictionary.count > 0) {
        [GTCountSDK trackCountEvent:eventId withArgs:dictionary withExt:ext];
    } else {
        [GTCountSDK trackCountEvent:eventId withArgs:nil withExt:ext];
    }
    NSLog(@"trackCountEvent,eventId : %@, args : %@", eventId, dictionary);
}

- (void)setProfile:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSMutableDictionary *dictionary = ConfigurationInfo[@"jsonObject"];
    NSString *ext = ConfigurationInfo[@"withExt"];
    [GTCountSDK setProfile:dictionary withExt:ext];
    NSLog(@"clickProfileSet, property : %@", dictionary);
}

- (void)getGtcId:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *gtcid = [GTCountSDK gtcid];
    result(gtcid);
    NSLog(@"getGtcId, gtcid : %@", gtcid);
}

- (void)setApplicationGroupIdentifier:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSString *identifier = ConfigurationInfo[@"identifier"];
    [GTCountSDK setApplicationGroupIdentifier:identifier];
    NSLog(@"setApplicationGroupIdentifier, identifier : %@", identifier);
}


- (void)setEventUploadInterval:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSNumber *timeMillisNumber = ConfigurationInfo[@"timeMillis"];
    if (timeMillisNumber != nil && [timeMillisNumber isKindOfClass:[NSNumber class]]) {
        NSInteger timeMillis = [timeMillisNumber integerValue];
        [GTCountSDK sharedInstance].profileUploadInterval = timeMillis;
        NSLog(@"setEventUploadInterval, timeMillis : %ld", (long) timeMillis);
    }
}

- (void)setEventForceUploadSize:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSNumber *size = ConfigurationInfo[@"size"];
    if (size != nil && [size isKindOfClass:[NSNumber class]]) {
        NSInteger _size = [size integerValue];
        [GTCountSDK sharedInstance].eventForceUploadSize = _size;
        NSLog(@"setEventUploadInterval, size : %ld", _size);
    }
}

- (void)setProfileUploadInterval:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSNumber *timeMillisNumber = ConfigurationInfo[@"timeMillis"];
    if (timeMillisNumber != nil && [timeMillisNumber isKindOfClass:[NSNumber class]]) {
        NSInteger timeMillis = [timeMillisNumber integerValue];
        [GTCountSDK sharedInstance].profileUploadInterval = timeMillis;
        NSLog(@"setProfileUploadInterval, timeMillis : %ld", (long) timeMillis);
    }
}

- (void)setProfileForceUploadSize:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSNumber *size = ConfigurationInfo[@"size"];
    if (size != nil && [size isKindOfClass:[NSNumber class]]) {
        NSInteger _size = [size integerValue];
        [GTCountSDK sharedInstance].profileForceUploadSize = _size;
        NSLog(@"setProfileForceUploadSize, size : %ld", _size);
    }
}

@end
