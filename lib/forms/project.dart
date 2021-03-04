import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:roboclub_flutter/screens/project_screen.dart';
import '../helper/dimensions.dart';
import '../widgets/appBar.dart';
import '../services/project.dart';
import 'package:intl/intl.dart';

class ProjectForm extends StatefulWidget {
  @override
  _ProjectFormState createState() => _ProjectFormState();
}

var vpH;
var vpW;

// TextFormFiels styling

final kHintTextStyle = TextStyle(
  color: Color(0xFF757575),
  fontSize: vpH * 0.022,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontSize: vpH * 0.025,
  fontFamily: 'OpenSans',
);

class _ProjectFormState extends State<ProjectForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  List<dynamic> dynamicList = [];
  String _projectName;
  String _description;
  String _date;
  String _link = "";
  String _fileUrl = "";
  List<dynamic> _imageUrls = List();
  List<File> imageList = List();
  List<dynamic> _teamMembers = List();
  String dropdownValue = '1';

  String fileName = '';
  String pdfFileName = '';
  File pdfFile;

  bool imagePicked = false;
  bool filePicked = false;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final projectImgController = TextEditingController();
  final linkController = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController _teamMember = new TextEditingController();
  // TextEditingController memberName = new TextEditingController();

  // upload image
  Future getImage() async {
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      randomName += rng.nextInt(100).toString();
    }

    FilePickerResult result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image)
        .then((result) async {
      if (result != null) {
        imagePicked = true;
        imageList = result.paths.map((path) => File(path)).toList();
        print(imageList.length);
        fileName = '$randomName';
      }
    }).catchError((error) {
      print("Error: " + error.toString());
    });
  }

  Future postImages(List<File> imageList, String name) async {
    for (int i = 0; i < imageList.length; i++) {
      final StorageReference storageReference =
          FirebaseStorage().ref().child("$name$i");
      final StorageUploadTask uploadTask =
          storageReference.putFile(imageList[i]);
      String url = await (await uploadTask.onComplete).ref.getDownloadURL();
      _imageUrls.add(url);
    }
    print(_imageUrls);
    print("Images posted");
  }

  // upload pdf

  Future getPdfAndUpload() async {
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      randomName += rng.nextInt(100).toString();
    }
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc']).then((result) async {
      if (result != null) {
        filePicked = true;
        pdfFile = File(result.files.single.path);
        pdfFileName = '$randomName.pdf';
      }
    }).catchError((error) {
      print("Error: " + error.toString());
    });
  }

  Future savePdf(List<int> asset, String name) async {
    StorageReference reference = FirebaseStorage.instance.ref().child(name);
    StorageUploadTask uploadTask = reference.putData(asset);
    _fileUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(_fileUrl);
  }

  void addMember(String member, String linkedinId) {
    Map<String, String> obj = {
      'member': member,
      'linkedinId': linkedinId,
    };
    _teamMembers.add(obj);
  }

  Widget memberField(int index) {
    return DynamicWidget(callback: addMember);
  }

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
    var projects = ProjectService();

    // alert after successful form submission
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: kLabelStyle,
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text(
        "Project added Successfully !!",
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
          strTitle: "Update Projects",
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
                Color(0xFF9FA8DA),
                Color(0xFF7986CB),
                Color(0xFF5C6BC0),
              ],
              stops: [0.1, 0.4, 0.7, 0.9],
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
                        left: vpW * 0.05, right: vpW * 0.05, top: vpH * 0.02),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Project Name',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.01),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: nameController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: vpH * 0.02,
                      ),
                      decoration: InputDecoration(
                        fillColor: Color(0xFFE8EAF6),
                        hintText: 'Enter Project Name',
                        hintStyle: kHintTextStyle,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter name";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _projectName = value;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Description',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.01),
                    child: TextFormField(
                      maxLines: 3,
                      textCapitalization: TextCapitalization.words,
                      controller: descriptionController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: vpH * 0.02,
                      ),
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        fillColor: Color(0xFFE8EAF6),
                        hintText: 'Enter Description',
                        hintStyle: kHintTextStyle,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _description = value;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Text(
                          'Pick an Image',
                          style: kLabelStyle,
                        ),
                        IconButton(
                          icon: Icon(Icons.add_a_photo),
                          onPressed: () {
                            getImage();
                          },
                        ),
                        fileName.isEmpty
                            ? Text('No Image Selected.',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: vpH * 0.02,
                                    fontWeight: FontWeight.bold))
                            : Text('${imageList.length}: Images Selected.',
                                style: TextStyle(
                                    color: Colors.limeAccent[400],
                                    fontSize: vpH * 0.02,
                                    fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Text(
                          'Upload PDF',
                          style: kLabelStyle,
                        ),
                        IconButton(
                          icon: Icon(Icons.upload_file),
                          onPressed: () {
                            getPdfAndUpload();
                          },
                        ),
                        pdfFileName.isEmpty
                            ? Text('No File Selected.',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: vpH * 0.02,
                                    fontWeight: FontWeight.bold))
                            : Text('File Selected.',
                                style: TextStyle(
                                    color: Colors.limeAccent[400],
                                    fontSize: vpH * 0.02,
                                    fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Project Link',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.01),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: linkController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: vpH * 0.02,
                      ),
                      decoration: InputDecoration(
                        fillColor: Color(0xFFE8EAF6),
                        hintText: 'Attach Project Link',
                        hintStyle: kHintTextStyle,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onSaved: (value) {
                        _link = value;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Date',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.01),
                    child: TextFormField(
                      controller: date,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: vpH * 0.02,
                      ),
                      decoration: InputDecoration(
                        fillColor: Color(0xFFE8EAF6),
                        hintText: 'Pick a Date',
                        hintStyle: kHintTextStyle,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.calendar_today),
                        ),
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        DateTime dateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1990),
                          lastDate: DateTime(2030),
                        );

                        DateFormat formatter = DateFormat('yyyy-MM-dd');
                        String formatted = formatter.format(dateTime);
                        print(formatted);
                        date.text = formatted;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please select date';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        _date = value;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    alignment: Alignment.topLeft,
                    child: Text('Team Members', style: kLabelStyle),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.01),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButton<String>(
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        dropdownColor: Color(0xFFE8EAF6),
                        value: dropdownValue,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>[
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9',
                          '10'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: Text('Select Team Size'),
                      ),
                    ),
                  ),
                  for (int i = 0; i < int.parse(dropdownValue); i++)
                    memberField(i),
                  Container(
                    padding: EdgeInsets.all(15),
                    width: vpW * 0.5,
                    child: RaisedButton(
                      elevation: vpH * 0.5,
                      onPressed: () async {
                        if (filePicked) {
                          await savePdf(pdfFile.readAsBytesSync(), pdfFileName);
                        }
                        if (imagePicked) {
                          await postImages(imageList, fileName);
                        }
                        // await Future.wait([savePdf(pdfFile.readAsBytesSync(), pdfFileName),postImages(imageList,fileName)]);
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          projects.postProjects(
                            link: _link,
                            description: _description,
                            name: _projectName,
                            projectImg: _imageUrls,
                            date: _date,
                            fileUrl: _fileUrl,
                            teamMembers: _teamMembers,
                          );
                          print("saved");
                          nameController.clear();
                          descriptionController.clear();
                          projectImgController.clear();
                          linkController.clear();

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        } else {
                          print("not valid");
                          return null;
                        }
                      },
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Color(0xFFFF9C01),
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: vpW * 0.005,
                          fontSize: vpH * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DynamicWidget extends StatelessWidget {
  final TextEditingController _teamMember = new TextEditingController();
  final TextEditingController _linkedinId = new TextEditingController();
  final void Function(String, String) callback;

  DynamicWidget({Key key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: vpH * 0.005, horizontal: vpW * 0.05),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: vpW * 0.9,
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: TextFormField(
                  controller: _teamMember,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter name";
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: vpH * 0.02,
                  ),
                  decoration: InputDecoration(
                    fillColor: Color(0xFFE8EAF6),
                    hintText: 'Member Name',
                    hintStyle: kHintTextStyle,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onSaved: (newValue) {},
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: vpW * 0.9,
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: TextFormField(
                  controller: _linkedinId,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: vpH * 0.02,
                  ),
                  decoration: InputDecoration(
                    fillColor: Color(0xFFE8EAF6),
                    hintText: 'Linkedin Id',
                    hintStyle: kHintTextStyle,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onSaved: (newValue) {
                    callback(_teamMember.text, _linkedinId.text);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
