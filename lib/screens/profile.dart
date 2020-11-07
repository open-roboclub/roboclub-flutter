import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
// import '../widgets/appBar.dart';
// import '../helper/dimensions.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProvider>(context).getUser;
    // var _color = Colors.orange[400];
    return SafeArea(
        child: Scaffold(
      body: ListTile(
        leading: Text(_user.name),
        title: Text(_user.email),
        subtitle: Text(_user.uid),
      ),
    ));
  }
}
