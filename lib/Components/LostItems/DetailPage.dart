import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:findall/GlobalComponents/BoostResearch.dart';
import 'package:findall/GlobalComponents/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter_swiper/flutter_swiper.dart';


class DetailLostPage extends StatefulWidget {

  final int index;
  final String objectName;
  final String description;
  final String town;
  final String quarter;
  final String date;
  final String contact;
  final List images;
  var profileImg;
  final String postBy;
  final String rewardAmount;
  final BuildContext context;

  DetailLostPage({Key key,
    this.index,
    this.objectName,
    this.description,
    this.town,
    this.quarter,
    this.contact,
    this.images,
    this.profileImg,
    this.postBy,
    this.date,
    this.rewardAmount,
    this.context
  }) : super(key: key);

  @override
  _DetailLostPageState createState() => _DetailLostPageState();
}

class _DetailLostPageState extends State<DetailLostPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

       WidgetsBinding.instance.addPostFrameCallback((_) async {
         seen.ready.then((_) => {
         if( checkIfFirstSeen(widget.index) == false) {
           _boostSearchDialog()
         }else{

         }
         });
      });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  Future _boostSearchDialog()async{

      return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return SimpleDialog(
              backgroundColor: Colors.white,
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Color(0xffdcdcdc))),
              contentPadding: EdgeInsets.only(left: 25,top: 25,right: 15,bottom: 5),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text("Boost your chance to find your "+' '+ widget.objectName,style: TextStyle(fontWeight: FontWeight.w800,fontFamily: "Raleway"),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
              children: <Widget>[

                Column(
                  children: <Widget>[

                    SizedBox(width: 15),

                    Container(
                      height: 50,
                      width: 230,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.pink),
                      child: FloatingActionButton.extended(
                        icon: Icon(FontAwesomeIcons.buysellads,size: 27,color: Colors.deepPurple),
                        label: Text('Boost Now',style: TextStyle(fontSize: 16
                            ,color: Colors.deepPurple,fontFamily: 'Raleway',fontWeight: FontWeight.w700),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        backgroundColor: Colors.white,
                        heroTag: "popupBoost"+widget.index.toString(),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BoostResearchPage(key: widget.key,index: widget.index)
                            ),

                          );
                        },
                      ),
                    ),

                    SizedBox(width: 25),

                    Container(
                        height: 40,
                        width: 230,
                        alignment: Alignment.center,
                        child: FlatButton(
                            onPressed:  (){
                              Navigator.of(context).pop();
                            },
                            child:  Text('Skip',
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  color: Colors.pink,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12
                              ),
                            ),
                        )

                    ),
                  SizedBox(width: 10),
                  ],
                )
              ],
            );
          }
      );


  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;


    final topBar = new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        new IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.deepPurple, size: 40),
            onPressed: () {
              Navigator.of(context).pop();
            }
        ),

        SizedBox(width: width / 2.4),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('Post by' + ' ', style: TextStyle(color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'Raleway'),
              textAlign: TextAlign.justify,
            ),

            SizedBox(width: 5),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple, width: 0.5),
                borderRadius: BorderRadius.circular(50),
                color: Colors.white10,
              ),
              height: 50,
              width: 50,
              child: widget.profileImg == null
                  ?
                    Icon(Icons.person, size: 45, color: Colors.deepPurple)
                  :
                    GestureDetector(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                            widget.profileImg, fit: BoxFit.cover, height: 50, width: 50),
                      ),
                      onTap: () {
                        photoView(context, widget.profileImg);
                      },
                    )
              ,
            ),
          ],
        ),

        SizedBox(width: 10)
      ],
    );


    final slider = Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xffeaeff2), width: 0.5),
          borderRadius: BorderRadius.circular(15),
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
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                    height: height / 2,
                    imageUrl: widget.images[index],
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                    placeholder: (context, url) =>
                        SpinKitFadingCircle(color: Colors.deepPurple, size: 50),
                    errorWidget: (context, url, error) =>
                    new Icon(Icons.error, color: Colors.deepPurple, size: 35)
                )
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
    );


    final objectName = Container(
        padding: EdgeInsets.only(top: height / 35,
            left: width / 11,
            right: width / 13,
            bottom: height / 35),
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xffeaeff2)),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Center(
                  child: Text(widget.objectName, style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'Raleway')
                  ),
                )
            )
          ],
        )
    );


    final description = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(child: Text('Description:', style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            fontFamily: 'Raleway')
        )
        ),
        SizedBox(width: width / 30),
        Container(
          child: Expanded(
              child: Text(widget.description, style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  fontFamily: 'Raleway'),
                textAlign: TextAlign.justify,
              )
          ),
        )
      ],
    );


    final location = Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Location:', style: TextStyle(color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: 'Raleway')
            ),
            SizedBox(width: width / 30),
            Expanded(child: Text(widget.town + ', ' + widget.quarter,
                style: TextStyle(color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: 'Raleway'),
              textAlign: TextAlign.justify,
            )
            )
          ],
        )
    );

    final date = Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Date:', style: TextStyle(color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: 'Raleway')),
            SizedBox(width: width / 30),
            Expanded(child: Text(widget.date, style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Raleway'),
              textAlign: TextAlign.justify,
             )
            )
          ],
        )
    );

    final reward = Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Reward amount:', style: TextStyle(color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: 'Raleway')),
            SizedBox(width: width / 30),
            Expanded(child: Text(widget.rewardAmount.toString(), style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Raleway'),
              textAlign: TextAlign.justify,
             )
            )
          ],
        )
    );


    final founderName = Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('By:', style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)
            ),
            SizedBox(width: 20),
            Expanded(child: Text(widget.postBy, style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Raleway')))
          ],
        )
    );


    final content = Container(
      margin: EdgeInsets.only(left: 17.0, right: 17.0),
      padding: EdgeInsets.only(top: height / 35,
          left: width / 15,
          right: width / 15,
          bottom: height / 35),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffeaeff2)),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          description,
          SizedBox(height: height / 35),
          location,
          SizedBox(height: height / 35),
          date,
          SizedBox(height: height / 35),
          reward,
          SizedBox(height: height / 35),
          founderName
        ],
      ),
    );

    final bottomButton = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[

        Container(
          height: 50,
          width: width/2.6,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Color(0xffd4d4d3),
                    blurRadius: 10.0, // has the effect of softening the shadow
                    offset: Offset(2,7)
                )
              ]
          ),
          child: FloatingActionButton.extended(
            icon: Icon(Icons.call,size: 27,color: Colors.white),
            label: Text('Call',style: TextStyle(fontFamily: "Raleway"),),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            backgroundColor: Colors.pink,
            heroTag: "call"+ widget.index.toString(),
            onPressed: (){
              UrlLauncher.launch('tel:'+ widget.contact);
            },
          ),
        ),

        Container(
          height: 50,
          width: width/2.6,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Color(0xffd4d4d3),
                    blurRadius: 10.0, // has the effect of softening the shadow
                    offset: Offset(2,7)
                )
              ]
          ),
          child: FloatingActionButton.extended(
            icon: Icon(FontAwesomeIcons.buysellads,size: 27,color: Colors.deepPurple),
            label: Text('Boost',
                style: TextStyle(color: Colors.deepPurple,fontFamily: "Raleway")
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            backgroundColor: Colors.white,
            heroTag: "boost"+ widget.index.toString(),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder:
                        (context) => BoostResearchPage(index: widget.index)
                ),
              );

            },
          ),
        ),
      ],
    );


    return WillPopScope(
        child: Scaffold(
          body: ListView(
            padding: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 25),
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 25),
              topBar,
              SizedBox(height: 7),
              slider,
              SizedBox(height: 30),
              objectName,
              SizedBox(height: 10),
              content,
              SizedBox(height: 20),
              bottomButton,
            ],
          ),
        ),
        onWillPop: () {
          Navigator.of(context).pop();
        }
    );
  }

}

