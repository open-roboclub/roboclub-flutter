import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:roboclub_flutter/models/project.dart';
import '../helper/dimensions.dart';
import '../widgets/appBar.dart';
import '../services/project.dart';
import 'package:intl/intl.dart';

class ProjectForm extends StatefulWidget {

  final Project project;
  final bool editMode;
  final void Function(Project) callback;

  const ProjectForm({Key key, this.project, this.editMode, this.callback}) : super(key: key);
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

  String _projectName="";
  String _description="";
  String _date="";
  String _link = "";
  String _fileUrl = "";
  String fileName = '';
  String pdfFileName = '';
  File pdfFile;
  List<dynamic> dynamicList = [];
  List<dynamic> _imageUrls = List();
  List<File> imageList = List();
  List<dynamic> _teamMembers = List();
  String dropdownValue = '1';
  bool imagePicked = false;
  bool filePicked = false;
  bool dateUPdated=false;
  StorageUploadTask uploadTask;
  StorageUploadTask pdfUploadTask;
  String url ="";
  DateTime dateTime;
  
  // upload image
  Future getImage() async {
    setState(() async{
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
          });
          fileName = '$randomName';
        }
      }).catchError((error) {
        print("Error: " + error.toString());
      });
    });
  }

  Future postImages(List<File> imageList, String name) async {
    for (int i = 0; i < imageList.length; i++) {
      StorageReference storageReference =
          FirebaseStorage().ref().child("$name$i");
      setState(() {
        uploadTask = storageReference.putFile(imageList[i]);
      });
      url = await (await uploadTask.onComplete).ref.getDownloadURL();
      _imageUrls.add(url);
    }
  }

  // upload pdf

  Future getPdfAndUpload() async {
    setState(() async{
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
          });

          pdfFileName = '$randomName.pdf';
        }
      }).catchError((error) {
        print("Error: " + error.toString());
      });
    });
    
  }

  Future savePdf(List<int> asset, String name) async {
    StorageReference reference = FirebaseStorage.instance.ref().child(name);
    setState(() {
      pdfUploadTask = reference.putData(asset);
    });
    _fileUrl = await (await pdfUploadTask.onComplete).ref.getDownloadURL();
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


  Future<void> updateProject(Project project, BuildContext context) async {
    print("updateProject entered");
    // widget.callback(updatedProject);
    if(_date.isEmpty){ 
      String dateStr = project.date;
      final formatter = DateFormat('MMM dd, yyyy');
      final dateTimeFromStr = formatter.parse(dateStr);
      project.date =DateFormat('yyyy-MM-dd').format(dateTimeFromStr);
    }
    Map<String, dynamic> projectObject = {
      'name': _projectName.isEmpty ? project.name: _projectName,
      'projectImg': _imageUrls.isEmpty ? project.projectImg: _imageUrls,
      'description': _description.isEmpty ? project.description : _description,
      'date': _date.isEmpty ? project.date : _date,
      'fileUrl': _fileUrl.isEmpty ? project.fileUrl : _fileUrl,
      'link': _link.isEmpty ? project.link : _link,
    };
    updatedProject = Project.fromMap(projectObject);
    String id;
      Firestore.instance.collection('/projects').getDocuments().then((projects) {
        projects.documents.forEach((project) {
          if (project['name'] == widget.project.name) {
            print(project['name']);
            id = project.documentID;
            return Firestore.instance
              .collection('/projects')
              .document(id)
              .updateData(projectObject)
              .then((value) => print("Project Updated"))
              .catchError((error) => print("Failed to update project: $error"));
          }
        });
      });
    
  }

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
    var projects = ProjectService();

    TextEditingController date = TextEditingController();
    
    setState(() {
      final dateStr = widget.project.date;
      final formatter = DateFormat('MMM dd, yyyy');
      final dateTimeFromStr = formatter.parse(dateStr);
      String currDate =DateFormat('yyyy-MM-dd').format(dateTimeFromStr);
      print(currDate);
      date.text=widget.editMode ? _date=="" ? currDate :_date : _date;      
    });
    // alert after successful form submission
    Widget okButton = FlatButton(
                      
      child: Text(
        "OK",
        style: kLabelStyle,
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        widget.callback(updatedProject);
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
                      initialValue: widget.editMode ? widget.project.name : _projectName,
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
                      initialValue: widget.editMode? widget.project.description : _description,
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
                        ? widget.project.projectImg.isEmpty 
                          ? Text('No Image Selected.',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: vpH * 0.02,
                                fontWeight: FontWeight.bold),
                          ) 
                          : Text('${widget.project.projectImg.length}: Images Selected.',
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
                          : Text('${imageList.length}: Images Selected.',
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
                        ? widget.project.fileUrl.isEmpty 
                          ? Text('No File Selected.',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: vpH * 0.02,
                                fontWeight: FontWeight.bold),
                          )
                          :Text('File Selected.',
                            style: TextStyle(
                              color: Colors.limeAccent[400],
                              fontSize: vpH * 0.02,
                              fontWeight: FontWeight.bold,
                            )
                          )
                        :  pdfFile == null
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
                            )
                          )
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
                      initialValue:widget.editMode ? widget.project.link : _link,
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
                          setState(() async{
                            dateTime = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1990),
                              lastDate: DateTime(2030),
                            );
                            
                            DateFormat formatter = DateFormat('yyyy-MM-dd');
                            String formatted = formatter.format(dateTime);
                            print(formatted);
                            _date = formatted;
                            date.text=formatted;
                            dateUPdated=true;
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
                          print(_date);
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
                        value: widget.editMode ? widget.project.teamMembers.length.toString() : dropdownValue,
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
                          await savePdf(pdfFile.readAsBytesSync(), 'projects/${widget.project.name}/$pdfFileName');
                        }
                        if (imagePicked) {
                          await postImages(imageList, 'projects/${widget.project.name}/$fileName');
                        }
                        if (!_formKey.currentState.validate()){
                          print("not valid");
                          return null;
                        }
                        else {
                           if(widget.editMode){
                            _formKey.currentState.save();
                            await updateProject(widget.project, context);
                          }
                          else{
                            _formKey.currentState.save();
                            await projects.postProjects(
                              link: _link,
                              description: _description,
                              name: _projectName,
                              projectImg: _imageUrls,
                              date: _date,
                              fileUrl: _fileUrl,
                              teamMembers: _teamMembers,
                              progress: "",
                            );
                          }
                          print("saved");
                          // nameController.clear();
                          // descriptionController.clear();
                          // projectImgController.clear();
                          // linkController.clear();

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
                      child: Text( widget.editMode
                        ? "Update" 
                        :"Create",
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
                  // validator: (value) {
                  //   if (value.isEmpty) {
                  //     return "Please enter name";
                  //   }
                  //   return null;
                  // },
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
                  onChanged: (newValue) {},
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
                  onChanged: (newValue) {
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
