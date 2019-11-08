
import 'package:cached_network_image/cached_network_image.dart';
import 'package:findall/FakeData/FoundModel.dart';
import 'package:findall/FoundItems/FoundedItemsList.dart';
import 'package:findall/GlobalComponents/BottomNavigationBar.dart';
import 'package:findall/Home/HomePage.dart';
import 'package:findall/LostItems/PostAnnounceForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class LostItemsList extends StatefulWidget {

  @override
  LostItemsListState createState() => LostItemsListState();
}

class LostItemsListState extends State<LostItemsList> {
  int _selectedIndex = 2;
  List lostList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    lostList = getFoundList();
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
                                Text(lostList[index].objectName, style: Theme.of(context).textTheme.title,overflow: TextOverflow.ellipsis,textAlign: TextAlign.left),
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
                                    Text(lostList[index].date, style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13), overflow: TextOverflow.ellipsis,)
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
                                    Text('Ville:',style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 11)),
                                    SizedBox(width: 3),
                                    Text(lostList[index].town,style: TextStyle(fontWeight: FontWeight.bold)),
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
                                    Text('Quartier:',style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 11)),
                                    SizedBox(width: 3),
                                    Text(lostList[index].quarter,style: TextStyle(fontWeight: FontWeight.bold)),
                                  ]
                              ),
                            ),

                            SizedBox(height: 1.5 ),

                            Container(
                              height: 20,
                              width: width/2.2,
                              child: Row(
                                  children: <Widget>[
                                    Text('Reward Amount:',style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 11)),
                                    SizedBox(width: 3),
                                    Text(lostList[index].rewardAmount,style: TextStyle(fontWeight: FontWeight.bold)),
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
          onTap: (){},
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

      }
      break;
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
        body:Column(
          children: <Widget>[
            SizedBox(height: 50),

            Row(
              children: <Widget>[
                SizedBox(width: 5),
                Text('Lost objects',textAlign: TextAlign.left,style: Theme.of(context).textTheme.title),
              ],
            ),

            Row(
              children: <Widget>[
                SizedBox(width: 5),
                Text('About (4) objects',textAlign: TextAlign.left, style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 11)),
              ],
            ),

            Flexible(
              fit: FlexFit.tight,
              child: ListView.builder(
                itemBuilder: _buildLostItem,
                scrollDirection: Axis.vertical,
                itemCount: 4,
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              title: Text('Found items'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance),
              title: Text('Lost items'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.public),
              title: Text('Post annou..'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('My account'),
            ),
          ],
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

List getFoundList(){
  return [
    Found(
        objectName: 'Mobile Phone',
        town: 'Yaounde',
        quarter: 'Bastos',
        phone: '656894756',
        date: '15 Janvier 2019 15h45',
        isLost: true,
        postBy: 'Fergiestella Tina',
        description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy",
        imageUrl: [
          "https://images.pexels.com/photos/237018/pexels-photo-237018.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          "https://images.pexels.com/photos/1319911/pexels-photo-1319911.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          "https://images.pexels.com/photos/1133957/pexels-photo-1133957.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
        ],
      rewardAmount: r"$5"
    ),
    Found(
        objectName: 'Certificates',
        town: 'Yaounde',
        quarter: 'Bastos',
        phone: '656894756',
        date: '15 Janvier 2019 15h45',
        isLost: true,
        postBy: 'Fergiestella Tina',
        description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy",
        imageUrl: [
          "https://images.pexels.com/photos/1133957/pexels-photo-1133957.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          "https://images.pexels.com/photos/237018/pexels-photo-237018.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          "https://images.pexels.com/photos/1319911/pexels-photo-1319911.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
        ],
      rewardAmount: r"$8"
    ),
    Found(
        objectName: 'Passport',
        town: 'Yaounde',
        quarter: 'Bastos',
        phone: '656894756',
        date: '15 Janvier 2019 15h45',
        isLost: true,
        postBy: 'Fergiestella Tina',
        description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy",
        imageUrl: [
          "https://images.pexels.com/photos/1319911/pexels-photo-1319911.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          "https://images.pexels.com/photos/237018/pexels-photo-237018.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          "https://images.pexels.com/photos/1133957/pexels-photo-1133957.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
        ],
        rewardAmount: r"$15"
    ),
    Found(
        objectName: 'Identity Card',
        town: 'Yaounde',
        quarter: 'Bastos',
        phone: '656894756',
        date: '15 Janvier 2019 15h45',
        isLost: true,
        postBy: 'Fergiestella Tina',
        description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy",
        imageUrl: [
          "https://images.pexels.com/photos/999515/pexels-photo-999515.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          "https://images.pexels.com/photos/237018/pexels-photo-237018.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          "https://images.pexels.com/photos/1319911/pexels-photo-1319911.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          "https://images.pexels.com/photos/1133957/pexels-photo-1133957.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
        ],
        rewardAmount: r"$10"
    )
  ];
}