import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:roboclub_flutter/models/contributor.dart';
import 'package:roboclub_flutter/models/user.dart';
import 'package:roboclub_flutter/provider/user_provider.dart';
import 'package:roboclub_flutter/services/contributors.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/contribution_card.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import '../helper/dimensions.dart';
import '../forms/contribution.dart';
import 'package:flutter_svg/svg.dart';

class ContributorScreen extends StatefulWidget {
  @override
  _ContributorScreenState createState() => _ContributorScreenState();
}

class _ContributorScreenState extends State<ContributorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Contributor> contributorsList = [];
  bool isLoading = true;
  @override
  void initState() {
    ContributorService().fetchContributors().then((value) {
      value.forEach((element) {
        DateTime _parsed = DateTime.parse(element.date);
        element.date = DateFormat('yMMMd').format(_parsed);
      });
      addContriList(value);
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  void addContriList(List<Contributor> contribution) {
    contribution.forEach((item) {
      contributorsList.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    ModelUser _user = Provider.of<UserProvider>(context).getUser;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: appdrawer(context, page: "Contributors"),
        appBar: appBar(
          context,
          strTitle: "CONTRIBUTORS",
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
                  width: vpW * 0.90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blueGrey[200]!,
                          blurRadius: 5.0,
                          offset: Offset(0.0, 0.75)),
                    ],
                  ),
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "We are because of you!!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF9C01),
                            fontSize: vpH * 0.028),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        height: vpH * 0.002,
                        width: vpW * 2.0,
                        color: Color(0xFFFF9C01),
                      ),
                    ),
                    Row(children: [
                      // ListTile(
                      //   style: ListTileStyle.list,
                      // )
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: vpW * 0.028, vertical: vpH * 0.015),
                          child: Text(
                            "Thank you for all the people who contributed in making AMURoboclub what it is today.We couldn't have reached this place without your support.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: vpH * 0.018),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Image.asset('assets/img/contri.png'),
                        ),
                      ),
                    ])
                  ]),
                ),
              ),
              SizedBox(
                height: vpH * 0.005,
              ),
              Container(
                height: vpH * 0.6,
                width: vpW,
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : contributorsList.length == 0
                        ? Center(
                            child: Container(
                              width: vpW * 0.7,
                              height: vpH * 0.6,
                              child: SvgPicture.asset(
                                'assets/illustrations/transfer_money.svg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: contributorsList.length,
                            itemBuilder: (context, index) {
                              return ContriCard(
                                contributor: contributorsList[index],
                              );
                            },
                          ),
              )
            ],
          ),
        ),
        // TODO:check condition
        floatingActionButton: _user.uid.length>3
            ? (_user.isAdmin
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ContributionForm();
                          },
                        ),
                      );
                    },
                    child: Icon(Icons.add),
                  )
                : null)
            : null,
      ),
    );
  }
}
