import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  String _eventName,
      _details,
      _posterUrl,
      _setEndTime,
      _place,
      _setStartTime,
      _setDate,
      fileName='';

  bool filePicked =false;
  File file;
  String _hour, _minute, _time;
  String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _setDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(selectedDate);
        print(_setDate);
        _dateController.text =
            DateFormat("yyyy-MM-dd hh:mm:ss").format(selectedDate);
      });
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (picked != null)
      setState(() {
        selectedStartTime = picked;
        _hour = selectedStartTime.hour.toString();
        _minute = selectedStartTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _startTimeController.text = _time;
        _startTimeController.text = formatDate(
            DateTime(
                2019, 08, 1, selectedStartTime.hour, selectedStartTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );
    if (picked != null)
      setState(() {
        selectedEndTime = picked;
        _hour = selectedEndTime.hour.toString();
        _minute = selectedEndTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _endTimeController.text = _time;
        _endTimeController.text = formatDate(
            DateTime(2019, 08, 1, selectedEndTime.hour, selectedEndTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(selectedDate);
    _startTimeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    _endTimeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }
  // upload image

  Future getImage()async{

    var rng = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      randomName += rng.nextInt(100).toString();
    }
   
    FilePickerResult result =
      await FilePicker.platform.pickFiles(type: FileType.image)
      .then((result) async {
        if(result!=null)
        {
          filePicked=true;
          file = File(result.files.single.path);
          fileName = '$randomName';
        }
      }).catchError((error)
      {
        print("Error: "+error.toString());
      });
   
    }
  Future saveImg(List<int> asset, String name) async {
    StorageReference reference = FirebaseStorage.instance.ref().child(name);
    StorageUploadTask uploadTask = reference.putData(asset);
    _posterUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    
  }
  


  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    var events = EventService();

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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EventScreen()));
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text(
        "Event added Successfully !!",
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
          strTitle: "Create Event",
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
                      'Event Name',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.01),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: eventNameController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: vpH * 0.02,
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
                      onSaved: (value) {
                        _eventName = value;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Event Details',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    child: TextFormField(
                      maxLines: 3,
                      textCapitalization: TextCapitalization.words,
                      controller: detailController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: vpH * 0.02,
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
                      onSaved: (value) {
                        _details = value;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Place',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: placeController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: vpH * 0.02,
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
                      onSaved: (value) {
                        _place = value;
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
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _dateController,
                      onSaved: (String value) {
                        _setDate = value;
                      },
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
                      onTap: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Event Start Time',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _startTimeController,
                      onSaved: (String value) {
                        _setStartTime = value;
                      },
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: vpH * 0.02,
                      ),
                      decoration: InputDecoration(
                        fillColor: Color(0xFFE8EAF6),
                        hintText: 'Choose Start Time',
                        hintStyle: kHintTextStyle,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.lock_clock),
                        ),
                      ),
                      onTap: () {
                        _selectStartTime(context);
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Event End Time',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _endTimeController,
                      onSaved: (String value) {
                        _setEndTime = value;
                      },
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: vpH * 0.02,
                      ),
                      decoration: InputDecoration(
                        fillColor: Color(0xFFE8EAF6),
                        hintText: 'Choose End Time',
                        hintStyle: kHintTextStyle,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.lock_clock),
                        ),
                      ),
                      onTap: () {
                        _selectEndTime(context);
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.005),
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Pick a poster Image',
                          style: kLabelStyle,
                        ),
                        IconButton(
                          icon: Icon(Icons.add_a_photo),
                          onPressed: () {
                            getImage();
                          },
                        ),
                        fileName.isEmpty
                        ? Text('Poster Image not Selected.',style: TextStyle(color: Colors.grey[400],fontSize: vpH*0.016,fontWeight:FontWeight.bold))
                        :Text('Poster Image Selected.',style: TextStyle(color: Colors.limeAccent[400],fontSize: vpH*0.016, fontWeight:FontWeight.bold))
                      ],
                    ),
                  ),
                  
                  Container(
                    padding: EdgeInsets.all(15),
                    child: RaisedButton(
                      elevation: vpH * 0.5,
                      onPressed: ()async {
                        if(filePicked)
                        {
                          await saveImg(file.readAsBytesSync(), fileName);
                        }
                        if (!_formKey.currentState.validate()) {
                          print("not valid");
                          return null;
                        } else {
                          _formKey.currentState.save();
                          events.postEvent(
                            eventName: _eventName,
                            details: _details,
                            date: _setDate,
                            startTime: _setStartTime,
                            place: _place,
                            endTime: _setEndTime,
                            posterURL: _posterUrl,
                          );
                          print("saved");
                          eventNameController.clear();
                          detailController.clear();
                          _dateController.clear();
                          _startTimeController.clear();
                          _endTimeController.clear();
                          placeController.clear();
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
                        "Create",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: vpW*0.005,
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
