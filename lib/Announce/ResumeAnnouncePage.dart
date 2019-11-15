import 'package:cached_network_image/cached_network_image.dart';
import 'package:findall/FakeData/FoundModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class ResumeAnnounce extends StatefulWidget {

@override
ResumeAnnounceState createState() => ResumeAnnounceState();
}

class ResumeAnnounceState extends State<ResumeAnnounce> {

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
                      child: Text('Resume of your Announcement',textAlign: TextAlign.center,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700,fontFamily: 'Raleway'))
                  ),

                  SizedBox(height: 70),
                ],
              ),


              new Expanded(
                child: ListView(
                  padding: EdgeInsets.only(left: 8,right: 8,bottom: 15),
//                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    new Container(
                      width: width,
                      height: height/2.7,
                      padding: const EdgeInsets.all(3.0),
                      child:CachedNetworkImage(
                        width: width/1.1,
                        height: height/2.7,
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.noRepeat,
                        imageUrl: foundList[0].imageUrl[0],
                        placeholder: (context, url) => new SpinKitWave(color: Colors.deepPurple,size: 40),
                        errorWidget: (context, url, error) => new Icon(Icons.error,color: Colors.deepPurple),
                      ),
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(foundList[0].objectName, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,fontFamily: 'Raleway')),
                        ),

                      ],
                    ),
                    SizedBox(height: 8 ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.date_range, color: Colors.pink, size: 15),
                        SizedBox(width: 5),
                        Text('Lost the:', style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway'), overflow: TextOverflow.ellipsis,),
                        SizedBox(width: 5 ),
                        Text(foundList[0].date, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,fontFamily: 'Raleway'), overflow: TextOverflow.ellipsis,)
                      ],
                    ),

                    SizedBox(height: 5 ),
                    Row(
                        children: <Widget>[
                          Icon(Icons.location_city, color: Colors.pink, size: 15),
                          SizedBox(width: 5),
                          Text('Lost at:', style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway'), overflow: TextOverflow.ellipsis,),
                          SizedBox(width: 3),
                          Text(foundList[0].town + ',' +foundList[0].quarter,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Raleway')),
                        ]
                    ),

                    SizedBox(height: 5 ),

                    Row(
                        children: <Widget>[
                          Icon(Icons.monetization_on, color: Colors.pink, size: 15),
                          SizedBox(width: 5),
                          Text('Deal offer:', style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 13,fontFamily: 'Raleway'), overflow: TextOverflow.ellipsis,),
                          SizedBox(width: 3),
                          Text(foundList[0].rewardAmount,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,fontFamily: 'Raleway')),
                        ]
                    ),

                    SizedBox(height: 5 ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.description, color: Colors.pink, size: 15),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(foundList[0].description,style: TextStyle(fontSize: 15,fontFamily: 'Raleway')),
                        ),
                      ],
                    ),

                    SizedBox(height: 10 ),

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
                            label: Text('Back',style: TextStyle(color: Colors.pink,fontFamily: 'Raleway'),),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            backgroundColor: Colors.white,
                            heroTag: "back",
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                          ),
                        ),

                        SizedBox(width: width/3.2),

                        Container(
                            height: 40,
                            width: 100,
                            child:FloatingActionButton.extended(
                              label: Text('Proceed',
                                style: TextStyle(
                                    fontFamily: 'Raleway'
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              backgroundColor: Colors.deepPurple,
                              heroTag: "proceed",
                              onPressed: (){
                                /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FoundedItemsList()
                            ),

                          );*/
                              },
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