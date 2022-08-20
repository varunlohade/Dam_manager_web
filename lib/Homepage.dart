import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

class HomePage extends StatefulWidget {
  String? location;
  HomePage({Key? key, location}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
