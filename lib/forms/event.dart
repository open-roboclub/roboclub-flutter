import 'package:intl/intl.dart';
import 'package:roboclub_flutter/screens/event_screen.dart';
import 'package:roboclub_flutter/services/event.dart';
import 'package:date_format/date_format.dart';
import '../helper/dimensions.dart';
import '../widgets/appBar.dart';
import 'package:flutter/material.dart';

class EventForm extends StatefulWidget {
  
  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();


  String _eventName, _details, _posterImg, _duration, _place, _setTime, _setDate;
  
  String _hour, _minute, _time;
  String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  final eventNameController = TextEditingController();
  final detailController = TextEditingController();
  final posterImgController = TextEditingController();
  final duratiomController = TextEditingController();
  final placeController = TextEditingController();
 

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    var events = EventService();

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
        Navigator.push(context, MaterialPageRoute(builder: (context) => EventScreen()));
      },  
    );

    AlertDialog alert = AlertDialog(  
      content: Text("Event added Successfully !!",style: kLabelStyle,),  
      actions: [  
        okButton,  
      ],  
    );  

    return SafeArea(
      child:Scaffold(
       key: _scaffoldKey,
        appBar: appBar(
          context,
          strTitle: "Update Event",
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
                      child:Text('Event Name',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: eventNameController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: ' Enter Event Name',
                          hintStyle: kHintTextStyle,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                   
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter Event name";
                          }
                          return null;
                        },
                        onSaved: (value)
                        {
                          _eventName = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      alignment: Alignment.topLeft,
                      child:Text('Event Details',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: detailController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: ' Enter Detail',
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
                           _details = value;
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
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _dateController,
                          onSaved: (String value) {
                            _setDate = value;
                          },
                          style: TextStyle(
                            color: Colors.purple[200],
                            fontFamily: 'OpenSans',
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
                          onTap: ()
                          {
                            _selectDate(context);
                          },
                       
                        ),
                    
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.005),
                      alignment: Alignment.topLeft,
                      child:Text('Time',style: kLabelStyle,
                      ),
                    ),
                   
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _timeController,
                          onSaved: (String value) {
                            _setTime = value;
                          },
                          style: TextStyle(
                            color: Colors.purple[200],
                            fontFamily: 'OpenSans',
                          ),
                          decoration: InputDecoration(
                            fillColor: Color(0xFFE8EAF6),
                            hintText: 'Choose Time',
                            hintStyle: kHintTextStyle,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(Icons.lock_clock),
                            ),
                          ),    
                          onTap: ()
                          {
                            _selectTime(context);
                          },
                       
                        ),
                    
                    ),
                    
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      alignment: Alignment.topLeft,
                      child:Text('Duration',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: duratiomController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: ' Enter duration',
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
                           _duration = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      alignment: Alignment.topLeft,
                      child:Text('Place',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: placeController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: 'Enter Venue',
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
                           _place = value;
                        },
                      ),
                    ),

                    
                    Container(
                      padding: EdgeInsets.all(15),
                      child:RaisedButton(
                        elevation: vpH*0.5,
                        onPressed: (){
                          if (!_formKey.currentState.validate()) {
                            print("not valid");
                            return null;
                          }
                          else{
                            _formKey.currentState.save();
                            events.postEvent(
                              eventName: _eventName,
                              details: _details,
                              date: _setDate,
                              time: _setTime,
                              place: _place,
                              duration: _duration,
                              posterURL: "",);
                              print("saved");
                              eventNameController.clear();
                              detailController.clear();
                              _dateController.clear();
                              placeController.clear();
                              duratiomController.clear();
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