
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findall/Components/Authentication/AuthPage.dart';
import 'package:findall/Components/Authentication/ProfilePage.dart';
import 'package:findall/Components/LostItems/LostItemsList.dart';
import 'package:findall/FakeData/FoundModel.dart';
import 'package:findall/Components/FoundItems/DetailsPage.dart';
import 'package:findall/GlobalComponents/BottomNavigationItems.dart';
import 'package:findall/GlobalComponents/SearchItems.dart';
import 'package:findall/GlobalComponents/Utilities.dart';
import 'package:findall/Home/HomePage.dart';
import 'package:findall/Components/MyObjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';


class FoundedItemsList extends StatefulWidget {

  final String town;
  final DateTime date;

  FoundedItemsList({Key key,
    this.town,
    this.date
  }) : super(key: key);

  @override
  _FoundedItemsListState createState() => _FoundedItemsListState();
}

class _FoundedItemsListState extends State<FoundedItemsList> {
  int _selectedIndex = 1;
  List<DocumentSnapshot>  _foundList = [];
  List<DocumentSnapshot> _allData = []; // stores fetched products
  bool _isLoading = false; // track if products fetching
  bool _hasMore = false; // flag for more products available or not
  int _docPerPage = 3;
  DocumentSnapshot _lastDocument; // flag for last document from where next 10 records to be fetched
  DateTime _now = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _isLoading = true;
    });
    print(widget.town);
    if(widget.town.runtimeType == Null){
      db.collection('ObjectList')
          .where('isLost',isEqualTo: false)
          .where('hasBeenTaken',isEqualTo: false).getDocuments().then((allData){

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

    }else{
      db.collection('ObjectList')
          .where('isLost',isEqualTo: false)
          .where('town', isEqualTo: widget.town)
          .where('hasBeenTaken',isEqualTo: false).getDocuments().then((allData){

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
    }

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
        _foundList = _allData;
      });
    }else{
      var _restDoc = _allData.length - _foundList.length;

      print(_restDoc);
      if(_restDoc >= _docPerPage){

        _foundList.length == 0
                              ?
                                setState(() {
                                  _hasMore = true;
                                  _foundList.addAll(_allData.getRange(0, _docPerPage));
                                  _lastDocument = _foundList[_foundList.length - 1];
                                })
                              :
                                setState(() {
                                  _hasMore = true;
                                  _foundList.addAll(_allData.getRange(_foundList.lastIndexOf(_lastDocument) , (_foundList.length - 1) + _docPerPage ));
                                  _lastDocument = _foundList[_foundList.length - 1];
                                });

      }else{
        setState(() {
          _foundList.addAll(_allData.sublist(_foundList.length));
          _lastDocument = _foundList[_foundList.length - 1];
          _hasMore = false;
        });
      }
      if(_foundList.length == _allData.length){
        setState(() {
          _hasMore = false;

        });
      }
    }
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
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,

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
                          imageUrl: _foundList[index].data['images'][0],
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

                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(_foundList[index].data['objectName'], style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,fontFamily: 'Raleway'),overflow: TextOverflow.ellipsis,textAlign: TextAlign.left),
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
                                        child: Text(DateFormat("dd-MM-yyyy").format(_foundList[index].data['date'].toDate()).toString(), style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway'), overflow: TextOverflow.ellipsis)
                                    )
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
                                    Text(_foundList[index].data['town'],style: TextStyle(fontFamily: 'Raleway',fontSize: 13)),
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
                                    Text(_foundList[index].data['quarter'],style: TextStyle(fontFamily: 'Raleway',fontSize: 13)),
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
                                    Text('Trouvé par:',style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 11,fontFamily: 'Raleway')),
                                    SizedBox(width: 3),
                                    Text(_foundList[index].data['finderName'],style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Raleway',fontSize: 13)),
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
                    isMine: false,
                    objectName:_foundList[index].data['objectName'],
                    description: _foundList[index].data['description'],
                    contact: _foundList[index].data['contact'],
                    finderName: _foundList[index].data['finderName'],
                    images: _foundList[index].data['images'],
                    date: _foundList[index].data['date'],
                    profileImg: _foundList[index].data['profileUrl'],
                    quarter: _foundList[index].data['quarter'],
                    town: _foundList[index].data['town'],
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(width: 5),
                        Text('Objets trouvés',textAlign: TextAlign.center,style: TextStyle(
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
                        Text(_isLoading ? 'Environ (0) objet' :'Environ ('+ _foundList.length.toString() +') objet(s)',textAlign: TextAlign.left, style: TextStyle(color: Colors.black.withOpacity(0.6),fontStyle: FontStyle.italic,fontSize: 13,fontFamily: 'Raleway')),
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
                                                _foundList.length == 0
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

                                                                              Text('Aucun objet trouvé.',style: TextStyle(fontFamily: 'Raleway',fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                                                                            ],
                                                                          ),
                                                                        )
                                                                      :
                                                                        ListView.builder(
                                                                          primary: false,
                                                                          shrinkWrap: true,
                                                                          physics: NeverScrollableScrollPhysics(),
                                                                          itemBuilder: _buildFoundedItem,
                                                                          itemCount: _foundList.length,
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

