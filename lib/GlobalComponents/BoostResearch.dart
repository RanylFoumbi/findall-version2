import 'package:findall/GlobalComponents/Utilities.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _messageController = TextEditingController();

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

              SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    iconSize: 40,
                    icon: Icon(FontAwesomeIcons.facebookSquare,
                      color: Color(0xff3b5998) ,
                      size: 55,
                    ),
                    onPressed: null,
                  ),

                  SizedBox(width: 8),

                  IconButton(
                    iconSize: 40,
                    icon: Icon(FontAwesomeIcons.instagram,
                      color: Color(0xffC13584) ,
                      size: 55,
                    ),
                    onPressed: null,
                  ),

                  SizedBox(width: 8),

                  IconButton(
                    iconSize: 40,
                    icon: Icon(FontAwesomeIcons.twitterSquare,
                      color: Color(0xff00acee) ,
                      size: 55,
                    ),
                    onPressed: null,
                  ),
                ],
              ),

              SizedBox(height: 45),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                   IconButton(
                        color: Colors.white,
                        iconSize: 40,
                        icon: Icon(Icons.call,
                          color: Colors.deepPurple,
                          size: 50,
                        ),
                        onPressed: (){
                          UrlLauncher.launch('tel:'+ OUR_CONTACT);
                        }
                    ),

                   IconButton(
                        color: Colors.white,
                        iconSize: 40,
                        icon: Icon(FontAwesomeIcons.sms,
                          color: Colors.deepPurple,
                          size: 50,
                        ),
                        onPressed: (){
                          UrlLauncher.launch('sms:'+ OUR_CONTACT);
                        }
                    ),

                ],
              ),

              SizedBox(height: 4),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Call us',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,fontFamily: "Raleway")
                  ),

                  Text('Write us',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,fontFamily: "Raleway")
                  )
                ]
              ),

              SizedBox(height: 25),

              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('OR',style: TextStyle(fontSize: 23,fontWeight: FontWeight.w700,fontFamily: "Raleway")
                    ),
                  ]
              ),

            SizedBox(height: 45),

            Builder(
                builder: (context)=>Form(
                    key: _formKey,
                    autovalidate: false,
                    child: Column(

                      children: <Widget>[

                        new Container(
                            width: width/1.15,
                            height: height/14,
                            padding: EdgeInsets.only(left: 15.0, right: 15),
                            child:TextFormField(
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Name",
                                  hintStyle: TextStyle(
                                      fontSize: 13.0,
                                      fontFamily: 'Raleway'
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color(0xffdcdcdc)),
                                      borderRadius: BorderRadius.circular(10.0)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: Icon(
                                    FontAwesomeIcons.user,
                                    color: Color(0xfff4f4f4),
                                  ),
                                ),
                              )
                        ),

                        SizedBox(height: 15),

                        new Container(
                          width: width/1.15,
                          height: height/14,
                          padding: EdgeInsets.only(left: 15.0, right: 15),
                          child:TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Email**",
                                hintStyle: TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: 'Raleway'
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xffdcdcdc)),
                                    borderRadius: BorderRadius.circular(10.0)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Color(0xfff4f4f4),
                                ),
                              ),
                            validator: (String value){
                              RegExp emailValid = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                              if(emailValid.hasMatch(value) == true){
                                return null;
                              } else if(value.isEmpty ){
                                return "This field can not be empty";
                              }else{
                                return "Must be an email address";
                              }
                            },
                            )
                        ),

                        SizedBox(height: 15),

                        new Container(
                          width: width/1.15,
                          padding: EdgeInsets.only(left: 15.0, right: 15),
                          child:TextFormField(
                            controller: _messageController,
                            keyboardType: TextInputType.multiline,
                            autocorrect: true,
                            autofocus: false,
                            maxLines: 15,
                            validator: (String value){
                              if(value.isEmpty ){
                                return "This field can not be empty";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                hintText: "Your message...**",
                                hintStyle: TextStyle(fontSize: 13,fontFamily: 'Raleway'),
                                alignLabelWithHint: true,
                                contentPadding: EdgeInsets.only(top: 10,right: 3, left: 10, bottom: 2),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),borderSide: BorderSide(color: Color(0xffdcdcdc),))
                            ),
                          )
                        ),

                        SizedBox(height: 25),

                        new Container(
                            width: width/1.15,
                            height: height/14,
                            padding: EdgeInsets.only(left: 15.0, right: 15),
                            child: FloatingActionButton.extended(
                                label: Text('Get a personal quick search',style: TextStyle(fontFamily: 'Raleway',fontWeight: FontWeight.bold),
                                  ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                backgroundColor: Colors.pink,
                                heroTag: "quicksearck"+widget.index.toString(),
                                onPressed: () {},
                            )
                          )
                      ],
                    )
                )
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