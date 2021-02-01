import "package:flutter/material.dart";
import 'package:roboclub_flutter/models/project.dart';
import '../helper/dimensions.dart';
import '../widgets/appBar.dart';
import '../services/project.dart';

class ProjectForm extends StatefulWidget {

  @override
  _ProjectFormState createState() => _ProjectFormState();
}

enum projectstatus {completed,ongoing}

class _ProjectFormState extends State<ProjectForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();


  projectstatus _status = projectstatus.ongoing;

  String _projectImg;
  String _projectName;
  String _description;
  String _date;
  String _memberImg;
  String _link;
  bool _projectStatus;
  // List<String> _teamMembers;
  // File _file;


  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final projectImgController = TextEditingController();
  final linkController = TextEditingController();
  final dateController = TextEditingController();

  List<Project> projectsList = [];

  @override
  void initState() {
    ProjectService().fetchProjects().then((value) {
      projectsList = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    var projects = ProjectService();

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
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: ' Enter Project Name',
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
                        textCapitalization: TextCapitalization.words,
                        controller: descriptionController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
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
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
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
                      child:Text('Upload Project Image',style: kLabelStyle,
                      ),
                    ),
                   
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: projectImgController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: 'Enter project image url',
                          hintStyle: kHintTextStyle,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                                
                        onSaved: (value)
                        {
                          _projectImg = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.005),
                      alignment: Alignment.topLeft,
                      child:Text('Enter Complete/Start Date',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: dateController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                           fillColor: Color(0xFFE8EAF6),
                         hintText: 'Enter Date',
                           hintStyle: kHintTextStyle,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                                
                        onSaved: (value)
                        {
                          _date = value;
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal:vpW*0.12, vertical: vpH*0.015),
                    child:Row(
                      children: <Widget> [
                        Text('Ongoing',style:kLabelStyle ,),
                        Radio(  
                          value: projectstatus.ongoing,  
                          groupValue: _status,  
                          onChanged: (projectstatus value) {  
                            setState(() {  
                              _status = value;  
                              if(_status==projectstatus.ongoing)
                                {
                                  _projectStatus = false;
                                }
                                print(_projectStatus);
                              });  
                            },  
                          ),  
                        Text('Completed',style: kLabelStyle,),  
                        Radio(  
                          value: projectstatus.completed,  
                          groupValue: _status,  
                          onChanged: (projectstatus value) {  
                            setState(() {  
                              _status = value;
                              if(_status==projectstatus.completed)
                              {
                                _projectStatus = true;
                              }  
                              print(_projectStatus);
                            });  
                          },  
                        ),
                      ],
                    ),),
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
                              projectImg: "",
                              date: _date,
                              projectStatus:_projectStatus
                            );
                            print("saved");
                            nameController.clear();
                            descriptionController.clear();
                            projectImgController.clear();
                            linkController.clear();
                            dateController.clear();
                              
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