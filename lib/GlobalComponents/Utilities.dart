import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localstorage/localstorage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';


final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
final FirebaseAuth auth = FirebaseAuth.instance;
final db = Firestore.instance;
final facebookLogin = FacebookLogin();
final LocalStorage seen = LocalStorage('seen');
final LocalStorage phoneNumberStorage =  LocalStorage('userphone');
final LocalStorage userStorage =  LocalStorage('userId');
final LocalStorage isToPostStorage =  LocalStorage('isTopost');
final String ORANGE_MONEY = '+237 656 801 839';

  Future<FirebaseUser> getCurrentUser() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  bool checkIfFirstSeen(index){
    if(seen.getItem('seen$index').runtimeType == Null){
      seen.setItem('seen$index','true');
      return false;
    }else{
      return true;
    }
  }


  /*objectType either lost or found*/
  Future uploadImage(imageList,objectType) async{

    List uploadImages = [];

    for(var i=0; i<imageList.length; i++){
      var uuid = new Uuid();
      var id = uuid.v4();
      var url;
      if(imageList[i].runtimeType == String){
        uploadImages.add(imageList[i]);
      }else{
        StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(objectType).child("${id.toString()}.jpg");
        StorageUploadTask task = firebaseStorageRef.putFile(imageList[i]);
        var dowUrl = await (await task.onComplete).ref.getDownloadURL();
        url = dowUrl.toString();
        uploadImages.add(url);
      }

    }
    print(uploadImages);
    return uploadImages;
  }

  Future compressImage(imgList) async {
    var compressedImage;
    var compressedImageList = [];

     for(var i=0; i<imgList.length; i++){

       if(imgList[i].runtimeType == String){

        compressedImageList.add(imgList[i]);
       }
       else{
         compressedImage = await FlutterImageCompress.compressAndGetFile(
             imgList[i].path,
             imgList[i].path,
             quality: 75,
             minHeight: 650,
             minWidth: 650
         );
         compressedImageList.add(compressedImage);
       }
     }

    return compressedImageList;
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
              imageProvider: verifyImageSource(image)? NetworkImage(image):FileImage(image),
              loadingChild: SpinKitWave(color: Colors.deepPurple,size: 50),
            ),
          ),
          backgroundColor: Colors.black,
        );
      },
    );
  }

  Future loaderModal(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: Center( // Aligns the container to center
          child: SpinKitRing(
            color: Colors.white,
            lineWidth: 2.5,
            size: 45,
          ),
        ),
      ),
    );
  }