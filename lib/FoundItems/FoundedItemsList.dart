
import 'package:cached_network_image/cached_network_image.dart';
import 'package:findall/FakeData/FoundModel.dart';
import 'package:findall/FoundItems/DetailsPage.dart';
import 'package:findall/GlobalComponents/BottomNavigationItems.dart';
import 'package:findall/GlobalComponents/SearchItems.dart';
import 'package:findall/Home/HomePage.dart';
import 'package:findall/LostItems/LostItemsList.dart';
import 'package:findall/Announce/PostAnnounceForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class FoundedItemsList extends StatefulWidget {

  @override
  FoundedItemsListState createState() => FoundedItemsListState();
}

class FoundedItemsListState extends State<FoundedItemsList> {
  int _selectedIndex = 1;
  List foundList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foundList = Found().getFoundList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  Widget _buildFoundedItem(BuildContext context, int index){

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
        key: Key(index.toString()),
        child: GestureDetector(
          child: Card(
            color: Colors.white,
            child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
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
                          imageUrl: foundList[index].imageUrl[0],
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
                                Text(foundList[index].objectName, style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20
                                    ),
                                      overflow: TextOverflow.ellipsis,textAlign: TextAlign.left,
                                    )
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
                                    Text(foundList[index].date, style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway',), overflow: TextOverflow.ellipsis,)
                                  ],
                                )
                            ),

                            SizedBox(height: 2.5 ),

                            Container(
                              height: 20,
                              width: width/2.2,
                              child: Row(
                                  children: <Widget>[
                                    Icon(Icons.location_city, color: Colors.pink, size: 15),
                                    SizedBox(width: 5),
                                    Text('Ville:',style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 11,fontFamily: 'Raleway')),
                                    SizedBox(width: 3),
                                    Text(foundList[index].town,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Raleway',fontSize: 13)),
                                  ]
                              ),
                            ),

                            SizedBox(height: 2.5 ),

                            Container(
                              height: 20,
                              width: width/2.2,
                              child: Row(
                                  children: <Widget>[
                                    Icon(Icons.my_location, color: Colors.pink, size: 15),
                                    SizedBox(width: 5),
                                    Text('Quartier:',style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 11,fontFamily: 'Raleway')),
                                    SizedBox(width: 3),
                                    Text(foundList[index].quarter,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Raleway',fontSize: 13)),
                                  ]
                              ),
                            ),

                            SizedBox(height: 2.5 ),

                            Container(
                              height: 20,
                              width: width/2.2,
                              child: Row(
                                  children: <Widget>[
                                    Icon(Icons.person, color: Colors.pink, size: 15),
                                    SizedBox(width: 5),
                                    Text('Post by:',style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 11,fontFamily: 'Raleway')),
                                    SizedBox(width: 3),
                                    Text(foundList[index].postBy,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Raleway',fontSize: 13)),
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
                      (context) => DetailFoundPage (
                    index: index,
                    objectName:foundList[index].objectName,
                    description: foundList[index].description,
                    contact: foundList[index].phone,
                    founderName: foundList[index].foundBy,
                    images: foundList[index].imageUrl,
                    date: foundList[index].date,
                    profileImg: foundList[index].profileImg,
                    quarter: foundList[index].quarter,
                    town: foundList[index].town,
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
              builder: (context) => PostAnnounceForm()
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

      }
      break;
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      child: Scaffold(
        body:Column(
          children: <Widget>[
            SizedBox(height: 50),
            Row(
              children: <Widget>[
                SizedBox(width: 5),
                Text('Found objects',textAlign: TextAlign.left,style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Raleway'
                )
                ),
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
                itemBuilder: _buildFoundedItem,
                scrollDirection: Axis.vertical,
                itemCount: foundList.length,
                key: Key(foundList.length.toString()),
              ),
            )
          ],
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
      onWillPop: null,
    );
  }

}

