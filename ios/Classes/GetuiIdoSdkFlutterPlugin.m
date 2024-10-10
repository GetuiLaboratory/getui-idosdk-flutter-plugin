#import "GetuiIdoSdkFlutterPlugin.h"
#import <GTCountSDK/GTCountSDK.h>

@interface GetuiIdoSdkFlutterPlugin ()<GTCountSDKDelegate> {
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
    
    NSLog(@"\n>>>IDOSDK startSdk, appId:%@", appId);
    [GTCountSDK startSDKWithAppId:appId withChannelId:channelId delegate:self];
}


- (void)setDebugEnable:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    BOOL debugEnable = ConfigurationInfo[@"debugEnable"];
    NSLog(@"\n>>>IDOSDK setDebugEnable:%@", @(debugEnable));
    [GTCountSDK setDebugEnable:debugEnable];
}

- (void)onBeginEvent:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSString *eventId = ConfigurationInfo[@"eventId"];
    NSLog(@"\n>>>IDOSDK onBeginEvent,eventId : %@", eventId);
    [GTCountSDK trackCustomKeyValueEventBegin:eventId];
}

- (void)onEndEvent:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSString *eventId = ConfigurationInfo[@"eventId"];
    NSMutableDictionary *dictionary = ConfigurationInfo[@"jsonObject"];
    NSString *ext = ConfigurationInfo[@"withExt"];
    
    NSLog(@"\n>>>IDOSDK eventEndWithArg, eventId:%@, args:%@", eventId, dictionary);
    if (dictionary && [dictionary isKindOfClass:[NSMutableDictionary class]] &&
        dictionary.count > 0) {
        [GTCountSDK trackCustomKeyValueEventEnd:eventId withArgs:dictionary withExt:ext];
    } else {
        [GTCountSDK trackCustomKeyValueEventEnd:eventId withArgs:nil withExt:ext];
    }
}

- (void)trackCountEvent:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSString *eventId = ConfigurationInfo[@"eventId"];
    NSMutableDictionary *dictionary = ConfigurationInfo[@"jsonObject"];
    NSString *ext = ConfigurationInfo[@"withExt"];
    
    NSLog(@"\n>>>IDOSDK trackCountEvent,eventId : %@, args : %@", eventId, dictionary);
    if (dictionary && [dictionary isKindOfClass:[NSMutableDictionary class]] &&
        dictionary.count > 0) {
        [GTCountSDK trackCountEvent:eventId withArgs:dictionary withExt:ext];
    } else {
        [GTCountSDK trackCountEvent:eventId withArgs:nil withExt:ext];
    }
}

- (void)setProfile:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSMutableDictionary *dictionary = ConfigurationInfo[@"jsonObject"];
    NSString *ext = ConfigurationInfo[@"withExt"];
    NSLog(@"\n>>>IDOSDK clickProfileSet, property:%@", dictionary);
    [GTCountSDK setProfile:dictionary withExt:ext];
}

- (void)getGtcId:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *gtcid = [GTCountSDK gtcid];
    NSLog(@"\n>>>IDOSDK getGtcId:%@", gtcid);
    result(gtcid);
}

- (void)setApplicationGroupIdentifier:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSString *identifier = ConfigurationInfo[@"identifier"];
    NSLog(@"\n>>>IDOSDK setApplicationGroupIdentifier, identifier : %@", identifier);
    [GTCountSDK setApplicationGroupIdentifier:identifier];
}


- (void)setEventUploadInterval:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSNumber *timeMillisNumber = ConfigurationInfo[@"timeMillis"];
    if (timeMillisNumber != nil && [timeMillisNumber isKindOfClass:[NSNumber class]]) {
        NSInteger timeMillis = [timeMillisNumber integerValue];
        NSLog(@"\n>>>IDOSDK setEventUploadInterval, timeMillis : %ld", (long) timeMillis);
        [GTCountSDK sharedInstance].profileUploadInterval = timeMillis;
    }
}

- (void)setEventForceUploadSize:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSNumber *size = ConfigurationInfo[@"size"];
    if (size != nil && [size isKindOfClass:[NSNumber class]]) {
        NSInteger _size = [size integerValue];
        NSLog(@"\n>>>IDOSDK setEventUploadInterval, size : %ld", _size);
        [GTCountSDK sharedInstance].eventForceUploadSize = _size;
    }
}

- (void)setProfileUploadInterval:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSNumber *timeMillisNumber = ConfigurationInfo[@"timeMillis"];
    if (timeMillisNumber != nil && [timeMillisNumber isKindOfClass:[NSNumber class]]) {
        NSInteger timeMillis = [timeMillisNumber integerValue];
        NSLog(@"\n>>>IDOSDK setProfileUploadInterval, timeMillis : %ld", (long) timeMillis);
        [GTCountSDK sharedInstance].profileUploadInterval = timeMillis;
    }
}

- (void)setProfileForceUploadSize:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSNumber *size = ConfigurationInfo[@"size"];
    if (size != nil && [size isKindOfClass:[NSNumber class]]) {
        NSInteger _size = [size integerValue];
        NSLog(@"\n>>>IDOSDK setProfileForceUploadSize, size : %ld", _size);
        [GTCountSDK sharedInstance].profileForceUploadSize = _size;
    }
}

//MARK: - Delegate

- (void)GTCountSDKDidReceiveGtcid:(NSString *)gtcid error:(NSError*)error {
    NSLog(@"\n>>>IDOSDK GTCountSDKDidReceiveGtcid, gtcid:%@ error:%@", gtcid, error);
    [_channel invokeMethod:@"gtcIdCallback" arguments:gtcid?:@""];
}
@end
