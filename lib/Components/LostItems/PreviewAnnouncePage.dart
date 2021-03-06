import 'package:findall/Components/LostItems/LostItemsList.dart';
import 'package:findall/GlobalComponents/Utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';


class PreviewAnnounce extends StatefulWidget {

  final String objectName;
  final String description;
  final String town;
  final String quarter;
  final String date;
  final String contact;
  final String rewardAmount;
  final List images;

  PreviewAnnounce({Key key,
    this.objectName,
    this.description,
    this.town,
    this.quarter,
    this.contact,
    this.images,
    this.date,
    this.rewardAmount
  }) : super(key: key);

  @override
  _PreviewAnnounceState createState() => _PreviewAnnounceState();
}

class _PreviewAnnounceState extends State<PreviewAnnounce> {

  bool _isLoading = false;

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

  void createLostObject(data)async{
    setState(() {
      _isLoading = true;
    });
    await db.collection("lostObjectList").add({
      'objectName': data['objectName'],
      'town': data['town'],
      'quarter': data['quarter'],
      'date': data['date'],
      'description': data['description'],
      'contact': data['contact'],
      'rewardAmount': data['rewardAmount'],
      'images': data['images'],
      'userId': data['userId'],
      'isLost': true,
    }).then((documentReference) {
      setState(() {
        _isLoading = true;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LostItemsList()
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
      'town': widget.town,
      'quarter': widget.quarter,
      'date': widget.date,
      'description': widget.description,
      'contact': widget.contact,
      'rewardAmount': widget.rewardAmount == "YES" ? "Possible" : "No reward",
      'images': imagesUrl,
      'userId': userId,
    };

    createLostObject(dataToSave);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      child: Scaffold(
          body: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    SizedBox(height: 50),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 5),
                        Expanded(
                            child: Text('Preview of your Announcement',textAlign: TextAlign.center,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700,fontFamily: 'Raleway'))
                        ),

                        SizedBox(height: 50),
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
                                    child: widget.images[index].runtimeType == String ?
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
                          SizedBox(height: 15 ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.date_range, color: Colors.pink, size: 15),
                              SizedBox(width: 5),
                              Text('Lost the:', style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway')),
                              SizedBox(width: 5 ),
                              Expanded(
                                  child: Text(widget.date, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,fontFamily: 'Raleway'))
                              )
                            ],
                          ),

                          SizedBox(height: 8 ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.location_city, color: Colors.pink, size: 15),
                              SizedBox(width: 5),
                              Text('Lost at:', style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway')),
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
                              Icon(Icons.monetization_on, color: Colors.pink, size: 15),
                              SizedBox(width: 5),
                              Text('Deal offer:', style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway')),
                              SizedBox(width: 5 ),
                              Expanded(
                                  child: Text(widget.rewardAmount == "YES" ? "Possible" : "No reward", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,fontFamily: 'Raleway'))
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
                              SizedBox(width: 5),
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
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                color: Colors.white,
                                child: FloatingActionButton.extended(
                                  label: Text('Back',style: TextStyle(color: Colors.pink,fontFamily: 'Raleway'),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  heroTag: "back",
                                  backgroundColor: Colors.white,
                                  onPressed: (){
                                        _isLoading
                                                  ?
                                                   null
                                                  :
                                                   Navigator.of(context).pop();
                                  }
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
                                            label: Text('Publish',
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
                                                      uploadImage(compressedImg,"lostObjectImages").then((imagesUrl){
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),)
          )

      ),
      onWillPop: (){

      },
    );
  }

}

