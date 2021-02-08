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


class _ProjectFormState extends State<ProjectForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();


  String _projectImg="";
  String _projectName;
  String _description;
  String _date;
  String _link="";
  String _fileUrl="";
 

  // List<String> _teamMembers;
  

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final projectImgController = TextEditingController();
  final linkController = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController fileController = TextEditingController();
  
  
  // upload image
  
  Future getImage()async{
    var rng = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    FilePickerResult result = await FilePicker.platform.pickFiles();
    File file = File(result.files.single.path);
    String fileName = '$randomName.png';
    print(fileName);
    print('${file.readAsBytesSync()}');
    saveImg(file.readAsBytesSync(), fileName);
  }
  Future saveImg(List<int> asset, String name) async {

  StorageReference reference = FirebaseStorage.instance.ref().child(name);
  StorageUploadTask uploadTask = reference.putData(asset);
  String url = await (await uploadTask.onComplete).ref.getDownloadURL();
  print(url);
  projectImgController.text = url;
  
}
  // upload pdf
  
  Future getPdfAndUpload()async{
    var rng = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    FilePickerResult result = await FilePicker.platform.pickFiles();
    File file = File(result.files.single.path);
    String fileName = '$randomName.pdf';
    print(fileName);
    print('${file.readAsBytesSync()}');
    savePdf(file.readAsBytesSync(), fileName);
  }
  Future savePdf(List<int> asset, String name) async {

  StorageReference reference = FirebaseStorage.instance.ref().child(name);
  StorageUploadTask uploadTask = reference.putData(asset);
  String url = await (await uploadTask.onComplete).ref.getDownloadURL();
  print(url);
  fileController.text = url;
  
}

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    var projects = ProjectService();

    // TextFormFiels styling 

    final kHintTextStyle = TextStyle(
      color: Color(0xFF757575),
      fontSize: vpH*0.022,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectScreen()));
      },  
    );

    AlertDialog alert = AlertDialog(  
      content: Text("Project added Successfully !!",style: kLabelStyle,),  
      actions: [  
        okButton,  
      ],  
    );  

    return SafeArea(
      child:Scaffold(
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
          height: double.infinity, width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFC5CAE9),
                Color(0xFF9FA8DA),
                Color(0xFF7986CB),
                Color(0xFF5C6BC0),
              ],
              stops: [0.1, 0.4, 0.7, 0.9],
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key:_formKey,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[   
                    Container(
                      padding: EdgeInsets.only(left:vpW*0.05,right:vpW*0.05, top: vpH*0.02),
                      alignment: Alignment.topLeft,
                      child:Text('Project Name',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: nameController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: vpH*0.02,
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
                        onSaved: (value)
                        {
                          _projectName = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.005),
                      alignment: Alignment.topLeft,
                      child:Text('Description',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      child: TextFormField(
                        maxLines: 3,
                        textCapitalization: TextCapitalization.words,
                        controller: descriptionController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: vpH*0.02,
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
                        onSaved: (value)
                        {
                           _description = value;
                        },
                      ),
                    ),
                   
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.005),
                      alignment: Alignment.topLeft,
                      child:Text('Project Link',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: linkController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: vpH*0.02,
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: 'Attach Project Link',
                          hintStyle: kHintTextStyle,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                  
                        onSaved: (value)
                        {
                          _link = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.005),
                      alignment: Alignment.topLeft,
                      child:Text('Date',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      child:TextFormField(
                        controller: date,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: vpH*0.02,
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
                            lastDate:DateTime(2030),
                          );
                         
                          DateFormat formatter = DateFormat('yyyy-MM-dd');
                          String formatted = formatter.format(dateTime);
                          print(formatted);
                          date.text = formatted;
                         
                        },
                        onSaved: (String value)
                        {
                          _date = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.005),
                      alignment: Alignment.topLeft,
                      child:Row(children:[
                        Text('Pick an Image',style: kLabelStyle,),
                        IconButton(icon: Icon(Icons.add_a_photo),
                        onPressed: (){
                          getImage();
                        },)
                      ],),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.005),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: projectImgController,
                          onSaved: (String value) {
                            _projectImg = value;
                            
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: vpH*0.02,
                          ),
                          decoration: InputDecoration(
                            fillColor: Color(0xFFE8EAF6),
                            hintText: 'No Image Selected',
                            hintStyle: kHintTextStyle,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                           
                          ),    
                         
                        ),
                    
                    ),  
                    
                     Container(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.005),
                      alignment: Alignment.topLeft,
                      child:Row(children:[
                        Text('Upload PDF',style: kLabelStyle,),
                        IconButton(icon: Icon(Icons.upload_file),
                        onPressed: (){
                          getPdfAndUpload();
                        },)
                      ],),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.005),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: fileController,
                          onSaved: (String value) {
                            _fileUrl = value;
                            
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: vpH*0.02,
                          ),
                          decoration: InputDecoration(
                            fillColor: Color(0xFFE8EAF6),
                            hintText: 'No File Uploaded',
                            hintStyle: kHintTextStyle,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                           
                          ),    
                         
                        ),
                    
                    ),  
                    
                    Container(
                      padding: EdgeInsets.all(15),
                      child:RaisedButton(
                        elevation: vpH*0.5,
                        onPressed: (){
                          if(_formKey.currentState.validate()){
                            _formKey.currentState.save();
                            projects.postProjects(
                              link:_link,
                              description: _description,
                              name: _projectName,
                              projectImg: _projectImg,
                              date: _date,
                              fileUrl: _fileUrl,
    
                            
                            );
                            print("saved");
                            nameController.clear();
                            descriptionController.clear();
                            projectImgController.clear();
                            linkController.clear();
                            projectImgController.clear();
                            fileController.clear();
                           
                          
                            showDialog(  
                              context: context,  
                              builder: (BuildContext context) {  
                                return alert;  
                              },  
                            );  
                              
                          }
                          else{
                            print("not valid");
                            return null;
                          }
                        },
                        padding: EdgeInsets.all(15),
                        shape:RoundedRectangleBorder(
                          borderRadius:BorderRadius.circular(30.0),
                        ),
                        color: Color(0xFF3F51B5),
                        child: Text(
                          "Update",
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: vpW*0.015,
                            fontSize: vpH*0.02,
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