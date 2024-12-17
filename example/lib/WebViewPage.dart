import 'package:flutter/material.dart';
import 'package:flutter_demo/IdoFlutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web View Page'),
      ),
      body: InAppWebView(
        // initialUrlRequest: URLRequest(url: WebUri('https://www.baidu.com')),
        initialFile: "assets/ido_demo/index.html",
        onWebViewCreated: (InAppWebViewController controller) {
          webViewController = controller;
          webViewController?.addJavaScriptHandler(
            handlerName: 'getui_ido_flutter_handler',
            callback: (args) async {
              print('Flutter Received message : $args');
              // // 延时1秒后发送消息给JS
              // Future.delayed(const Duration(seconds: 1), () {
              //   webViewController?.evaluateJavascript(
              //       source: 'window.postMessage("Hello from Flutter!");');
              // });
              // return IdoFlutter.instance.onBridgeEvent(args);
              //接受从JS的参数传递给IdoFlutter使用，onBridgeEvent接受String，返回Feture<String>
              String dataFromJS =
                  args is List ? args.first.toString() : args.toString();
              String? result =
                  await IdoFlutter.instance.onBridgeEvent(dataFromJS);
              return result ?? "";
            },
          );
        },
        onLoadError: (InAppWebViewController controller, Uri? url, int code,
            String message) {
          print('Error loading $url: $message');
        },
      ),
    );
  }
}
