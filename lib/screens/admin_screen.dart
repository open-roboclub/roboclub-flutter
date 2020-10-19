import 'package:flutter/material.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import '../helper/dimensions.dart';
import './sign-up_login_screen.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        key: _scaffoldKey,
        drawer: appdrawer(context, page: "Admin"),
        appBar: appBar(
          context,
          strTitle: "Admin",
          isDrawer: true,
          isNotification: false,
          scaffoldKey: _scaffoldKey,
        ),
        body: Center(
            child:Column(
              children: [
                Padding(padding: EdgeInsets.all(15.0),
                child:Container(
                  child: Image.asset('assets/img/admin.png'),
                ),
                ),
                Padding(padding: EdgeInsets.only(top:50.0),
                child:Container(
                  child: FlatButton(
                    color: Colors.white,
                    textColor: Colors.orange[300],
                    padding: EdgeInsets.symmetric(horizontal:40.0,vertical: 20.0),
                    onPressed: ()=>Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (BuildContext context)=>LoginSignup()
                          )),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(35.0)),
                    child:Text(
                      "Admin Area !!",
                      style:TextStyle(
                        fontSize: 30.0,
                        fontWeight:FontWeight.w600),
                    )
                    ),
                ))
                ]
      ),
    ),
    )
    );
  }
}
