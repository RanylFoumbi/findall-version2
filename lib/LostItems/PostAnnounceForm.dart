
import 'dart:io';
import 'dart:io';
import 'dart:io';
import 'dart:io';

import 'package:findall/LostItems/PreviewAnnouncePage.dart';
import 'package:findall/Authentication/AuthPage.dart';
import 'package:findall/FoundItems/FoundedItemsList.dart';
import 'package:findall/GlobalComponents/BottomNavigationItems.dart';
import 'package:findall/GlobalComponents/SearchItems.dart';
import 'package:findall/Home/HomePage.dart';
import 'package:findall/LostItems/LostItemsList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:toast/toast.dart';


class PostAnnounceForm extends StatefulWidget {

  @override
  _PostAnnounceFormState createState() => _PostAnnounceFormState();
}

class _PostAnnounceFormState extends State<PostAnnounceForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _otherObjectController = TextEditingController();
  var _otherTownController = TextEditingController();
  var _quarterController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _phoneController = TextEditingController();
  var _rewardController = TextEditingController();
  var _dateController = TextEditingController();
  bool _isLoadingImg = false;
  bool _isLoading = false;
  List _imageList = [];
  String _objectName;
  String _townName;
  String _currentcy;
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
  
  _onItemTapped(int index) {
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

  _getImage(context,index,option) async{
    var picture;
    Navigator.of(context).pop();
    setState(() {
      _isLoadingImg = true;
    });
    if(option == 'camera'){
      var photo = await ImagePicker.pickImage(source: ImageSource.camera);
      if(photo == null){
        Toast.show("Vous devez télécharger au moins une image avant de publier.", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }
       setState(() {
         picture = photo;
       });
    }
    else{
      var photo = await ImagePicker.pickImage(source: ImageSource.gallery);
      if(photo == null){
        Toast.show("Vous devez télécharger au moins une image avant de publier.", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }
      setState(() {
        picture = photo;
      });
    }

    if(_imageList.isEmpty){
      setState(() {
        _imageList.add(picture);
        _isLoadingImg = false;
      });
    }
    else {
       if(index < _imageList.length){
         setState(() {
           _imageList.add(new File('assets/images/map.png'));
           _imageList[index] = picture;
           _imageList.remove(new File('assets/images/map.png'));
         });
       }
       else{
         setState(() {
           _imageList.add(_imageList[index - 1]);
           _imageList[index] = picture;
         });
       }

    }

  }

  Future _dialog(BuildContext context,index) async {
    return  showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Importer la photo depuis',style: TextStyle(fontSize: 17)),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  _getImage(context,index,'gallerie');
                },
                child: const Text('la gallerie'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  _getImage(context,index,'camera');
                },
                child: const Text('la camera'),
              ),

            ],
          );
        });
  }
  
  _hello(){
    print('Wait a bit');
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
              child: Text("Click on the input to select a date",
                style: TextStyle(
                     fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily:"Raleway"
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
        style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 15
        ),
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
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily:"Raleway"
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
              style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black,fontFamily: 'Raleway',fontSize: 13),
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
        hintStyle: TextStyle(fontSize: 13,fontStyle: FontStyle.italic,fontFamily: 'Raleway'),
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
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily:"Raleway"
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
              style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black,fontFamily: 'Raleway'),
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
        hintStyle: TextStyle(fontSize: 13,fontStyle: FontStyle.italic,fontFamily: 'Raleway'),
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
          hintStyle: TextStyle(fontSize: 13,fontStyle: FontStyle.italic,fontFamily: 'Raleway'),
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
          hintStyle: TextStyle(fontSize: 13,fontStyle: FontStyle.italic,fontFamily: 'Raleway'),
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
              child: Text("Leave your phone number so that you could be contacted if someone finds your item.",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily:"Raleway"
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
         fontSize: 13.0,
           fontFamily: 'Raleway'
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

    final camera =  Card(
        color: Colors.white,
        child:Container(
          width: width/1.1,
          height: height/5.7,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.only(top: 15,bottom: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    width: width/4.2,
                    height: height/8,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all(color: Color(0xffdcdcdc))),
                    padding: EdgeInsets.all(2),
                    child:GestureDetector(
                      child: _imageList.length == 0? Icon(Icons.add_circle,size: 25,color: Colors.pink,)
                          :
                            Image.file(
                                _imageList[0],
                                width: width/4.5,
                                height: height/8,
                                fit: BoxFit.cover
                            ),
                      onTap: (){
                        _dialog(context,0);
                      },
                    )
                  ),

                  SizedBox(width: 22),

                  Container(
                      width: width/4.2,
                      height: height/8,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all(color: Color(0xffdcdcdc))),
                      padding: EdgeInsets.all(2),
                      child:GestureDetector(
                        child: _imageList.length < 2? Icon(Icons.add_circle,size: 25,color: Colors.pink,)
                            :
                            Image.file(
                                _imageList[1],
                                width: width/4.5,
                                height: height/8,
                                fit: BoxFit.cover
                            ),
                        onTap: (){
                          _dialog(context,1);
                        },
                      )
                  ),

                  SizedBox(width: 22),

                  Container(
                      width: width/4.2,
                      height: height/8,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all(color: Color(0xffdcdcdc))),
                      padding: EdgeInsets.all(2),
                      child:GestureDetector(
                        child: _imageList.length < 3? Icon(Icons.add_circle,size: 25,color: Colors.pink,)
                            :
                        Image.file(
                            _imageList[2],
                            width: width/4.5,
                            height: height/8,
                            fit: BoxFit.cover
                        ),
                        onTap: (){
                          _dialog(context,2);
                        },
                      )
                  )

                ],
              ),

            ],
          ),
      ),

    );

    final AmountTitle =  new Container(
        width: width/1.15,
        padding: EdgeInsets.only(left: 6.5,right: 6.5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text("Which amount can you give to someone who finds your item.",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily:"Raleway"
                ),
                textAlign: TextAlign.left,
              ),
            )
          ],
        )
    );

    final rewardAmount =  new Container(
        width: width/1.8,
        padding: EdgeInsets.only(left: 6.5,right: 6.5),
        child: TextFormField(
            controller: _rewardController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Amount",
              hintStyle: TextStyle(
                fontSize: 13.0,
                fontFamily: 'Raleway'
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffdcdcdc)),
                  borderRadius: BorderRadius.circular(10.0)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: Icon(
                Icons.attach_money,
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
          )
    );

    final currentcyList =  new Container(
        width: width/3,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Color(0xffdcdcdc))),
        padding: EdgeInsets.only(left: 25.0, right: 7.0),
        child: DropdownButtonHideUnderline(
          child: new DropdownButton<String>(
              iconEnabledColor: Color(0xffdcdcdc),
              iconSize: 40,
              style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black,fontFamily: 'Raleway'),
              hint:  _currentcy == null ?
              Text(_currentcy = "USD")
                  :
              Text(_currentcy,
                style: TextStyle(
                    fontFamily:"Raleway"
                ),
              ),
              onChanged: (String changedValue) {
                _currentcy = changedValue;
                setState(() {
                  _currentcy;
                });
              },
              value: _currentcy,
              items: <String>[ 'EUR',"USD", 'XAF']
                  .map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList()),
        )
    );

    final rewardData = Row(

      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        rewardAmount,
        currentcyList
      ],
    );

    final postAnnounceButton = !_isLoading
        ?
    FloatingActionButton.extended(
      icon: Icon(Icons.public),
      label: Text('POST ANNOUNCEMENT',style: TextStyle(fontFamily: 'Raleway'),),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      backgroundColor: Colors.pink,
      heroTag: "post",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewAnnounce(
                town: _townName == 'Autre...'?_otherTownController.text: _townName,
                date: _dateController.text,
                contact: _phoneController.text,
                objectName: _objectName == 'Autre...'?_otherObjectController.text: _objectName,
                quarter: _quarterController.text,
                description: _descriptionController.text,
                rewardAmount: _rewardController.text + ' '+ _currentcy,
                images: _imageList.length > 3 ? _imageList.take(3).toList() : _imageList,
              )
          ),
        );

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
                  Text('Post Announcement',textAlign: TextAlign.center,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700,fontFamily: 'Raleway')),
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
                          datePicker,
                          SizedBox(height: 10.0),
                          dateTitle,
                          SizedBox(height: 10.0),
                          objectNames,
                          SizedBox(height: 10.0),
                          objectTitle,
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

                          SizedBox(height: 10.0),
                          town,
                          SizedBox(height: 10.0),
                          townTitle,
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
                          phone,
                          SizedBox(height: 10.0),
                          phoneTitle,
                          SizedBox(height: 10.0),
                          rewardData,
                          SizedBox(height: 10.0),
                          AmountTitle,
                          SizedBox(height: 15.0),
                          _imageList.length == 0
                              ?
                          Text('Veuillez remplir le formulaire en entier.',textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,fontFamily: 'Raleway'),)
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
            items: bottomNavigationItems(),
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.black54,
            onTap: _onItemTapped,
          ),
        ),
        onWillPop: null
    );
  }

}