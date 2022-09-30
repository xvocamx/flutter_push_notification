import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/customer.dart';

class SendNotificationPage extends StatefulWidget {
  const SendNotificationPage({Key? key,required this.customer}) : super(key: key);

  final Customer customer;

  @override
  State<SendNotificationPage> createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends State<SendNotificationPage> {

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  bool isFlutterLocalNotificationsInitialized = false;

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if(notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
            )
          )
        );
      }
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void loadFCM() async {
    if(!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

   Future<void> sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAAAz69Io:APA91bFHJJUTvl8n83yu3x5lHq6NTfQAy132jmka264535taUGIAMhC_xxeSGMPr_5Va47ecephHhWBD80_R6VCbePN9480eQHK6QIEQd0etxJq_mAh95eqcD73-EN2bb5aeIm90TAQ0',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      ).then((value) => Navigator.pop(context));
    } catch (e) {
      print("error push notification");
    }
  }
  

  @override
  void initState() {
    super.initState();

    requestPermission();

    loadFCM();

    listenFCM();
    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Notification"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Column(
            children: [
              TextFormField(
                validator: (value) => value!.isEmpty ? "Please enter title" : null,
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0)
                  )
                ),
              ),
              const SizedBox(height: 15,),
              TextFormField(
                validator: (value) => value!.isEmpty ? "Please enter body" : null,
                controller: bodyController,
                decoration: InputDecoration(
                    labelText: "Body",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)
                    )
                ),
              ),
              const SizedBox(height: 30,),
              InkWell(
                onTap: () {
                  String title = titleController.text.trim();
                  String body = bodyController.text.trim();
                  String token = widget.customer.token;
                  sendPushMessage(token, body, title);
                },
                child: Container(
                  width: 200,
                  height: 51,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(colors: [
                        Colors.greenAccent,
                        Colors.greenAccent.shade400,
                        Colors.green.shade300,
                      ])),
                  child: const Center(
                      child: Text(
                        "Send",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
