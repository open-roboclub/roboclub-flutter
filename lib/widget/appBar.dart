import 'package:flutter/material.dart';


AppBar appBar(context, {String strTitle})
{
  
  return AppBar(
    toolbarHeight: 70.0,
    title: Text(
      strTitle,
    ),
    backgroundColor: Theme.of(context).primaryColor,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
  
),
  );
}