import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:roboclub_flutter/models/project.dart';
import '../helper/dimensions.dart';
import '../widgets/appBar.dart';
import '../services/project.dart';
import 'package:intl/intl.dart';

class ProjectForm extends StatefulWidget {
  final Project currproject;
  final bool editMode;
  final String genericDate;
  final void Function(Project) callback;

  const ProjectForm(
      {Key key,
      this.currproject,
      this.editMode,
      this.genericDate,
      this.callback})
      : super(key: key);
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
  Project updatedProject;
  Project newProject;

  String _projectName = "";
  String _description = "";
  String _date = "";
  String _link = "";
  String _fileUrl = "";
  String fileName = '';
  String pdfFileName = '';
  File pdfFile;
  int imgFiles = 0;
  List<dynamic> dynamicList = [];
  List<dynamic> _imageUrls = List();
  List<File> imageList = List();
  List<dynamic> _teamMembers = List();
  String dropdownValue = '1';
  bool imagePicked = false;
  bool _loading;
  bool filePicked = false;
  bool showPdf = false;
  bool showImg = false;
  StorageUploadTask uploadTask;
  StorageUploadTask pdfUploadTask;
  String url = "";
  DateTime dateTime;
  TextEditingController date = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final TextEditingController _teamMember1 = new TextEditingController();
  final TextEditingController _linkedinId1 = new TextEditingController();
  final TextEditingController _teamMember2 = new TextEditingController();
  final TextEditingController _linkedinId2 = new TextEditingController();
  final TextEditingController _teamMember3 = new TextEditingController();
  final TextEditingController _linkedinId3 = new TextEditingController();
  final TextEditingController _teamMember4 = new TextEditingController();
  final TextEditingController _linkedinId4 = new TextEditingController();
  final TextEditingController _teamMember5 = new TextEditingController();
  final TextEditingController _linkedinId5 = new TextEditingController();
  final TextEditingController _teamMember6 = new TextEditingController();
  final TextEditingController _linkedinId6 = new TextEditingController();
  final TextEditingController _teamMember7 = new TextEditingController();
  final TextEditingController _linkedinId7 = new TextEditingController();
  final TextEditingController _teamMember8 = new TextEditingController();
  final TextEditingController _linkedinId8 = new TextEditingController();
  final TextEditingController _teamMember9 = new TextEditingController();
  final TextEditingController _linkedinId9 = new TextEditingController();
  final TextEditingController _teamMember10 = new TextEditingController();
  final TextEditingController _linkedinId10 = new TextEditingController();
  final TextEditingController _teamMember11 = new TextEditingController();
  final TextEditingController _linkedinId11 = new TextEditingController();
  final TextEditingController _teamMember12 = new TextEditingController();
  final TextEditingController _linkedinId12 = new TextEditingController();
  final TextEditingController _teamMember13 = new TextEditingController();
  final TextEditingController _linkedinId13 = new TextEditingController();
  final TextEditingController _teamMember14 = new TextEditingController();
  final TextEditingController _linkedinId14 = new TextEditingController();
  final TextEditingController _teamMember15 = new TextEditingController();
  final TextEditingController _linkedinId15 = new TextEditingController();
  final TextEditingController _teamMember16 = new TextEditingController();
  final TextEditingController _linkedinId16 = new TextEditingController();
  final TextEditingController _teamMember17 = new TextEditingController();
  final TextEditingController _linkedinId17 = new TextEditingController();
  final TextEditingController _teamMember18 = new TextEditingController();
  final TextEditingController _linkedinId18 = new TextEditingController();
  final TextEditingController _teamMember19 = new TextEditingController();
  final TextEditingController _linkedinId19 = new TextEditingController();
  final TextEditingController _teamMember20 = new TextEditingController();
  final TextEditingController _linkedinId20 = new TextEditingController();
  final TextEditingController _teamMember21 = new TextEditingController();
  final TextEditingController _linkedinId21 = new TextEditingController();
  final TextEditingController _teamMember22 = new TextEditingController();
  final TextEditingController _linkedinId22 = new TextEditingController();
  final TextEditingController _teamMember23 = new TextEditingController();
  final TextEditingController _linkedinId23 = new TextEditingController();
  final TextEditingController _teamMember24 = new TextEditingController();
  final TextEditingController _linkedinId24 = new TextEditingController();
  final TextEditingController _teamMember25 = new TextEditingController();
  final TextEditingController _linkedinId25 = new TextEditingController();
  List<TextEditingController> teamController;
  List<TextEditingController> linkedinController = [];

  @override
  void initState() {
    _loading = false;
    teamController = [
      _teamMember1,
      _teamMember2,
      _teamMember3,
      _teamMember4,
      _teamMember5,
      _teamMember6,
      _teamMember7,
      _teamMember8,
      _teamMember9,
      _teamMember10,
      _teamMember11,
      _teamMember12,
      _teamMember13,
      _teamMember14,
      _teamMember15,
      _teamMember16,
      _teamMember17,
      _teamMember18,
      _teamMember19,
      _teamMember20,
      _teamMember21,
      _teamMember22,
      _teamMember23,
      _teamMember24,
      _teamMember25
    ];
    linkedinController = [
      _linkedinId1,
      _linkedinId2,
      _linkedinId3,
      _linkedinId4,
      _linkedinId5,
      _linkedinId6,
      _linkedinId7,
      _linkedinId8,
      _linkedinId9,
      _linkedinId10,
      _linkedinId11,
      _linkedinId12,
      _linkedinId13,
      _linkedinId14,
      _linkedinId15,
      _linkedinId16,
      _linkedinId17,
      _linkedinId18,
      _linkedinId19,
      _linkedinId20,
      _linkedinId21,
      _linkedinId22,
      _linkedinId23,
      _linkedinId24,
      _linkedinId25
    ];
    if (widget.editMode) {
      date.text = widget.genericDate;
      showPdf = widget.currproject.fileUrl.isNotEmpty;
      dropdownValue = widget.currproject.teamMembers.length.toString();
      imgFiles = widget.currproject.projectImg.length;
      showImg = widget.currproject.projectImg.isNotEmpty;
    }
    super.initState();
  }

  // upload image
  Future getImage() async {
    setState(() {
      showImg = false;
    });
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      randomName += rng.nextInt(100).toString();
    }
    await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image)
        .then((result) async {
      if (result != null) {
        imagePicked = true;
        setState(() {
          imageList = result.paths.map((path) => File(path)).toList();
          imgFiles = imageList.length;
        });
        fileName = '$randomName';
        setState(() {
          showImg = true;
        });
      }
    }).catchError((error) {
      print("Error: " + error.toString());
    });
  }

  Future postImages(List<File> imageList, String name) async {
    for (int i = 0; i < imageList.length; i++) {
      StorageReference storageReference =
          FirebaseStorage().ref().child("$name$i");
      uploadTask = storageReference.putFile(imageList[i]);
      url = await (await uploadTask.onComplete).ref.getDownloadURL();
      _imageUrls.add(url);
    }
    if (widget.editMode) {
      widget.currproject.projectImg = _imageUrls;
    }
  }

  // upload pdf

  Future getPdfAndUpload() async {
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      randomName += rng.nextInt(100).toString();
    }
    await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc']).then((result) async {
      if (result != null) {
        filePicked = true;
        setState(() {
          pdfFile = File(result.files.single.path);
          showPdf = true;
        });
        pdfFileName = '$randomName.pdf';
      }
    }).catchError((error) {
      print("Error: " + error.toString());
    });
  }

  Future savePdf(List<int> asset, String name) async {
    StorageReference reference = FirebaseStorage.instance.ref().child(name);
    pdfUploadTask = reference.putData(asset);
    _fileUrl = await (await pdfUploadTask.onComplete).ref.getDownloadURL();
  }

  Widget memberField(int index) {
    if (widget.editMode) {
      if (widget.currproject.teamMembers.length >= index + 1) {
        teamController[index].value = TextEditingValue(
            text: widget.currproject.teamMembers[index]['member'],
            selection: TextSelection.fromPosition(TextPosition(
                offset:
                    widget.currproject.teamMembers[index]['member'].length)));
        linkedinController[index].value = TextEditingValue(
            text: widget.currproject.teamMembers[index]['linkedinId'],
            selection: TextSelection.fromPosition(TextPosition(
                offset: widget
                    .currproject.teamMembers[index]['linkedinId'].length)));
      }
    }
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
                  controller: teamController[index],
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
                  onChanged: (newValue) {
                    if (widget.editMode) {
                      widget.currproject.teamMembers[index]['member'] =
                          newValue;
                    }
                  },
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
                  controller: linkedinController[index],
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
                  onChanged: (newValue) {
                    if (widget.editMode) {
                      widget.currproject.teamMembers[index]['linkedinId'] =
                          newValue;
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> updateProject(Project project, BuildContext context) async {
    print("updateProject entered");
    Map<String, dynamic> projectObject = {
      'name': _projectName.isEmpty ? project.name : _projectName,
      'projectImg': project.projectImg,
      'description': _description.isEmpty ? project.description : _description,
      'fileUrl': _fileUrl.isEmpty ? project.fileUrl : _fileUrl,
      'link': _link.isEmpty ? project.link : _link,
      'date': _date.isEmpty ? widget.genericDate : _date,
      'teamMembers': _teamMembers,
    };
    updatedProject = Project.fromMap(projectObject);
    updatedProject.progress = project.progress;
    String id;
    Firestore.instance.collection('/projects').getDocuments().then((projects) {
      projects.documents.forEach((project) {
        if (project['name'] == widget.currproject.name) {
          id = project.documentID;
          return Firestore.instance
              .collection('/projects')
              .document(id)
              .updateData(projectObject)
              .then((value) {
            print("Project Updated");
            // widget.callback(updatedProject);
            // Navigator.of(context).pop();
          }).catchError((error) => print("Failed to update project: $error"));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);

    // alert after successful form submission
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: kLabelStyle,
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        if (widget.editMode) {
          widget.callback(updatedProject);
        } else {
          widget.callback(newProject);
        }
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text(
        widget.editMode
            ? "Project Updated Successfully!! "
            : "Project added Successfully !!",
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
          strTitle: widget.editMode ? "Update Project" : "Create Project",
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
                      initialValue: widget.editMode
                          ? widget.currproject.name
                          : _projectName,
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
                      onChanged: (value) {
                        setState(() {
                          _projectName = value;
                        });
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
                      maxLines: null,
                      textCapitalization: TextCapitalization.words,
                      initialValue: widget.editMode
                          ? widget.currproject.description
                          : _description,
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
                      onChanged: (value) {
                        setState(() {
                          _description = value;
                        });
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
                        widget.editMode
                            ? imgFiles == 0
                                ? Text(
                                    'No Image Selected.',
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: vpH * 0.02,
                                        fontWeight: FontWeight.bold),
                                  )
                                : showImg
                                    ? Text(
                                        '${imgFiles.toString()}: Images Selected.',
                                        style: TextStyle(
                                            color: Colors.limeAccent[400],
                                            fontSize: vpH * 0.02,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        'Picking Images....',
                                        style: TextStyle(
                                            color: Colors.limeAccent[400],
                                            fontSize: vpH * 0.02,
                                            fontWeight: FontWeight.bold),
                                      )
                            : imageList == null
                                ? Text('No Image Selected.',
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: vpH * 0.02,
                                        fontWeight: FontWeight.bold))
                                : Text(
                                    '${imageList.length}: Images Selected.',
                                    style: TextStyle(
                                        color: Colors.limeAccent[400],
                                        fontSize: vpH * 0.02,
                                        fontWeight: FontWeight.bold),
                                  )
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
                        widget.editMode
                            ? !showPdf
                                ? Text(
                                    'No File Selected.',
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: vpH * 0.02,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text('File Selected.',
                                    style: TextStyle(
                                      color: Colors.limeAccent[400],
                                      fontSize: vpH * 0.02,
                                      fontWeight: FontWeight.bold,
                                    ))
                            : pdfFile == null
                                ? Text('No File Selected.',
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: vpH * 0.02,
                                        fontWeight: FontWeight.bold))
                                : Text('File Selected.',
                                    style: TextStyle(
                                      color: Colors.limeAccent[400],
                                      fontSize: vpH * 0.02,
                                      fontWeight: FontWeight.bold,
                                    ))
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
                      initialValue:
                          widget.editMode ? widget.currproject.link : _link,
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
                      onChanged: (value) {
                        setState(() {
                          _link = value;
                        });
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
                        dateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1990),
                          lastDate: DateTime(2030),
                        );
                        setState(() {
                          DateFormat formatter = DateFormat('yyyy-MM-dd');
                          String formatted = formatter.format(dateTime);
                          print(formatted);
                          date.text = formatted;
                          print("2" + date.text);
                          _date = formatted;
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please select date';
                        }
                        return null;
                      },
                      onChanged: (String value) {
                        setState(() {
                          _date = value;
                          print(date.text);
                        });
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
                            _teamMembers = [];
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
                          '10',
                          '11',
                          '12',
                          '13',
                          '14',
                          '15',
                          '16',
                          '17',
                          '18',
                          '19',
                          '20',
                          '21',
                          '22',
                          '23',
                          '24',
                          '25',
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
                  _loading
                      ? Container(
                          padding: EdgeInsets.all(15),
                          width: vpW * 0.5,
                          child: RaisedButton(
                            elevation: vpH * 0.5,
                            onPressed: () {},
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Color(0xFFFF9C01),
                            child: CircularProgressIndicator(),
                          ))
                      : Container(
                          padding: EdgeInsets.all(15),
                          width: vpW * 0.5,
                          child: RaisedButton(
                            elevation: vpH * 0.5,
                            onPressed: () async {
                              setState(() {
                                _loading = true;
                              });
                              if (!_formKey.currentState.validate()) {
                                print("not valid");

                                setState(() {
                                  _loading = false;
                                });
                                return null;
                              } else {
                                for (int i = 0;
                                    i < int.parse(dropdownValue);
                                    i++) {
                                  _teamMembers.add({
                                    "member": teamController[i].text,
                                    "linkedinId": linkedinController[i].text
                                  });
                                }
                                if (_teamMembers.length == 0) {
                                  print(
                                      "Validation Error: No team member selected");

                                  setState(() {
                                    _loading = false;
                                  });
                                  return null;
                                }
                                if (imagePicked) {
                                  widget.editMode
                                      ? await postImages(imageList,
                                          'projects/${widget.currproject.name}/$fileName')
                                      : await postImages(imageList,
                                          'projects/$_projectName/$fileName');
                                } else {
                                  if (!widget.editMode) {
                                    print(
                                        "Validation Error: No image is picked");
                                    _teamMembers = [];

                                    setState(() {
                                      _loading = false;
                                    });
                                    return null;
                                  }
                                }
                                if (filePicked) {
                                  widget.editMode
                                      ? await savePdf(pdfFile.readAsBytesSync(),
                                          'projects/${widget.currproject.name}/$pdfFileName')
                                      : await savePdf(pdfFile.readAsBytesSync(),
                                          'projects/$_projectName/$pdfFileName');
                                }
                                _formKey.currentState.save();
                                if (widget.editMode) {
                                  await updateProject(
                                      widget.currproject, context);
                                } else {
                                  var projectService = ProjectService();
                                  await projectService.postProjects(
                                    link: _link,
                                    description: _description,
                                    name: _projectName,
                                    projectImg: _imageUrls,
                                    date: _date,
                                    fileUrl: _fileUrl,
                                    teamMembers: _teamMembers,
                                    progress: "",
                                  );

                                  Map<String, dynamic> newProjectObject = {
                                    'name': _projectName,
                                    'projectImg': _imageUrls,
                                    'description': _description,
                                    'fileUrl': _fileUrl,
                                    'link': _link,
                                    'date': _date,
                                    'teamMembers': _teamMembers,
                                    'progress': "",
                                  };
                                  newProject =
                                      Project.fromMap(newProjectObject);
                                  print("saved");
                                  // nameController.clear();
                                  // descriptionController.clear();
                                  // projectImgController.clear();
                                  // linkController.clear();

                                }

                                setState(() {
                                  _loading = false;
                                });
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              }
                            },
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Color(0xFFFF9C01),
                            child: Text(
                              widget.editMode ? "Update" : "Create",
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
