
import 'package:findall/Components/FoundItems/FoundedItemsList.dart';
import 'package:findall/Components/FoundItems/NewFoundForm.dart';
import 'package:findall/GlobalComponents/Utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';


class PreviewNewFound extends StatefulWidget {

  final String objectName;
  final String description;
  final String town;
  final String quarter;
//  var date;
  final String contact;
  final String finderName;
  final List images;

  PreviewNewFound({Key key,
    this.objectName,
    this.description,
    this.town,
    this.quarter,
    this.contact,
    this.images,
    this.finderName,
//    this.date
  }) : super(key: key);


  @override
  _PreviewNewFoundState createState() => _PreviewNewFoundState();
}

class _PreviewNewFoundState extends State<PreviewNewFound> {
  bool _isLoading = false;
  FirebaseUser _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser().then((user)=>{
      setState(() {
        _user = user;
      }),
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _createFoundObject(data)async{
    setState(() {
      _isLoading = true;
    });
    await db.collection("ObjectList").add({
      'objectName': data['objectName'],
      'town': data['town'],
      'quarter': data['quarter'],
      'date': DateTime.now(),
      'description': data['description'],
      'contact': data['contact'],
      'images': data['images'],
      'userId': data['userId'],
      'finderName': data['finderName'],
      'profileUrl': _user.providerData[0].photoUrl,
      'hasBeenTaken': false,
      'isLost': false,
    }).then((documentReference) {
      setState(() {
        _isLoading = true;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FoundedItemsList()
        ),
      );

      setState(() {
        _isLoading = false;
      });

      print(documentReference.documentID);
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    });
  }


  void _publish(imagesUrl,userId) async{

    var dataToSave = {
      'objectName': widget.objectName,
      'town': widget.town.toLowerCase(),
      'quarter': widget.quarter,
//      'date': widget.date,
      'description': widget.description,
      'contact': widget.contact,
      'finderName': widget.finderName,
      'images': imagesUrl,
      'userId': userId,
    };

    _createFoundObject(dataToSave);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 10, right: 10,top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                SizedBox(height: 50),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 5),
                    Expanded(
                        child: Text('Aperçu de votre annonce',textAlign: TextAlign.center,style: TextStyle(fontSize: 24,fontWeight: FontWeight.w700,fontFamily: 'Raleway'))
                    ),

                    SizedBox(height: 45),
                  ],
                ),


                new Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(left: 13,right: 13,top: 15,bottom: 30),
                    children: <Widget>[

                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffeaeff2), width: 0.5),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xffd4d4d4),
                                  blurRadius: 10.0, // has the effect of softening the shadow
                                  offset: Offset(0, 4)
                              )
                            ]
                        ),
                        width: width,
                        height: height / 2,
                        child: new Swiper(
                          itemWidth: height / 1.8,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child:  widget.images[index].runtimeType == String ?
                                                                                      Image.network(
                                                                                          widget.images[index],
                                                                                          width: width/1.1,
                                                                                          height: height/2.7,
                                                                                          fit: BoxFit.cover
                                                                                      )
                                                                                    :
                                                                                      Image.file(
                                                                                          widget.images[index],
                                                                                          width: width/1.1,
                                                                                          height: height/2.7,
                                                                                          fit: BoxFit.cover
                                                                                      ),
                              ),
                              onTap: () {
                                photoView(context, widget.images[index]);
                              },
                            );
                          },
                          itemCount: widget.images.length,
                          autoplay: true,
                          pagination: new SwiperPagination(margin: EdgeInsets.all(0),),
                          control: new SwiperControl(
                            padding: EdgeInsets.all(0),
                            color: Colors.deepPurple,
                            size: 0,
                            iconPrevious: null,
                            iconNext: null,
                          ),
                        ),
                      ),

                      SizedBox(height: 15 ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(widget.objectName, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,fontFamily: 'Raleway')),
                          ),

                        ],
                      ),
                     /* SizedBox(height: 15 ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.date_range, color: Colors.pink, size: 15),
                          SizedBox(width: 5),
                          Text('Trouvé le:', style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway')),
                          SizedBox(width: 5 ),
                          Expanded(
                              child: Text(DateFormat("dd-MM-yyyy").format(widget.date.toDate()).toString(), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,fontFamily: 'Raleway'))
                          )
                        ],
                      ),*/

                      SizedBox(height: 8 ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.location_city, color: Colors.pink, size: 15),
                          SizedBox(width: 5),
                          Text('Trouvé à:', style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway')),
                          SizedBox(width: 5 ),
                          Expanded(
                              child: Text(widget.town, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,fontFamily: 'Raleway'))
                          )
                        ],
                      ),


                      SizedBox(height: 8 ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.account_circle, color: Colors.pink, size: 15),
                          SizedBox(width: 5),
                          Text('Trouvé par:', style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway')),
                          SizedBox(width: 5 ),
                          Expanded(
                              child: Text(widget.finderName, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,fontFamily: 'Raleway'))
                          )
                        ],
                      ),


                      SizedBox(height: 8 ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.phone, color: Colors.pink, size: 15),
                          SizedBox(width: 5),
                          Text('Contact:', style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway')),
                          SizedBox(width: 5 ),
                          Expanded(
                              child: Text(widget.contact, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,fontFamily: 'Raleway'))
                          )
                        ],
                      ),


                      SizedBox(height: 8 ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.description, color: Colors.pink, size: 15),
                          SizedBox(width: 5),
                          Text('Description:', style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway')),
                          SizedBox(width: 5 ),
                          Expanded(
                            child: Text(widget.description,style: TextStyle(fontSize: 15,fontFamily: 'Raleway')),
                          ),
                        ],
                      ),

                      SizedBox(height: 30 ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          SizedBox(height: 20),

                          Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.pink),
                            child: FloatingActionButton.extended(
                              label: Text('Retour',style: TextStyle(color: Colors.pink,fontFamily: 'Raleway'),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              backgroundColor: Colors.white,
                              heroTag: "back",
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewFoundForm(
                                        town: widget.town,
                                        contact: widget.contact,
                                        objectName: widget.objectName,
                                        quarter: widget.quarter,
                                        description: widget.description,
                                        finderName: widget.finderName,
                                        images: widget.images,
                                      )
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(width: width/3.2),

                          Container(
                              height: 40,
                              width: 100,
                              alignment: Alignment.center,
                              color: Colors.pink,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                              child: _isLoading
                                              ?

                                                SpinKitCircle(
                                                  color: Colors.deepPurple,
                                                  size: 45.0,
                                                )
                                              :
                                                FloatingActionButton.extended(
                                                  icon: Icon(Icons.public,color: Colors.white),
                                                  label: Text('Publier',
                                                    style: TextStyle(
                                                        fontFamily: 'Raleway'
                                                    ),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  backgroundColor: Colors.pink,
                                                  heroTag: "proceed",
                                                  onPressed: (){
                                                    getCurrentUser().then((FirebaseUser user){
                                                      setState(() {
                                                        _isLoading = true;
                                                      });
                                                      compressImage(widget.images).then((compressedImg){
                                                        setState(() {
                                                          _isLoading = true;
                                                        });
                                                        uploadImage(compressedImg,"foundObjectImages").then((imagesUrl){
                                                          setState(() {
                                                            _isLoading = true;
                                                          });
                                                          _publish(imagesUrl,user.providerData[0].uid);
                                                        });
                                                      });
                                                    }).catchError((err){
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                    });

                                                  }

                                          )
                          )
                        ],
                      ),
                    ],
                  ),

                ),

              ],
            ),
          )

      ),
      onWillPop: (){

      },
    );
  }


}