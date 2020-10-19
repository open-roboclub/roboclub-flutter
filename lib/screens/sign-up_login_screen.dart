import 'package:flutter/material.dart';
import '../widgets/appBar.dart';
import '../helper/dimensions.dart';

class LoginSignup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _color = Colors.orange[400];
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: appBar(
          context,
          strTitle: "",
          isDrawer: false,
          isNotification: false,
        ),
        body: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Container(
                  child: FlatButton(
                    color: _color,
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal:80.0,vertical: 20.0),
                    onPressed: (){},
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(35.0)),
                    child:Text(
                      "Log In",
                      style:TextStyle(
                        fontSize: 30.0,
                        fontWeight:FontWeight.w600),
                    )
                    ),
                ),
                
                Container(
                  margin: const EdgeInsets.all(50.0),
                  child: OutlineButton(
                  onPressed: (){},
                  textColor: _color,
                  highlightedBorderColor: _color,
                  padding: EdgeInsets.symmetric(horizontal:70.0,vertical: 20.0),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(35.0)),
                  borderSide: BorderSide(
                  color: _color,
                  width: 2.0,
                ),
                  child:Text(
                      "Sign Up",
                      style:TextStyle(
                        fontSize: 30.0,
                        fontWeight:FontWeight.w600),
                    )
                  ),
                  )
            ],
            ),
            ),
      
    );
  }
}

