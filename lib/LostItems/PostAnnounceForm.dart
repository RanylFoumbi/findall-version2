
import 'package:findall/FoundItems/FoundedItemsList.dart';
import 'package:findall/Home/HomePage.dart';
import 'package:findall/LostItems/LostItemsList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class PostAnnounceForm extends StatefulWidget {

  @override
  PostAnnounceFormState createState() => PostAnnounceFormState();
}

class PostAnnounceFormState extends State<PostAnnounceForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _otherObjectController = TextEditingController();
  var _otherTownController = TextEditingController();
  var _quarterController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _phoneController = TextEditingController();
  var _dateController = TextEditingController();
  bool _isLoadingImg = false;
  bool _isLoading = false;
  List _imageList = [];
  String _objectName;
  String _townName;
  var _image;

  int _selectedIndex = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget displayImage(){
    var rowImage = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[

      ],
    );
    if(_imageList.length == 0){
      return Text("Uploads images of the object.",style: TextStyle(color: Colors.black));
    }
    else{
      for(var i=0; i<_imageList.length; i++){
        _imageList==null
            ?
        rowImage
            :
        rowImage.children.add(
            Image.file(
                _imageList[i],
                width: 60,
                height: 80,
                fit: BoxFit.cover
            )
        );
      }

    }
    return Row(children: <Widget>[rowImage],mainAxisAlignment: MainAxisAlignment.spaceEvenly,);
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

      case 4: {

      }
      break;
    }

  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // TODO: implement build

    final dateTitle =  new Container(
        width: width/1.15,
        padding: EdgeInsets.only(left: 6.5,right: 6.5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text("Tap the input to select a date",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                ),
                textAlign: TextAlign.left,
              ),
            )
          ],
        )
    );

    final datePicker = new Container(
      width: width/1.2,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Color(0xffdcdcdc))),
      padding: EdgeInsets.only(left: 7.0, right: 7.0),
      child: DateTimeField(
        controller: _dateController,
        textAlign: TextAlign.center,
        decoration: InputDecoration(enabledBorder: null,border: null),
        format: DateFormat("EEEE d, MMMM  yyyy 'at' h:mma"),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(2014),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
        initialValue: DateTime.now(),
        onChanged:(currentTime){},
      ),
    );

    final objectTitle =  new Container(
        width: width/1.15,
        padding: EdgeInsets.only(left: 6.5,right: 6.5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text("Quel objet avez-vous trouvé? S'il vous plaît choisissez l'option 'Autre...' si l'object ne figure pas.",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                ),
                textAlign: TextAlign.left,
              ),
            )
          ],
        )
    );

    final objectNames =  new Container(
        width: width/1.2,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Color(0xffdcdcdc))),
        padding: EdgeInsets.only(left: 25.0, right: 7.0),
        child: DropdownButtonHideUnderline(
          child: new DropdownButton<String>(
              iconEnabledColor: Color(0xffdcdcdc),
              iconSize: 40,
              style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),
              hint:  _objectName == null ?
              Text(_objectName = "Carte national d'identité")
                  :
              Text(_objectName),
              onChanged: (String changedValue) {
                _objectName = changedValue;
                setState(() {
                  _objectName;
                });
              },
              value: _objectName,
              items: <String>[ 'Actes de naissance',"Carte national d'identité", 'Dilplômes', 'Passe port','Relevé de note','Téléphone portable','Autre...' ]
                  .map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList()),
        )
    );


    final otherObject = TextFormField(
      controller: _otherObjectController,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: "Autre type d'objet",
        hintStyle: TextStyle(fontSize: 13,fontStyle: FontStyle.italic),
        prefixIcon: Icon(
            Icons.devices_other,
            color: Color(0xffdcd3d3)
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color(0xffdcdcdc)
            ),
            borderRadius: BorderRadius.circular(10.0)
        ),
      ),
    );


    final townTitle =  new Container(
        width: width/1.15,
        padding: EdgeInsets.only(left: 6.5,right: 6.5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text("Où? S'il vous plaît choisissez l'option 'Autre...' si la ville ne figure pas.",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                ),
                textAlign: TextAlign.left,
              ),
            )
          ],
        )
    );

    final town = new Container(
        width: width/1.2,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Color(0xffdcdcdc))),
        padding: EdgeInsets.only(left: 25.0, right: 7.0),
        child: DropdownButtonHideUnderline(
          child: new DropdownButton<String>(
              iconEnabledColor: Color(0xffdcdcdc),
              iconSize: 40,
              style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),
              hint:  _townName == null ?
              Text(_townName = "Yaoundé")
                  :
              Text(_townName),
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
                  child: new Text(value),
                );
              }).toList()),
        )
    );

    final otherTown = TextFormField(
      controller: _otherTownController,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Autre ville**',
        hintStyle: TextStyle(fontSize: 13,fontStyle: FontStyle.italic),
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
    );

    final quarter = TextFormField(
      controller: _quarterController,
      keyboardType: TextInputType.text,
      autofocus: false,
      validator: (String value){
        if(value.isEmpty ){
          return "Ce champ ne peut pas être vide";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          hintText: 'Dans quel quartier? **',
          hintStyle: TextStyle(fontSize: 13,fontStyle: FontStyle.italic),
          prefixIcon: Icon(Icons.home,color: Color(0xffdcdcdc)),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),borderSide: BorderSide(color: Color(0xffdcdcdc),))
      ),
    );

    final description = TextFormField(
      controller: _descriptionController,
      keyboardType: TextInputType.multiline,
      autocorrect: true,
      maxLines: 5,
      autofocus: false,
      validator: (String value){
        if(value.isEmpty ){
          return "Ce champ ne peut pas être vide";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          hintText: "Entrez une petite description de l'objet ...**",
          hintStyle: TextStyle(fontSize: 13,fontStyle: FontStyle.italic),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.only(top: 10,right: 3, left: 10, bottom: 2),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),borderSide: BorderSide(color: Color(0xffdcdcdc),))
      ),
    );

    final phoneTitle =  new Container(
        width: width/1.15,
        padding: EdgeInsets.only(left: 6.5,right: 6.5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text("Leave your phone number so that we contact you if we found your object.",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                ),
                textAlign: TextAlign.left,
              ),
            )
          ],
        )
    );

    final phone =  TextFormField(
     controller: _phoneController,
     keyboardType: TextInputType.phone,
     decoration: InputDecoration(
       filled: true,
       fillColor: Colors.white,
       hintText: "phone Number",
       hintStyle: TextStyle(
         fontSize: 16.0,
       ),
       enabledBorder: OutlineInputBorder(
           borderSide: const BorderSide(color: Color(0xffdcdcdc)),
           borderRadius: BorderRadius.circular(10.0)),
       border: OutlineInputBorder(
         borderRadius: BorderRadius.circular(10.0),
       ),
       prefixIcon: Icon(
         Icons.phone,
         color: Color(0xfff4f4f4),
       ),
     ),
     validator: (String value) {
       if(value.isEmpty) {
         return "Entrer un numéro de téléphone";
       }
       else if(value.length <= 4) {
         return "Entrer un numéro de téléphone valide";
       }
     },
   );

    final camera = Card(
      child: Row(
        children: <Widget>[
          SizedBox(height: 110, width: 0),
          _isLoading ?
          Text("butoi",style: TextStyle(color: Colors.white))
              :
          _imageList.length < 4 ?
          IconButton(icon: Icon(Icons.file_upload, color: Colors.pink,size: 30), onPressed: (){
//            Dialog(context);
          })
              :
          Text("butoi",style: TextStyle(color: Colors.white)),

          displayImage(),
        ],
      ),

    );

    final postAnnounceButton = !_isLoading
        ?
    FloatingActionButton.extended(
      icon: Icon(Icons.public),
      label: Text('POST ANNOUNCEMENT'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      backgroundColor: Colors.pink,
      heroTag: "post",
      onPressed: () {

        },
    )
        :
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SpinKitWave(color: Colors.deepPurple,size: 30),
      ],
    );

    return WillPopScope(
        child: Scaffold(
          appBar: null,
          body: Column(
            children: <Widget>[

              SizedBox(height: 50),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 5),
                  Text('Post Announcement',textAlign: TextAlign.center,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600)),
                ],
              ),


              Expanded(
                child: Builder(
                    builder: (context) =>Form(
                      key: _formKey,
                      autovalidate: false,
                      child: ListView(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.only(left: 15,right: 15),
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      dateTitle,
                      SizedBox(height: 10.0),
                      datePicker,
                      SizedBox(height: 20.0),
                      objectTitle,
                      SizedBox(height: 10.0),
                      objectNames,
                      _objectName == 'Autre...'
                          ?
                      SizedBox(height: 10.0)
                          :
                      SizedBox(height: 0.0),
                      _objectName == 'Autre...'
                          ?
                      otherObject
                          :
                      SizedBox(height: 0.0),
                      SizedBox(height: 15.0),
                      townTitle,
                      SizedBox(height: 10.0),
                      town,
                      _townName == 'Autre...'
                          ?
                      SizedBox(height: 10.0)
                          :
                      SizedBox(height: 0.0),
                      _townName == 'Autre...'
                          ?
                      otherTown
                          :
                      SizedBox(height: 0.0),
                      SizedBox(height: 10.0),
                      quarter,
                      SizedBox(height: 10.0),
                      description,
                      SizedBox(height: 10.0),
                      camera,
                      SizedBox(height: 10.0),
                      phoneTitle,
                      SizedBox(height: 10.0),
                      phone,
                      SizedBox(height: 15.0),
                      _imageList.length != 0
                          ?
                      Text('Veuillez remplir le formulaire en entier.',textAlign: TextAlign.center,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),)
                          :
                      postAnnounceButton,
                      SizedBox(height: 25.0),

                    ],
                  )
                  ),
                )
              )

            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: false,
            showSelectedLabels: true,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.view_list),
                title: Text('Found items'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance),
                title: Text('Lost items'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.public),
                title: Text('Post annou..'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('My account'),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.black54,
            onTap: onItemTapped,
          ),
        ),
        onWillPop: null
    );
  }

}