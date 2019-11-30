import 'package:findall/FoundItems/PreviewNewFoundPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class NewFoundForm extends StatefulWidget {

  @override
  _NewFoundFormState createState() => _NewFoundFormState();
}

class _NewFoundFormState extends State<NewFoundForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _otherObjectController = TextEditingController();
  var _otherTownController = TextEditingController();
  var _quarterController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _phoneController = TextEditingController();
  var _finderNameController = TextEditingController();
  var _dateController = TextEditingController();
  bool _isLoadingImg = false;
  bool _isLoading = false;
  List _imageList = [];
  String _objectName;
  String _townName;
  var _image;

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
      return Text("Uploads images of the object.",style: TextStyle(color: Colors.black,fontFamily: 'Raleway',fontSize: 13));
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
              Text(_objectName = "Carte nationale d'identité")
                  :
              Text(_objectName),
              onChanged: (String changedValue) {
                _objectName = changedValue;
                setState(() {
                  _objectName;
                });
              },
              value: _objectName,
              items: <String>[ 'Actes de naissance',"Carte nationale d'identité", 'Dilplômes','Ordinateur', 'Passeport','Porte-feuille','Relevé de note','Sac à dos','Sac à main','Télévision','Téléphone portable','Autre...' ]
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
              child: Text("Leave your phone number so that you could be contacted by the owner.",
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
        height: height/3,
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
                    width: width/4.5,
                    height: height/8,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all(color: Color(0xffdcdcdc))),
                    padding: EdgeInsets.all(2),
                    child:GestureDetector(
                      child: Image.asset(
                          'assets/images/foret.jpeg',
                          width: width/4.5,
                          height: height/8,
                          fit: BoxFit.cover
                      ),
                    )
                ),

                SizedBox(width: 25),

                Container(
                    width: width/4.5,
                    height: height/8,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all(color: Color(0xffdcdcdc))),
                    padding: EdgeInsets.all(2),
                    child:GestureDetector(
                      child: Icon(Icons.add_circle,size: 25,color: Colors.pink,),
                    )
                ),

                SizedBox(width: 25),

                Container(
                    width: width/4.5,
                    height: height/8,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all(color: Color(0xffdcdcdc))),
                    padding: EdgeInsets.all(2),
                    child:GestureDetector(
                      child: Image.asset(
                          'assets/images/mer.jpeg',
                          width: width/4.5,
                          height: height/8,
                          fit: BoxFit.cover
                      ),
                    )
                )

              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Container(
                    width: width/4.5,
                    height: height/8,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all(color: Color(0xffdcdcdc))),
                    padding: EdgeInsets.all(2),
                    child:GestureDetector(
                      child: Icon(Icons.add_circle,size: 25,color: Colors.pink,),
                    )
                ),

                SizedBox(width: 25),

                Container(
                    width: width/4.5,
                    height: height/8,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all(color: Color(0xffdcdcdc))),
                    padding: EdgeInsets.all(2),
                    child:GestureDetector(
                      child: Image.asset(
                          'assets/images/jardin.jpeg',
                          width: width/4.5,
                          height: height/8,
                          fit: BoxFit.cover
                      ),
                    )
                ),

                SizedBox(width: 25),

                Container(
                    width: width/4.5,
                    height: height/8,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all(color: Color(0xffdcdcdc))),
                    padding: EdgeInsets.all(2),
                    child:GestureDetector(
                      child: Icon(Icons.add_circle,size: 25,color: Colors.pink,),
                    )
                )

              ],
            ),
          ],
        ),
      ),

    );

    final finderName =  new Container(
        width: width/1.2,
        padding: EdgeInsets.only(left: 6.5,right: 6.5),
        child: TextFormField(
          controller: _finderNameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "Your name",
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
              Icons.person,
              color: Color(0xfff4f4f4),
            ),
          ),
          validator: (String value) {
            if(value.isEmpty) {
              return "can not be empty";
            }
          },
        )
    );

    final postAnnounceButton = !_isLoading
        ?
            FloatingActionButton.extended(
              icon: Icon(Icons.public),
              label: Text('PUBLISH',style: TextStyle(fontFamily: 'Raleway'),),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              backgroundColor: Colors.pink,
              heroTag: "publish",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PreviewNewFound(
                        town: _townName == 'Autre...'?_otherTownController.text: _townName,
                        date: _dateController.text,
                        contact: _phoneController.text,
                        foundBy: _finderNameController.text,
                        objectName: _objectName == 'Autre...'?_otherObjectController.text: _objectName,
                        quarter: _quarterController.text,
                        description: _descriptionController.text,
                        images: ['assets/images/foret.jpeg','assets/images/mer.jpeg','assets/images/jardin.jpeg'],
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
          body:SizedBox.expand(
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    verticalDirection: VerticalDirection.down,
                    children: <Widget>[

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(width: 5),
                          Text('New Item found',textAlign: TextAlign.center,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700,fontFamily: 'Raleway')),

                        ],
                      ),

                      SizedBox(height: 20.0),

                      Flexible(
                          child: Builder(
                            builder: (context) =>Form(
                                key: _formKey,
                                autovalidate: false,
                                child: ListView(
                                  primary: false,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
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
                                    SizedBox(height: 12.0),
                                    phone,
                                    SizedBox(height: 7.0),
                                    phoneTitle,
                                    SizedBox(height: 12.0),
                                    finderName,
                                    SizedBox(height: 15.0),
                                    _imageList.length != 0
                                        ?
                                    Text('Veuillez remplir le formulaire en entier.',textAlign: TextAlign.center,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,fontFamily: 'Raleway'),)
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
                );
              },
            ),
          ),
        ),
        onWillPop: null
    );
  }

}