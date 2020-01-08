
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findall/Components/Authentication/AuthPage.dart';
import 'package:findall/Components/Authentication/ProfilePage.dart';
import 'package:findall/FakeData/FoundModel.dart';
import 'package:findall/Components/FoundItems/FoundedItemsList.dart';
import 'package:findall/GlobalComponents/BottomNavigationItems.dart';
import 'package:findall/GlobalComponents/SearchItems.dart';
import 'package:findall/GlobalComponents/Utilities.dart';
import 'package:findall/Home/HomePage.dart';
import 'package:findall/Components/LostItems/LostItemsList.dart';
import 'package:findall/Components/LostItems/PostAnnounceForm.dart';
import 'package:findall/Components/LostItems/DetailPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class MyObjects extends StatefulWidget {

  @override
  _MyObjectsState createState() => _MyObjectsState();
}

class _MyObjectsState extends State<MyObjects> {

  List<DocumentSnapshot> _lostList = []; // stores fetched products
  List<DocumentSnapshot> _allData = []; // stores fetched products
  FirebaseUser _user;
  bool _isLoading = false; // track if products fetching
  bool _hasMore = false; // flag for more products available or not
  int _docPerPage = 7;
  DocumentSnapshot _lastDocument; // flag for last document from where next 10 records to be fetched
  int _selectedIndex = 3;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _isLoading = true;
    });
    /*fetch current user data*/
    getCurrentUser().then((user){
      setState(() {
        _user = user;
      });
      /*fetch all objects of the current user from FireStore*/
      db.collection('lostObjectList').where('userId',isEqualTo: _user == null ? null : _user.providerData[0].uid.toString()).getDocuments().then((allData){

        if(allData.documents.length == 0){
          setState(() {
            _isLoading = false;
          });
        }else{
          setState(() {
            _allData = allData.documents;
            _isLoading = false;
          });
          _getObjects();
        }

      }).catchError((err){
        print(err);
      });
    }).catchError((err){
      print(err);
    });

    super.initState();

  }

  _getObjects() async{

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
                                                  child: Text(_lostList[index].data['date'], style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway'), overflow: TextOverflow.ellipsis)
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
                                                child:Text(_lostList[index].data['town'],style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Raleway',fontSize: 13),overflow: TextOverflow.ellipsis),
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
                                              Icon(Icons.monetization_on, color: Colors.pink, size: 15),
                                              SizedBox(width: 5),
                                              Text('Reward Amount:',style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 11,fontFamily: 'Raleway')),
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
                    onTap: (){

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder:
                                (context) => DetailLostPage (
                              index: index,
                              context: context,
                              isMine: true,
                              objectName:_lostList[index].data['objectName'],
                              description: _lostList[index].data['description'],
                              contact: _lostList[index]['contact'],
                              uid: _lostList[index].data['userId'],
                              images: _lostList[index].data['images'],
                              date: _lostList[index].data['date'],
                              profileImg: _user.providerData[0].photoUrl,
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
            var userID = userStorage.getItem('userId');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    userId: userID,
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
              return SingleChildScrollView(
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
                        Text('Added objects',textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25,fontFamily: 'Raleway')),
                      ],
                    ),

                    Row(
                      children: <Widget>[
                        SizedBox(width: 5),
                        Text('About ('+ _lostList.length.toString() +') object(s)',textAlign: TextAlign.left, style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 13,fontFamily: 'Raleway')),
                      ],
                    ),

                    Flexible(
                      child: _isLoading == true
                          ?
                           _user == null
                                       ?
                           Container(
                             alignment: Alignment.center,
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: <Widget>[
                                 Container(
                                   padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/6.5,bottom: 8),
                                   alignment: Alignment.center,
                                   child: Image.asset("assets/images/loginBefore.png",
                                     alignment: Alignment.center,
                                     fit: BoxFit.cover,
                                     width: MediaQuery.of(context).size.width/2.2,
                                     height: MediaQuery.of(context).size.width/2.2,
                                   ),
                                 ),

                                 Text('You are not Login.',style: TextStyle(fontFamily: 'Raleway',fontSize: 15,fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
                                 SizedBox(height: 3),
                                 FlatButton(
                                     onPressed: (){
                                       Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                             builder: (context) => AuthPage()
                                         ),
                                       );
                                     },
                                     child: Text('Login',style: TextStyle(color: Colors.deepPurple,fontSize: 14,fontFamily: 'Raleway',fontWeight: FontWeight.bold),)
                                 ),

                               ],
                             ),
                           )
                                       :
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
                                                                          
                                                                          Text('No data found.',style: TextStyle(fontFamily: 'Raleway',fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
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
                                onPressed: ()=>_getObjects(),
                                child: Text('Load More.',style: TextStyle(color: Colors.black,fontSize: 12,fontFamily: 'Raleway'),)
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: (){
            userStorage.ready.then((_){
              if(isLoggedIn() != true){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AuthPage()
                  ),
                );
              }else{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PostAnnounceForm()
                  ),
                );
              }
            });
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
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
      onWillPop: (){},
    );
  }

}

