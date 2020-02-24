import 'package:cached_network_image/cached_network_image.dart';
import 'package:findall/GlobalComponents/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter_swiper/flutter_swiper.dart';


class DetailFoundPage extends StatefulWidget {

  final int index;
  final bool isMine;
  final String docID;
  final String town;
  final String quarter;
  var date;
  final String contact;
  final List images;
  bool hasBeenTaken;
  var profileImg;
  final String objectName;
  final String description;
  final String finderName;

  DetailFoundPage({Key key,
    this.index,
    this.town,
    this.date,
    this.docID,
    this.images,
    this.isMine,
    this.quarter,
    this.contact,
    this.objectName,
    this.description,
    this.hasBeenTaken,
    this.profileImg,
    this.finderName,
  }) : super(key: key);

  @override
  _DetailFoundPageState createState() => _DetailFoundPageState();
}

class _DetailFoundPageState extends State<DetailFoundPage> {

  bool _showGetObject = false;

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

  _showGetMyObject() {
    setState(() {
      _showGetObject = !_showGetObject;
    });
  }

  _thisObjectHasBeenTaken(){
    print('it has been taken');
    setState(() {
      widget.hasBeenTaken = !widget.hasBeenTaken;
    });
    db.collection('ObjectList').document(widget.docID).updateData({'hasBeenTaken': widget.hasBeenTaken});
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

        SizedBox(width: width / 2.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('Trouvé par' + ' ', style: TextStyle(color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
                fontFamily: 'Raleway'),
              textAlign: TextAlign.justify,
            ),

            SizedBox(width: 5),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.35),
                borderRadius: BorderRadius.circular(50),
                color: Colors.white10,
              ),
              height: 50,
              width: 50,
              child: widget.profileImg == null
                                              ?
                                                Image.asset('assets/images/user.png',height: 40,width: 40,fit: BoxFit.cover,)
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
                                                ),
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
                    fontFamily: 'Raleway')
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
            Expanded(child: Text(DateFormat("dd-MM-yyyy").format(widget.date.toDate()).toString(), style: TextStyle(
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
            Text('Par:', style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
            SizedBox(width: 20),
            Expanded(child: Text(widget.finderName, style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Raleway')
             )
            )
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
          founderName
        ],
      ),
    );

    final bottomButton = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Container(
          height: 53,
          width: width/1.2,
          child: widget.isMine
                              ?
                                FloatingActionButton.extended(
                                  icon: Icon(widget.hasBeenTaken ? Icons.check_box : Icons.check_box_outline_blank,size: 28,color: Colors.white),
                                  label: Text('Déjà pris',style: TextStyle(fontFamily: "Raleway"),),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  backgroundColor: Colors.deepPurple,
                                  heroTag: "taken"+ widget.index.toString(),
                                  onPressed: (){
                                    _thisObjectHasBeenTaken();
                                  },
                                )
                              :
                                FloatingActionButton.extended(
                                  label: _showGetObject
                                                       ?
                                                          Text('Veuillez défiler vers le bas', style: TextStyle(
                                                              color: Colors.white,fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
                                                          )
                                                       :
                                                          Text('Recupérer votre objet', style: TextStyle(
                                                              color: Colors.white,fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
                                                          ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  backgroundColor: Colors.deepPurple,
                                  heroTag: "get"+widget.index.toString(),
                                  onPressed: () {
                                    _showGetMyObject();
                                  },
                                ),
        ),
      ],
    );

    final getObject = Column(
      children: <Widget>[

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Text('Entrez en contact avec la personne',style:
                            TextStyle(fontFamily: 'Raleway',fontSize: 15,),
                            textAlign: TextAlign.justify,
                   )
            ),
            Container(
                child: Text('qui a trouvé votre objet.',style:
                TextStyle(fontFamily: 'Raleway',fontSize: 15,),
                  textAlign: TextAlign.justify,
                )
            )
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[

            new Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.white),
                  color: Colors.white,
                  boxShadow:[
                    BoxShadow(
                        color: Color(0xffd4d4d4),
                        blurRadius: 10.0, // has the effect of softening the shadow
                        offset: Offset(0,5)
                    )
                  ]
              ),
              child: IconButton(
                  color: Colors.white,
                  iconSize: 40,
                  icon: Icon(Icons.call,
                    color: Colors.deepPurple,
                    size: 32,
                  ),
                  onPressed: (){
                    UrlLauncher.launch('tel:'+ widget.contact);
                  }
              ),

             ),

            new Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.white),
                  color: Colors.white,
                  boxShadow:[
                    BoxShadow(
                        color: Color(0xffd4d4d4),
                        blurRadius: 10.0, // has the effect of softening the shadow
                        offset: Offset(0,5)
                    )
                  ]
              ),
              child: IconButton(
                  color: Colors.white,
                  iconSize: 40,
                  icon: Icon(FontAwesomeIcons.sms,
                    color: Colors.deepPurple,
                    size: 32,
                  ),
                  onPressed: (){
                    UrlLauncher.launch('sms:'+ widget.contact);
                  }
              ),

            ),
          ],
        )
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
              _showGetObject == true
                                    ?
                                      SizedBox(height: 27.0)
                                    :
                                      SizedBox(height: 0.0),
              _showGetObject == true
                                    ?
                                      getObject
                                    :
                                      SizedBox(height: 0.0),
            ],
          ),
        ),
        onWillPop: () {
          Navigator.of(context).pop();
        }
    );
  }

 }

