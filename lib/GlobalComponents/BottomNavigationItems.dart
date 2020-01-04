
import 'package:flutter/material.dart';



  List<BottomNavigationBarItem> bottomNavigationItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home',style: TextStyle(fontFamily: 'Raleway')),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.view_list),
        title: Text('Found',style: TextStyle(fontFamily: 'Raleway')),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_balance),
        title: Text('Lost',style: TextStyle(fontFamily: 'Raleway')),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_outline),
        title: Text('Added',style: TextStyle(fontFamily: 'Raleway')),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        title: Text('Search',style: TextStyle(fontFamily: 'Raleway')),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        title: Text('Account',style: TextStyle(fontFamily: 'Raleway')),
      ),
    ];
  }