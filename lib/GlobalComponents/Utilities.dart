import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localstorage/localstorage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:async/async.dart';


final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
final FirebaseAuth auth = FirebaseAuth.instance;
final facebookLogin = FacebookLogin();
final LocalStorage seen = LocalStorage('seen');
final LocalStorage phoneNumberStorage =  LocalStorage('userphone');
final LocalStorage userStorage =  LocalStorage('userId');
final LocalStorage isToPostStorage =  LocalStorage('isTopost');
final String ORANGE_MONEY = '+237 656 801 839';


  bool checkIfFirstSeen(index){
    if(seen.getItem('seen$index').runtimeType == Null){
      seen.setItem('seen$index','true');
      return false;
    }else{
      return true;
    }
  }

  bool isLoggedIn(){
    if(userStorage.getItem('userId') != null){
      return true;
    }else{
      return false;
    }
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  noInternet(context,msg){

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              msg,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 17
              ),
              textAlign: TextAlign.center,
            ),
            contentPadding: EdgeInsets.all(7.0),
            backgroundColor: Colors.white,
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: Color(0xffdcdcdc)
                )
            ),
            children: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                      'OK',
                      style: TextStyle(
                          color: Colors.deepPurple
                      )
                  )
              ),
            ],
          );
        }
    );
  }

  verifyImageSource(image){

      if(image.runtimeType == String) return true;
        else return false;
  }

  photoView(context,image){

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Scaffold(
          body: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: PhotoView(
              imageProvider: verifyImageSource(image)? CachedNetworkImageProvider(image):FileImage(image),
              loadingChild: SpinKitWave(color: Colors.deepPurple,size: 50),
            ),
          ),
          backgroundColor: Colors.black,
        );
      },
    );
  }