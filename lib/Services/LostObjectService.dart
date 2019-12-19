import 'package:findall/Components/LostItems/LostItemsList.dart';
import 'package:findall/GlobalComponents/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LostObjectService{

  void createLostObject(context, data)async{

    await db.collection("objectList").add({
      'objectName': data['objectName'],
      'town': data['town'],
      'quarter': data['quarter'],
      'date': data['date'],
      'description': data['description'],
      'contact': data['contact'],
      'rewardAmount': data['rewardAmount'],
      'images': data['images'],
      'userId': data['userId'],
      'isLost': true,
    }).then((documentReference) {

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LostItemsList()
        ),
      );

      print(documentReference.documentID);
    }).catchError((e) {
      print(e);
    });
  }

  List getLostObjectList(){

    return null;
  }

  void updateLostObject(data){

  }

  void deleteLostObject(data){

  }
}