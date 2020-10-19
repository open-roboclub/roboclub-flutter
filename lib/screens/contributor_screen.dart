import 'package:flutter/material.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/contribution_card.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import '../helper/dimensions.dart';

class ContributorScreen extends StatefulWidget {
  @override
  _ContributorScreenState createState() => _ContributorScreenState();
}

class _ContributorScreenState extends State<ContributorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: appdrawer(context, page: "Contributors"),
        appBar: appBar(
          context,
          strTitle: "Contributors",
          isDrawer: true,
          isNotification: false,
          scaffoldKey: _scaffoldKey,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
               Padding(
                padding: EdgeInsets.all(25.0),
                child: Container(
                  height: vpH * 0.30,
                  width: vpW * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey[200],
                        // offset: Offset(2, 2),
                        blurRadius: 5.0,
                        // spreadRadius: 1.0,
                        offset: Offset(0.0, 0.75)
                      ),
                    ],
              ),
              child: Column(
                children:[
                  Padding(padding: EdgeInsets.all(10.0),
                  child: Text("We are because of you!!", style:TextStyle(fontWeight: FontWeight.bold,color: Colors.orange[300],fontSize: 25.0)),
                  ),
                  Padding(padding: EdgeInsets.all(15.0),
                  child: Text("Thank you for all the people who contributed in making AMURoboclub what it is today.",style:TextStyle(fontWeight: FontWeight.bold,)),
                  ),
                  Row(children: [
                    Expanded(child: 
                    Padding(padding: EdgeInsets.all(10.0),
                    child:Text(" We couldn't have reached this place without your support",style:TextStyle(fontWeight: FontWeight.bold,),),
                    ),),
                    Expanded(child: 
                    Padding(padding: EdgeInsets.all(5.0),
                    child:Image.asset('assets/img/contri.png'))
                  ),])
                      // Padding(padding: EdgeInsets.all(15.0),
                      // child: Image.asset('assets/img/contri.png'),) 
                    ]
              ),
              
                ),
              ),
              SizedBox(
                height: vpH * 0.005,
                
              ),
              Container(
                height: vpH *0.8,
                width: vpW,
                child: true
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 10,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return ContriCard();
                        },  
                      )
                    : Center(
                        child: Text('No Contributions Yet'),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

