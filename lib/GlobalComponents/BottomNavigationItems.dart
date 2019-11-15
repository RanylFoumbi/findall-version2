
import 'package:flutter/material.dart';



  List<BottomNavigationBarItem> bottomNavigationItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home',style: TextStyle(fontFamily: 'Raleway')),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.view_list),
        title: Text('Found items',style: TextStyle(fontFamily: 'Raleway')),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_balance),
        title: Text('Lost items',style: TextStyle(fontFamily: 'Raleway')),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.public),
        title: Text('Post annou..',style: TextStyle(fontFamily: 'Raleway')),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        title: Text('Search',style: TextStyle(fontFamily: 'Raleway')),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        title: Text('My account',style: TextStyle(fontFamily: 'Raleway')),
      ),
    ];
  }