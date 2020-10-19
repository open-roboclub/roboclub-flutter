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
                padding: EdgeInsets.all(15.0),
                child: Container(
                  height: vpH * 0.25,
                  width: vpW * 0.90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey[200],
                        blurRadius: 5.0,
                        offset: Offset(0.0, 0.75)
                      ),
                      ],
                    ),
                    child: Column( 
                      children:[
                        Padding(padding: EdgeInsets.all(10.0),
                        child: Text("We are because of you!!", style:TextStyle(fontWeight: FontWeight.bold,color: Colors.orange[400],fontSize: 28.0)),
                        ),
                        Padding(
                          padding:EdgeInsets.symmetric(horizontal:10.0),
                          child:Container(
                          height:1.8,
                          width:300.0,
                          color:Colors.orange[400],),
                          ),
                        Row(children: [
                          Expanded(child: 
                            Padding(padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                            child: Text("Thank you for all the people who contributed in making AMURoboclub what it is today.We couldn't have reached this place without your support",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
                            ),
                            ),
                          Expanded(child: 
                            Padding(padding: EdgeInsets.all(5.0),
                            child:Image.asset('assets/img/contri.png'))
                          ),
                          ])   
                        ]),
                    
                  ),
                ),
              SizedBox(
                height: vpH * 0.005,
                
              ),
              Container(
                height: vpH *0.6,
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

