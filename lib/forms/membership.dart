import 'dart:io';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:roboclub_flutter/configs/remoteConfig.dart';
import 'package:roboclub_flutter/services/auth.dart';
import 'package:roboclub_flutter/services/email.dart';
import 'package:roboclub_flutter/services/member.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import '../helper/dimensions.dart';
import '../widgets/appBar.dart';

class Membership extends StatefulWidget {
  @override
  _MembershipState createState() => _MembershipState();
}

class _MembershipState extends State<Membership> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _email;
  late String _enrollNo;
  late String _facultyNo;
  bool isPaid = false;
  String? _mobileNo, _collegeName, _course, _yearOfStudy;
  late bool _loading;
  File? file;
  bool filePicked = false;
  String _img = "";

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final enrollController = TextEditingController();
  final facultyNoController = TextEditingController();
  final mobileNoController = TextEditingController();
  final collegeNameController = TextEditingController();
  final courseController = TextEditingController();
  final yearOfStudyController = TextEditingController();

  // upload image

  Future getImage() async {
    await FilePicker.platform
        .pickFiles(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'png', 'pdf'],
            allowCompression: true)
        .then((result) async {
      if (result != null) {
        filePicked = true;
        setState(() {
          file = File(result.paths.first!);
        });
      } else {
        file = null;
      }
    }).catchError((error) {
      print("Error: " + error.toString());
    });
  }

  Future saveImg(List<int> asset, String name) async {
    Reference reference = FirebaseStorage.instance.ref().child(name);
    UploadTask uploadTask = reference.putData(Uint8List.fromList(asset));
    _img =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
  }

  // get email

  Future<String?> getEmail() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    return googleSignInAccount?.email;
  }

  // List of courses in our dropdown menu
  var courses = [
    // "Enter Course Name",
    'B.Tech',
    'B.Sc.',
    'BCA',
    'M.Sc.',
    'M.Tech',
    'Polytechnic',
    'BE',
    
  ];
  var years = [
    '1st',
    '2nd',
    '3rd',
    '4th',
    '5th',
  ];
  bool isPayOpen = false;

  @override
  void initState() {
   
    // _course = "Enter Course Name";
    super.initState();
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    var members = MemberService();

    // TextFormFiels styling

    final kHintTextStyle = TextStyle(
      color: Color(0xFF757575),
      fontSize: vpH * 0.018,
      fontFamily: 'OpenSans',
    );

    final kLabelStyle = TextStyle(
      // color: Theme.of(context).primaryColor,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontSize: vpH * 0.02,
      fontFamily: 'OpenSans',
    );

    final formPadding = EdgeInsets.only(
      left: vpW * 0.05,
      right: vpW * 0.05,
      bottom: vpH * 0.008,
      top: 0.008,
    );
    final containerPadding = EdgeInsets.only(
      left: vpW * 0.05,
      right: vpW * 0.05,
      bottom: vpH * 0.008,
      top: 0.015,
    );
    InputDecoration formField = InputDecoration(
      // fillColor: Color(0xFFE8EAF6),
      fillColor: Colors.white,
      hintStyle: kHintTextStyle,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.white)),
    );

//     // alert after successful form submission
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: kLabelStyle,
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop({"success": true});
      },
    );

    Widget okButton1 = TextButton(
      child: Text(
        "OK",
        style: kLabelStyle,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text(
        "Membership form Submitted Successfully. Check your mail for confirmation",
        style: kLabelStyle,
      ),
      actions: [
        okButton,
      ],
    );

    AlertDialog fileAlert = AlertDialog(
      content: Text(
        "Select ID Proof",
        style: kLabelStyle,
      ),
      actions: [
        okButton1,
      ],
    );
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: appBar(
          context,
          strTitle: "Registration Details",
          isDrawer: false,
          isNotification: false,
          scaffoldKey: _scaffoldKey,
        ),
        backgroundColor: Color(0xFFC5CAE9),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFC5CAE9),
              ],
              stops: [0.1],
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        left: vpW * 0.05,
                        right: vpW * 0.05,
                        top: vpH * 0.02,
                        bottom: vpH * 0.008),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Name',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: formPadding,
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: nameController,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: formField.copyWith(hintText: " Enter Name"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter name";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _name = value!;
                      },
                    ),
                  ),
                  Container(
                    padding: containerPadding,
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Email',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: formPadding,
                    child: TextFormField(
                      maxLines: null,
                      textCapitalization: TextCapitalization.words,
                      controller: emailController,
                      onTap: () {
                        getEmail().then((value) {
                          emailController.text = value == null ? "" : value;
                          googleSignIn.signOut();
                        });
                      },
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: formField.copyWith(hintText: "Enter Email"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter valid email id';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                  ),
                  Container(
                    padding: containerPadding,
                    alignment: Alignment.topLeft,
                    child: Text(
                      'College',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: formPadding,
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: collegeNameController,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                      ),
                      keyboardType: TextInputType.text,
                      decoration:
                          formField.copyWith(hintText: "Enter College Name"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your College';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _collegeName = value!;
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: containerPadding,
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Course',
                                style: kLabelStyle,
                              ),
                            ),
                            Padding(
                              padding: formPadding,
                              child: FormField<String>(
                                // key:_formKey,

                                builder: (FormFieldState<String> state) {
                                  return InputDecorator(
                                    decoration: formField.copyWith(
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        hintText: "Enter Course Name"),
                                    isEmpty: courses == [],
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        hint: Text(
                                          "Course name",
                                          style: TextStyle(fontSize: 12),
                                          // maxLines: 1,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        value: _course,
                                        isDense: true,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _course = newValue!;
                                            state.didChange(newValue);
                                          });
                                        },
                                        items: courses.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: containerPadding,
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Year Of Study',
                                style: kLabelStyle,
                              ),
                            ),
                            Padding(
                              padding: formPadding,
                              child: FormField<String>(
                                builder: (FormFieldState<String> state) {
                                  return InputDecorator(
                                    decoration: formField.copyWith(
                                        hintText: "Enter year of study"),
                                    isEmpty: years == [],
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        hint: Text(
                                          "Course year",
                                          maxLines: 1,
                                          style: TextStyle(fontSize: 12),
                                          overflow: TextOverflow.clip,
                                        ),
                                        value: _yearOfStudy,
                                        isDense: true,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _yearOfStudy = newValue!;
                                            state.didChange(newValue);
                                          });
                                        },
                                        items: years.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: containerPadding,
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Enrollment Number',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: formPadding,
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: enrollController,
                      maxLength: 6,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                      ),
                      keyboardType: TextInputType.text,
                      decoration:
                          formField.copyWith(hintText: "Enter Enrollment No"),
                      validator: (value) {
                        if (value!.isNotEmpty && value.length != 6) {
                          return 'Please enter valid Enrollment No';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enrollNo = value!;
                      },
                    ),
                  ),
                  Container(
                    padding: containerPadding,
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Faculty Number',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: formPadding,
                    child: TextFormField(
                      maxLength: 10,
                      textCapitalization: TextCapitalization.words,
                      controller: facultyNoController,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                      ),
                      keyboardType: TextInputType.text,
                      decoration:
                          formField.copyWith(hintText: "Enter Faculy No."),
                      onSaved: (value) {
                        _facultyNo = value!;
                      },
                    ),
                  ),
                  Container(
                    padding: containerPadding,
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Mobile Number',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: formPadding,
                    child: TextFormField(
                      maxLength: 10,
                      textCapitalization: TextCapitalization.words,
                      controller: mobileNoController,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                      ),
                      keyboardType: TextInputType.phone,
                      decoration:
                          formField.copyWith(hintText: "Enter Mobile No"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your mobile number';
                        } else if (value.length < 10) {
                          return "Please enter valid mobile number";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _mobileNo = value!;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: vpW * 0.05,
                      vertical: vpH * 0.005,
                    ),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: FittedBox(
                            child: Text(
                              'Pick your ID Proof\n(Admit card, ID card, etc)',
                              style: kLabelStyle,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_a_photo),
                          onPressed: () {
                            getImage();
                          },
                        ),
                        file == null
                            ? Text(
                                'File not Selected.',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: vpH * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                'File Selected.',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: vpH * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                      ],
                    ),
                  ),
                  _loading
                      ? Container(
                          padding: EdgeInsets.all(15),
                          width: vpW * 0.5,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                            elevation: vpH * 0.5,
                          
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            primary: Theme.of(context).primaryColor,
                            ),
                              onPressed: () {},
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(15),
                          width: vpW * 0.5,
                          child: ElevatedButton(

                            style: ElevatedButton.styleFrom(
                            elevation: vpH * 0.5,

                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            primary: Theme.of(context).primaryColor,
                            ),
                            onPressed: () async {
                              setState(() {
                                _loading = true;
                              });

                              if (!_formKey.currentState!.validate()) {
                                print("not valid");
                                setState(() {
                                  _loading = false;
                                });
                                return null;
                              } else {
                                if (_course == null || _course!.isEmpty) {
                                  setState(() {
                                    _loading = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: "Enter course name");
                                  return;
                                } else if (_yearOfStudy == null ||
                                    _yearOfStudy!.isEmpty) {
                                  setState(() {
                                    _loading = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: "Enter course year");
                                }

                                if (filePicked) {
                                  await saveImg(
                                    file!.readAsBytesSync(),
                                    'registeredMembers/${nameController.text}_${mobileNoController.text}',
                                  );
                                  _formKey.currentState!.save();
                                  members.postMember(
                                    enrollNo: _enrollNo,
                                    email: _email,
                                    name: _name,
                                    facultyNo: _facultyNo,
                                    fileUrl: _img,
                                    course: _course,
                                    collegeName: _collegeName,
                                    yearOfStudy: _yearOfStudy,
                                    mobileNo: _mobileNo,
                                    dateOfReg: DateTime.now(),
                                  );
                                  print("saved");
                                  EmailService().sendRegistrationEmail(
                                      recipent: emailController.text,
                                      payment: false,
                                      username: "",
                                      pdf: null);
                                  nameController.clear();
                                  emailController.clear();
                                  enrollController.clear();
                                  facultyNoController.clear();
                                  mobileNoController.clear();
                                  collegeNameController.clear();
                                  courseController.clear();
                                  yearOfStudyController.clear();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return fileAlert;
                                    },
                                  );
                                }
                                setState(() {
                                  _loading = false;
                                });
                              }
                            },
                           
                            child: Text(
                              "Submit",
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
