import 'package:flutter/material.dart';
import 'package:flutter_push_notification/Firebase/service_firebase.dart';
import 'package:flutter_push_notification/screens/home_page.dart';
import 'package:flutter_push_notification/screens/signin_page.dart';
class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ServiceFirebase().authStateChanges,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return const HomePage();
        } else {
          return const SignInPage();
        }
      },
    );
  }
}
