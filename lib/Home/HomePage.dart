import 'package:findall/Components/FoundItems/NewFoundForm.dart';
import 'package:findall/Components/FoundItems/Popup.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:io';


class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Home(),
    );
  }
}



class Home extends StatelessWidget {

  _close(BuildContext context){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffd4d4d4)),borderRadius: BorderRadius.circular(10)),
            title: Text("Voulez-vous vraiment quitter findall?",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 12),),
            contentPadding: EdgeInsets.all(10.0),
            backgroundColor: Colors.white,
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text('Non',style: TextStyle(color: Colors.deepPurple))
                  ),

                  FlatButton(
                      onPressed: (){
                        exit(0);
                      },
                      child: Text('Oui',style: TextStyle(color: Colors.deepPurple))
                  )
                ],
              )
            ],
          );
        }
    );
  }

  Future searchPopup(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return Popup();
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      child: Stack(

        children: <Widget>[

          Container(
              child: RotatedBox(
                quarterTurns: 0,
                child: new Image.asset(
                  'assets/images/bar_loupe.png',
                  width: width,
                  fit: BoxFit.fill,
                ),
              )
          ),

          Container(
            margin: EdgeInsets.only(top: height/2.9,left: width/3.8),
            child: new Image.asset(
              'assets/images/logo_findall.png',
              height: height/6.5,
              fit: BoxFit.fill,
            ),
          ),


          Container(
            margin: EdgeInsets.only(top: height/4.2, left: width/5.9),
            child: new Image.asset(
              'assets/images/verre.png',
              height: height/2.7,
              width: width/1.5,
              fit: BoxFit.fill,
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: width/1.3,top: 50),
            child: FloatingActionButton.extended(
              label: Text('?',style: TextStyle(color: Colors.pink,fontSize: 35),textAlign: TextAlign.center,),
              backgroundColor: Colors.white,
              heroTag: "question",
              onPressed: (){
              },
            ),
          ),

         Positioned.fill(
           top: height/1.47,
            child:  Align(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[

                  Flexible(
                    child: Text(
                      'Nous vous aidons à retrouver vos objets ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                          fontFamily:"Raleway"
                      ),
                    ),
                  ),

                  const SizedBox(height: 2),
                  Flexible(
                    child: Text(
                      ' ou documents perdus',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                          fontFamily:"Raleway"
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Container(
                    width: width/1.7,
                    decoration: ShapeDecoration(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.pink),
                        gapPadding: 5
                     ),
                      color: Colors.pink,
                    ),
                    child: FloatingActionButton.extended(
                      icon: Icon(Icons.view_list,size: 18,),
                      label: AutoSizeText(
                        "As tu perdu un objet?",
                        style: TextStyle(fontFamily:"Raleway",fontSize: 11.5),
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      backgroundColor: Colors.pink,
                      heroTag: "See lost objects button",
                      onPressed: (){
                        searchPopup(context);
                      },
                    ),
                  ),
                  SizedBox(height: 17),
                  Container(
                      width: width/1.7,
                      decoration: ShapeDecoration(
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.deepPurple),
                          gapPadding: 5
                        ),
                        color: Colors.deepPurple,
                      ),
                      child:FloatingActionButton.extended(
                            icon: Icon(Icons.add,size: 18,),
                            label: AutoSizeText(
                              "As tu trouvé un objet?",
                              style: TextStyle(fontFamily:"Raleway",fontSize: 11.5),
                              minFontSize: 10,
                              maxFontSize: 14,
                              maxLines: 1,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            backgroundColor: Colors.deepPurple,
                            heroTag: "new found button",
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewFoundForm()
                                  ),
                               );
                            },
                          )
                  ),
                ],
              ),
            ),
    ),
          Container(
            alignment: Alignment.bottomCenter,
            child: new Text('CopyRight@ranolf2020',
                style: new TextStyle(
                    fontSize: 9.0,
                    color: Colors.black,
                    fontFamily:"Raleway"
                )
            ),
          ),
         const SizedBox(height: 2),
        ],
      ),
      onWillPop: (){
        _close(context);
      },
    );
  }
}

