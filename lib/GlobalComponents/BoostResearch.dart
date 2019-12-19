import 'package:findall/Components/LostItems/LostItemsList.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;


class BoostResearchPage extends StatefulWidget{

  int index;

  BoostResearchPage({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  _BoostResearchPageState createState() => _BoostResearchPageState();
}

class _BoostResearchPageState extends State<BoostResearchPage> {

  Future _thankYouDialog()async{

    double width = MediaQuery.of(context).size.width;

    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return SimpleDialog(
            backgroundColor: Colors.white,
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Color(0xffdcdcdc))),
            contentPadding: EdgeInsets.only(left: 25,top: 25,right: 15,bottom: 25),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text("We will contact you as soon as possible. "+' ',style: TextStyle(fontWeight: FontWeight.w800,fontFamily: "Raleway"),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            children: <Widget>[

              Row(
                children: <Widget>[

                  Container(
                      height: 40,
                      width: width/1.1,
                      child:FloatingActionButton.extended(
                        label: Text('Okay',
                          style: TextStyle(
                              fontFamily: 'Raleway'
                          ),
                          textAlign: TextAlign.center,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        backgroundColor: Colors.pink,
                        heroTag: "okay",
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LostItemsList()
                            ),

                          );
                        },
                      )
                  )
                ],
              ),
            ],
          );
        }
    );


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
        child: Scaffold(
          key: Key("Key"+widget.index.toString()),
          body: ListView(
            scrollDirection: Axis.vertical,
            key: Key("List"+widget.index.toString()),
            padding: EdgeInsets.only(top: 60,bottom: 25),
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    ' Want us to quickly find',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        fontFamily:"Raleway"
                    ),
                  ),
                ],
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'your object',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        fontFamily:"Raleway"
                    ),
                  ),
                ],
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    ' we can promote it on',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        fontFamily:"Raleway"
                    ),
                  ),
                ],
              ),

              SizedBox(height: 35),


            Container(
              alignment: Alignment.center,
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
                  Text(''+"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
                      ,textAlign: TextAlign.justify)
                ],
              ),
            ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    height: 43,
                    width: width/3.5,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
                    child: FloatingActionButton.extended(
                      label: Text('Back',style: TextStyle(color: Colors.deepPurple,fontFamily: 'Raleway'),
                      ),
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

                  SizedBox(width: width/3.7),

                  Container(
                      height: 43,
                      width: width/3.5,
                      child:FloatingActionButton.extended(
                        label: Text('I agree',
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.white,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        backgroundColor: Colors.deepPurple,
                        heroTag: "agree",
                        onPressed: (){
                         /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FoundedItemsList()
                            ),

                          );*/
                        },
                      )
                  )
                ],
              )

            ],

          ),
        ),
        onWillPop: () {
          Navigator.of(context).pop();
        }
    );
  }



}