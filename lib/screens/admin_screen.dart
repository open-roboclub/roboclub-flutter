import 'package:flutter/material.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import '../helper/dimensions.dart';

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
        backgroundColor:Color.fromRGBO(217, 217, 217, 1),
        key: _scaffoldKey,
        drawer: appdrawer(context, page: "Admin Panel"),
        appBar: appBar(
          context,
          strTitle: "ADMIN PANEL",
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
                Padding(padding: EdgeInsets.only(top:vpH*0.07),
                child:Container(
                  child: FlatButton(
                    color: Colors.white,
                    textColor: Color.fromRGBO(255, 156, 1, 1),
                    padding: EdgeInsets.symmetric(horizontal:vpW*0.080,vertical:vpH* 0.020),
                    onPressed: (){},
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(35.0)),
                    child:Text(
                      "Admin Area !!",
                      style:TextStyle(
                        fontSize: vpH*0.040,
                        fontWeight:FontWeight.bold),
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
