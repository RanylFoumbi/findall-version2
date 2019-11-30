import 'package:cached_network_image/cached_network_image.dart';
import 'package:findall/Authentication/AuthPage.dart';
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
  bool _isEnable = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentUser().then((user){
      setState(() {
        _nameController.text = user.providerData[0].displayName;
        _phoneController.text = user.providerData[0].phoneNumber;
        _emailController.text = user.providerData[0].email;
        _profileImg = user.providerData[0].photoUrl;
      });
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _logout() async{
    userStorage.clear();
    await googleSignIn.signOut();
    await facebookLogin.logOut();
    await FirebaseAuth.instance.signOut();

    Navigator.push(
      context,
      MaterialPageRoute(
          builder:
              (context) => AuthPage()
      ),
    );
  }


  bool _isValidForm() {
    return _nameController.text.length > 0 ||
        _phoneController.text.length > 0 ||
        _emailController.text.length > 0 ;
  }

  _submit(){
    Toast.show("Update successfully!.", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
  }

  Future<FirebaseUser>_getCurrentUser() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }



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
                                              Navigator.of(context).pop();
                                            }
                                        ),

                                        SizedBox(
                                          width: width/1.4,
                                          child: Center(
                                            child: Text('Informations',style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: 'Raleway'
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
                                    )
                                ),
                                child: GestureDetector(
                                  child: ClipRRect(
                                    child:  _profileImg == null
                                        ?
                                          Icon(Icons.person, size: 160, color: Colors.deepPurple)
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
                                            Text("Lost",style: TextStyle(color: Colors.black,fontFamily: "Raleway",fontSize: 17),
                                            ),
                                            SizedBox(height: 7),

                                            Text("0",style: TextStyle(color: Colors.pink,fontFamily: "Raleway",fontSize: 17,fontStyle: FontStyle.italic,fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: width/3),

                                      Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text("Found",style: TextStyle(color: Colors.black,fontFamily: "Raleway",fontSize: 17),
                                            ),

                                            SizedBox(height: 7),

                                            Text("15",style: TextStyle(color: Colors.deepPurple,fontFamily: "Raleway",fontStyle: FontStyle.italic,fontSize: 17,fontWeight: FontWeight.w300),
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
                                  child:Text('Name',style: TextStyle(
                                      fontSize: 13.0,
                                      fontFamily: 'Raleway'
                                  ),
                                    textAlign: TextAlign.left,
                                 ),
                                ),
                                new Container(
                                    width: width/1.3,
                                    height: height/15,
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
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            Icons.mode_edit,
                                            color: Colors.black26,
                                          ),
                                          onPressed: (){
                                            setState(() {
                                              _isEnable = !_isEnable;
                                            });
                                          },
                                        )
                                      ),
                                      validator: (String value) {
                                        if(value.isEmpty) {
                                          return "This field can not be empty.";
                                        }
                                      },
                                    )),

                                SizedBox(height: 13),

                                new Container(
                                  width: width/1.3,
                                  padding: EdgeInsets.only(left: 5,right: 5,bottom: 5),
                                  child:Text('Phone',style: TextStyle(
                                      fontSize: 13.0,
                                      fontFamily: 'Raleway'
                                  ),
                                    textAlign: TextAlign.left,),
                                ),
                                new Container(
                                    width: width/1.3,
                                    height: height/15,
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
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            Icons.mode_edit,
                                            color: Colors.black26,
                                          ),
                                          onPressed: (){
                                            setState(() {
                                              _isEnable = true;
                                            });
                                          },
                                        )
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
                                    height: height/15,
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
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            Icons.mode_edit,
                                            color: Colors.black26,
                                          ),
                                          onPressed: (){
                                            setState(() {
                                              _isEnable = true;
                                            });
                                          },
                                        )
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
                  child: Text('Logout',style: TextStyle(fontFamily: 'Raleway',color: Colors.deepPurple),),
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
