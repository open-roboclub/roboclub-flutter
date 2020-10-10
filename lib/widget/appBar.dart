import 'package:flutter/material.dart';


AppBar appBar(context, {String strTitle,bool isNotification=false, isDrawer=false})
{
  
  return AppBar(
    toolbarHeight: 80.0,
    leading: isDrawer ? Icon(Icons.menu,color: Theme.of(context).primaryColorLight,size: 40.0,):Icon(Icons.arrow_back,color: Theme.of(context).primaryColorLight,size: 30.0,),
    title: Text(
      strTitle,
      style: TextStyle(
        fontFamily: "Signatra",
        fontSize: 25.0,
      ),),
    actions: [
      Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: isNotification ? Icon(Icons.notifications,color: Theme.of(context).primaryColorLight,size: 30.0):null,
    ),
      
    ],
    backgroundColor: Theme.of(context).primaryColor,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
    ),
    
  );
}