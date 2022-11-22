import 'package:flutter/material.dart';
import 'package:untitled2/ui/item_detail.dart';
import 'package:untitled2/ui/home.dart';
import 'package:untitled2/ui/showItems.dart';
import 'package:untitled2/ui/splachScreen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "ecs",
        routes: <String, WidgetBuilder>{

          '/home': (BuildContext context) => Home(),
          '/showItems': (BuildContext context) => ShowItems('','','',null,null,null,null,null,null,null,null),
          '/detail': (BuildContext context) =>ItemDetail('',-1,[]),
        },

        home:SplashScreen1()

    );
  }
}
