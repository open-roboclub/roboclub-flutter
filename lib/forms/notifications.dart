import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:roboclub_flutter/screens/notification_screen.dart';
import '../helper/dimensions.dart';
import '../widgets/appBar.dart';
import '../services/notification.dart';

class NotificationForm extends StatefulWidget {

  
  @override
  _NotificationFormState createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
 
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();


  String _title;
  String _msg;
  String _link="";
  String _date;

 TextEditingController date = TextEditingController();
 TextEditingController titleController = TextEditingController();
 TextEditingController msgController = TextEditingController();
 TextEditingController linkController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    var notifications = NotificationService();

   
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
      onPressed: () async{
        NotificationService().pushNotification(
          title:  _title,
          msg: _msg,
          img:"https://www.biznessapps.com/blog/wp-content/uploads/2016/01/push.png",
          screen: 'notification',
          link: _link,
          date:_date,
        );  
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },  
    );

    AlertDialog alert = AlertDialog(  
      content: Text("Notification sent Successfully !!",style: kLabelStyle,),  
      actions: [  
        okButton,  
      ],  
    );  

    
    return SafeArea(
      child:Scaffold(
       key: _scaffoldKey,
        appBar: appBar(
          context,
          strTitle: "Send Notification",
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
                      child:Text('Title',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: titleController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: ' Enter Notification title',
                          hintStyle: kHintTextStyle,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                   
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter title";
                          }
                          return null;
                        },
                        onSaved: (value)
                        {
                          _title = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      alignment: Alignment.topLeft,
                      child:Text('Message',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: msgController,
                        maxLines: 3,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: ' Enter Notigication Message',
                          hintStyle: kHintTextStyle,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                  
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some message';
                          }
                          return null;
                        },
                        onSaved: (value)
                        {
                          _msg = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      alignment: Alignment.topLeft,
                      child:Text('Notification Link',style: kLabelStyle,
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
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: 'Enter Notification Link',
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
                            DateFormat formatter = DateFormat("yyyy-MM-dd hh:mm:ss");
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
                      padding: EdgeInsets.all(15),
                      child:RaisedButton(
                        elevation: vpH*0.5,
                        onPressed: ()async{
                          if (!_formKey.currentState.validate()) {
                            print("not valid");
                            return null;
                          }
                          else{
                             _formKey.currentState.save();
                            notifications.postNotification(
                              title:_title,
                              msg: _msg,
                              link: _link,
                              date: _date);
                           
                           
                            print("saved");
                            titleController.clear();
                            linkController.clear();
                            msgController.clear();

                            showDialog(  
                              context: context,  
                              builder: (BuildContext context) {  
                                return alert;  
                              },  
                            );  
                              
                          }
                        },
                        padding: EdgeInsets.all(15),
                        shape:RoundedRectangleBorder(
                          borderRadius:BorderRadius.circular(30.0),
                        ),
                        color: Color(0xFFFF9C01),
                        child: Text(
                          "Update",
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