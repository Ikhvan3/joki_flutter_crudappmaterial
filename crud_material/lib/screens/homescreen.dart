import 'package:crud_material/screens/forminputdata.dart';
import 'package:crud_material/screens/lihatdata.dart';
import 'package:flutter/material.dart';

class AppPendataan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topRight,
                  colors: [
                Color.fromARGB(255, 125, 233, 255),
                // Color.fromARGB(255, 46, 220, 255),
                Color.fromARGB(255, 255, 255, 255),
              ])),
          child: Column(
            children: [
              Card(
                elevation: 2,
                color: Color.fromARGB(255, 112, 251, 251),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topRight,
                        colors: [
                          Color.fromARGB(255, 2, 210, 252),
                          Color.fromARGB(255, 112, 251, 251),
                        ]),
                  ),
                  height: 150,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Image(
                          height: 130,
                          width: 120,
                          image: AssetImage("images/logom.png"),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 45, right: 30),
                        child: Column(
                          children: [
                            Text(
                              "MATERIAL BANGUNAN",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 251, 251, 251),
                              ),
                            ),
                            Text(
                              "Wujudkan rumah baru Anda bersama kami",
                              style: TextStyle(
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Builder(
                    builder: (context) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TambahDataScreen(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 0, 145, 174),
                                  blurRadius: 20,
                                  blurStyle: BlurStyle.inner,
                                  offset: Offset(4, 4),
                                  spreadRadius: BorderSide.strokeAlignOutside,
                                )
                              ],
                              borderRadius: BorderRadius.circular(20),
                              gradient: RadialGradient(colors: [
                                Color.fromARGB(255, 255, 255, 255),
                                Color.fromARGB(255, 2, 152, 252),
                              ])),
                          height: 170,
                          width: 160,
                          child: Column(
                            children: [
                              Image(
                                height: 120,
                                image: AssetImage("images/tambahd.png"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                alignment: Alignment.center,
                                height: 40,
                                width: 160,
                                child: Text(
                                  "INPUT DATA",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 2, 152, 252),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Builder(
                    builder: (context) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Lihatdata(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 0, 145, 174),
                                  blurRadius: 20,
                                  blurStyle: BlurStyle.inner,
                                  offset: Offset(4, 4),
                                  spreadRadius: BorderSide.strokeAlignOutside,
                                )
                              ],
                              borderRadius: BorderRadius.circular(20),
                              gradient: RadialGradient(colors: [
                                Color.fromARGB(255, 255, 255, 255),
                                Color.fromARGB(255, 2, 152, 252),
                              ])),
                          margin: EdgeInsets.only(left: 30),
                          height: 170,
                          width: 160,
                          child: Column(
                            children: [
                              Image(
                                height: 120,
                                image: AssetImage("images/view.png"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: 160,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  "LIHAT DATA",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 2, 152, 252),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
