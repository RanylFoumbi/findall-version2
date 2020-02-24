import 'package:cached_network_image/cached_network_image.dart';
import 'package:findall/Components/Authentication/AuthPage.dart';
import 'package:findall/Components/FoundItems/FoundedItemsList.dart';
import 'package:findall/GlobalComponents/Utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';


class ProfilePage extends StatefulWidget{

  final String userId;
  final bool isPhoneAuth ;
  final String email;
  final String username;
  var profileImg;
  final String phoneNumber;

  ProfilePage({Key key,
    this.isPhoneAuth,
    this.userId,
    this.email,
    this.username,
    this.profileImg,
    this.phoneNumber
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  var _profileImg;
  int _nbrOfLostItems = 0;
  int _nbrOfFoundItems = 0;
  int _totalItems;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser().then((user){
      setState(() {
        _nameController.text = user.providerData[0].displayName;
        _phoneController.text = user.providerData[0].phoneNumber;
        _emailController.text = user.providerData[0].email;
        _profileImg = user.providerData[0].photoUrl;
      });
    });


    db.collection('ObjectList').where('userId',isEqualTo: widget.userId).getDocuments().then((data)=>{
      setState((){
        _totalItems = data.documents.length;
      }),
      data.documents.retainWhere((item) => item.data['isLost'] == true),
      data.documents.join(','),
      setState((){
        _nbrOfLostItems = data.documents.length;
        _nbrOfFoundItems = _totalItems - _nbrOfLostItems;
      }),
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _logout() async{
    loaderModal(context);
    userStorage.ready.then((_){
      db.collection('users').where('uid',isEqualTo: userStorage.getItem('userId')).getDocuments().then((docs){
        googleSignIn.signOut();
        facebookLogin.logOut();
        FirebaseAuth.instance.signOut();
        userStorage.clear();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder:
                  (context) => AuthPage()
          ),
        );
      });

    });
  }


 /* bool _isValidForm() {
    return _nameController.text.length > 0 ||
        _phoneController.text.length > 0 ||
        _emailController.text.length > 0 ;
  }*/

  /*_submit(){
    Toast.show("Mis à jour avec succès!.", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
  }*/



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;



    return  WillPopScope(
        child: Scaffold(
          key: Key("Key"),
          body: ListView(
            padding: EdgeInsets.only(bottom: 25),
            scrollDirection: Axis.vertical,
            children: <Widget>[

              Form(
                key: _formKey,
                autovalidate: false,
                child: new Column(
                  children: <Widget>[
                    Container(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  height: height/2.7,
                                  width: width,
                                  alignment: Alignment.topLeft,
                                  color: Colors.pink,
                                  child: SizedBox(
                                    height: 100,
                                    child: Row(
                                      children: <Widget>[

                                        new IconButton(
                                            icon: Icon(Icons.chevron_left, color: Colors.white, size: 40),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => FoundedItemsList()
                                                ),
                                              );
                                            }
                                        ),

                                        SizedBox(
                                          width: width/1.4,
                                          child: Center(
                                            child: Text('Informations',style: TextStyle(color: Colors.white,fontSize: 15,fontFamily: 'Raleway'
                                            ),
                                           ),
                                          )
                                        ),

                                        new IconButton(
                                            icon: Icon(Icons.help, color: Colors.white, size: 30),
                                            onPressed: () {}
                                        ),

                                      ],
                                    )
                                  )
                                ),
                              )
                            ],
                          ),

                          SizedBox(height: 200,),

                          Positioned(
                            top: height/4.3,
                            child: Container(
                                width: width/1.09,
                                height: height/1.4,
                                padding: EdgeInsets.only(bottom: 30),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xfff4f4f4),
                                      offset: Offset(
                                        5.0, // Move to right 10  horizontally
                                        8.0, // Move to bottom 10 Vertically
                                      )
                                    )
                                  ]
                                ),
                            ),
                          ),

                          Positioned(
                            top: height/7,
                            child: Container(
                                width: width/2.2,
                                height: width/2.2,
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 2.0,
                                        color: Colors.white
                                    ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0x000000),
                                        offset: Offset(
                                          2.0, // Move to right 10  horizontally
                                          3.5, // Move to bottom 10 Vertically
                                        )
                                    )
                                  ]
                                ),
                                child: GestureDetector(
                                  child: ClipRRect(
                                    child:  _profileImg == null
                                                              ?
                                                                Image.asset('assets/images/user.png',height: height/2,fit: BoxFit.cover,)
                                                              :
                                                                GestureDetector(
                                                                  child:CachedNetworkImage(
                                                                      height: height / 2,
                                                                      imageUrl: _profileImg,
                                                                      fit: BoxFit.cover,
                                                                      repeat: ImageRepeat.noRepeat,
                                                                      placeholder: (context, url) =>
                                                                          SpinKitFadingCircle(color: Colors.deepPurple, size: 50),
                                                                      errorWidget: (context, url, error) =>
                                                                      new Icon(Icons.error, color: Colors.deepPurple, size: 35)
                                                                  ),
                                                                  onTap: () {
                                                                    photoView(context, widget.profileImg);
                                                                  },
                                                                ),
                                                          borderRadius: BorderRadius.circular(100),
                                                        ),
                                                        onTap: (){},
                                                      )
                            ),
                          ),

                          Positioned(
                            top: height/2.5,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 10),
                                  Center(
                                    child: Row(
                                      children: <Widget>[
                                        Text(_nameController.text,style: TextStyle(fontFamily: 'Raleway',fontSize: 17,fontWeight: FontWeight.w700),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 15),

                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text("Perdu(s)",style: TextStyle(color: Colors.black,fontFamily: "Raleway",fontSize: 15),
                                            ),
                                            SizedBox(height: 7),

                                            Text(_nbrOfLostItems.toString(),style: TextStyle(color: Colors.pink,fontFamily: "Raleway",fontSize: 15,fontStyle: FontStyle.italic,fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: width/3),

                                      Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text("Trouvé(s)",style: TextStyle(color: Colors.black,fontFamily: "Raleway",fontSize: 15),
                                            ),

                                            SizedBox(height: 7),

                                            Text(_nbrOfFoundItems.toString(),style: TextStyle(color: Colors.deepPurple,fontFamily: "Raleway",fontStyle: FontStyle.italic,fontSize: 15,fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Positioned(
                            top: height/1.8,
                            height: height/1.2,
                            child: Column(
                              children: <Widget>[
                                new Container(
                                  width: width/1.3,
                                  padding: EdgeInsets.only(left: 5,right: 5,bottom: 5),
                                  child:Text('Nom',style: TextStyle(
                                      fontSize: 13.0,
                                      fontFamily: 'Raleway'
                                  ),
                                    textAlign: TextAlign.left,
                                 ),
                                ),
                                new Container(
                                    width: width/1.3,
                                    height: height/14,
                                    padding: EdgeInsets.only(left: 5,right: 5),
                                    child: TextFormField(
                                      controller: _nameController,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontFamily: 'Raleway'
                                      ),
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffdcdcdc)
                                            ),
                                            borderRadius: BorderRadius.circular(10.0)
                                        ),
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
                                          return "ce champ ne doit pas être vide.";
                                        }
                                      },
                                    )),

                                SizedBox(height: 13),

                                new Container(
                                  width: width/1.3,
                                  padding: EdgeInsets.only(left: 5,right: 5,bottom: 5),
                                  child:Text('Téléphone',style: TextStyle(
                                      fontSize: 13.0,
                                      fontFamily: 'Raleway'
                                  ),
                                    textAlign: TextAlign.left,),
                                ),
                                new Container(
                                    width: width/1.3,
                                    height: height/14,
                                    padding: EdgeInsets.only(left: 5,right: 5),
                                    child: TextFormField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      style: TextStyle(fontSize: 13.0,
                                          fontFamily: 'Raleway'
                                      ),
                                      enabled: false,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffdcdcdc)),
                                            borderRadius: BorderRadius.circular(10.0)
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.phone,
                                          color: Color(0xfff4f4f4),
                                        ),
                                      ),
                                    )
                                ),

                                SizedBox(height: 13),

                                new Container(
                                  width: width/1.3,
                                  padding: EdgeInsets.only(left: 5,right: 5,bottom: 5),
                                  child:Text('Email',style: TextStyle(
                                      fontSize: 13.0,
                                      fontFamily: 'Raleway'
                                  ),
                                    textAlign: TextAlign.left,),
                                ),
                                new Container(
                                    width: width/1.3,
                                    height: height/14,
                                    padding: EdgeInsets.only(left: 5,right: 5),
                                    child: TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(fontSize: 13.0,
                                          fontFamily: 'Raleway'
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabled: false,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffdcdcdc)),
                                            borderRadius: BorderRadius.circular(10.0)
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Color(0xfff4f4f4),
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            ),
                          )

                        ],
                      ),
                    ),

                  ],
                )
              ),

              Container(
                margin: EdgeInsets.only(top: height/1.75),
                alignment: Alignment.center,
                child: FlatButton(
                  child: Text('Se déconnecter',style: TextStyle(fontFamily: 'Raleway',color: Colors.deepPurple,fontSize: 13),),
                  onPressed: (){
                    _logout();
                  },
                )
              ),

            ],
          )
        ),
        onWillPop: (){

        },
    );
  }

}
