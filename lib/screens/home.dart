import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:point_in_polygon/point_in_polygon.dart';
import 'package:http/http.dart' as http;
import 'package:twilio_flutter/twilio_flutter.dart';

class HomePage extends StatefulWidget {
  String? location;
  HomePage({Key? key, location}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var Discharge = TextEditingController();
  var Velocity = TextEditingController();
  var Depth = TextEditingController();

  Point point = Point(x: 75.9231777, y: 17.6689025);
  List<Point> points = [];

  bool? isInside;
  Future getCoordinates() async {
    var url = Uri.https('floodapisihflutter1234.herokuapp.com', '/Solapur');
    print(url);
    try {
      var response = await http.get(url);
      RegExp exp = RegExp(r'[+-]?([0-9]*[.])?[0-9]+');
      print(response.body);
      Iterable<RegExpMatch> x = exp.allMatches(response.body);
      List l = [];
      for (var y in x) {
        print(y.group(0));
        l.add(double.parse(y.group(0)!));
        if (y.group(0) == '0') {
          points.add(Point(x: l[0], y: l[1]));
          l = [];
        }
      }

      setState(() {
        isInside = Poly.isPointInPolygon(
            Point(x: 75.29679722, y: 17.66192500), points);
      });
    } catch (e) {
      print('$e');
    }
  }

  bool areCoordinatesInside(double x, double y) {
    return Poly.isPointInPolygon(Point(x: x, y: y), points);
  }

  TwilioFlutter? twilioFlutter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoordinates();
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC076195addcb68dc8557cc0f20de099ea',
        authToken: '7bbfd44972a84f32ae6f6200bd795d0d',
        twilioNumber: '+13254221345');
  }

  void sendSms(String number) async {
    twilioFlutter!.sendSMS(
        toNumber: number,
        messageBody:
            'This message is to let you know that a flood warning is issued in your area');
  }

  /*Future<bool> callOnFcmApiSendPushNotifications(List<String> userToken) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "registration_ids": userToken,
      "collapse_key": "type_a",
      "notification": {
        "title": 'NewTextTitle',
        "body": 'NewTextBody',
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': constant.firebaseTokenAPIFCM // 'key=YOUR_SERVER_KEY'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: jsonEncode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      return false;
    }
  }*/

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAATGzh-UY:APA91bFI9YL6ROWjfShqGVT5BdaXFQpr3kjkudMuAbSIhCtS0WuypihBUT0rU23o64k1-PWiMzD1tSaeRKygHiHqk2FXo_gpqQyFsQ6IFXOyXdpOE-M-ONGsPNo2zsccOETEdbaUEpTZ',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  void sendNotification(String fcm) async {
    FirebaseMessaging.instance.sendMessage(to: fcm, data: {
      'title': 'Hello',
      'body': 'Hello',
    });
  }

  Future<void> UpdateAlert(String dischargeValue) async {
    var url = Uri.https('floodapisihflutter1234.herokuapp.com', '/Solapur');
    print(url);
    try {
      var response = await http.get(url);
      RegExp exp = RegExp(r'[+-]?([0-9]*[.])?[0-9]+');
      print(response.body);
      FirebaseFirestore.instance
          .collection('NDRF')
          .doc('Solapur')
          .collection('Alerts')
          .add({
        "velocity": 50,
        "severity": 'Extreme',
        "RWL": 496,
        "RWL at flood discharge": dischargeValue,
        "Coordinates": "${response.body}",
        "Date": DateTime.now(),
      });
    } catch (e) {
      print('$e');
    }
  }

  void sendAlerts() {
    FirebaseFirestore.instance.collection('People').get().then((query) {
      query.docs.forEach((doc) {
        if (areCoordinatesInside(double.parse(doc.data()['coordinates'][1]),
                double.parse(doc.data()['coordinates'][0])) &&
            int.parse(Discharge.text) > 6000) {
          print(doc.data()['fcm']);
          sendPushMessage(
              doc.data()['fcm'],
              'This is to notify that a flood warning is been issued in your area',
              'Flood Alert');
          sendSms('${doc.data()['number']}');
        } else {
          print('Not inside the region');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Dam Manager",
              style: TextStyle(fontSize: 30),
            ),
          ),
          // Text(widget.location!),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            width: 200.0,
            child: TextField(
              controller: Discharge,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Flood Discharge Value",
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          SizedBox(
            width: 200.0,
            child: TextField(
              controller: Velocity,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Velocity",
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          SizedBox(
            width: 200.0,
            child: TextField(
              controller: Depth,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Depth",
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),

          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 500.0),
            child: Container(
                child: Row(
              children: [
                Text(
                  "Alert button:   ",
                  style: TextStyle(fontSize: 20),
                ),
                NeoPopButton(
                  color: Colors.red,
                  onTapUp: () {},
                  onTapDown: () {
                    sendAlerts();
                    UpdateAlert(Discharge.text);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Alert 💀",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
          )
        ],
      ),
    ));
  }
}
