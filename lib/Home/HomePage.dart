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
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[

          SizedBox(height: height/1.9),

          Center(
            child: Column(
              children: <Widget>[
                Container(
                  height: height/20,
                  width: width,
                  padding: EdgeInsets.only(left: 50,right: 0),
                  child: Text(
                    'No more anxiety or frustration!',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 23,
                        fontFamily: 'Robotto'
                    ),
                  ),
                ),

                Container(
                  height: height/13,
                  width: width,
                  padding: EdgeInsets.only(left: 70,right: 40),
                  child: Text(
                    'We help you recover your lost items or documents',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 23,
                        fontFamily: 'Robotto'
                    ),
                  ),
                ),
                SizedBox(height: 25),
                FloatingActionButton.extended(
                  icon: Icon(Icons.view_list),
                  label: Text('JUST LOST AN ITEM?'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  backgroundColor: Colors.pink,
                  heroTag: "See lost objects button",
                  onPressed: (){
                    searchPopup(context);
                  },
                ),
                SizedBox(height: 25),
                FloatingActionButton.extended(
                  icon: Icon(Icons.add),
                  label: Text('JUST FOUND AN ITEM?'),
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
          SizedBox(height: height/15),
          Center(
            child: new Text('CopyRight@ranolf2019',
                style: new TextStyle(
                    fontSize: 9.0,
                    color: Colors.black
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

