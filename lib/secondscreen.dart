import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class SecondScreen extends StatelessWidget {

  final String title;

  SecondScreen({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      routes: {
        "/": (_) => new WebviewScaffold(
              url: "https://www.google.com",
              appBar: new AppBar(
                title: new Text("Widget webview"),
              ),
            )
      },
    );



  }
}





