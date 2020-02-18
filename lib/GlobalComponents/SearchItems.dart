import 'package:cached_network_image/cached_network_image.dart';
import 'package:findall/Components/FoundItems/DetailsPage.dart';
import 'package:findall/Components/LostItems/DetailPage.dart';
import 'package:findall/GlobalComponents/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';


class SearchItems extends StatefulWidget {

  @override
  _SearchItemsPageState createState() => _SearchItemsPageState();

}

class _SearchItemsPageState extends State<SearchItems> {

  bool _isLoading = false;
  var _finalResult = []; // stores fetched products

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<List> _searchByNameOrTown(String query) async {
    setState(() {
      _isLoading = true;
    });
    db.collection('ObjectList').getDocuments().then((allData){
      setState(() {
        _finalResult = allData.documents.where((res)=>res['objectName'].toLowerCase().contains(query.toLowerCase()) || res['town'].toLowerCase().contains(query.toLowerCase()) || res['description'].toLowerCase().contains(query.toLowerCase())).toList();
        _isLoading = false;
      });

    }).catchError((err){
      print(err);
    });

   return _finalResult;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Widget _buildResultList (BuildContext context, int index){
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
                                imageUrl: _finalResult[index]['images'][0],
                                placeholder: (context, url) => new SpinKitWave(color: Colors.deepPurple,size: 30),
                                errorWidget: (context, url, error) => new Icon(Icons.error,color: Colors.deepPurple),
                              ),
                            ),
                            new Positioned(
                                left: 1.0,
                                top: 0.0,
                                child: _finalResult[index]['isLost'] == false
                                                                            ?
                                                                              new Image.asset('assets/images/trouve.png',
                                                                                width: 60.0,
                                                                                height: 27.0,
                                                                              )
                                                                            :
                                                                              new Image.asset('assets/images/perdu.png',
                                                                                width: 60.0,
                                                                                height: 27.0,
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
                                child: Text(_finalResult[index]['objectName'], style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,fontFamily: 'Raleway'),overflow: TextOverflow.ellipsis,textAlign: TextAlign.left),
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
                                          child: Text(DateFormat("dd-MM-yyyy").format(_finalResult[index]['date'].toDate()).toString(), style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway'), overflow: TextOverflow.ellipsis)
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
                                        child:Text(_finalResult[index]['town'],style: TextStyle(fontFamily: 'Raleway',fontSize: 13),overflow: TextOverflow.ellipsis),
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
                                      Text(_finalResult[index]['quarter'],style: TextStyle(fontFamily: 'Raleway',fontSize: 13)),
                                    ]
                                ),
                              ),

                              SizedBox(height: 1.6 ),

                              _finalResult[index]['isLost'] == true
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
                                                                                child: Text(_finalResult[index]['rewardAmount'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),overflow: TextOverflow.ellipsis,)
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
                                                                            Text(_finalResult[index]['finderName'].runtimeType == Null ? '---': _finalResult[index]['finderName'],style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Raleway',fontSize: 13)),
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
              _finalResult[index]['isLost'] == true ?
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) => DetailLostPage (
                                                              index: index,
                                                              context: context,
                                                              isMine: false,
                                                              docID: _finalResult[index].documentID,
                                                              hasBeenFound: _finalResult[index]['hasBeenFound'],
                                                              objectName:_finalResult[index]['objectName'],
                                                              description: _finalResult[index]['description'],
                                                              contact: _finalResult[index]['contact'],
                                                              images: _finalResult[index]['images'],
                                                              date: _finalResult[index]['date'],
                                                              ownerName: _finalResult[index]['ownerName'],
                                                              profileImg: _finalResult[index]['profileUrl'],
                                                              quarter: _finalResult[index]['quarter'],
                                                              town: _finalResult[index]['town'],
                                                              rewardAmount: _finalResult[index]['rewardAmount'],
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
                                                              isMine: false,
                                                              docID: _finalResult[index].documentID,
                                                              hasBeenTaken: _finalResult[index]['hasBeenTaken'],
                                                              objectName:_finalResult[index]['objectName'],
                                                              description: _finalResult[index]['description'],
                                                              contact: _finalResult[index]['contact'],
                                                              finderName: _finalResult[index]['finderName'],
                                                              images: _finalResult[index]['images'],
                                                              date: _finalResult[index]['date'],
                                                              profileImg: _finalResult[index]['profileUrl'],
                                                              quarter: _finalResult[index]['quarter'],
                                                              town: _finalResult[index]['town'],
                                                            )
                                                        ),
                                                      );
            },
          )
      );
    }


    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (query){
                _searchByNameOrTown(query);
              },
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  color: Colors.deepPurple,
                  icon: Icon(Icons.arrow_back_ios,color: Colors.deepPurple,size: 20,),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
                contentPadding: EdgeInsets.only(left: 25),
                hintText: 'Chercher un objet, une ville ou description',
                hintStyle: TextStyle(fontStyle: FontStyle.italic),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                )
              ),
            ),
          ),


          Expanded(
            child: _isLoading == true
                                    ?
                                      Center(
                                        child: SpinKitRing(
                                          color: Colors.deepPurple,
                                          lineWidth: 3,
                                          size: 40,
                                        ),
                                      )
                                    :
                                      _finalResult.length == 0
                                                              ?
                                                                new  Center(
                                                                  child: Column(
                                                                      children: <Widget>[
                                                                      SizedBox(height: 80),
                                                                          Text("Aucun resultats",
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 30,
                                                                                  fontFamily: 'Raleway'
                                                                              )
                                                                          ),

                                                                          SizedBox(height: 40),

                                                                          Center(
                                                                            child: Image.asset('assets/images/error_loupe.png',fit: BoxFit.contain),
                                                                          ),

                                                                          SizedBox(height: 40),

                                                                          Container(
                                                                            margin: EdgeInsets.only(left: 30,right: 30),
                                                                            child: Text("Rien n'a été trouvé",
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    fontSize: 13,
                                                                                    fontFamily: 'Raleway'
                                                                                )
                                                                            ),
                                                                          ),
                                                                      ]
                                                                  )
                                                                )
                                                              :
                                                                ListView.builder(
                                                                        primary: false,
                                                                        shrinkWrap: true,
                                                                        itemBuilder: _buildResultList,
                                                                        itemCount: _finalResult.length,
                                                                    ),
          )
        ],
      )
    );
  }
}