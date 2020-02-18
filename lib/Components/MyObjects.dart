import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findall/Components/Authentication/AuthPage.dart';
import 'package:findall/Components/Authentication/ProfilePage.dart';
import 'package:findall/Components/FoundItems/DetailsPage.dart';
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
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';


class MyObjects extends StatefulWidget {

  @override
  _MyObjectsState createState() => _MyObjectsState();
}

class _MyObjectsState extends State<MyObjects> {

  List<DocumentSnapshot> _myObjectList = []; // stores fetched products
  List<DocumentSnapshot> _allData = []; // stores fetched products
  FirebaseUser _user;
  bool _isLoading = false; // track if products fetching
  bool _hasMore = false; // flag for more products available or not
  int _docPerPage = 3;
  DocumentSnapshot _lastDocument; // flag for last document from where next 10 records to be fetched
  String _message;
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
    if(_user.runtimeType != FirebaseUser){
      setState(() {
        _allData = [];
        _message = 'No connected';
        _isLoading = false;
      });
    }else{
      /*fetch all objects of the current user from FireStore*/
      db.collection('ObjectList').where('userId',isEqualTo: _user.providerData[0].uid.toString()).getDocuments().then((allData){

        if(allData.documents.length == 0){
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
    }
    }).catchError((err){
      print(err);
    });

    super.initState();

  }

  _fetchObjects() async{

     if(_allData.length < _docPerPage){
       setState(() {
         _hasMore = false;
         _myObjectList = _allData;
       });
     }else{
       var _restDoc = _allData.length - _myObjectList.length;

       print(_restDoc);
       if(_restDoc >= _docPerPage){

         _myObjectList.length == 0
                                 ?
                                   setState(() {
                                     _hasMore = true;
                                     _myObjectList.addAll(_allData.getRange(0, _docPerPage));
                                     _lastDocument = _myObjectList[_myObjectList.length - 1];
                                   })
                                 :
                                   setState(() {
                                     _hasMore = true;
                                     _myObjectList.addAll(_allData.getRange(_myObjectList.lastIndexOf(_lastDocument) , (_myObjectList.length - 1) + _docPerPage ));
                                     _lastDocument = _myObjectList[_myObjectList.length - 1];
                                   });

       }else{
         setState(() {
           _myObjectList.addAll(_allData.sublist(_myObjectList.length));
           _lastDocument = _myObjectList[_myObjectList.length - 1];
           _hasMore = false;
         });
       }
       if(_myObjectList.length == _allData.length){
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

  _delete(docID) {
      db.collection('ObjectList').document(docID).delete();
      setState(() {
        _myObjectList.length = _myObjectList.length - 1;
      });
      Navigator.of(context).pop(true);
      Toast.show("Supprimer avec succès.", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
  }


  Widget _buildMyObjects(BuildContext context, int index){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return  Slidable(
          key: Key('slidable'+index.toString()),
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
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

                           Stack(
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
                                  imageUrl: _myObjectList[index].data['images'][0],
                                  placeholder: (context, url) => new SpinKitWave(color: Colors.deepPurple,size: 30),
                                  errorWidget: (context, url, error) => new Icon(Icons.error,color: Colors.deepPurple),
                                ),
                              ),
                              new Positioned(
                                  left: 1.0,
                                  top: 0.0,
                                  child: _myObjectList[index].data['isLost'] == false ?
                                                                                          new Image.asset('assets/images/trouve.png',
                                                                                            width: 50.0,
                                                                                            height: 20.0,
                                                                                          )
                                                                                        :
                                                                                          new Image.asset('assets/images/perdu.png',
                                                                                            width: 50.0,
                                                                                            height: 20.0,
                                                                                          )
                              ),
                            ],
                           ),

                            new Container(
                              width: width/2,
                              margin: EdgeInsets.only(left: 5),
                              child: Column(
                                children: <Widget>[

                                  SizedBox(height: 17 ),

                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(_myObjectList[index].data['objectName'], style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,fontFamily: 'Raleway'),overflow: TextOverflow.ellipsis,textAlign: TextAlign.left),
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
                                              child: Text(DateFormat("dd-MM-yyyy").format(_myObjectList[index].data['date'].toDate()).toString(), style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway'), overflow: TextOverflow.ellipsis)
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
                                            child:Text(_myObjectList[index].data['town'],style: TextStyle(fontFamily: 'Raleway',fontSize: 13),overflow: TextOverflow.ellipsis),
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
                                          Text(_myObjectList[index].data['quarter'],style: TextStyle(fontFamily: 'Raleway',fontSize: 13)),
                                        ]
                                    ),
                                  ),

                                  SizedBox(height: 1.6 ),

                                  _myObjectList[index].data['isLost'] == true
                                                                             ?
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
                                                                                            child: Text(_myObjectList[index].data['rewardAmount'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),overflow: TextOverflow.ellipsis,)
                                                                                        )
                                                                                      ]
                                                                                  ),
                                                                                )
                                                                             :
                                                                                Container(
                                                                                  height: 20,
                                                                                  width: width/2.2,
                                                                                  child: Row(
                                                                                      children: <Widget>[
                                                                                        Icon(Icons.person, color: Colors.pink, size: 15),
                                                                                        SizedBox(width: 5),
                                                                                        Text('Trouvé par:',style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 11,fontFamily: 'Raleway')),
                                                                                        SizedBox(width: 3),
                                                                                        Text(_myObjectList[index].data['finderName'].runtimeType == null ? '---': _myObjectList[index].data['finderName'],style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Raleway',fontSize: 13)),
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
                  _myObjectList[index].data['isLost'] == true ?
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) => DetailLostPage (
                                                                            index: index,
                                                                            context: context,
                                                                            isMine: true,
                                                                            docID: _myObjectList[index].documentID,
                                                                            hasBeenFound: _myObjectList[index].data['hasBeenFound'],
                                                                            objectName:_myObjectList[index].data['objectName'],
                                                                            description: _myObjectList[index].data['description'],
                                                                            contact: _myObjectList[index].data['contact'],
                                                                            images: _myObjectList[index].data['images'],
                                                                            date: _myObjectList[index].data['date'],
                                                                            ownerName: _myObjectList[index].data['ownerName'],
                                                                            profileImg: _user.providerData[0].photoUrl,
                                                                            quarter: _myObjectList[index].data['quarter'],
                                                                            town: _myObjectList[index].data['town'],
                                                                            rewardAmount: _myObjectList[index].data['rewardAmount'],
                                                                      )
                                                                  ),
                                                                )
                                                             :
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) => DetailFoundPage (
                                                                            index: index,
                                                                            isMine: true,
                                                                            docID: _myObjectList[index].documentID,
                                                                            hasBeenTaken: _myObjectList[index].data['hasBeenTaken'],
                                                                            objectName:_myObjectList[index].data['objectName'],
                                                                            description: _myObjectList[index].data['description'],
                                                                            contact: _myObjectList[index].data['contact'],
                                                                            finderName: _myObjectList[index].data['finderName'],
                                                                            images: _myObjectList[index].data['images'],
                                                                            date: _myObjectList[index].data['date'],
                                                                            profileImg: _user.providerData[0].photoUrl,
                                                                            quarter: _myObjectList[index].data['quarter'],
                                                                            town: _myObjectList[index].data['town'],
                                                                          )
                                                                  ),
                                                                );
                },
              )
          ),
          dismissal: SlidableDismissal(
            child: SlidableDrawerDismissal(),
            onWillDismiss: (actionType) {
              return showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    content: Text('Êtes vous sûr de vouloir supprimer'+'    '+ _myObjectList[index]['objectName'] +'?',style: TextStyle(fontFamily: 'Raleway'),),
                    actions: <Widget>[
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                         FlatButton(
                           child: Text('Non'),
                           onPressed: () => Navigator.of(context).pop(false),
                         ),
                         FlatButton(
                           child: Text('Oui'),
                           onPressed: () => _delete(_myObjectList[index].documentID),
                         ),
                       ],
                     )
                    ],
                  );
                },
              );
            },
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Supprimer',
              color: Colors.red,
              icon: Icons.delete,
            ),
          ],
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
                        Text('Mes objets',textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25,fontFamily: 'Raleway')),
                      ],
                    ),

                    Row(
                      children: <Widget>[
                        SizedBox(width: 5),
                        Text('Environ ('+ _myObjectList.length.toString() +') objet(s)',textAlign: TextAlign.left, style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 13,fontFamily: 'Raleway')),
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
                                                    (_message == 'No connected')
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

                                                                                          Text('Vous êtes pas connecté.',style: TextStyle(fontFamily: 'Raleway',fontSize: 15,fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
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
                                                                                              child: Text('Se connecter',style: TextStyle(color: Colors.deepPurple,fontSize: 14,fontFamily: 'Raleway',fontWeight: FontWeight.bold),)
                                                                                          ),

                                                                                        ],
                                                                                      ),
                                                                                    )
                                                                                :
                                                                                  _myObjectList.length == 0
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

                                                                                                                    Text("Vous n'avez encore ajouté aucun objet",style: TextStyle(fontFamily: 'Raleway',fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                                                                                                                  ],
                                                                                                                ),
                                                                                                              )
                                                                                                           :
                                                                                                               ListView.builder(
                                                                                                                  primary: false,
                                                                                                                  shrinkWrap: true,
                                                                                                                  physics: NeverScrollableScrollPhysics(),
                                                                                                                  itemBuilder: _buildMyObjects,
                                                                                                                  itemCount: _myObjectList.length,
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



