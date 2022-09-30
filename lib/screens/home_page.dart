import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_push_notification/Firebase/service_firebase.dart';
import 'package:flutter_push_notification/models/pushnotification.dart';
import 'package:flutter_push_notification/models/customer.dart';
import 'package:flutter_push_notification/screens/notification_badge.dart';
import 'package:flutter_push_notification/screens/send_notification_page.dart';
import 'package:overlay_support/overlay_support.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  // initalize some values
  late final FirebaseMessaging _messaging;
  late int _totalNotificationCounter;
  // model
  PushNotification? _notificationInfo;
  Customer? selectCustomer;
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  // register notification
  Future<void> registerNotification() async {
    await Firebase.initializeApp();
    // instance for firebase messaging
    _messaging = FirebaseMessaging.instance;

    // three type of state in notification
    // not determined (null), granted (true) and decline (false)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,

      provisional: false,
      sound: true,

    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted the permission");
      // main message
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {

        PushNotification notification = PushNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body']
        );

        setState(() {
          _totalNotificationCounter++;
          _notificationInfo = notification;
        });

        if(notification != null) {
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotification: _totalNotificationCounter),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.blue.shade400,
            duration: const Duration(seconds: 2),
          );
        }

      });
    } else if(settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    }
    else {
      print('User denied the permission');
    }
  }

  // check the initial message that we receive
  checkForInitiaMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null) {
      PushNotification notification = PushNotification(
          title: initialMessage.notification!.title,
          body: initialMessage.notification!.body,
          dataTitle: initialMessage.data['title'],
          dataBody: initialMessage.data['body']
      );

      setState(() {
        _totalNotificationCounter++;
        _notificationInfo = notification;
      });
    }
  }

  // @override
  // void initState() {
  //   // when app is in background
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     PushNotification notification = PushNotification(
  //         title: message.notification!.title,
  //         body: message.notification!.body,
  //         dataTitle: message.data['title'],
  //         dataBody: message.data['body']
  //     );
  //
  //     setState(() {
  //       _totalNotificationCounter++;
  //       _notificationInfo = notification;
  //     });
  //   });
  //   // normal notification
  //   registerNotification();
  //   // when app is terminated state
  //   checkForInitiaMessage();
  //   _totalNotificationCounter = 0;
  //   super.initState();
  // }

  Future<void> signOut() async {
    await ServiceFirebase().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance.collection('users').snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách customer"),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return InkWell(
                onTap: () {
                  Customer customer = Customer(
                      id: data['id'],
                      username: data['username'],
                      email: data['email'],
                      token: data['token'],
                  );
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SendNotificationPage(customer: customer)));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade400,
                          shape: BoxShape.circle
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['username']),
                            const SizedBox(height: 5,),
                            Text(data['email'])
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
