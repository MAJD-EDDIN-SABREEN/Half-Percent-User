import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:untitled2/ui/home.dart';
class SplashScreen1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SplashScreen(

      seconds: 6,
      navigateAfterSeconds: new Home(),
      title: new Text('Malkanat',textScaleFactor: 2,),
      image: new Image.network('https://www.geeksforgeeks.org/wp-content/uploads/gfg_200X200.png'),
      loadingText: Text("Loading"),
      photoSize: 100.0,

      loaderColor: Colors.blue,
    );
  }
}

