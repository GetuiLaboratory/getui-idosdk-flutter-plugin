import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
  FlutterManager,
  Any
} from '@ohos/flutter_ohos';
import { BusinessError } from '@ohos.base';
import notificationManager from '@ohos.notificationManager';
import hilog from '@ohos.hilog';
import common from '@ohos.app.ability.common';
import { ArrayList } from '@kit.ArkTS';
import Want from '@ohos.app.ability.Want';
import { Ido, IdoConfig } from '@getui/ido';
import { ArkTSUtils, JSON } from '@kit.ArkTS';

let TAG = "ohos_idoflut"

/** FlutterHarmonyPlugin **/
export default class Idoflutter implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;
  private binding: FlutterPluginBinding | null = null;
  private context: common.UIAbilityContext | null = null;
  private gtcId: string | null = null;

  constructor() {
  }

  getUniqueClassName(): string {
    return "IdoFlutter"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "IdoFlutter");
    this.channel.setMethodCallHandler(this)
    this.binding = binding
    // this.context =  binding.getApplicationContext() as  common.UIAbilityContext
    this.context = FlutterManager.getInstance().getUIAbility()?.context as common.UIAbilityContext

  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {

    try {
      hilog.debug(0x0000, TAG, '%{public}s',
        "method = " + call.method + "  argument = " + ArkTSUtils.ASON.stringify(call.args));
    } catch (error) {
      // TODO: Implement error handling.
    }

    switch (call.method) {
      case 'getPlatformVersion':
        result.success(`harmony os !!`);
        break;

      case 'setDebugEnable':
        const debugEnable: boolean = call.argument("debugEnable")
        IdoConfig.setDebugEnable(debugEnable);
        result.success(true);
        break;

      case 'setInstallChannel':
        const channel: string = call.argument("channel")
        IdoConfig.setChannel(channel);
        result.success(true);
        break;

      case 'setAppId':
        const appId: string = call.argument("appId")
        IdoConfig.setAppId(appId);
        result.success(true);
        break;

      case 'setEventUploadInterval':
        const timeMillis1: number = call.argument("timeMillis")
        IdoConfig.setEventUploadInterval(timeMillis1);

        break;

      case 'setEventForceUploadSize':
        const size1: number = call.argument("size")
        IdoConfig.setEventForceUploadSize(size1);

        break;

      case 'setProfileUploadInterval':
        const timeMillis2: number = call.argument("timeMillis")
        IdoConfig.setProfileUploadInterval(timeMillis2);
        break;

      case 'setProfileForceUploadSize':
        const size2: number = call.argument("size")
        IdoConfig.setProfileForceUploadSize(size2);

        break;

      case 'setSessionTimeoutMillis':
        const timeoutMillis: number = call.argument("timeoutMillis")
        IdoConfig.setSessionTimeoutMillis(timeoutMillis);

        break;

      case 'setMinAppActiveDuration':
        const minDuration: number = call.argument("minAppActiveDuration")
        IdoConfig.setMinAppActiveDuration(minDuration);

        break;

      case 'setMaxAppActiveDuration':
        const maxDuration: number = call.argument("maxAppActiveDuration")
        IdoConfig.setMaxAppActiveDuration(maxDuration);
        break;

      case 'preInit':
        if (this.context) {
          Ido.preInit(this.context);
        } else {
          result.error('NO_CONTEXT', 'UIAbilityContext is null', null);
        }
        break;

      case 'init':
        if (!this.context) {
          result.error('NO_CONTEXT', 'UIAbilityContext is null', null);
          return;
        }

        hilog.info(0x0000, TAG, 'IDO version: (%{public}s)',  Ido.getVersion());
        Ido.init(this.context)
          .then((gtcId: string) => {
            hilog.info(0x0000, TAG, 'IDO init Succeeded. GtcId: (%{public}s)', gtcId);
            this.channel?.invokeMethod("gtcIdCallback", gtcId);
            this.gtcId =  gtcId
            result.success(gtcId);
          })
          .catch((err: BusinessError) => {
            hilog.error(0x0000, TAG, 'IDO init failed: %{public}s', JSON.stringify(err));
            result.error('INIT_FAILED', err.message || 'Unknown error', null);
          });
        break;

      case 'getGtcId':
        result.success(this.gtcId)
        break;

      case 'onBeginEvent':
        if (call.argument("eventId")) {
          Ido.onBeginEvent(call.argument("eventId"));
        } else {
          result.error('MISSING_EVENT_ID', 'eventId is required', null);
        }
        break;

      case 'onEndEvent':
        if (call.argument("eventId") && call.argument("jsonObject")) {
          Ido.onEndEvent(call.argument("eventId"), call.argument("jsonObject"), call.argument("ext"));
        } else {
          result.error('MISSING_PARAMS', 'eventId, jsonObject, ext are required', null);
        }
        break;

      case 'trackCountEvent':
        if (call.argument("eventId") && call.argument("jsonObject")) {
          Ido.onEvent(call.argument("eventId"), call.argument("jsonObject"), call.argument("ext"));
        } else {
          result.error('MISSING_PARAMS', 'eventId, jsonObject, ext are required', null);
        }
        break;

      case 'setProfile':
        if (call.argument("jsonObject")) {
          Ido.onProfile(call.argument("jsonObject"), call.argument("ext"));
        } else {
          result.error('MISSING_PARAMS', 'jsonObject, ext are required', null);
        }
        break;

      case 'onBridgeEvent':
        const data: string  =  call.argument("data")
        Ido.onBridgeEvent(data)
        break;
      case 'registerEventProperties':
        result.notImplemented();
        break;
      default:
        result.notImplemented();
        break;
    }
  }
}

