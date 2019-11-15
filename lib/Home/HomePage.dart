import 'package:findall/LostItems/Popup.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:findall/FoundItems/FoundedItemsList.dart';


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
            title: Text("Voulez-vous vraiment quitter findall?",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),),
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
                      child: Text('NON',style: TextStyle(color: Colors.deepPurple))
                  ),

                  FlatButton(
                      onPressed: (){
                        exit(0);
                      },
                      child: Text('OUI',style: TextStyle(color: Colors.deepPurple))
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
              margin: EdgeInsets.only(),
              child: RotatedBox(
                quarterTurns: 0,
                child: new Image.asset(
                  'assets/images/loupe_final.png',
                  width: width,
                  fit: BoxFit.fill,
                ),
              )
          ),

          Container(
            margin: EdgeInsets.only(top: height/5.8, left: width/5.9),
            child: new Image.asset(
              'assets/images/verre.png',
              height: height/2.9,
              width: width/1.5,
              fit: BoxFit.fill,
            ),
          ),

         Positioned.fill(
           top: height/1.8,
            child:  Align(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      'No more anxiety or',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 33,
                          fontFamily:"Raleway"
                      ),
                    ),
                  ),


                  Flexible(
                    child: Text(
                      'frustration!',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 33,
                          fontFamily:"Raleway"
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Flexible(
                    child: Text(
                      'We help you recover your lost items',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                          fontFamily:"Raleway"
                      ),
                    ),
                  ),

                  Flexible(
                    child: Text(
                      ' or documents',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                          fontFamily:"Raleway"
                      ),
                    ),
                  ),

                  SizedBox(height: 30),
                  FloatingActionButton.extended(
                    icon: Icon(Icons.view_list),
                    label: Text('JUST LOST AN ITEM?',
                      style: TextStyle(
                          fontFamily:"Raleway"
                      ),
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
                  SizedBox(height: 20),
                  FloatingActionButton.extended(
                    icon: Icon(Icons.add),
                    label: Text('JUST FOUND AN ITEM?',
                      style: TextStyle(
                          fontFamily:"Raleway"
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    backgroundColor: Colors.deepPurple,
                    heroTag: "new found button",
                    onPressed: null,
                  ),
                ],
              ),
            ),
    ),
          Container(
            margin: EdgeInsets.only(
              left: width/2.5,
              top: height/1.02,
            ),
            child: new Text('CopyRight@ranolf2019',
                style: new TextStyle(
                    fontSize: 9.0,
                    color: Colors.black,
                    fontFamily:"Raleway"
                )
            ),
          ),
          SizedBox(height: 2),
        ],
      ),
      onWillPop: (){
        _close(context);
      },
    );
  }
}

