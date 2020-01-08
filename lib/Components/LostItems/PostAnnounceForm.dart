import 'dart:io';
import 'package:findall/Components/Authentication/ProfilePage.dart';
import 'package:findall/GlobalComponents/Utilities.dart';
import 'package:findall/Components/LostItems/PreviewAnnouncePage.dart';
import 'package:findall/Components/Authentication/AuthPage.dart';
import 'package:findall/Components/FoundItems/FoundedItemsList.dart';
import 'package:findall/GlobalComponents/BottomNavigationItems.dart';
import 'package:findall/GlobalComponents/SearchItems.dart';
import 'package:findall/Home/HomePage.dart';
import 'package:findall/Components/LostItems/LostItemsList.dart';
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
  var _dateController = TextEditingController();
  bool _isLoadingImg = false;
  bool _isLoading = false;
  List _imageList = [];
  String _objectName;
  String _townName;
  String _isRewarded;

  int _selectedIndex = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _phoneController.text = phoneNumberStorage.getItem('userphone');
    });
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
        userStorage.ready.then((_){

          if(!isLoggedIn()){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AuthPage()
              ),
            );
          }else{
            var userID = userStorage.getItem('userId');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    userId: userID,
                  ),
                )
            );
          }
        });
      }
      break;
    }

  }

  _removeImage(image){
    setState(() {
      _imageList.remove(image);
    });
  }

  Widget _buildImageListView() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return  ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _imageList.length + 1,
          itemBuilder: (BuildContext context, int index) {
              return new Padding(
                padding: EdgeInsets.only(left: 4,right: 2),
                child: index < _imageList.length ?
                          Container(
                              width: width/4.5,
                              height: height/8,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all(color: Color(0xffdcdcdc))),
                              padding: EdgeInsets.all(2),
                              child: Stack(
                                children: <Widget>[
                                  _imageList[index].runtimeType == String ?
                                      Image.network(
                                      _imageList[index],
                                          width: width/4.5,
                                          height: height/8,
                                          fit: BoxFit.cover
                                      )
                                    :
                                      Image.file(
                                      _imageList[index],
                                          width: width/4.5,
                                          height: height/8,
                                          fit: BoxFit.cover
                                      ),

                                  Positioned(
                                    right: 0.0,
                                    child: GestureDetector(
                                      onTap: (){
                                        _removeImage(_imageList[index]);
                                      },
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: CircleAvatar(
                                          radius: 8.5,
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.close, color: Colors.red, size: 10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          )

                        :
                          IconButton(
                            padding: EdgeInsets.all(3.5),
                            icon: Icon(Icons.add_circle,size: 40, color: _imageList.length == 3 ? Colors.white : Colors.pink),
                            onPressed:() {
                              _imageList.length == 3 ? null : _dialog(context);
                            },
                          ),
              );

          });

  }

  _getImage(context,option) async{
    var picture;
    Navigator.of(context).pop();
    setState(() {
      _isLoadingImg = true;
    });
    if(option == 'camera'){
      File photo = await ImagePicker.pickImage(source: ImageSource.camera);
      if(photo.lengthSync() == 0){
        Toast.show("Vous devez télécharger au moins une image avant de publier.", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }
      if(photo.runtimeType != Null){
        setState(() {
          picture = photo;
          _imageList.add(picture);
        });
      }else{

      }
    }
    else{
      File photo = await ImagePicker.pickImage(source: ImageSource.gallery);
      if(photo.lengthSync() == 0){
        Toast.show("Vous devez télécharger au moins une image avant de publier.", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }
      if(photo.runtimeType != Null){
        setState(() {
          picture = photo;
          _imageList.add(picture);
        });
      }else{

      }
    }
  }

  bool _isValidForm() {
    return _descriptionController.text.length > 0 &&
          _phoneController.text.length > 0 &&
          _dateController.text.length > 0;
   }

  _submit(){

    print(_imageList[0]);
    print(_imageList[0].runtimeType);

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
            rewardAmount: _isRewarded,
            images: _imageList,
          )
      ),
    );
  }

  _setImageIfNotSelected(objectName){

    switch (objectName) {
      case 'Document':
        {
          _imageList.add("https://firebasestorage.googleapis.com/v0/b/findall-11e21.appspot.com/o/staticImages%2Fdocument.png?alt=media&token=541369a6-ebce-407e-8584-95336b84be44");
        }
        break;

      case 'Ordinateur':
        {
          _imageList.add("https://firebasestorage.googleapis.com/v0/b/findall-11e21.appspot.com/o/staticImages%2Fordinateur.png?alt=media&token=34b5e44c-fc9e-4985-96da-5458ec9d9716");
        }
        break;

      case 'Porte-feuille':
        {
          _imageList.add("https://firebasestorage.googleapis.com/v0/b/findall-11e21.appspot.com/o/staticImages%2FArtboard%208%20copy%202.png?alt=media&token=53e56c40-0f77-4d74-9bcd-606ecce4ff9c");
        }
        break;

      case 'Sac à dos':
        {
          _imageList.add("https://firebasestorage.googleapis.com/v0/b/findall-11e21.appspot.com/o/staticImages%2FArtboard%208%20copy%202.png?alt=media&token=53e56c40-0f77-4d74-9bcd-606ecce4ff9c");
        }
        break;

      case 'Sac à main':
        {
          _imageList.add("https://firebasestorage.googleapis.com/v0/b/findall-11e21.appspot.com/o/staticImages%2Fsac%20a%20main.png?alt=media&token=c86e9540-8487-4c38-ad0a-9a30623162b1");
        }
        break;

      case 'Téléphone portable':
        {
          _imageList.add("https://firebasestorage.googleapis.com/v0/b/findall-11e21.appspot.com/o/staticImages%2Ftelephone.png?alt=media&token=ef2d7e0b-d388-494f-9560-89a1f2dbb13f");
        }
        break;

      case 'Autre...':
        {
          _imageList.add("https://firebasestorage.googleapis.com/v0/b/findall-11e21.appspot.com/o/staticImages%2Fautre.png?alt=media&token=ba5ed8a8-f9ce-4339-8583-9fb5c839de82");
        }
        break;
    }

  }

  Future _dialog(BuildContext context) async {
    return  showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Importer la photo depuis',style: TextStyle(fontSize: 17)),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  _getImage(context,'gallerie');
                },
                child: const Text('la gallerie'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  _getImage(context,'camera');
                },
                child: const Text('la camera'),
              ),

            ],
          );
        });
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
              Text(_objectName = "Document",textAlign: TextAlign.center)
                  :
              Text(_objectName),
              onChanged: (String changedValue) {
                _objectName = changedValue;
                setState(() {
                  _objectName;
                });
              },
              value: _objectName,
              items: <String>[ "Document", 'Ordinateur','Porte-feuille','Sac à dos','Sac à main','Téléphone portable','Autre...' ]
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
              padding: EdgeInsets.only(top: 15,bottom: 15,left: _imageList.length >= 1 ? 30 : 10.0),
              child: _buildImageListView(),
          ),
        );

    final amountTitle =  new Container(
        width: width/1.15,
        padding: EdgeInsets.only(left: 6.5,right: 6.5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text("Could you be able to reward someone who finds your item?",
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

    final reward =  new Container(
        width: width/1.2,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Color(0xffdcdcdc))),
        padding: EdgeInsets.only(left: 25.0, right: 7.0),
        child: DropdownButtonHideUnderline(
          child: new DropdownButton<String>(
              iconEnabledColor: Color(0xffdcdcdc),
              iconSize: 40,
              style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black,fontFamily: 'Raleway'),
              hint:  _isRewarded == null ?
              Text(_isRewarded = "YES",textAlign: TextAlign.center,)
                  :
              Text(_isRewarded,
                style: TextStyle(
                    fontFamily:"Raleway"
                ),
                  textAlign: TextAlign.center
              ),
              onChanged: (String changedValue) {
                _isRewarded = changedValue;
                setState(() {
                  _isRewarded;
                });
              },
              value: _isRewarded,
              items: <String>[ 'YES',"NO"]
                  .map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList()),
        )
    );


    final postAnnounceButton = !_isLoading
        ?
          FloatingActionButton.extended(
            icon: Icon(Icons.public),
            label: Text('POST ANNOUNCEMENT',style: TextStyle(fontFamily: 'Raleway'),
              ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            backgroundColor: Colors.pink,
            heroTag: "post",
            onPressed: () {
              _formKey.currentState.validate();
                if (_isValidForm()) {
                  _imageList.length == 0 ? _setImageIfNotSelected(_objectName) : _submit();
                  _submit();
                } else {
                  _dateController.text.length == 0
                      ?
                        Toast.show("Please pick the date.", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM)
                      :
                        Toast.show("Fill the whole form.", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                }
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
          body: SizedBox.expand(
            child:DraggableScrollableSheet(
              initialChildSize: 1,
              expand: false,
              minChildSize: 1,
              builder: (context,scrollController){
                return SingleChildScrollView(physics: ScrollPhysics(),
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(top: 50),
                  child: Column(
                    children: <Widget>[

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(width: 5),
                          Text('Post Announcement',textAlign: TextAlign.center,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700,fontFamily: 'Raleway')),
                        ],
                      ),

                      SizedBox(height: 20),

                      Flexible(
                          child: Builder(
                            builder: (context) =>Form(
                                key: _formKey,
                                autovalidate: false,
                                child: ListView(
                                  primary: false,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  padding: EdgeInsets.only(left: 15,right: 15),
                                  children: <Widget>[
                                        datePicker,
                                        SizedBox(height: 7.0),
                                        dateTitle,
                                        SizedBox(height: 12.0),
                                        objectNames,
                                        SizedBox(height: 7.0),
                                        objectTitle,
                                        _objectName == 'Autre...'
                                            ?
                                        SizedBox(height: 12.0)
                                            :
                                        SizedBox(height: 0.0),
                                        _objectName == 'Autre...'
                                            ?
                                        otherObject
                                            :
                                        SizedBox(height: 0.0),

                                        SizedBox(height: 12.0),
                                        town,
                                        SizedBox(height: 7.0),
                                        townTitle,
                                        _townName == 'Autre...'
                                            ?
                                        SizedBox(height: 12.0)
                                            :
                                        SizedBox(height: 0.0),
                                        _townName == 'Autre...'
                                            ?
                                        otherTown
                                            :
                                        SizedBox(height: 0.0),
                                        SizedBox(height: 12.0),
                                        quarter,
                                        SizedBox(height: 12.0),
                                        description,
                                        SizedBox(height: 12.0),
                                        camera,
                                        SizedBox(height: 10.0),
                                        phone,
                                        SizedBox(height: 7.0),
                                        phoneTitle,
                                        SizedBox(height: 12.0),
                                        reward,
                                        SizedBox(height: 7.0),
                                        amountTitle,
                                        SizedBox(height: 15.0),
                                       /* _imageList.length == 0
                                            ?
                                        Text('Veuillez remplir le formulaire en entier.',textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,fontFamily: 'Raleway'),)
                                            :*/
                                        postAnnounceButton,
                                        SizedBox(height: 25.0),

                                  ],
                                )
                            ),
                          )
                      )

                    ],
                  ),
                );
              },
            ),
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
        onWillPop: (){
            Navigator.of(context).pop();
        }
    );
  }

}