package com.example.idoflutter;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.util.Log;

import androidx.annotation.NonNull;

import com.getui.gs.ias.core.GsConfig;
import com.getui.gs.sdk.GsManager;
import com.getui.gs.sdk.IGtcIdCallback;

import org.json.JSONObject;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * GetuiIdosdkFlutterPlugin
 */
public class GetuiIdoSdkFlutterPlugin implements FlutterPlugin, MethodCallHandler {
    String TAG = "GetuiIdosdkFlutterPlugin";
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context fContext;
    public static GetuiIdoSdkFlutterPlugin instance;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "IdoFlutter");
        channel.setMethodCallHandler(this);
        instance = this;
        fContext = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        Log.d(TAG, "onMethodCall: " + call.method + " . arguments: " + call.arguments);
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("setDebugEnable")) {
            setDebugEnable(Boolean.TRUE.equals(call.argument("debugEnable")));
        } else if (call.method.equals("setInstallChannel")) {
            setInstallChannel(call.argument("channel"));
        } else if (call.method.equals("setAppId")) {
            setAppId(call.argument("appId"));
        } else if (call.method.equals("setEventUploadInterval")) {
            setEventUploadInterval(call,result);
        } else if (call.method.equals("setEventForceUploadSize")) {
            setEventForceUploadSize(call,result);
        } else if (call.method.equals("setProfileUploadInterval")) {
            setProfileUploadInterval(call,result);
        } else if (call.method.equals("setProfileForceUploadSize")) {
            setProfileForceUploadSize(call,result);
        } else if (call.method.equals("setSessionTimeoutMillis")) {
            setSessionTimeoutMillis(call,result);
        } else if (call.method.equals("setMinAppActiveDuration")) {
            setMinAppActiveDuration(call,result);
        } else if (call.method.equals("setMaxAppActiveDuration")) {
            setMaxAppActiveDuration(call,result);
        } else if (call.method.equals("preInit")) {
            preInit();
        } else if (call.method.equals("init")) {
            init();
        } else if (call.method.equals("getGtcId")) {
            result.success(getGtcId());
        } else if (call.method.equals("onBeginEvent")) {
            onBeginEvent(call,result);
        } else if (call.method.equals("onEndEvent")) {
            onEndEvent(call,result);
        } else if (call.method.equals("trackCountEvent")) {
            onEvent(call,result);
        } else if (call.method.equals("setProfile")) {
            setProfile(call,result);
        } else {
            result.notImplemented();
        }
    }


    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private void setDebugEnable(boolean debugEnable) {
        Log.d(TAG, "setDebugEnable: " + debugEnable);
        try {
            GsConfig.setDebugEnable(debugEnable);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    private void setInstallChannel(String channel) {
        GsConfig.setInstallChannel(channel);
    }

    private void setAppId(String appId) {
        GsConfig.setAppId(appId);

    }

    private void setEventUploadInterval(MethodCall call, Result result) {
        Long timeMillis = call.argument("timeMillis");
        if (timeMillis != null) {
            GsConfig.setEventUploadInterval(timeMillis);
        }
    }

    private void setEventForceUploadSize(MethodCall call, Result result) {
        Integer size = call.argument("size");
        if (size != null) {
            GsConfig.setEventForceUploadSize(size);
        }

    }

    private void setProfileUploadInterval(MethodCall call, Result result) {
        Long timeMillis = call.argument("timeMillis");
        if (timeMillis != null) {
            GsConfig.setProfileUploadInterval(timeMillis);
        }
    }

    private void setProfileForceUploadSize(MethodCall call, Result result) {

        Integer size = call.argument("size");
        if (size != null) {
            GsConfig.setProfileForceUploadSize(size);
        }
    }

    private void setSessionTimeoutMillis(MethodCall call, Result result) {
        Long timeoutMillis = call.argument("timeoutMillis");
        if (timeoutMillis != null) {
            GsConfig.setSessionTimeoutMillis(timeoutMillis);
        }

    }


    private void setMinAppActiveDuration(MethodCall call, Result result) {
        Long minAppActiveDuration = call.argument("minAppActiveDuration");
        if (minAppActiveDuration != null) {
            GsConfig.setMinAppActiveDuration(minAppActiveDuration);
        }
    }

    private void setMaxAppActiveDuration(MethodCall call, Result result) {

        Long maxAppActiveDuration = call.argument("maxAppActiveDuration");
        if (maxAppActiveDuration != null) {
            GsConfig.setMaxAppActiveDuration(maxAppActiveDuration);
        }
    }

    private void preInit() {
        GsManager.getInstance().preInit(fContext);
    }

    private void init() {
        GsManager.getInstance().setGtcIdCallback(new IGtcIdCallback() {
            @Override
            public void onGetGtcId(String gtcId) {
                Log.d(TAG, "onGetGtcId: " + gtcId);
                transforMapSend(gtcId);
            }
        });
        GsManager.getInstance().init(fContext);
    }


    private String getGtcId() {
        return GsManager.getInstance().getGtcId();
    }

    private void onEvent(MethodCall call, Result result) {
        try {
            String eventId = call.argument("eventId");
            Map<String, Object> map = call.argument("jsonObject");
            if (map != null) {
                JSONObject jsonObject = new JSONObject();
                for (Map.Entry<String, Object> entry : map.entrySet()) {
                    jsonObject.put(entry.getKey(), entry.getValue());
                }
                GsManager.getInstance().onEvent(eventId, jsonObject);
            } else {
                GsManager.getInstance().onEvent(eventId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void onBeginEvent(MethodCall call, Result result) {
        try {
            String eventId = call.argument("eventId");
            Map<String, Object> map = call.argument("jsonObject");
            if (map != null) {
                JSONObject jsonObject = new JSONObject();
                for (Map.Entry<String, Object> entry : map.entrySet()) {
                    jsonObject.put(entry.getKey(), entry.getValue());
                }
                GsManager.getInstance().onBeginEvent(eventId, jsonObject);
            } else {
                GsManager.getInstance().onBeginEvent(eventId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void onEndEvent(MethodCall call, Result result) {
        try {
            String eventId = call.argument("eventId");
            Map<String, Object> map = call.argument("jsonObject");
            if (map != null) {
                JSONObject jsonObject = new JSONObject();
                for (Map.Entry<String, Object> entry : map.entrySet()) {
                    jsonObject.put(entry.getKey(), entry.getValue());
                }
                GsManager.getInstance().onEndEvent(eventId, jsonObject);
            } else {
                GsManager.getInstance().onEndEvent(eventId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private void setProfile(MethodCall call, Result result) {
        try {
            Map<String, Object> map = call.argument("jsonObject");
            JSONObject jsonObject = new JSONObject();
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                jsonObject.put(entry.getKey(), entry.getValue());
            }
            GsManager.getInstance().setProfile(jsonObject);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private void transforMapSend(String gtcId) {
        Message msg = Message.obtain();
        msg.what = 0;
        msg.obj = gtcId;
        flutterHandler.sendMessage(msg);
    }

    private static Handler flutterHandler = new Handler(Looper.getMainLooper()) {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 0:
                    GetuiIdoSdkFlutterPlugin.instance.channel.invokeMethod("gtcIdCallback", msg.obj);
                    break;
                default:
                    break;
            }
        }
    };

}
