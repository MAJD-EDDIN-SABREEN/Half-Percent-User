import 'dart:convert';
import 'package:circle_button/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:untitled2/ui/showItems.dart';
import 'package:http/http.dart' as http;
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {

  void onTap(String name){
    if(name=='عقارات'){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  ShowItems('estate','all','',null,null,null,null,null,null,null,null) ),(route) => false
      );
    }
    if(name=='سيارات'){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  ShowItems('car','','all',null,null,null,null,null,null,null,null) ),(route) => false);
    }
    if(name=='خدمات'){

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (BuildContext context) =>
                  ShowItems('service','','',null,null,null,null,null,null,null,null)), (route) => false);
    }

  }
  Future<Widget>homeAlert(String msg) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(msg),
          actions: <Widget>[
            TextButton(
              child: new Text('حسناً'),
              onPressed: ()  {
                Navigator.pushNamed(context, '/home');

              },
            ),
          ],
        );
      },
    );
  }
  Future<Widget>callAlert() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("أنت على وشك الاتصال بلرقم 09988926997 وهذه المكالمة مأجورة"),
          actions: <Widget>[
            TextButton(
              child: new Text('الغاء الأمر'),
              onPressed: ()  {
                Navigator.pop(context);

              },
            ),
            TextButton(
              child: new Text('اتصال'),
              onPressed: ()  {
                FlutterPhoneDirectCaller.callNumber('0988926997');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  Future<Widget>slideAlert(String describe,String imagePath) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(describe,textDirection: TextDirection.rtl,),
          actions: <Widget>[
            SizedBox(
              height:MediaQuery.of(context).size.height/3 ,
              width:MediaQuery.of(context).size.width ,
              child: Image.network(imagePath,fit: BoxFit.fill,),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [TextButton(
              child: new Text('حسناً'),
              onPressed: ()  {
                Navigator.pop(context);

              },
            ),
            CircleButton(onTap: (){
              callAlert();
            },child: Icon(Icons.phone),backgroundColor: Colors.green,)])
          ],
        );
      },
    );
  }
  Future<List>getAdvData()async{
    String myurl = 'http://10.0.2.2:8000/api/advertisement/getAll';
    var response;
    try {
      response = await http.get(myurl,
        headers: {
          'Accept': 'application/json',
        },
      );
    return jsonDecode(response.body);
    }
    catch (e) {
      if(jsonDecode(response.body)=="you are dont have Advertisement")
        return [{"0":"0"}];
      homeAlert('لايوجد اتصال بلانترنت');
    }
  }
  Widget carOrHomeOrService(String imgPath,String name){
    return InkWell(
        child:Container(
          //margin: EdgeInsets.only(top: 20),
            height: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(imgPath),
                    fit: BoxFit.fill)),
            child: Stack(children: <Widget>[
              Positioned(
                child:
                Container(margin: EdgeInsets.only(top: 50),
                  child: Center(
                    child: Text(
                      name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ]))
        ,
        onTap:(){ onTap(name);}
    );
  }
  List<Widget> showAdv(List data)
  {
    List <Widget> slide = [];
  for (int i = 0; i < data.length; i++) {
      slide.add(
          Column(children: [
            InkWell(
            child: Container(
                height: 190,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Image.network(
                  'http://10.0.2.2:8000/images/AdvertisementPictures/${data[i]['image']}',
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null ?
                        loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                )),
            onTap: (){slideAlert('${data[i]['describe']}', 'http://10.0.2.2:8000/images/AdvertisementPictures/${data[i]['image']}');},),
            Expanded
              (
                child:
            Container(height: 60,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                color: Colors.white,
                  child:
                  Center(
                    child: Text('${data[i]['describe']}', style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),))

            )
         )
          ]
      )
    )
    ;


  }
    return slide;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:Colors.red,
          centerTitle: true,
          title: Text("الصفحة الرئيسية"),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                FutureBuilder(
    future:getAdvData(),
    builder: (BuildContext context, AsyncSnapshot snapshot){
    if(snapshot.hasData) {
      if (snapshot.data[0]["0"] != '0') {
        return ImageSlideshow(
            width: double.infinity,
            height: 250,
            initialPage: 0,
            indicatorColor: Colors.blue,
            indicatorBackgroundColor: Colors.grey,
            onPageChanged: (value) {

            },
            autoPlayInterval: 4000,
            isLoop: true,
            children:
            showAdv(snapshot.data)
        );
      }
      else
        return Center(child:Text("لا يوجد اعلانات"));
    }
    else
      return Center(
       child: CircularProgressIndicator()
      );



    })
                ,
                carOrHomeOrService('images/estate.jpg', 'عقارات'), carOrHomeOrService('images/car.jpg', 'سيارات'), carOrHomeOrService('images/electricity.jpg', 'خدمات')

              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              title: Text('الإعدادات'),
              icon: Icon(Icons.settings),
            ),
            BottomNavigationBarItem(
                title: Text('الرئيسية'), icon: Icon(Icons.home_filled)),

          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor:Colors.red,
          //onTap: navigationBottom,
          fixedColor: Colors.white,
          unselectedItemColor: Colors.white,
        ),
      ),
    );
  }
}
