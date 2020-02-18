import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:findall/Components/Authentication/ProfilePage.dart';
import 'package:findall/Components/FoundItems/PreviewNewFoundPage.dart';
import 'package:findall/GlobalComponents/Utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';


class SMSLoginPage extends StatefulWidget {
  final bool newFound;
  final Map dataFound;

  SMSLoginPage({Key key,
    this.newFound,
    this.dataFound,
  }) : super(key: key);
  @override
  _SMSLoginPageState createState() => _SMSLoginPageState();
}

class _SMSLoginPageState extends State<SMSLoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _numController = TextEditingController();

  String smsCode;
  String verificationId;
  bool _loading;

  @override
  void initState() {
    _numController.text = "+237";
    _loading = false;
    super.initState();
  }


  _redirect(user){
    /*phoneNumberStorage.ready.then((_){
      phoneNumberStorage.clear();
      phoneNumberStorage.setItem('userphone', _numController.text);
    });*/
    if(widget.newFound == true){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PreviewNewFound(
              town: widget.dataFound['town'],
//              date: widget.dataFound['date'],
              contact: widget.dataFound['contact'],
              objectName: widget.dataFound['objectName'],
              quarter: widget.dataFound['quarter'],
              description: widget.dataFound['description'],
              finderName: widget.dataFound['finderName'],
              images: widget.dataFound['images'],
            )
        ),
      );
    }
      else{
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context)=> ProfilePage(
                userId: user.providerData[0].uid,
                email: null,
                phoneNumber: user.providerData[0].phoneNumber,
                profileImg: null,
                username: null,
                isPhoneAuth: true,
              )
          )
      );
      }
  }


  Future<void> _verifyPhone() async {
    setState(() {
      _loading = true;
    });
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      print("Sign in");
      setState(() {
        _loading = true;
      });
      _smsCodeDialog(context).then((value) {
        setState(() {
          _loading = false;
        });
      }).catchError((err) {
        print('yeesssssssssssssssss');
        setState(() {
          _loading = false;
        });
        Toast.show("Code Erroné.", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor: Colors.red);
      });
    };

    final verificationCompleted = (user) {
      print("Verified");
    } ;

    final PhoneVerificationFailed verifiedFailed = (AuthException exception) {
      print('00000000000000000000000000000');
      Toast.show("Le format du numero est incorrect.", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor: Colors.red);
      print("${exception.message}");
    };
    try {
      setState(() {
        _loading = true;
      });
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: _numController.text,
          codeAutoRetrievalTimeout: autoRetrieve,
          codeSent: smsCodeSent,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verifiedFailed
      );

      setState(() {
        _loading = false;
      });
    } catch (e) {
      print('88888888888888888888888888888');
      Toast.show("Erreur, Veuillez reésayer.", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM, backgroundColor: Colors.red);
      print("Error");
      print(e);
    }
    setState(() {
      _loading = false;
    });
  }

  Future<bool> _smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Entrez le code sms"),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Color(0xffdcdcdc))),
            content: TextField(
              keyboardType: TextInputType.number,

              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Text("Annuler",
                      style: TextStyle(
                        color: Colors.pink,
                        fontFamily: 'Raleway',
                        fontSize: 14.0,
                      ),
                    ),
                  ),

                  SizedBox(width: 25),

                  RaisedButton(
                    onPressed: () {
                      FirebaseAuth.instance.currentUser().then((user) {
                        _signIn().then((user) {
                          userStorage.setItem('userId', user.providerData[0].uid);
                          _redirect(user);

                        }).catchError((err) {
                          Toast.show("Code Invalide", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER, backgroundColor: Colors.red);
                          Navigator.of(context).pop();
                          print(err);
                        });
                      });
                    },
                    color: Colors.pink,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Text("Valider",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Raleway',
                        fontSize: 14.0,
                      ),
                    ),
                  )

                ],
              )

            ],
          );
        }
    );
  }

  Future<FirebaseUser> _signIn() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: this.verificationId,
      smsCode: this.smsCode,
    );
    final AuthResult _auth = await auth.signInWithCredential(credential);
    return _auth.user;
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 100.0, right: 25.0, left: 25.0, bottom: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset("assets/images/logo_findall.png", height: 110, width: 110),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      CountryCodePicker(
                        onChanged: (val) {
                          _numController.text = val.toString();
                          },
                        initialSelection: 'CM',
                        favorite: ['+237','FR'],
                        showCountryOnly: false,
                        alignLeft: false,
                      ),
                    ],
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _numController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Numéro de tel",
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
                        else if(value.length <= 5) {
                          return "Entrer un numéro de téléphone valide";
                        }
                      },
                    ),
                    const SizedBox(height: 17.0),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: _loading ? Alignment.center : null,
                        height: 50,
                        child: !_loading ?
                                          Container(
                                              width: width/1.2,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.pink,
                                              ),
                                              child:FloatingActionButton.extended(
                                                  backgroundColor: Colors.pink,
                                                  heroTag: "codephone",
                                                  shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Color(0xffea4335))),
                                                  label: Text("Continuer",style: TextStyle(color: Colors.white,fontFamily: "Raleway",fontWeight: FontWeight.bold,fontSize: 17),
                                                  ),
                                                onPressed: () async {
                                                  if (await checkInternet() == true) {
                                                    if(_numController.text[0] == '+'){
                                                      _formKey.currentState.validate();

                                                      _verifyPhone().then((val) {

                                                      })
                                                        .catchError((err) {
                                                        Toast.show("Numéro invalide", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor: Colors.red);
                                                        print(err);

                                                      });
                                                    }else{
                                                      Toast.show("Le format du numéro est incorrect", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM
                                                          , backgroundColor: Colors.red);
                                                    }

                                                  }
                                                  else {
                                                    noInternet(context, "Veuillez vérifier votre connexion internet, puis réessayez");
                                                  }
                                                }
                                              )
                                          )
                                       :
                                          SpinKitWave(
                                              color: Colors.deepPurple,
                                              size: 30
                                          )
                    ),
                    const SizedBox(height: 27.0),
                    Container(
                      alignment: Alignment.center,
                      child: AutoSizeText("Entrez votre numéro de téléphone. Vous recevrez un code de confirmation par sms.",
                          style: TextStyle(
                            fontFamily: "Raleway"
                          ),
                          textAlign: TextAlign.center,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                    )
                  ],
                ),
              )),
        ),
        onWillPop: (){
          Navigator.of(context).pop();
        }
    );
  }
}
