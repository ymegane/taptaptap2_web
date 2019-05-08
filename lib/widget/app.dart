import 'package:flutter_web/cupertino.dart';
import 'package:flutter_web/material.dart';
import 'package:taptaptap2_web/widget/launch_screen.dart';
import 'package:taptaptap2_web/widget/playground_screen.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => LaunchScreen(),
        '/playground': (_) => PlaygroundScreen(),
      },
    );
  }
}
