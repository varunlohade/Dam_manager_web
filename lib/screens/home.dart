import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:point_in_polygon/point_in_polygon.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  String? location;
  HomePage({Key? key, location}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Point point = Point(x: 75.9231777, y: 17.6689025);
  List<Point> points = [];

  bool? isInside;
  Future getCoordinates() async {
    var url = Uri.https('floodapisihflutter1234.herokuapp.com', '/Solapur');
    print(url);
    try {
      var response = await http.get(url);
      RegExp exp = RegExp(r'[+-]?([0-9]*[.])?[0-9]+');
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoordinates();
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
          Center(
            child: Align(
              alignment: Alignment.center,
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
                    onTapDown: () {},
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
            ),
          )
        ],
      ),
    ));
  }
}
