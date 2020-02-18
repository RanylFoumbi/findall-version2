
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findall/Components/Authentication/AuthPage.dart';
import 'package:findall/Components/Authentication/ProfilePage.dart';
import 'package:findall/Components/FoundItems/FoundedItemsList.dart';
import 'package:findall/GlobalComponents/BottomNavigationItems.dart';
import 'package:findall/GlobalComponents/SearchItems.dart';
import 'package:findall/GlobalComponents/Utilities.dart';
import 'package:findall/Home/HomePage.dart';
import 'package:findall/Components/MyObjects.dart';
import 'package:findall/Components/LostItems/DetailPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';


class LostItemsList extends StatefulWidget {

  @override
  _LostItemsListState createState() => _LostItemsListState();
}

class _LostItemsListState extends State<LostItemsList> {
  int _selectedIndex = 2;
  List<DocumentSnapshot>  _lostList = [];
  List<DocumentSnapshot> _allData = []; // stores fetched products
  bool _isLoading = false; // track if products fetching
  bool _hasMore = false; // flag for more products available or not
  int _docPerPage = 3;
  DocumentSnapshot _lastDocument; // flag for last document from where next 10 records to be fetched

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _isLoading = true;
    });
    /*fetch all objects of the current user from FireStore*/
    db.collection('ObjectList').where('isLost',isEqualTo: true).where('hasBeenFound',isEqualTo: false).getDocuments().then((allData){

      if(allData.documents.runtimeType == Null){
        setState(() {
          _isLoading = false;
        });
      }else{
        setState(() {
          _allData = allData.documents;
          _isLoading = false;
        });
        _fetchObjects();
      }

    }).catchError((err){
      print(err);
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  _fetchObjects() async{

    if(_allData.length < _docPerPage){
      setState(() {
        _hasMore = false;
        _lostList = _allData;
      });
    }else{
      var _restDoc = _allData.length - _lostList.length;

      print(_restDoc);
      if(_restDoc >= _docPerPage){

        _lostList.length == 0
                            ?
                              setState(() {
                                _hasMore = true;
                                _lostList.addAll(_allData.getRange(0, _docPerPage));
                                _lastDocument = _lostList[_lostList.length - 1];
                              })
                            :
                              setState(() {
                                _hasMore = true;
                                _lostList.addAll(_allData.getRange(_lostList.lastIndexOf(_lastDocument) , (_lostList.length - 1) + _docPerPage ));
                                _lastDocument = _lostList[_lostList.length - 1];
                              });

      }else{
        setState(() {
          _lostList.addAll(_allData.sublist(_lostList.length));
          _lastDocument = _lostList[_lostList.length - 1];
          _hasMore = false;
        });
      }
      if(_lostList.length == _allData.length){
        setState(() {
          _hasMore = false;
        });
      }
    }
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
                  padding: const EdgeInsets.only(bottom: 1.5),
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
                          imageUrl: _lostList[index].data['images'][0],
                          placeholder: (context, url) => new SpinKitWave(color: Colors.deepPurple,size: 30),
                          errorWidget: (context, url, error) => new Icon(Icons.error,color: Colors.deepPurple),
                        ),
                      ),


                      new Container(
                        width: width/2,
                        margin: EdgeInsets.only(left: 5),
                        child: Column(
                          children: <Widget>[

                            SizedBox(height: 17 ),

                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(_lostList[index].data['objectName'], style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,fontFamily: 'Raleway'),overflow: TextOverflow.ellipsis,textAlign: TextAlign.left),
                            ),

                            SizedBox(height: 18 ),
                            Container(
                                height: 20,
                                width: width/2.2,
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.date_range, color: Colors.pink, size: 15,),
                                    SizedBox(width: 5 ),
                                    Flexible(
                                        child: Text(DateFormat("dd-MM-yyyy").format(_lostList[index].data['date'].toDate()).toString(), style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway'), overflow: TextOverflow.ellipsis)
                                    )
                                  ],
                                )
                            ),

                            SizedBox(height: 1.6 ),

                            Container(
                              height: 20,
                              width: width/2.2,
                              child: Row(
                                  children: <Widget>[
                                    Icon(Icons.location_city, color: Colors.pink, size: 15),
                                    SizedBox(width: 5),
                                    Text('Ville:',style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 11,fontFamily: 'Raleway')),
                                    SizedBox(width: 3),
                                    Flexible(
                                      child:Text(_lostList[index].data['town'],style: TextStyle(fontFamily: 'Raleway',fontSize: 13),overflow: TextOverflow.ellipsis),
                                    )
                                  ]
                              ),
                            ),

                            SizedBox(height: 1.6 ),

                            Container(
                              height: 20,
                              width: width/2.2,
                              child: Row(
                                  children: <Widget>[
                                    Icon(Icons.my_location, color: Colors.pink, size: 15),
                                    SizedBox(width: 5),
                                    Text('Quartier:',style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 11,fontFamily: 'Raleway')),
                                    SizedBox(width: 3),
                                    Text(_lostList[index].data['quarter'],style: TextStyle(fontFamily: 'Raleway',fontSize: 13)),
                                  ]
                              ),
                            ),



                            SizedBox(height: 1.6 ),

                            Container(
                              height: 20,
                              width: width/2.2,
                              child: Row(
                                  children: <Widget>[
                                    Icon(Icons.monetization_on, color: Colors.pink, size: 15),
                                    SizedBox(width: 5),
                                    Text('Récompense:',style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 11,fontFamily: 'Raleway')),
                                    SizedBox(width: 3),
                                    Flexible(
                                        child: Text(_lostList[index].data['rewardAmount'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),overflow: TextOverflow.ellipsis,)
                                    )
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
          onTap: ()async{

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder:
                      (context) => DetailLostPage (
                    index: index,
                    context: context,
                    isMine: false,
                    objectName:_lostList[index].data['objectName'],
                    description: _lostList[index].data['description'],
                    profileImg: _lostList[index].data['profileUrl'],
                    contact: _lostList[index].data['contact'],
                    ownerName: _lostList[index].data['ownerName'],
                    images: _lostList[index].data['images'],
                    date: _lostList[index].data['date'],
                    quarter: _lostList[index].data['quarter'],
                    town: _lostList[index].data['town'],
                    rewardAmount: _lostList[index].data['rewardAmount'],
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
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchItems()
          ),
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
                          Text('Objets perdus',textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25,fontFamily: 'Raleway')),
                        ],
                      ),

                      Row(
                        children: <Widget>[
                          SizedBox(width: 5),
                          Text(_isLoading ? 'Environ (0) objet' :'Environ ('+ _lostList.length.toString() +') object(s)',textAlign: TextAlign.left, style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 13,fontFamily: 'Raleway')),
                        ],
                      ),

                      Flexible(
                        child: _isLoading == true
                                                ?
                                                  Container(
                                                    height: MediaQuery.of(context).size.height/1.3,
                                                    alignment: Alignment.center,
                                                    child: SpinKitFadingCircle(color: Colors.deepPurple,
                                                      size: 65,
                                                    ),
                                                  )
                                                :
                                                 _lostList.length == 0
                                                                      ?
                                                                        Container(
                                                                          alignment: Alignment.center,
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: <Widget>[
                                                                              Container(
                                                                                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/4,bottom: 8),
                                                                                alignment: Alignment.center,
                                                                                child: Image.asset("assets/images/noDataFound.png",
                                                                                  alignment: Alignment.center,
                                                                                  fit: BoxFit.cover,
                                                                                  width: MediaQuery.of(context).size.width/1.5,
                                                                                ),
                                                                              ),

                                                                              Text('Aucun objet perdu.',style: TextStyle(fontFamily: 'Raleway',fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                                                                            ],
                                                                          ),
                                                                        )
                                                                      :
                                                                        ListView.builder(
                                                                          primary: false,
                                                                          shrinkWrap: true,
                                                                          physics: NeverScrollableScrollPhysics(),
                                                                          itemBuilder: _buildLostItem,
                                                                          itemCount: _lostList.length,
                                                                        ),
                      ),

                      _hasMore
                              ?
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(3),
                                  child: FlatButton(
                                      shape: Border.all(color: Colors.black),
                                      onPressed: ()=>_fetchObjects(),
                                      child: Text('Voir plus.',style: TextStyle(color: Colors.black,fontSize: 12,fontFamily: 'Raleway'),)
                                  ),
                                )
                              :
                                Container()

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

