import 'dart:convert';
import 'dart:typed_data';

import 'package:circle_button/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import 'home.dart';

class ItemDetail extends StatefulWidget{
  String type;
  int pos;
  List data;

  ItemDetail(this.type, this.pos,this.data);

  @override
  State<StatefulWidget> createState() {
    return ItemDetailState(this.type,this.pos,this.data);
  }
}
class ItemDetailState extends State<ItemDetail> {
  String type;
  int pos;
  List data;
  ItemDetailState(this.type,this.pos,this.data);
  GlobalKey<FormState>formStateItemDetail=new GlobalKey<FormState>();
  final screenControlle=ScreenshotController();
  TextEditingController phoneNumber=new TextEditingController();
  TextEditingController problemDescribe=new TextEditingController();
  String phoneNumberValidator(String val){
    if (val.trim().isEmpty)
      return'رقم الهاتف الجوال لا يجب أن يكون فارغاً';
    if (val.trim().length<10)
      return 'رقم الهاتف الجوال غير صالح ';
    if(val.trim().length>10)
      return 'رقم الهاتف الجوال غير صالح ';
    if(val.trim().trim().substring(0,2)!="09")
      return 'رقم الهاتف الجوال يحب أن يبدأ ب 09 ';
  }
  String problemDescribeValidator(String val){
    if (val.trim().isEmpty)
      return'وصف المشكلة لا يجب أن يكون فارغاً';
  }
  String estateState(String val){
    if (val=='0')
      return('آجار');
    else
      return('بيع');
    
  }
  Future<String>saveScreenShot(Uint8List bytes)async
  {
    await[Permission.storage].request();
    final time=DateTime.now().toIso8601String().replaceAll(".", "-").replaceAll(":", "-");
    final name="Malkinit_$time";
    final result=await ImageGallerySaver.saveImage(bytes,name: name);
    return result['filePath'];
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
  Future<Widget>itemDetailAlert(String msg) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(msg),
          actions: <Widget>[
            TextButton(
              child: new Text('حسناً'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void>addOrderToServer () async{
    var formData=formStateItemDetail.currentState;
    if(formData.validate()) {
      formData.save();
      String myurl = 'http://10.0.2.2:8000/api/Service/serviceRequest';
      try {

        var response = await http.post(myurl,
            headers: {
              'Accept': 'application/json',
              'Authorization' : 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9sb2NhbGhvc3Q6ODAwMFwvYXBpXC9sb2dpbiIsImlhdCI6MTY0NjQzNjU3MywibmJmIjoxNjQ2NDM2NTczLCJqdGkiOiJXYXJFNUh1RGtReHhwOXdmIiwic3ViIjoxLCJwcnYiOiI4N2UwYWYxZWY5ZmQxNTgxMmZkZWM5NzE1M2ExNGUwYjA0NzU0NmFhIn0.ZWQqkiLAb4lDMz8UJI6ERg3C4VkJf1lkKzTpoQNvmHI'
            },
            body: {
              'descriptionOfTheProblem':problemDescribe.text,
              'mobile':phoneNumber.text,


            });

        switch(response.statusCode.toString())
        {
          case '200':

            Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
                builder: (BuildContext context) =>
                    Home()
            ), (route) => false);break;

            break;
          default:itemDetailAlert('الاتصال بلانترنت ضعيف يرجى إعادة المحاولة');
        }

      }

      catch (e) {
        itemDetailAlert('لا يوجد اتصال بلانترنت');

      }
    }
  }
  List<Widget> showEstatesImages(List imagespaths) {
    List<Widget> images = [];
    for (int i = 0; i < imagespaths.length; i++) {
      images.add(InkWell(
          child: Image.network(
        'http://10.0.2.2:8000/images/EstatePictures/${imagespaths[i]['imageName']}',
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },
      ),
      onTap: (){slideAlert( 'http://10.0.2.2:8000/images/EstatePictures/${imagespaths[i]['imageName']}');},));
    }
    return images;
  }
  List<Widget> showCarsImages(List imagespaths) {
    List<Widget> images = [];
    for (int i = 0; i < imagespaths.length; i++) {
      images.add(InkWell(
         child: Image.network(
        'http://10.0.2.2:8000/images/CarPictures/${imagespaths[i]['imageName']}',
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },
      ),
      onTap: (){slideAlert( 'http://10.0.2.2:8000/images/CarPictures/${imagespaths[i]['imageName']}');},));
    }
    return images;
  }
  Future<Widget>slideAlert(String imagePath) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            SizedBox(
              height:MediaQuery.of(context).size.height/1.5 ,
              width:MediaQuery.of(context).size.width ,
              child: Image.network(imagePath,fit: BoxFit.fill,),
            ),
            TextButton(
              child: Text('حسناً'),
              onPressed: ()  {
                Navigator.pop(context);

              },
            ) ,

          ],
        );
      },
    );
  }
  Widget cardDetail(String text1,String text2,IconData icon){
   return Container(

        padding: EdgeInsets.only(left: 3, right: 3),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade500))),
        child: Card(
          color: Colors.white,
            elevation: 5,
            child: Row(

                children: [
                  Expanded(
                child:  Padding(padding:EdgeInsets.only(right: 5),
            child: Text(text2,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 22.0,
                fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )))),
      Text(       text1,
                 style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ))
       ,Padding(padding:EdgeInsets.only(left: 10),
                       child :Icon(icon))
                  ]))
        );
  }
  Widget carDetail(
      context,
      String text1,
      String text2,
      String text3,
      String text4,
      String text5,
      String text6,
      String text7,
      String text8,
      String text9,
      String text10,
      String text11,
      String text12,
      String text13,
      String text14,
      String text15,
      String text16,
      String text17,
      String text18,
      String text19,
      String text20,
      IconData icon1,
      IconData icon2,
      IconData icon3,
      IconData icon4,
      IconData icon5,
      IconData icon6,
      IconData icon7,
      IconData icon8,
      IconData icon9,
      IconData icon10,

      List imagespaths

) {
    return Container(
      color: Colors.white,
      child: ListView(children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child:   ImageSlideshow(
            width: double.infinity,
            height: 200,
            initialPage: 0,
            indicatorColor: Colors.blue,
            indicatorBackgroundColor: Colors.grey,
            onPageChanged: (value) {},
            autoPlayInterval: 3000,
            isLoop: true,
            children: showCarsImages(imagespaths))),
        SizedBox(height: 20.0),
        Container(
            //padding: EdgeInsets.only(left: 40, right: 15),
            child:
    Column(children: [
      cardDetail(text1, text2, icon1),
      cardDetail(text3, text4, icon2),
    cardDetail(text5, text6, icon3),
    cardDetail(text7, text8, icon4),
    cardDetail(text9, text10, icon5),
    cardDetail(text11, text12, icon6),
    cardDetail(text13, text14, icon7),
    cardDetail(text15, text16, icon8),
    cardDetail(text17, text18, icon9),
      cardDetail(text19, text20, icon10),
           SizedBox(height: 20,)
,    Row(
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async{
            final screemimage=await screenControlle.capture();
            if(screemimage==null)return;
            await saveScreenShot(screemimage);
          },

          style: ButtonStyle(
              shape:MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()) ,
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.red)),
          child: Text(
            "التقاط الشاشة",

            style: TextStyle(color: Colors.white,fontSize: 25),
          ),
        ) ,
        Padding(padding: EdgeInsets.only(right: 10)),
        CircleButton(onTap: (){
        callAlert();
          },
          backgroundColor: Colors.green,height: 50,width: 50,
        child: Icon(Icons.call,size:30,),)
      ],
    ),
    //  SizedBox(height: 20,)
    ])),


      ]),
    );
  }
  Widget estateDetail(
      context,
      String text1,
      String text2,
      String text3,
      String text4,
      String text5,
      String text6,
      String text7,
      String text8,
      String text9,
      String text10,
      String text11,
      String text12,
      String text13,
      String text14,
      String text15,
      String text16,

      IconData icon1,
      IconData icon2,
      IconData icon3,
      IconData icon4,
      IconData icon5,
      IconData icon6,
      IconData icon7,
      IconData icon8,

      List imagespaths
      ) {
    return Container(
      color: Colors.white,
      child: ListView(children: [
        Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child:   ImageSlideshow(
                width: double.infinity,
                height: 200,
                initialPage: 0,
                indicatorColor: Colors.blue,
                indicatorBackgroundColor: Colors.grey,
                onPageChanged: (value) {},
                autoPlayInterval: 3000,
                isLoop: true,
                children: showEstatesImages(imagespaths))),
        SizedBox(height: 20.0),
        Container(
          //padding: EdgeInsets.only(left: 40, right: 15),
            child:
            Column(children: [
              cardDetail(text1, text2, icon1),
              cardDetail(text3, text4, icon2),
              cardDetail(text5, text6, icon3),
              cardDetail(text7, text8, icon4),
              cardDetail(text9, text10, icon5),
              cardDetail(text11, text12, icon6),
              cardDetail(text13, text14, icon7),
              cardDetail(text15, text16, icon8),
              SizedBox(height: 20,)
              ,    Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async{
                      final screemimage=await screenControlle.capture();
if(screemimage==null)return;
await saveScreenShot(screemimage);
                      },

                    style: ButtonStyle(
                        shape:MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()) ,
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red)),
                    child: Text(
                      "التقاط الشاشة",

                      style: TextStyle(color: Colors.white,fontSize: 25),
                    ),
                  ) ,
                  Padding(padding: EdgeInsets.only(right: 10)),
                  CircleButton(onTap: (){callAlert();},backgroundColor: Colors.green.shade400,height: 50,width: 50,
                    child: Icon(Icons.call,size:30,),)
                ],
              ),
              //  SizedBox(height: 20,)
            ])),


      ]),
    );
  }

  Widget showItemDetail(String type, context) {
    if (type == 'estate') {
      return
       estateDetail(
          context,
          ' : وضع العقار ',
          estateState('${data[pos]['state']}'),
          '  : نوع العقار ',
          '${data[pos]['type']}',
        ' : المساحة ',
            '${data[pos]['space']}'+" م ",
          ' : عدد الغرف',
          '${data[pos]['numberOfRooms']}',
          ' : عدد الحمامات',
          '${data[pos]['numberOfBathrooms']}',

          ' : المنطقة',
          '${data[pos]['area']}',

          ' : السعر',
        '${data[pos]['price']}'+   "   ل.س"   ,
           ' : الوصف',
           '${data[pos]['describe']}',
          Icons.home_work_outlined,
          Icons.home_outlined,
          Icons.space_bar,
          Icons.meeting_room_rounded,
          Icons.bathtub,
          Icons.location_on_rounded,
          Icons.price_change_outlined,
           Icons.description_outlined,
         data[pos]['image_estate']
          );
    }



    else if (type == 'car') {

        return carDetail(
          context,
        ' : الطراز',
        '${data[pos]['name']}',
        ' : الموديل',
            '${data[pos]['model']}',
      " : سنة الصنع",
        '${data[pos]['manufacturingYear']}',
        ' : عدد الكيلومترات',
        'كم ${data[pos]['mileage']}',
        ' : اللون',
        '${data[pos]['color']}',
        ' : ناقل الحركة',
        '${data[pos]['motionVector']}',
        ' : المدينة',
        '${data[pos]['city']}',
        ' : المحرك',
        '${data[pos]['engineCapacity']}'+ "cc",
        ' : السعر',
             ' ${data[pos]['price']} '+" ل.س"   ,

        ' :  الوصف ',
        '${data[pos]['describe']}',
        Icons.directions_car,
        Icons.local_car_wash_sharp,
        Icons.date_range_rounded,
        Icons.album_outlined,
        Icons.color_lens_sharp,
        Icons.car_repair,
        Icons.location_on_rounded,
        Icons.cancel_schedule_send_rounded,
        Icons.price_change_outlined,
        Icons.description_outlined,
            data[pos]['image_car']
         );
    }

    else if (type == 'service') {


      return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/serviceBackground.jpg'),
                fit: BoxFit.fill)),
        child:Form(
key: formStateItemDetail,
            child:  ListView(
          children: [
            Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 6,
                    right: MediaQuery.of(context).size.width / 6,
                    top: 20),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade100))),
                    child: TextFormField(
                      keyboardType:TextInputType.phone ,
                      controller: phoneNumber,
                      validator: phoneNumberValidator,
                      decoration: InputDecoration(
                        labelText: "رقم الهاتف الجوال",
                        labelStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 20),
                        icon: Icon(Icons.call),
                      ),
                    ))),
            Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 6,
                    right: MediaQuery.of(context).size.width / 6,
                    top: 20),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade100))),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: problemDescribeValidator,
                      controller: problemDescribe,
                      maxLines: 10,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "اوصف المشكلة",
                        labelStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 20),
                        icon: Icon(
                          Icons.rate_review_outlined,
                          size: 60,
                        ),
                      ),
                    ))),
            Padding(padding: EdgeInsets.only(top: 40)),
            Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.red)),
                        onPressed: () {
                         addOrderToServer();
                        },
                        child: Text(
                          'ارسال طلب',
                          style: TextStyle(color: Colors.white),
                        ))))
          ],
        )),


      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
controller: screenControlle,
        child:
      Scaffold(
        appBar: AppBar(
          backgroundColor:Colors.red,
          elevation: 0.0,
        ),
        body: showItemDetail(type, context)));
  }
}
