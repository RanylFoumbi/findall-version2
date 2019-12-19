import 'package:findall/Components/FoundItems/FoundedItemsList.dart';
import 'package:flutter/material.dart';


class Popup extends StatefulWidget {

  @override
  _PopupState createState() => _PopupState();
}

class _PopupState extends State<Popup> {

  var _othertownController = TextEditingController();
  String _townName;
  String _dayLeft;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SimpleDialog(
        backgroundColor: Colors.white,
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Color(0xffdcdcdc))),
        contentPadding: EdgeInsets.only(left: 25,top: 25,right: 15,bottom: 25),
        children: <Widget>[

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Where?',textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.w600,fontFamily: 'Raleway')),

            SizedBox(height: 2),
            
            new Container(
                width: 230,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Color(0xffdcdcdc))),
                padding: EdgeInsets.only(left: 15.0, right: 7.0),
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton<String>(
                      iconEnabledColor: Color(0xffdcdcdc),
                      iconSize: 40,
                      style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black,fontFamily: 'Raleway'),
                      hint:  _townName == null ?
                      Text(_townName = "Yaoundé",
                        style: TextStyle(
                            fontFamily: 'Raleway'
                        ),
                      )
                          :
                      Text(_townName,
                        style: TextStyle(
                            fontFamily: 'Raleway'
                        ),
                      ),
                      onChanged: (String changedValue) {
                        _townName = changedValue;
                        setState(() {
                          _townName;
                        });
                      },
                      value: _townName,
                      items: <String>['Bafoussam','Bamenda', 'Bertoua', 'Buéa', 'Douala','Ebolowa', 'Garoua', 'Maroua', 'Ngaoundéré',"Yaoundé",'Autre...']
                          .map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value,
                            style: TextStyle(
                                fontFamily: 'Raleway'
                            ),
                          ),
                        );
                      }).toList()
                  ),
                )
            ),

            _townName == 'Autre...'
                ?
            SizedBox(height: 15.0)
                :
            SizedBox(height: 0.0),

            _townName == 'Autre...'
                ?
            new Container(
                width: 230,
                child: TextFormField(
                  controller: _othertownController,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Autre ville**',
                    hintStyle: TextStyle(fontSize: 13,fontStyle: FontStyle.italic,
                          fontFamily: 'Raleway'
                    ),
                    prefixIcon: Icon(
                        Icons.location_city,
                        color: Color(0xffdcd3d3)
                    ),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xffdcdcdc)),
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                  ),
                )
            )

                :
            SizedBox(height: 0.0),

            SizedBox(height: 15),

            Text('When?',textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.w600,fontFamily: 'Raleway')),

            SizedBox(height: 2),

            new Container(
                width: 230,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Color(0xffdcdcdc))),
                padding: EdgeInsets.only(left: 15.0, right: 7.0),
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton<String>(
                      iconEnabledColor: Color(0xffdcdcdc),
                      iconSize: 40,
                      style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),
                      hint:  _dayLeft == null ?
                      Text(_dayLeft = "more than 3 days",
                        style: TextStyle(
                            fontFamily: 'Raleway'
                        ),
                      )
                          :
                      Text(_dayLeft,
                        style: TextStyle(
                            fontFamily: 'Raleway'
                        ),
                      ),
                      onChanged: (String changedValue) {
                        _dayLeft = changedValue;
                        setState(() {
                          _dayLeft;
                        });
                      },
                      value: _dayLeft,
                      items: <String>["less than 3 days", "more than 3 days"]
                          .map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value,
                            style: TextStyle(
                                fontFamily: 'Raleway'
                            ),
                          ),
                        );
                      }).toList()
                  ),
                )
            ),

            SizedBox(height: 15),

            Row(
              children: <Widget>[

                SizedBox(width: 20),

                Container(
                  height: 40,
                  width: 85,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.pink),
                  child: FloatingActionButton.extended(
                    label: Text('Cancel',style: TextStyle(color: Colors.pink,fontFamily: 'Raleway'),),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    backgroundColor: Colors.white,
                    heroTag: "cancel",
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ),

                SizedBox(width: 25),

                Container(
                    height: 40,
                    width: 85,
                    child:FloatingActionButton.extended(
                      label: Text('Next',
                        style: TextStyle(
                          fontFamily: 'Raleway'
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      backgroundColor: Colors.deepPurple,
                      heroTag: "next",
                      onPressed: (){
                        Navigator.push(
                          context,
                            MaterialPageRoute(
                                builder: (context) => FoundedItemsList()
                            ),

                        );
                      },
                    )
                )
              ],
            )

          ],
        )
      ],
    );
  }


}