import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
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

class ProfileForm extends StatefulWidget {
  final ModelUser member;
  final void Function(ModelUser) callback;

  const ProfileForm({Key ?key,required this.member, required this.callback}) : super(key: key);
  @override
  _ProfileFormState createState() => _ProfileFormState(member);
}

class _ProfileFormState extends State<ProfileForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late ModelUser updatedUser;

  String _name = "";
  String _batch = "";
  String _branch = "";
  String _about = "";
  String _contact = "";
  String _interests = "";
  String _cvLink = "";
  String _fbId = "";
  String _instaId = "";
  String _linkedinId = "";
  String _position = "";
  String _quote = "";
  late bool _loading;
  bool filePicked = false;

  late UploadTask uploadTask;
  late File file;
  String _img = "";
  String fileName = '';
  final ModelUser _user;

  _ProfileFormState(this._user);
  // upload image

  Future getImage() async {
    setState(() async {
      var rng = new Random();
      String randomName = "";
      for (var i = 0; i < 20; i++) {
        randomName += rng.nextInt(100).toString();
      }

      await FilePicker.platform
          .pickFiles(type: FileType.image)
          .then((result) async {
        if (result != null) {
          filePicked = true;
          setState(() {
            file = File(result.files.first.path!);
          });
          fileName = '$randomName';
        }
      }).catchError((error) {
        print("Error: " + error.toString());
      });
    });
  }

  Future saveImg(List<int> asset, String name) async {
    Reference reference = FirebaseStorage.instance.ref().child(name);
    setState(() {
      uploadTask = reference.putData(Uint8List.fromList(asset));
    });
    _img = await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
  }

  Future<void> updateProfile(ModelUser user, BuildContext context) async {
    Map<String, dynamic> userObject = {
      'about': _about.isEmpty ? user.about : _about,
      'batch': _batch.isEmpty ? user.batch : _batch,
      'name': _name.isEmpty ? user.name : _name,
      'profileImageUrl': _img.isEmpty ? user.profileImageUrl : _img,
      'contact': _contact.isEmpty ? user.contact : _contact,
      'quote': _quote.isEmpty ? user.quote : _quote,
      'cvLink': _cvLink.isEmpty ? user.cvLink : _cvLink,
      'fbId': _fbId.isEmpty ? user.fbId : _fbId,
      'instaId': _instaId.isEmpty ? user.instaId : _instaId,
      'interests': _interests.isEmpty ? user.interests : _interests,
      'branch': _branch.isEmpty ? user.branch : _branch,
      'linkedinId': _linkedinId.isEmpty ? user.linkedinId : _linkedinId,
      'position': _position.isEmpty ? user.position : _position,
    };
    userObject['isAdmin'] = widget.member.isAdmin;
    userObject['uid'] = widget.member.uid;
    userObject['email'] = widget.member.email;
    userObject['isMember'] = widget.member.isMember;
    updatedUser = ModelUser.fromMap(userObject);

    FirebaseFirestore.instance
        .collection('/users')
        .doc(user.uid)
        .update(userObject)
        .then((value) => print("User Profile Updated"))
        .catchError((error) => print("Failed to update profile: $error"));
  }
  @override
  void initState() {
    super.initState();
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);

    // TextFormFiels styling
    final kHintTextStyle = TextStyle(
      color: Color(0xFF757575),
      fontSize: vpH * 0.024,
      fontFamily: 'OpenSans',
    );

    final kLabelStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: vpH * 0.025,
      fontFamily: 'OpenSans',
    );

    // alert after successful form submission
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: kLabelStyle,
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        if (updatedUser.uid ==
            Provider.of<UserProvider>(context, listen: false).getUser.uid) {
          Provider.of<UserProvider>(context, listen: false).setUser =
              updatedUser;
        } else {
          widget.callback(updatedUser);
        }
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text(
        "Save Changes",
        style: kLabelStyle,
      ),
      actions: [
        okButton,
      ],
    );

    return SafeArea(
      child: Scaffold(
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
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: vpH * 0.02,
                            left: vpW * 0.02,
                            right: vpW * 0.02,
                            bottom: vpH * 0.01),
                          child: file != null
                          ? Container(
                              width: vpW * 0.3,
                              height: vpH * 0.3,
                              child: Image.file(file),
                            )
                          : CircleAvatar(
                              radius: 80,
                              backgroundImage: _user.profileImageUrl.isEmpty
                              ? AssetImage('assets/img/teamMember.png')
                              : CachedNetworkImageProvider(
                                  _user.profileImageUrl,
                              ) as ImageProvider,
                            ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_a_photo,
                          size: vpH * 0.04,
                          color: Color(0xff7c56dc),
                        ),
                        onPressed: () async {
                          await getImage();
                        },
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: vpW * 0.05, right: vpW * 0.05, top: vpH * 0.02),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Name',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      initialValue: _user.name,
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
                        if (value!.isEmpty) {
                          return "Please enter name";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          _name = val;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: vpW * 0.05, right: vpW * 0.05, top: vpH * 0.005),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Position',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      initialValue: _user.position,
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
                        if (value!.isEmpty) {
                          return "Please enter position";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          _position = val;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: vpW * 0.05, right: vpW * 0.05, top: vpH * 0.002),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Batch',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.002),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      initialValue: _user.batch,
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
                      onChanged: (val) {
                        setState(() {
                          _batch = val;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: vpW * 0.05, right: vpW * 0.05, top: vpH * 0.002),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Branch',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.002),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      initialValue: _user.branch,
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
                      onChanged: (val) {
                        setState(() {
                          _branch = val;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: vpW * 0.05, right: vpW * 0.05, top: vpH * 0.002),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'About',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.002),
                    child: TextFormField(
                      initialValue: _user.about,
                      maxLines: null,
                      maxLength: 500,
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
                      onChanged: (val) {
                        setState(() {
                          _about = val;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: vpW * 0.05, right: vpW * 0.05, top: vpH * 0.002),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'CV Link',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.002),
                    child: TextFormField(
                      initialValue: _user.cvLink,
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
                      onChanged: (val) {
                        setState(() {
                          _cvLink = val;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.002),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Interests',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.002),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      initialValue: _user.interests,
                      maxLines: null,
                      maxLength: 200,
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
                      onChanged: (val) {
                        setState(() {
                          _interests = val;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: vpW * 0.05, right: vpW * 0.05, top: vpH * 0.002),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Contact No',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.002),
                    child: TextFormField(
                      maxLength: 10,
                      maxLengthEnforced: true,
                      initialValue: _user.contact,
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
                      onChanged: (val) {
                        setState(() {
                          _contact = val;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: vpW * 0.05, right: vpW * 0.05, top: vpH * 0.005),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Facebook Id',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    child: TextFormField(
                      initialValue: _user.fbId,
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
                      onChanged: (val) {
                        setState(() {
                          _fbId = val;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: vpW * 0.05, right: vpW * 0.05, top: vpH * 0.005),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Instagram ID',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    child: TextFormField(
                      initialValue: _user.instaId,
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
                      onChanged: (val) {
                        setState(() {
                          _instaId = val;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: vpW * 0.05, right: vpW * 0.05, top: vpH * 0.005),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'LinkedIn ID',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    child: TextFormField(
                      initialValue: _user.linkedinId,
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
                      onChanged: (val) {
                        setState(() {
                          _linkedinId = val;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.002),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Quote',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.002),
                    child: TextFormField(
                      initialValue: _user.quote,
                      maxLength: 100,
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
                      onChanged: (val) {
                        setState(() {
                          _quote = val;
                        });
                      },
                    ),
                  ),
                  _loading ?Container(
                    padding: EdgeInsets.all(15),
                    width: vpW * 0.5,
                    child: RaisedButton(
                      elevation: vpH * 0.5,
                      onPressed: () {} ,
                       padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Color(0xFFFF9C01),
                      child:  CircularProgressIndicator(),
                    )):
                  Container(
                    width: vpW * 0.5,
                    padding: EdgeInsets.all(15),
                    child: RaisedButton(
                      elevation: vpH * 0.5,
                      onPressed: () async {
                        setState(() {
                          _loading=true;
                        });
                        if (filePicked) {
                          await saveImg(file.readAsBytesSync(), 'users/${_user.name}/$fileName');
                        }
                        if (!_formKey.currentState!.validate()) {
                          print("not valid");
                          setState(() {
                            _loading=false;
                          });
                          return null;
                        } else {
                          _formKey.currentState.save();
                          await updateProfile(_user, context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        }
                      },
                      padding: EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Color(0xFFFF9C01),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: vpW * 0.005,
                          fontSize: vpH * 0.025,
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
