import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floodmanager/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:neopop/widgets/shimmer/neopop_shimmer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController id = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 235, 235),
      body: Center(
        child: Container(
            height: 450,
            width: 350,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text("Manager Login",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 60,
                  ),
                  Center(
                    child: TextField(
                      controller: id,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Id',
                        hintText: 'Enter Id',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter Password',
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: NeoPopButton(
                      color: const Color.fromRGBO(0, 0, 0, 1),
                      buttonPosition: Position.center,
                      onTapUp: () async {
                        FirebaseFirestore.instance
                            .collection("Manager")
                            .where('Id', isEqualTo: id.text)
                            .snapshots()
                            .listen((event) {
                          event.docs.forEach((element) async {
                            print(element['password']);
                            print(element.data());
                            if (password.text == element['password']) {
                              // String location = element['location'];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => HomePage(
                                            location: "location",
                                          )));
                            } else {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Incorrect Password"),
                                  content: const Text("Please try again"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Container(
                                        color: Colors.white,
                                        padding: const EdgeInsets.all(14),
                                        child: const Text("OK"),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          });
                          // if (id.text == '112230' &&
                          //     password.text == '1solapur') {
                          //   // Navigator.push(context,
                          //   //     MaterialPageRoute(builder: (_) => HomePage()));
                          // }
                          //  else {
                          //   showDialog(
                          //     context: context,
                          //     builder: (ctx) => AlertDialog(
                          //       title: const Text("Incorrect Password"),
                          //       content: const Text("Please try again"),
                          //       actions: <Widget>[
                          //         TextButton(
                          //           onPressed: () {
                          //             Navigator.of(ctx).pop();
                          //           },
                          //           child: Container(
                          //             color: Colors.white,
                          //             padding: const EdgeInsets.all(14),
                          //             child: const Text("OK"),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          // }
                        });
                        // FirebaseFirestore.instance
                        //     .collection("Manager")
                        //     .where('id', isEqualTo: id.text)
                        //     .snapshots()
                        //     .listen((event) {
                        //   event.docs.forEach((element) async {
                        //     if (element['password'] == password.text) {
                        //       print("working");
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => HomePage()));
                        //     } else {
                        //       print("not working");
                        // showDialog(
                        //   context: context,
                        //   builder: (ctx) => AlertDialog(
                        //     title: const Text("Alert Dialog Box"),
                        //     content: const Text(
                        //         "You have raised a Alert Dialog Box"),
                        //     actions: <Widget>[
                        //       TextButton(
                        //         onPressed: () {
                        //           Navigator.of(ctx).pop();
                        //         },
                        //         child: Container(
                        //           color: Colors.green,
                        //           padding: const EdgeInsets.all(14),
                        //           child: const Text("okay"),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // );
                        //     }
                        //   });
                        // });
                      },
                      border: Border.fromBorderSide(
                        BorderSide(color: Colors.grey, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Login",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // ElevatedButton(
                  //   child: Text('Login'),
                  //   onPressed: () {},
                  //   style: ElevatedButton.styleFrom(
                  //       primary: Colors.purple,
                  //       padding: EdgeInsets.symmetric(
                  //           horizontal: 30, vertical: 10),
                  //       textStyle: TextStyle(
                  //           fontSize: 14, fontWeight: FontWeight.bold)),
                  // ),
                ],
              ),
            )),
      ),
    );
  }
}
