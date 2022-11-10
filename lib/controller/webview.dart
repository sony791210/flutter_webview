import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';



class WebviewScreen  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        child: const SafeArea(
          child:  WebView(
            initialUrl: 'https://metafame.com/',
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}
