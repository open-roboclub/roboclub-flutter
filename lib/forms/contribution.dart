import "package:flutter/material.dart";
import 'package:roboclub_flutter/models/contributor.dart';
import 'package:roboclub_flutter/screens/contributor_screen.dart';
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


 String _name;
 String _description;
 String _amount;
 String _img;
 
 final nameController = TextEditingController();
 final descriptionController = TextEditingController();
 final amountController = TextEditingController();
 final imgController = TextEditingController();

  List<Contributor> contributorsList = [];

  @override
  void initState() {
    ContributorService().fetchContributors().then((value) {
      contributorsList = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    var contributors = ContributorService();

   
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => ContributorScreen()));
          },  
        );

      AlertDialog alert = AlertDialog(  
        content: Text("Contribution made Successfully !!",style: kLabelStyle,),  
        actions: [  
          okButton,  
        ],  
      );  

    return SafeArea(
      child:Scaffold(
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
                      child:Text('Name',style: kLabelStyle,
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
                          hintText: ' Enter Name',
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
                          _name = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
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
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: ' Enter Description',
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
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      alignment: Alignment.topLeft,
                      child:Text('Amount',style: kLabelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: amountController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: 'Enter Amount',
                          hintStyle: kHintTextStyle,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                  
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some amount';
                          }
                          return null;
                        },
                        onSaved: (value)
                        {
                          _amount = value;
                        },
                      ),
                    ),
                    Container(
                    padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      alignment: Alignment.topLeft,
                      child:Text('Upload Image',style: kLabelStyle,
                      ),
                    ),
                     Padding(
                      padding: EdgeInsets.symmetric(horizontal:vpW*0.05, vertical: vpH*0.01),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: imgController,
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFE8EAF6),
                          hintText: 'Enter image url',
                          hintStyle: kHintTextStyle,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                       
                        onSaved: (value)
                        {
                          _img = value;
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
                            contributors.postContributor(
                              amount:_amount,
                              description: _description,
                              name: _name,
                              representativeImg: "",);
                              print("saved");
                              nameController.clear();
                              descriptionController.clear();
                              amountController.clear();
                              imgController.clear();
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