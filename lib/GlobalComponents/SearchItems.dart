import 'package:flutter/material.dart';


class SearchItems extends SearchDelegate<SearchItems> {

  List articles = new List();
  int index;
  String _filterValue;


  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => "Item name or town";

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return ThemeData(
      primaryColor: Colors.white,
      textTheme: TextTheme(
        body1: TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.black,
          fontSize: 17,
          fontFamily: 'Raleway',
          fontStyle: FontStyle.italic
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [

    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return  null;
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Scaffold(
      body: ListView(
        children: <Widget>[
          new  Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 80),
                Text("Aucun resultats",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                        fontFamily: 'Raleway'
                    )
                ),

                SizedBox(height: 40),

                Center(
                  child: Image.asset('assets/images/error_loupe.png',fit: BoxFit.contain),
                ),

                SizedBox(height: 40),

                Container(
                  margin: EdgeInsets.only(left: 30,right: 30),
                  child: Text("Rien n'a été trouvé "+"'$query'",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          fontFamily: 'Raleway'
                      )
                  ),
                ),

                SizedBox(height: 80),

              ],
            ),
          )
        ],
      ),

      floatingActionButton:
      new Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Color(0xffdcdcdc))),
          padding: EdgeInsets.only(left: 20.0, right: 7.0),
          child: DropdownButtonHideUnderline(
            child: new DropdownButton<String>(
                iconEnabledColor: Color(0xffdcdcdc),
                iconSize: 40,
                style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black,fontFamily: 'Raleway'),
                hint:  _filterValue == null ?
                Text(_filterValue = "Lost Items")
                    :
                Text(_filterValue),
                onChanged: (String changedValue) {
                  _filterValue = changedValue;
                  print(_filterValue);
                /*setState(() {
                  _townName;
                });*/
                },
                value: _filterValue,
                items: <String>['Lost Items','Found Items']
                    .map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList()),
          )
      ),
    );


  }
}