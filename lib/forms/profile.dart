import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/helper/custom_icons.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import '../helper/dimensions.dart';
import '../widgets/appBar.dart';
import '../services/contributors.dart';

class ProfileForm extends StatefulWidget {

  final bool viewMode;
  final User member;

  const ProfileForm({Key key, this.viewMode = false, this.member})
    : super(key: key);
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
 
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();


  String _name;
  String _batch;
  String _branch;
  String _about;
  String _contact;
  String _interests;
  String _cvLink;
  String _email;
  String _fbId;
  String _instaId;
  String _linkedinId;
  String _position;
  String _quote;
  bool filePicked = false;



  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);

    var _userProvider, _user, _currUser;
    _userProvider = Provider.of<UserProvider>(context);
    if (!widget.viewMode) {
      _user = _userProvider.getUser;
      _currUser = _userProvider.getUser;
    } else {
      _user = widget.member;
      _currUser = _userProvider.getUser;
    }


    final nameController = TextEditingController();
    nameController.text =_user.name.isEmpty ? "": _user.name;
    final batchController = TextEditingController();
    setState(() {
      batchController.text = batchController.text.isEmpty ? _user.batch : batchController.text;      
    });
    final branchController = TextEditingController();
    branchController.text = _user.branch.isEmpty ? "": _user.branch;
    final aboutController = TextEditingController();
    aboutController.text = _user.about.isEmpty ? "" : _user.about;
    final interestsController = TextEditingController();
    interestsController.text = _user.interests.isEmpty ? "": _user.interests;
    final cvLinkController = TextEditingController();
    cvLinkController.text = _user.cvLink.isEmpty ? "": _user.cvLink;
    final contactController = TextEditingController();
    contactController.text = _user.contact.isEmpty? "" : _user.contact;
    final emailController = TextEditingController();
    emailController.text = _user.email.isEmpty ? "": _user.email;
    final fbIdController = TextEditingController();
    fbIdController.text = _user.fbId.isEmpty ? "" : _user.fbId;
    final instaIdController = TextEditingController();
    instaIdController.text = _user.instaId.isEmpty ? "" : _user.instaId;
    final linkedinIdController = TextEditingController();
    linkedinIdController.text = _user.linkedinId.isEmpty ? "" : _user.linkedinId;
    final positionController = TextEditingController();
    positionController.text = _user.position.isEmpty ? "" : _user.position;
    final quoteController = TextEditingController();
    quoteController.text = _user.quote=="What quote describes you"? "What quote describes you" : _user.quote;


    File file;
    String _img="";
    String fileName='';
    

    // upload image
    
    Future getImage()async{
      setState(() async{
        var rng = new Random();
        String randomName="";
        for (var i = 0; i < 20; i++) {
          print(rng.nextInt(100));
          randomName += rng.nextInt(100).toString();
        }
        FilePickerResult result =
          await FilePicker.platform.pickFiles(type: FileType.image)
          .then((result) async {
            if(result!=null)
            {
            filePicked =true; 
              file = File(result.files.single.path);
              fileName = '$randomName';
            }
          }).catchError((error)
          {
            print("Error: "+error.toString());
          });      
      });
    }
    Future saveImg(List<int> asset, String name) async {

      StorageReference reference = FirebaseStorage.instance.ref().child(name);
      StorageUploadTask uploadTask = reference.putData(asset);
      _img = await (await uploadTask.onComplete).ref.getDownloadURL();
      print(_img);
    
    }

    // TextFormFiels styling 
    final kHintTextStyle = TextStyle(
      color: Color(0xFF757575),
      fontSize: vpH*0.024,
      fontFamily: 'OpenSans',
    );

    final kLabelStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: vpH*0.025,
      fontFamily: 'OpenSans',
    ); 
      
    // alert after successful form submission 
    Widget okButton =FlatButton(  
      child: Text("OK",style: kLabelStyle,),  
      onPressed: () {  
        Navigator.of(context).pop();
      },  
    );

    AlertDialog alert = AlertDialog(  
      content: Text("Save Changes",style: kLabelStyle,),  
      actions: [  
        okButton,  
      ],  
    );  

    Future<void> updateUserProfile() async {
      String id;
      Firestore.instance.collection('users').getDocuments().then((users) {
        users.documents.forEach((user) {
          if (user['email'] == _user.email) {
            id = user.documentID;
            return Firestore.instance
              .collection('users')
              .document(id)
              .updateData(
                {'about': _about,
                  'email':_email,
                  'batch':_batch ,
                  'name': _name,
                  'profileImageUrl': _img.isEmpty?_user.photoUrl : _img,
                  'contact': _contact,
                  'quote': _quote,
                  'cvLink': _cvLink,
                  'fbId': _fbId,
                  'instaId': _instaId,
                  'interests': _interests,
                  'branch': _branch,
                  'linkedinId': _linkedinId,
                  'position': _position,
                }
              )
              .then((value) => print("User Profile Updated"))
              .catchError(
                (error) => print("Failed to update progress: $error"));
          }
        });
      });
    }

    return SafeArea(
      child:Scaffold(
       key: _scaffoldKey,
        appBar: appBar(
          context,
          strTitle: "Edit Profile",
          isDrawer: false,
          isNotification: false,
          scaffoldKey: _scaffoldKey,
        ),
       backgroundColor: Color(0xFFE8EAF6),
        body: Container(
          height: double.infinity, width: double.infinity,
         
          child: SingleChildScrollView(
            child: Form(
               key:_formKey,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[   
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(top:vpH*0.02, left: vpW*0.02, right: vpW*0.02, bottom:vpH*0.01),
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage:
                                NetworkImage(_user.profileImageUrl),
                            ),
                          ),
                        ),
                        IconButton(icon: Icon(Icons.add_a_photo,size: vpH*0.04,color: Color(0xff7c56dc),),
                          onPressed: ()async{
                            await getImage();

                          },
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(left:vpW*0.05,right:vpW*0.05, top: vpH*0.02),
                      alignment: Alignment.topLeft,
                      child:Text('Name',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.005),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: nameController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: ' Name',
                          hintStyle: kHintTextStyle,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.person),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter name";
                          }
                          return null;
                        },
                        onSaved: (value)
                        {
                          _name = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left:vpW*0.05,right:vpW*0.05, top: vpH*0.005),
                      alignment: Alignment.topLeft,
                      child:Text('Position',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.005),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: positionController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: ' Position',
                          hintStyle: kHintTextStyle,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.bolt),
                          ),
                        ),
                   
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter position";
                          }
                          return null;
                        },
                        onSaved: (value)
                        {
                          _position = value;
                        },
                      ),
                    ),
                     Container(
                      padding: EdgeInsets.only(left:vpW*0.05,right:vpW*0.05, top: vpH*0.002),
                      alignment: Alignment.topLeft,
                      child:Text('Batch',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.002),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: batchController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: ' Batch',
                          hintStyle: kHintTextStyle,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.people),
                          ),
                        ),
                        onSaved: (value)
                        {
                          _batch = value;
                        },
                      ),
                    ),
                     Container(
                      padding: EdgeInsets.only(left:vpW*0.05,right:vpW*0.05, top: vpH*0.002),
                      alignment: Alignment.topLeft,
                      child:Text('Branch',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.002),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: branchController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: ' Branch',
                          hintStyle: kHintTextStyle,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.stream),
                          ),
                        ),
                        onSaved: (value)
                        {
                          _branch = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left:vpW*0.05,right:vpW*0.05, top: vpH*0.002),
                      alignment: Alignment.topLeft,
                      child:Text('About',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.002),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: aboutController,
                        maxLength: 100,
                        maxLengthEnforced: true,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: ' About',
                          hintStyle: kHintTextStyle,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.book),
                          ),
                        ),
                        onSaved: (value)
                        {
                          _about = value;
                        },
                      ),
                    ),
                     Container(
                      padding: EdgeInsets.only(left:vpW*0.05,right:vpW*0.05, top: vpH*0.002),
                      alignment: Alignment.topLeft,
                      child:Text('CV Link',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.002),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: cvLinkController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: 'CV Link',
                          hintStyle: kHintTextStyle,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.link),
                          ),
                        ),
                        onSaved: (value)
                        {
                          _cvLink = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.002),
                      alignment: Alignment.topLeft,
                      child:Text('Interests',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.002),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: interestsController,
                        maxLength: 100,
                        maxLengthEnforced: true,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: ' Interests',
                          hintStyle: kHintTextStyle,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.face),
                          ),
                        ),
                        onSaved: (value)
                        {
                           _interests = value;
                        },
                      ),
                    ),
                     Container(
                      padding: EdgeInsets.only(left:vpW*0.05,right:vpW*0.05, top: vpH*0.002),
                      alignment: Alignment.topLeft,
                      child:Text('Contact No',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.002),
                      child: TextFormField(
                        maxLength: 10,
                        maxLengthEnforced: true,
                        controller: contactController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: 'Contact No',
                          hintStyle: kHintTextStyle,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.phone),
                          ),
                        ),
                        onSaved: (value)
                        {
                          _contact = value;
                        },
                      ),
                    ),
                     Container(
                      padding: EdgeInsets.only(left:vpW*0.05,right:vpW*0.05, top: vpH*0.002),
                      alignment: Alignment.topLeft,
                      child:Text('Email',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.002),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: emailController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: ' Enter Email',
                          hintStyle: kHintTextStyle,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.email),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter your email";
                          }
                          return null;
                        },
                        onSaved: (value)
                        {
                          _name = value;
                        },
                      ),
                    ),
                     Container(
                      padding: EdgeInsets.only(left:vpW*0.05,right:vpW*0.05, top: vpH*0.005),
                      alignment: Alignment.topLeft,
                      child:Text('Facebook Id',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.005),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: fbIdController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: ' Enter Facebook Id',
                          hintStyle: kHintTextStyle,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(SocialMedia.facebook),
                          ),
                        ),
                        onSaved: (value)
                        {
                          _fbId = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left:vpW*0.05,right:vpW*0.05, top: vpH*0.005),
                      alignment: Alignment.topLeft,
                      child:Text('Instagram ID',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.005),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: instaIdController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: ' Enter Instagram ID',
                          hintStyle: kHintTextStyle,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(SocialMedia.instagram),
                          ),
                        ),
                        
                        onSaved: (value)
                        {
                          _instaId = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left:vpW*0.05,right:vpW*0.05, top: vpH*0.005),
                      alignment: Alignment.topLeft,
                      child:Text('LinkedIn ID',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.005),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: linkedinIdController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: ' Enter LinkedIn ID',
                          hintStyle: kHintTextStyle,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(SocialMedia.linkedin),
                          ),
                        ),
                        
                        onSaved: (value)
                        {
                          _linkedinId = value;
                        },
                      ),
                    ),
                  
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.002),
                      alignment: Alignment.topLeft,
                      child:Text('Quote',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.002),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: quoteController,
                        maxLength: 50,
                        maxLengthEnforced: true,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: 'Quote',
                          hintStyle: kHintTextStyle,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.format_quote),
                          ),
                        ),
                        onSaved: (value)
                        {
                          _quote = value;
                        },
                      ),
                    ),
                    Container(
                      width: vpW*0.5,
                      padding: EdgeInsets.all(15),
                      child:RaisedButton(
                        elevation: vpH*0.5,
                        onPressed: ()async{
                          if(filePicked){
                            await saveImg(file.readAsBytesSync(), fileName);
                          }
                          if (!_formKey.currentState.validate()) {
                            print("not valid");
                            return null;
                          }
                          else{
                            _formKey.currentState.save();
                            await updateUserProfile();
                            showDialog(  
                              context: context,  
                              builder: (BuildContext context) {  
                                return alert;  
                              },  
                            ); 
                          }
                           
                        },
                        padding: EdgeInsets.all(12),
                        shape:RoundedRectangleBorder(
                          borderRadius:BorderRadius.circular(30.0),
                        ),
                        color: Color(0xFFFF9C01),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: vpW*0.005,
                            fontSize: vpH*0.025,
                            fontWeight: FontWeight.bold,
                            
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                
          ),
        ),
      ),
    ),
  );
                      
  }
}