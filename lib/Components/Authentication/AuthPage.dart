import 'package:findall/Components/Authentication/ProfilePage.dart';
import 'package:findall/Components/Authentication/SmsLoginPage.dart';
import 'package:findall/GlobalComponents/Utilities.dart';
import 'package:findall/Components/LostItems/MyObjects.dart';
import 'package:findall/Components/FoundItems/FoundedItemsList.dart';
import 'package:findall/GlobalComponents/BottomNavigationItems.dart';
import 'package:findall/GlobalComponents/SearchItems.dart';
import 'package:findall/Home/HomePage.dart';
import 'package:findall/Components/LostItems/LostItemsList.dart';
import 'package:findall/Services/LostObjectService.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';



class AuthPage extends StatefulWidget{


  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  int _selectedIndex = 5;


  Future<FirebaseUser> _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult _auth = await auth.signInWithCredential(credential);
    return _auth.user;
  }

  Future<FirebaseUser> _signInWithFacebook() async {
    final result = await facebookLogin.logIn(['email', 'public_profile']);
    if (result.status == FacebookLoginStatus.loggedIn) {
      final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token);
      final AuthResult _auth = await auth.signInWithCredential(credential);
      return _auth.user;
    }
  }

  _redirect(user,authType){
    /*if the previous screen was not a form to be submit,rediret to the profile page,
    * else redirect to the lostobjectList page or to the foundObjectList page*/
    isToPostStorage.ready.then((_) {
      if (isToPostStorage.getItem('isTopost') == null) {
       if(user != null){
         Navigator.push(
           context,
           MaterialPageRoute(
               builder:
                   (context) => ProfilePage(
                 userId: user.providerData[0].uid,
                 email: authType == 'Google' ? user.providerData[0].email : null,
                 phoneNumber: null,
                 profileImg: user.providerData[0].photoUrl,
                 username: user.providerData[0].displayName,
                 isPhoneAuth: false,
               )
           ),
         );
       }else{

         noInternet(context, "Veillez verifier votre connexion internet puis reessayer");
       }
      }else{


      }
    });
  }

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
              builder: (context) => MyObjects()
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
        userStorage.ready.then((_){

            if(isLoggedIn() != true){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AuthPage()
                  ),
                );
            }else{
              var userId = userStorage.getItem('userId');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        userId: userId,
                    ),
                  )
                );
            }
          });

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
                    'your missing item',
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
                            label: Text("With Google",style: TextStyle(color: Colors.white,fontFamily: "Raleway"),
                          ),
                          onPressed: ()async{
                            _signInWithGoogle().then((user){
                              print(user.providerData);
                              userStorage.setItem('userId', user.providerData[0].uid);
                              saveUser(user);
                              _redirect(user,'Google');
                            }).catchError((err){
                              noInternet(context, "Veillez verifier votre connexion internet puis reessayer");
                              print(err);
                            });

                          },
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
                          label: Text("With Facebook",style: TextStyle(color: Colors.white,fontFamily: "Raleway"),
                          ),
                          onPressed: ()async{
                              _signInWithFacebook().then((FirebaseUser user) {
                                      userStorage.setItem('userId', user.providerData[0].uid);
                                       saveUser(user);
                                      _redirect(user,'Facebook');
                              }).catchError((err){
                                print(err);
                              });

                          },
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