import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:markets/src/models/user.dart';
import 'package:markets/src/pages/loading_screen.dart';

import '../repository/user_repository.dart' as userRepo;

class Web extends StatefulWidget {
  @override
  _WebState createState() => _WebState();
}

final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

class _WebState extends State<Web> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  User _user = userRepo.currentUser.value;
  @override
  Widget build(BuildContext context) {
    print(_user.apiToken);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'urway',
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: WebviewScaffold(
        url:
            "http://tactic.sa/api/payments/Urway/request?api_token=${_user.apiToken}",
        //    url: "https://www.google.com",
        javascriptChannels: jsChannels,
        mediaPlaybackRequiresUserGesture: false,

        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        initialChild: const Center(
            child: LoadingWidget(
          color: Colors.transparent,
        )),
      ),
    );
  }
}
