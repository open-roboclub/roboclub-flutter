import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import '../helper/dimensions.dart';
import '../widgets/appBar.dart';
import '../services/contributors.dart';

class ContributionForm extends StatefulWidget {
  @override
  _ContributionFormState createState() => _ContributionFormState();
}

class _ContributionFormState extends State<ContributionForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _description;
  late String _amount;
  String _img = "";
  String _date = "";
  File? file;
  String fileName = '';
  bool filePicked = false;
  late bool _loading;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  TextEditingController date = TextEditingController();
  // upload image

  Future getImage() async {
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
          file = File(result.paths.first!);
        });
        fileName = '$randomName';
      }
      else{
        file = null;
      }
    }).catchError((error) {
      print("Error: " + error.toString());
    });
  }

  Future saveImg(List<int> asset, String name) async {
    Reference reference = FirebaseStorage.instance.ref().child(name);
    UploadTask uploadTask = reference.putData(Uint8List.fromList(asset));
    _img = await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
  }
  @override
  void initState(){
    super.initState();
    _loading=false;
  }
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    var contributors = ContributorService();

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
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text(
        "Contribution made Successfully !!",
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
          strTitle: "Update Contribution",
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
                      'Name',
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
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        fillColor: Color(0xFFE8EAF6),
                        hintText: ' Enter Name',
                        hintStyle: kHintTextStyle,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
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
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.01),
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
                      controller: descriptionController,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        fillColor: Color(0xFFE8EAF6),
                        hintText: ' Enter Description',
                        hintStyle: kHintTextStyle,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _description = value!;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.01),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Amount',
                      style: kLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vpW * 0.05, vertical: vpH * 0.01),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: amountController,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                      ),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        fillColor: Color(0xFFE8EAF6),
                        hintText: 'Enter Amount',
                        hintStyle: kHintTextStyle,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some amount';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _amount = value!;
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
                        DateTime? dateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1990),
                          lastDate: DateTime(2030),
                        );
                        if(dateTime!=null){
                           DateFormat formatter = DateFormat('yyyy-MM-dd');
                        String formatted = formatter.format(dateTime);
                        date.text = formatted;
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _date = value!;
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
                        file == null
                        ? Text('Image not Selected.',
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: vpH * 0.02,
                                fontWeight: FontWeight.bold))
                        : Text('Image Selected.',
                            style: TextStyle(
                                color: Colors.limeAccent[400],
                                fontSize: vpH * 0.02,
                                fontWeight: FontWeight.bold))
                      ],
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
                    padding: EdgeInsets.all(15),
                    width: vpW * 0.5,
                    child: RaisedButton(
                      elevation: vpH * 0.5,
                      onPressed: () async {
                        setState(() {
                          _loading = true;
                        });
                        if (filePicked) {
                          await saveImg(file!.readAsBytesSync(), 'contributions/${nameController.text}/$fileName');
                        }
                        if (!_formKey.currentState!.validate()) {
                          print("not valid");
                          setState(() {
                            _loading=false;
                          });
                          return null;
                        } else {
                          _formKey.currentState!.save();
                          contributors.postContributor(
                              amount: _amount,
                              description: _description,
                              name: _name,
                              representativeImg: _img,
                              date: _date);
                          print("saved");
                          nameController.clear();
                          descriptionController.clear();
                          amountController.clear();

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
                        "Update",
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
