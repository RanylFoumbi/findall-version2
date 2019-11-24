import 'package:findall/LostItems/PostAnnounceForm.dart';
import 'package:findall/Authentication/SmsLoginPage.dart';
import 'package:findall/FoundItems/FoundedItemsList.dart';
import 'package:findall/GlobalComponents/BottomNavigationItems.dart';
import 'package:findall/GlobalComponents/SearchItems.dart';
import 'package:findall/Home/HomePage.dart';
import 'package:findall/LostItems/LostItemsList.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class AuthPage extends StatefulWidget{


  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  int _selectedIndex = 5;

  onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch(_selectedIndex) {
      case 0: {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage()
          ),
        );
      }
      break;

      case 1: {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FoundedItemsList()
          ),
        );
      }
      break;

      case 2: {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LostItemsList()
          ),
        );
      }
      break;


      case 3: {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostAnnounceForm()
          ),
        );
      }
      break;

      case 4: {
        showSearch(
            context: context,
            delegate: SearchItems(),
            query: ''
        );
      }
      break;

      case 5:{
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AuthPage()
          ),
        );
      }
      break;
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
        child: Scaffold(
          body: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(top: height/5,bottom: 25),
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Image.asset("assets/images/logo_findall.png", height: 110, width: 110),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    ' Register to receive update about ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
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
                    'your messing item',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        fontFamily:"Raleway"
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    width: width/1.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green),
                        color: Colors.green,
                      ),
                      child: FloatingActionButton.extended(
                        heroTag: "phone",
                        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.green)),
                        backgroundColor: Colors.green,
                          icon: Icon(Icons.phone,color: Colors.white,size: 18),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder:
                                      (context) => SMSLoginPage()
                              ),
                            );
                          },
                          label: Text("With phone",style: TextStyle(color: Colors.white,fontFamily: "Raleway"),
                          )
                      )
                   ),
                  SizedBox(height: 10),


                  Container(
                    width: width/1.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffea4335),
                    ),
                    child:FloatingActionButton.extended(
                          backgroundColor: Color(0xffea4335),
                          heroTag: "google",
                          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Color(0xffea4335))),
                          icon: Icon(FontAwesomeIcons.google,color: Colors.white,size: 18),
                          onPressed: null,
                          label: Text("With Google",style: TextStyle(color: Colors.white,fontFamily: "Raleway"),)
                        )
                  ),

                  SizedBox(height: 10),

                  Container(
                    width: width/1.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xff3b5998)),
                      color: Color(0xff3b5998),
                    ),
                    child:FloatingActionButton.extended(
                          backgroundColor: Color(0xff3b5998),
                          heroTag: "facebook",
                          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Color(0xff3b5998))),
                          icon: Icon(FontAwesomeIcons.facebookF,color: Colors.white,size: 18),
                          onPressed: null,
                          label: Text("With Facebook",style: TextStyle(color: Colors.white,fontFamily: "Raleway"),)
                    )
                  ),

                ],
              ),

              SizedBox(height: 45),


            ],

          ),
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: false,
            showSelectedLabels: true,
            items: bottomNavigationItems(),
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.black54,
            onTap: onItemTapped,
          ),
        ),
        onWillPop: () {
          Navigator.of(context).pop();
        }
    );
  }



}