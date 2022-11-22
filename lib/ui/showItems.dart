import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:untitled2/ui/item_detail.dart';
import 'package:http/http.dart' as http;
import 'home.dart';

class ShowItems extends StatefulWidget {
  String type;
  String estateType;
  String carType;
  String selectedValueEstateType;
  String selectedValueEstateSpace;
  String selectedValueEstatePrice;
  String selectedValueEstateArea;
  String selectedValueCarName;
  String selectedValueCarManufacturingYear;
  String selectedValueCarPrice;
  String selectedValueCarCity;

  ShowItems(
      this.type,
      this.estateType,
      this.carType,
      this.selectedValueEstateType,
      this.selectedValueEstateSpace,
      this.selectedValueEstatePrice,
      this.selectedValueEstateArea,
      this.selectedValueCarName,
      this.selectedValueCarManufacturingYear,
      this.selectedValueCarPrice,
      this.selectedValueCarCity);

  @override
  State<StatefulWidget> createState() {
    return ShowItemsState(
        this.type,
        this.estateType,
        this.carType,
        this.selectedValueEstateType,
        this.selectedValueEstateSpace,
        this.selectedValueEstatePrice,
        this.selectedValueEstateArea,
        this.selectedValueCarName,
        this.selectedValueCarManufacturingYear,
        this.selectedValueCarPrice,
        this.selectedValueCarCity);
  }
}

class ShowItemsState extends State<ShowItems> {
  String type;
  String estateType;
  String carType;
  String selectedValueEstateType;
  String selectedValueEstateSpace;
  String selectedValueEstatePrice;
  String selectedValueEstateArea;
  String selectedValueCarName;
  String selectedValueCarManufacturingYear;
  String selectedValueCarPrice;
  String selectedValueCarCity;
  ShowItemsState(
      this.type,
      this.estateType,
      this.carType,
      this.selectedValueEstateType,
      this.selectedValueEstateSpace,
      this.selectedValueEstatePrice,
      this.selectedValueEstateArea,
      this.selectedValueCarName,
      this.selectedValueCarManufacturingYear,
      this.selectedValueCarPrice,
      this.selectedValueCarCity);
  List<String> estateTypes = [];
  List<String> estatearea = [];
  List<String> estatePrice = [
    '50->100 مليون',
    '101->200 مليون',
    '201->500 مليون',
    'اكثر من 500 مليون'
  ];
  List<String> estateSpace = ['50->100 متر', '101->200 متر', 'اكثر من 200 متر'];
  List<String> carName = [];
  List<String> carManufacturingYear = [];
  List<String> carPrice = ['5->20 مليون',
    '21->50 مليون',
    '50->100 مليون',
    'اكثر من 100 مليون'];
  List<String> carCity = [];
  int fromPriceSpaceForFilteringData(String SelectedValue) {
    switch (SelectedValue) {
      case '50->100 مليون':
        return 50000000;
        break;
      case '101->200 مليون':
        return 101000000;
        break;
      case '201->500 مليون':
        return 201000000;
        break;
      case 'اكثر من 500 مليون':
        return 501000000;
        break;
      case '50->100 متر':
        return 50;
        break;
      case '101->200 متر':
        return 101;
        break;
      case 'اكثر من 200 متر':
        return 201;
        break;
      case '5->20 مليون':
        return 5000000;
        break;
      case '21->50 مليون':
        return 21000000;
        break;
      case '50->100 مليون':
        return 50000000;
        break;
      case 'اكثر من 100 مليون':
        return 100000000;
        break;

    }
  }

  int toPriceSpaceForFilteringData(String SelectedValue) {
    switch (SelectedValue) {
      case '50->100 مليون':
        return 100000000;
        break;
      case '101->200 مليون':
        return 200000000;
        break;
      case '201->500 مليون':
        return 500000000;
        break;
      case 'اكثر من 500 مليون':
        return 500000000000;
        break;
      case '50->100 متر':
        return 100;
        break;
      case '101->200 متر':
        return 200;
        break;
      case 'اكثر من 200 متر':
        return 1000;
        break;
      case '5->20 مليون':
        return 20000000;
        break;
      case '21->50 مليون':
        return 50000000;
        break;
      case '50->100 مليون':
        return 50000000;
        break;
      case 'اكثر من 100 مليون':
        return 100000000000;
        break;

    }
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
  List<Widget> showEstatesImages(List imagespaths) {
    List<Widget> images = [];
    for (int i = 0; i < imagespaths.length; i++) {
      images.add(InkWell(
         child:  Image.network(
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
      onTap: (){slideAlert('http://10.0.2.2:8000/images/EstatePictures/${imagespaths[i]['imageName']}');},)
      );
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

  Future<Widget> showItemsAlert(String msg) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(msg),
          actions: <Widget>[
            TextButton(
              child: new Text('حسناً'),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
          ],
        );
      },
    );
  }

  Future<List> getEstatesData() async {
    String myurl = 'http://10.0.2.2:8000/api/Estate/getAll';
    var response;
    try {
      response = await http.get(
        myurl,
        headers: {
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    }
    catch (e) {
      if(jsonDecode(response.body)=="not found Estate")
        return [{"0":"0"}];
      showItemsAlert('لايوجد اتصال بلانترنت');
    }
  }

  Future<List> getEstatesForSellimgData() async {
    String myurl = 'http://10.0.2.2:8000/api/Estate/viewForSelling';
    var response;
    try {
      response = await http.get(
        myurl,
        headers: {
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      if(jsonDecode(response.body)=="No Estates")
        return [{"0":"0"}];
      showItemsAlert('لايوجد اتصال بلانترنت');
    }
  }

  Future<List> getEstatesForRentData() async {
    String myurl = 'http://10.0.2.2:8000/api/Estate/viewForRent';
    var response;
    try {
      response = await http.get(
        myurl,
        headers: {
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      if(jsonDecode(response.body)=="No Estates")
        return [{"0":"0"}];
      showItemsAlert('لايوجد اتصال بلانترنت');
    }
  }

  Future<List> getEstatesFilteringData() async {
    String myurl = 'http://10.0.2.2:8000/api/Estate/search';
    var response;
    try {
      response = await http.post(myurl, headers: {
        'Accept': 'application/json',
      }, body: {
        "area": selectedValueEstateArea == null ? "" : selectedValueEstateArea,
        "type": selectedValueEstateType==null ? "" :selectedValueEstateType,
        "pricefrom":selectedValueEstatePrice==null ? "":"${fromPriceSpaceForFilteringData(selectedValueEstatePrice)}",
        "priceto":selectedValueEstatePrice==null ? "":"${toPriceSpaceForFilteringData(selectedValueEstatePrice)}",
        "spacefrom":selectedValueEstateSpace==null ? "":"${fromPriceSpaceForFilteringData(selectedValueEstateSpace)}",
        "spaceto":selectedValueEstateSpace==null ? "":"${toPriceSpaceForFilteringData(selectedValueEstateSpace)}",
      }
      );

      return jsonDecode(response.body);

    } catch (e) {
      if(jsonDecode(response.body)=="not found Estate")
        return [{"0":"0"}];
     showItemsAlert("لا يوجد اتصال بلانترنت");

    }
  }

  Future<List> estateFiltering() async {
    switch (estateType) {
      case 'all':
        return getEstatesData();
        break;
      case 'sell':
        return getEstatesForSellimgData();
        break;
      case 'rent':
        return getEstatesForRentData();
        break;
      case 'search':
        return getEstatesFilteringData();
        break;
    }
  }

  Future<List> getCarsData() async {
    String myurl = 'http://10.0.2.2:8000/api/Car/viewAll';
    var response;
    try {
      response = await http.get(
        myurl,
        headers: {
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);

    } catch (e) {
      if(jsonDecode(response.body)=="not found Car")
        return [{"0":"0"}];
      showItemsAlert('لايوجد اتصال بلانترنت');
    }
  }

  Future<List> getCarsFilteringData() async {
    String myurl = 'http://10.0.2.2:8000/api/Car/search';
    var response;
    try {
      response = await http.post(myurl, headers: {
        'Accept': 'application/json',
      }, body: {
        "name": selectedValueCarName == null ? "" : selectedValueCarName,
        "manufacturingYear": selectedValueCarManufacturingYear==null ? "" :selectedValueCarManufacturingYear,
        "city": selectedValueCarCity==null ? "" :selectedValueCarCity,
        "pricefrom":selectedValueCarPrice==null ? "":"${fromPriceSpaceForFilteringData(selectedValueCarPrice)}",
        "priceto":selectedValueCarPrice==null ? "":"${toPriceSpaceForFilteringData(selectedValueCarPrice)}",
      });
      return jsonDecode(response.body);

    } catch (e) {
      if(jsonDecode(response.body)=="not found Car")
        return [{"0":"0"}];
      showItemsAlert('لايوجد اتصال بلانترنت');
    }
  }

  Future<List> carFiltering() async {
    switch (carType) {
      case 'all':
        return getCarsData();
        break;
      case 'search':
        return getCarsFilteringData();
        break;
    }
  }

  Future<List> getServiceData() async {
    String myurl = 'http://10.0.2.2:8000/api/Service/viewServices';
    var response;
    try {
      response = await http.get(
        myurl,
        headers: {
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      if(jsonDecode(response.body)=="you are dont have Services")
        return [{"0":"0"}];
      showItemsAlert('لايوجد اتصال بلانترنت');
    }
  }

  List<String> twoItemForDropDown(List data){
    if(data.length==1)
      return null;
    else
      return data;

  }
  void filter(List data, String type) {
    switch (type) {
      case 'estate':
        for (int i = 0; i < data.length; i++) {
          estatearea.add(data[i]['area']);
          estateTypes.add(data[i]['type']);
        }


        estatearea = estatearea.toSet().toList();
        estateTypes = estateTypes.toSet().toList();
        twoItemForDropDown(estatearea);
        twoItemForDropDown(estateTypes);
        break;
      case 'car':
        for (int i = 0; i < data.length; i++) {

          carCity.add(data[i]['city']);
          carManufacturingYear.add((data[i]['manufacturingYear']).toString());
          carName.add(data[i]['name']);
        }
        carCity = carCity.toSet().toList();
        carManufacturingYear = carManufacturingYear.toSet().toList();
        carName = carName.toSet().toList();
        twoItemForDropDown(carCity);
        twoItemForDropDown(carManufacturingYear);
        twoItemForDropDown(carName);
        break;
    }
  }

  void navigationBottomEstate(int val) {
    switch (val) {
      case 0:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => Home()),
            (route) => false);
        break;
      case 1:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ShowItems('estate', 'sell',
                    '', null, null, null, null, null, null, null, null)),
            (route) => false);
        break;
      case 2:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ShowItems('estate', 'rent',
                    '', null, null, null, null, null, null, null, null)),
            (route) => false);
        break;
    }
  }
  void navigationBottomCar(int val) {
    switch (val) {
      case 0:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => Home()),
                (route) => false);
        break;

    }
  }
  void navigationBottomService(int val) {
    switch (val) {
      case 0:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => Home()),
                (route) => false);
        break;

    }
  }

  Widget navigationBar() {
    if (type == 'estate') {
      return BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              title: Text('الرئيسية'), icon: Icon(Icons.home_filled)),
          BottomNavigationBarItem(
              title: Text('بيع'), icon: Icon(Icons.home_work)),
          BottomNavigationBarItem(
              title: Text('آجار'), icon: Icon(Icons.home_work_outlined)),

        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.red,
        onTap: navigationBottomEstate,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white,
      );
    }
    if (type == 'car') {
      return BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              title: Text('الرئيسية'), icon: Icon(Icons.home_filled)),
          BottomNavigationBarItem(
              title: Text('الإعدادات'), icon: Icon(Icons.settings)),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor:Colors.red,
        onTap: navigationBottomCar,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white,
      );
    }
    if (type == 'service') {
      return BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              title: Text('الرئيسية'), icon: Icon(Icons.home_filled)),
          BottomNavigationBarItem(
              title: Text('الإعدادات'), icon: Icon(Icons.rate_review)),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.red,
        onTap: navigationBottomService,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white,
      );
    }
  }

  Widget _buildCard(String price, String imgPath, context, int pos) {
    return Container(
        height: MediaQuery.of(context).size.height / 4,
        padding: EdgeInsets.only(top: 2.0, bottom: 2.0, left: 5.0, right: 5.0),
        child: InkWell(
          child: Column(children: [
            Container(
              height: MediaQuery.of(context).size.height / 5,

              //margin: EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(imgPath), fit: BoxFit.fill)),
            ),
            Container(
              color: Colors.red,
              child: Center(
                child: Text(
                  price,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ]),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ItemDetail('service', pos, [])));
          },
        ));
  }

  Widget showOrders() {
    return ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int postion) {
          return ListTile(
            title: Text("Date of booking :  "),
            subtitle: Text("Father Name :"),
            leading: CircleAvatar(
              child: Text("${postion + 1}"),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            onTap: () {},
          );
        });
  }

  Widget showFavorite() {
    return FutureBuilder(
        future: getEstatesData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Container(
                color: Colors.white,
                child: Column(children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int postion) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                color: Colors.white,
                                child: Column(children: [
                                  Container(
                                      padding: EdgeInsets.only(top: 15),
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      child: ImageSlideshow(
                                          width: double.infinity,
                                          height: 200,
                                          initialPage: 0,
                                          indicatorColor: Colors.blue,
                                          indicatorBackgroundColor: Colors.grey,
                                          onPageChanged: (value) {},
                                          autoPlayInterval: 3000,
                                          isLoop: true,
                                          children: showEstatesImages(
                                              snapshot.data[postion])

                                          // [Image.asset('images/h1.jpg',fit: BoxFit.cover,),
                                          // Image.asset('images/h2.jpg',fit: BoxFit.cover)],
                                          )),
                                  Padding(padding: EdgeInsets.only(left: 20)),

                                  Text(
                                    'نوع العقار : ' +
                                        '${snapshot.data[postion]['type']}',
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 10)),
                                  Text(
                                      'الموقع:' +
                                          '${snapshot.data[postion]['area']}',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue.shade900,
                                      )),

                                  Padding(padding: EdgeInsets.only(top: 10)),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ItemDetail(
                                                            'estate',
                                                            postion,
                                                            snapshot.data)));
                                          },
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      OutlinedBorder>(
                                                  StadiumBorder()),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.purple)),
                                          child: Text(
                                            "المزيد",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ItemDetail(
                                                            'estate',
                                                            postion,
                                                            snapshot.data)));
                                          },
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      OutlinedBorder>(
                                                  StadiumBorder()),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.purple)),
                                          child: Text(
                                            "حذف",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ]),
                                  Padding(padding: EdgeInsets.only(top: 5))

                                  // typeSearch(searchType,postion)
                                ]),
                              ),
                            );
                          })),
                ]));
          } else
            return CircularProgressIndicator();
        });
  }

  Widget showEstates() {
    return FutureBuilder(
        future: estateFiltering(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data[0]["0"] != '0') {
              filter(snapshot.data, type);
              return Container(
                  color: Colors.white,
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 10)),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(

                              children: [
                                Padding(padding: EdgeInsets.only(left: 3)),
                                DropdownButtonHideUnderline(

                                  child: DropdownButton2(
                                  isExpanded: true,
                                    hint: Text(
                                      'النوع',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),

                                    items: estateTypes
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  color:Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    value: selectedValueEstateType,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValueEstateType = value;
                                      });

                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ShowItems(
                                                      'estate',
                                                      'search',
                                                      '',
                                                      selectedValueEstateType,
                                                      selectedValueEstateSpace,
                                                      selectedValueEstatePrice,
                                                      selectedValueEstateArea,
                                                      selectedValueCarName,
                                                      selectedValueCarManufacturingYear,
                                                      selectedValueCarPrice,
                                                      selectedValueCarCity))
                                           , (route) => false
                                      );
                                    },
                                    buttonElevation: 2,
                                    itemPadding: const EdgeInsets.only(left: 14, right: 14),
                                    buttonHeight: 50,
                                    buttonWidth: 120,
                                    buttonDecoration: BoxDecoration(
                                     // borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      color: Colors.white,
                                    ),
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: Colors.white,
                                    ),
                                    dropdownElevation: 8,
                                    scrollbarRadius: const Radius.circular(40),
                                    alignment:Alignment.center ,
                                  ),
                                ),
                                //dropDown('النوع', selectedValueEstateType, estateTypes),
                                Padding(padding: EdgeInsets.only(right: 5)),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    hint: Text(
                                      'المساحة',
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    items: estateSpace
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    value: selectedValueEstateSpace,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValueEstateSpace = value;
                                      });
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ShowItems(
                                                      'estate',
                                                      'search',
                                                      '',
                                                      selectedValueEstateType,
                                                      selectedValueEstateSpace,
                                                      selectedValueEstatePrice,
                                                      selectedValueEstateArea,
                                                      selectedValueCarName,
                                                      selectedValueCarManufacturingYear,
                                                      selectedValueCarPrice,
                                                      selectedValueCarCity))
                                          , (route) => false
                                      );
                                    },
                                    buttonElevation: 2,
                                    itemPadding: const EdgeInsets.only(left: 14, right: 1),
                                    buttonHeight: 50,
                                    buttonWidth: 120,
                                    buttonDecoration: BoxDecoration(
                                     // borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      color: Colors.white,
                                    ),
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: Colors.white,
                                    ),
                                    dropdownElevation: 8,
                                    scrollbarRadius: const Radius.circular(40),
                                    alignment:Alignment.centerRight ,
                                  ),
                                ),
                                //dropDown('المساحة',selectedValueEstateSpace,estateSpace),
                                Padding(padding: EdgeInsets.only(right: 5)),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    hint: Text(
                                      'السعر',
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),

                                    items: estatePrice
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    value: selectedValueEstatePrice,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValueEstatePrice = value;
                                      });
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ShowItems(
                                                      'estate',
                                                      'search',
                                                      '',
                                                      selectedValueEstateType,
                                                      selectedValueEstateSpace,
                                                      selectedValueEstatePrice,
                                                      selectedValueEstateArea,
                                                      selectedValueCarName,
                                                      selectedValueCarManufacturingYear,
                                                      selectedValueCarPrice,
                                                      selectedValueCarCity))
                                          , (route) => false
                                      );
                                    },
                                    buttonElevation: 2,
                                    itemPadding: const EdgeInsets.only(left: 14, right: 14),
                                    buttonHeight: 50,
                                    buttonWidth:120,
                                    buttonDecoration: BoxDecoration(
                                    //  borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      color: Colors.white,
                                    ),
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                        color: Colors.white,
                                    ),
                                    dropdownElevation: 8,
                                    scrollbarRadius: const Radius.circular(40),
                                    alignment:Alignment.center ,
                                  ),
                                ),
                                //dropDown('السعر',selectedValueEstatePrice,estatePrice),
                                Padding(padding: EdgeInsets.only(right: 5)),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    hint: Text(
                                      'المنطقة',
textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    items: estatearea
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    value: selectedValueEstateArea,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValueEstateArea = value;
                                      });
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ShowItems(
                                                      'estate',
                                                      'search',
                                                      '',
                                                      selectedValueEstateType,
                                                      selectedValueEstateSpace,
                                                      selectedValueEstatePrice,
                                                      selectedValueEstateArea,
                                                      selectedValueCarName,
                                                      selectedValueCarManufacturingYear,
                                                      selectedValueCarPrice,
                                                      selectedValueCarCity))
                                          , (route) => false
                                      );
                                    },
                                    buttonElevation: 2,
                                    itemPadding: const EdgeInsets.only(left: 14, right: 2),
                                    buttonHeight: 50,
                                    buttonWidth: 120,
                                    buttonDecoration: BoxDecoration(
                                      //borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      color: Colors.white,
                                    ),
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                        color: Colors.white,
                                    ),
                                    dropdownElevation: 8,
                                    scrollbarRadius: const Radius.circular(40),
                                    alignment:Alignment.center ,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(right:5)),
                                //  dropDown('المنطقة',selectedValueEstateArea,estatearea)
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                            )),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder:
                                    (BuildContext context, int postion) {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(children: [
                                        Container(
                                            padding: EdgeInsets.only(top: 15),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                4,
                                            child: ImageSlideshow(
                                                width: double.infinity,
                                                height: 200,
                                                initialPage: 0,
                                                indicatorColor: Colors.blue,
                                                indicatorBackgroundColor:
                                                    Colors.grey,
                                                onPageChanged: (value) {},
                                                autoPlayInterval: 3000,
                                                isLoop: true,
                                                children: showEstatesImages(
                                                    snapshot.data[postion]
                                                        ['image_estate']))),
                                        Padding(
                                            padding: EdgeInsets.only(left: 20)),

                                        Text(
                                          'نوع العقار : ' +
                                              '${snapshot.data[postion]['type']}',
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blue.shade900,
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 10)),
                                        Text(
                                            'المنطقة:' +
                                                '${snapshot.data[postion]['area']}',
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.blue.shade900,
                                            )),

                                        Padding(
                                            padding: EdgeInsets.only(top: 10)),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ItemDetail(
                                                            'estate',
                                                            postion,
                                                            snapshot.data)));
                                          },
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      OutlinedBorder>(
                                                  StadiumBorder()),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.red)),
                                          child: Text(
                                            "المزيد",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 5))

                                        // typeSearch(searchType,postion)
                                      ]),
                                    ),
                                  );
                                })),
                      ]));
            } else
              return Center(child: Text('لا يوجد عقارات'));
          } else
            return Center(child: CircularProgressIndicator());
        });
  }
//majd
  Widget showCars() {
    return FutureBuilder(
        future: carFiltering(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data[0]["0"] != '0') {
              filter(snapshot.data, type);
              return Container(
                  child: Column(children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 10)),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            hint: Text(
                              'النوع',

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            items: carName
                                .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                                .toList(),
                            value: selectedValueCarName,
                            onChanged: (value) {
                              setState(() {
                                selectedValueCarName = value;
                              });

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ShowItems(
                                              'car',
                                              '',
                                              'search',
                                              selectedValueEstateType,
                                              selectedValueEstateSpace,
                                              selectedValueEstatePrice,
                                              selectedValueEstateArea,
                                              selectedValueCarName,
                                              selectedValueCarManufacturingYear,
                                              selectedValueCarPrice,
                                              selectedValueCarCity))
                              ,(route) => false);
                            },
                            buttonElevation: 2,
                            itemPadding: const EdgeInsets.only(left: 14, right: 14),
                            buttonHeight: 50,
                            buttonWidth: MediaQuery.of(context).size.width / 3,
                            buttonDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black,
                              ),
                              color: Colors.white,
                            ),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white,
                            ),
                            dropdownElevation: 8,
                            scrollbarRadius: const Radius.circular(40),
                            alignment:Alignment.centerRight ,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(right: 5)),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            hint: Text(
                              'سنة الصنع',

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            items:carManufacturingYear
                                .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                                .toList(),
                            value: selectedValueCarManufacturingYear,
                            onChanged: (value) {
                              setState(() {
                                selectedValueCarManufacturingYear = value;
                              });
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ShowItems(
                                              'car',
                                              '',
                                              'search',
                                              selectedValueEstateType,
                                              selectedValueEstateSpace,
                                              selectedValueEstatePrice,
                                              selectedValueEstateArea,
                                              selectedValueCarName,
                                              selectedValueCarManufacturingYear,
                                              selectedValueCarPrice,
                                              selectedValueCarCity))
                                  ,(route) => false);
                            },
                            buttonElevation: 2,
                            itemPadding: const EdgeInsets.only(left: 14, right: 14),
                            buttonHeight: 50,
                            buttonWidth: MediaQuery.of(context).size.width / 3,
                            buttonDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black,
                              ),
                              color: Colors.white,
                            ),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white,
                            ),
                            dropdownElevation: 8,
                            scrollbarRadius: const Radius.circular(40),
                            alignment:Alignment.centerRight ,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(right: 5)),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            hint: Text(
                              'السعر',

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            items:carPrice
                                .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                                .toList(),
                            value: selectedValueCarPrice,
                            onChanged: (value) {
                              setState(() {
                                selectedValueCarPrice = value;
                              });
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ShowItems(
                                              'car',
                                              '',
                                              'search',
                                              selectedValueEstateType,
                                              selectedValueEstateSpace,
                                              selectedValueEstatePrice,
                                              selectedValueEstateArea,
                                              selectedValueCarName,
                                              selectedValueCarManufacturingYear,
                                              selectedValueCarPrice,
                                              selectedValueCarCity))
                                  ,(route) => false);
                            },
                            buttonElevation: 2,
                            itemPadding: const EdgeInsets.only(left: 14, right: 14),
                            buttonHeight: 50,
                            buttonWidth: MediaQuery.of(context).size.width / 3,
                            buttonDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black,
                              ),
                              color: Colors.white,
                            ),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white,
                            ),
                            dropdownElevation: 8,
                            scrollbarRadius: const Radius.circular(40),
                            alignment:Alignment.centerRight ,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(right: 5)),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            hint: Text(
                              'المنطقة',

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            items:carCity
                                .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                                .toList(),
                            value: selectedValueCarCity,
                            onChanged: (value) {
                              setState(() {
                                selectedValueCarCity = value;
                              });
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ShowItems(
                                              'car',
                                              '',
                                              'search',
                                              selectedValueEstateType,
                                              selectedValueEstateSpace,
                                              selectedValueEstatePrice,
                                              selectedValueEstateArea,
                                              selectedValueCarName,
                                              selectedValueCarManufacturingYear,
                                              selectedValueCarPrice,
                                              selectedValueCarCity))
                                  ,(route) => false);
                            },
                            buttonElevation: 2,
                            itemPadding: const EdgeInsets.only(left: 14, right: 14),
                            buttonHeight: 50,
                            buttonWidth: MediaQuery.of(context).size.width / 3,
                            buttonDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black,
                              ),
                              color: Colors.white,
                            ),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white,
                            ),
                            dropdownElevation: 8,
                            scrollbarRadius: const Radius.circular(40),
                            alignment:Alignment.centerRight ,

                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    )),
                Padding(padding: EdgeInsets.only(top: 10)),
                Expanded(
                  child: Container(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int postion) {
                            return Center(
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    child: Column(children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        child: ImageSlideshow(
                                          width: double.infinity,
                                          height: 200,
                                          initialPage: 0,
                                          indicatorColor: Colors.blue,
                                          indicatorBackgroundColor: Colors.grey,
                                          onPageChanged: (value) {},
                                          autoPlayInterval: 3000,
                                          isLoop: true,
                                          children: showCarsImages(snapshot
                                              .data[postion]['image_car']),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, top: 10)),
                                      Text(
                                        '${snapshot.data[postion]['name']} ',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue.shade900,
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 10)),
                                      Text(
                                          'سنة الصنع : ' +
                                              '${snapshot.data[postion]['manufacturingYear']}',
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blue.shade900,
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(top: 10)),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          ItemDetail(
                                                              'car',
                                                              postion,
                                                              snapshot.data)));
                                        },
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    OutlinedBorder>(
                                                StadiumBorder()),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.red)),
                                        child: Text(
                                          "المزيد",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.only(top: 5))
                                    ]),
                                  )),
                            );
                          })),
                )
              ]));
            } else
              return Center(child: Text('لا يوجد سيارات'));
          } else
            return Center(child: CircularProgressIndicator());
        });
  }

  Widget showServices() {
    return FutureBuilder(
        future: getServiceData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data[0]["0"] != '0') {
            return ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                SizedBox(height: 15.0),
                Container(
                    color: Colors.grey,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        //childAspectRatio: 3 / 2,
                      ),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int postion) {
                        return _buildCard(
                            snapshot.data[postion]['nameService'],
                            'http://10.0.2.2:8000/images/ServicePictures/${snapshot.data[postion]['imageService']}',
                            context,
                            postion);
                      },
                    )),
                SizedBox(height: 15.0)
              ],
            );
          }
            else
              return Center(child: Text("لايوجد خدمات"),);
          } else
            return CircularProgressIndicator();
        });
  }

  Widget show(String type) {
    if (type == 'estate') {
      return showEstates();
    } else if (type == 'car') {
      return showCars();
    } else if (type == 'service') {
      return showServices();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: show(this.type),
        bottomNavigationBar: navigationBar(),
      ),
    );
  }
}
