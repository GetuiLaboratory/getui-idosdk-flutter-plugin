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
            Long timeMillis = call.argument("timeMillis");
            if (timeMillis != null) {
                setEventUploadInterval(timeMillis);
            }
        } else if (call.method.equals("setEventForceUploadSize")) {
            Integer size = call.argument("size");
            if (size != null) {
                setEventForceUploadSize(size);
            }
        } else if (call.method.equals("setProfileUploadInterval")) {
            Integer size = call.argument("size");
            if (size != null) {
                setProfileUploadInterval(size);
            }
        } else if (call.method.equals("setProfileForceUploadSize")) {
            Integer size = call.argument("size");
            if (size != null) {
                setProfileForceUploadSize(size);
            }
        } else if (call.method.equals("setSessionTimeoutMillis")) {
            Long timeoutMillis = call.argument("timeoutMillis");
            if (timeoutMillis != null) {
                setSessionTimeoutMillis(timeoutMillis);
            }
        } else if (call.method.equals("setMinAppActiveDuration")) {
            Long minAppActiveDuration = call.argument("minAppActiveDuration");
            if (minAppActiveDuration != null) {
                setMinAppActiveDuration(minAppActiveDuration);
            }
        } else if (call.method.equals("setMaxAppActiveDuration")) {
            Long maxAppActiveDuration = call.argument("maxAppActiveDuration");
            if (maxAppActiveDuration != null) {
                setMaxAppActiveDuration(maxAppActiveDuration);
            }
        } else if (call.method.equals("preInit")) {
            preInit();
        } else if (call.method.equals("init")) {
            init();
        } else if (call.method.equals("getGtcId")) {
            result.success(getGtcId());
        } else if (call.method.equals("onBeginEvent")) {
            try {
                String eventId = call.argument("eventId");
                Map<String, Object> map = call.argument("jsonObject");
                if (map != null) {
                    JSONObject jsonObject = new JSONObject();
                    for (Map.Entry<String, Object> entry : map.entrySet()) {

                        jsonObject.put(entry.getKey(), entry.getValue());

                    }
                    onBeginEvent(eventId, jsonObject);
                } else {
                    onBeginEvent(eventId, null);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (call.method.equals("onEndEvent")) {
            try {
                String eventId = call.argument("eventId");
                Map<String, Object> map = call.argument("jsonObject");
                if (map != null) {
                    JSONObject jsonObject = new JSONObject();
                    for (Map.Entry<String, Object> entry : map.entrySet()) {
                        jsonObject.put(entry.getKey(), entry.getValue());

                    }
                    onEndEvent(eventId, jsonObject);
                } else {
                    onEndEvent(eventId, null);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        } else if (call.method.equals("onEvent")) {
            try {
                String eventId = call.argument("eventId");
                Map<String, Object> map = call.argument("jsonObject");
                if (map != null) {
                    JSONObject jsonObject = new JSONObject();
                    for (Map.Entry<String, Object> entry : map.entrySet()) {
                        jsonObject.put(entry.getKey(), entry.getValue());
                    }
                    onEvent(eventId, jsonObject);
                } else {
                    onEvent(eventId, null);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        } else if (call.method.equals("setProfile")) {
            try {
                Map<String, Object> map = call.argument("jsonObject");
                JSONObject jsonObject = new JSONObject();
                for (Map.Entry<String, Object> entry : map.entrySet()) {
                    jsonObject.put(entry.getKey(), entry.getValue());
                }
                setProfile(jsonObject);
            } catch (Exception e) {
                e.printStackTrace();
            }
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

    private void setEventUploadInterval(long timeMillis) {
        GsConfig.setEventUploadInterval(timeMillis);
    }

    private void setEventForceUploadSize(int size) {
        GsConfig.setEventForceUploadSize(size);
    }

    private void setProfileUploadInterval(long timeMillis) {
        GsConfig.setProfileUploadInterval(timeMillis);
    }

    private void setProfileForceUploadSize(int size) {
        GsConfig.setProfileForceUploadSize(size);
    }

    private void setSessionTimeoutMillis(long timeoutMillis) {
        GsConfig.setSessionTimeoutMillis(timeoutMillis);
    }


    private void setMinAppActiveDuration(long minAppActiveDuration) {
        GsConfig.setMinAppActiveDuration(minAppActiveDuration);
    }

    private void setMaxAppActiveDuration(long maxAppActiveDuration) {
        GsConfig.setMaxAppActiveDuration(maxAppActiveDuration);
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

    private void onEvent(String eventId, JSONObject jsonObject) {
        if (jsonObject == null) {
            GsManager.getInstance().onEvent(eventId);
        } else {
            GsManager.getInstance().onEvent(eventId, jsonObject);
        }
    }

    private void onBeginEvent(String eventId, JSONObject jsonObject) {
        if (jsonObject == null) {
            GsManager.getInstance().onBeginEvent(eventId);
        } else {
            GsManager.getInstance().onBeginEvent(eventId, jsonObject);
        }
    }

    private void onEndEvent(String eventId, JSONObject jsonObject) {
        if (jsonObject == null) {
            GsManager.getInstance().onEndEvent(eventId);
        } else {
            GsManager.getInstance().onEndEvent(eventId, jsonObject);
        }
    }


    private void setProfile(JSONObject jsonObject) {
        GsManager.getInstance().setProfile(jsonObject);
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
