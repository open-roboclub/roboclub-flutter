import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';



AppBar appBar(context, {String strTitle,bool isNotification=false, isDrawer=false})
{
  var vpH = getViewportHeight(context);
  var vpW = getViewportWidth(context);
  var iconcolor = Theme.of(context).primaryColorLight;
  var bgcolor = Theme.of(context).primaryColor;
  
  return AppBar(
    toolbarHeight: vpH*0.098,
    leading: isDrawer ? Icon(Icons.menu,color: iconcolor,size: vpW *0.10,):Icon(Icons.arrow_back,color: iconcolor,size: vpW *0.10,),
    title: Text(
      strTitle,
      style: TextStyle(
        fontFamily: "Signatra",
        fontSize: vpH*0.03,
      ),),
    actions: [
      Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: isNotification ? Icon(Icons.notifications,color: iconcolor,size: vpW *0.080):null,
    ),
      
    ],
    backgroundColor: bgcolor,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
    ),
    
  );
}