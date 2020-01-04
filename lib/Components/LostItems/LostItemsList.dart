
import 'package:cached_network_image/cached_network_image.dart';
import 'package:findall/Components/Authentication/AuthPage.dart';
import 'package:findall/Components/Authentication/ProfilePage.dart';
import 'package:findall/FakeData/FoundModel.dart';
import 'package:findall/Components/FoundItems/FoundedItemsList.dart';
import 'package:findall/GlobalComponents/BottomNavigationItems.dart';
import 'package:findall/GlobalComponents/SearchItems.dart';
import 'package:findall/GlobalComponents/Utilities.dart';
import 'package:findall/Home/HomePage.dart';
import 'package:findall/Components/LostItems/MyObjects.dart';
import 'package:findall/Components/LostItems/DetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class LostItemsList extends StatefulWidget {

  @override
  _LostItemsListState createState() => _LostItemsListState();
}

class _LostItemsListState extends State<LostItemsList> {
  int _selectedIndex = 2;
  List lostList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lostList = Found().getFoundList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  Widget _buildLostItem(BuildContext context, int index){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
        key: Key(index.toString()),
        child: GestureDetector(
          child: Card(
            color: Colors.white,
            child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: <Widget>[

                      new Container(
                        width: width/2.2,
                        height: height/4.2,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(3.0),
                        child:CachedNetworkImage(
                          width: width/2.3,
                          height: height/4.2,
                          fit: BoxFit.cover,
                          repeat: ImageRepeat.noRepeat,
                          imageUrl: lostList[index].imageUrl[0],
                          placeholder: (context, url) => new SpinKitWave(color: Colors.deepPurple,size: 30),
                          errorWidget: (context, url, error) => new Icon(Icons.error,color: Colors.deepPurple),
                        ),
                      ),

                      new Container(
                        width: width/2,
                        height: height/4.35,
                        margin: EdgeInsets.only(left: 5),
                        child: Column(
                          children: <Widget>[

                            SizedBox(height: 17 ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(lostList[index].objectName, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,fontFamily: 'Raleway'),overflow: TextOverflow.ellipsis,textAlign: TextAlign.left),
                              ],
                            ),

                            SizedBox(height: 18 ),
                            Container(
                                height: 20,
                                width: width/2.2,
                                child: Wrap(
                                  children: <Widget>[
                                    Icon(Icons.date_range, color: Colors.pink, size: 15,),
                                    SizedBox(width: 5 ),
                                    Text(lostList[index].date, style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway'), overflow: TextOverflow.ellipsis)
                                  ],
                                )
                            ),

                            SizedBox(height: 1.5 ),

                            Container(
                              height: 20,
                              width: width/2.2,
                              child: Row(
                                  children: <Widget>[
                                    Icon(Icons.location_city, color: Colors.pink, size: 15),
                                    SizedBox(width: 5),
                                    Text('Ville:',style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 11,fontFamily: 'Raleway')),
                                    SizedBox(width: 3),
                                    Text(lostList[index].town,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Raleway',fontSize: 13),overflow: TextOverflow.ellipsis),
                                  ]
                              ),
                            ),

                            SizedBox(height: 1.5 ),

                            Container(
                              height: 20,
                              width: width/2.2,
                              child: Row(
                                  children: <Widget>[
                                    Icon(Icons.my_location, color: Colors.pink, size: 15),
                                    SizedBox(width: 5),
                                    Text('Quartier:',style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 11,fontFamily: 'Raleway')),
                                    SizedBox(width: 3),
                                    Text(lostList[index].quarter,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Raleway',fontSize: 13),overflow: TextOverflow.ellipsis,),
                                  ]
                              ),
                            ),

                            SizedBox(height: 1.5 ),

                            Container(
                              height: 20,
                              width: width/2.2,
                              child: Row(
                                  children: <Widget>[
                                    Icon(Icons.monetization_on, color: Colors.pink, size: 15),
                                    SizedBox(width: 5),
                                    Text('Reward Amount:',style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 11,fontFamily: 'Raleway')),
                                    SizedBox(width: 3),
                                lostList[index].rewardAmount == 0
                                    ?
                                      Text("No reward",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),overflow: TextOverflow.ellipsis,)
                                    :
                                      Text("Possible",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),overflow: TextOverflow.ellipsis,),
                                  ]
                              ),
                            ),


                          ],
                        ),

                      )

                    ],
                  ),
                )
            ),
          ),
          onTap: (){

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder:
                      (context) => DetailLostPage (
                    index: index,
                    context: context,
                    objectName:lostList[index].objectName,
                    description: lostList[index].description,
                    contact: lostList[index].phone,
                    postBy: lostList[index].postBy,
                    images: lostList[index].imageUrl,
                    date: lostList[index].date,
                    profileImg: lostList[index].profileImg,
                    quarter: lostList[index].quarter,
                    town: lostList[index].town,
                    rewardAmount: lostList[index].rewardAmount,
                  )
              ),
            );
          },
        )
    );

  }

  onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch(_selectedIndex) {
      case 0: {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage()
          ),
        );
      }
      break;

      case 1: {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FoundedItemsList()
          ),
        );
      }
      break;

      case 2: {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LostItemsList()
          ),
        );
      }
      break;


      case 3: {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyObjects()
          ),
        );
      }
      break;

      case 4: {
        showSearch(
            context: context,
            delegate: SearchItems(),
            query: ''
        );
      }
      break;

      case 5:{
        userStorage.ready.then((_){

          if(!isLoggedIn()){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AuthPage()
              ),
            );
          }else{
            var userId = userStorage.getItem('userId');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    userId: userId,
                  ),
                )
            );
          }
        });
      }
      break;
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return WillPopScope(
      child: Scaffold(
        body:SizedBox.expand(
            child:DraggableScrollableSheet(
              initialChildSize: 1,
              expand: false,
              minChildSize: 1,
              builder: (context,scrollController){
                return SingleChildScrollView(physics: ScrollPhysics(),
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    verticalDirection: VerticalDirection.down,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(width: 5),
                          Text('Lost objects',textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25,fontFamily: 'Raleway')),
                        ],
                      ),

                      Row(
                        children: <Widget>[
                          SizedBox(width: 5),
                          Text('About (4) objects',textAlign: TextAlign.left, style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 13,fontFamily: 'Raleway')),
                        ],
                      ),

                      Flexible(
                        child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: _buildLostItem,
                          itemCount: lostList.length,
                        ),
                      )
                    ],
                  ),
                );
              },
         ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: true,
          items: bottomNavigationItems(),
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.black54,
          onTap: onItemTapped,
        ),
      ),
      onWillPop: (){

      },
    );
  }

}

