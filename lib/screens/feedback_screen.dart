import 'dart:async';
import 'package:flutter/material.dart';

import 'package:roboclub_flutter/services/feedback.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _feedback = "";
  TextEditingController _controller = TextEditingController();
  bool selected = false;
  @override
  void initState() {
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        selected = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: appdrawer(context, page: "Feedback"),
        appBar: appBar(
          context,
          strTitle: "FEEDBACK",
          isDrawer: true,
          isNotification: false,
          scaffoldKey: _scaffoldKey,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: vpW * 1.0,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: vpW * 0.12, vertical: vpH * 0.05),
                  child: Text(
                    "We all need people who will give us feedback.\nThat’s how we improve.",
                    style: GoogleFonts.baumans(
                        fontWeight: FontWeight.bold, fontSize: vpH * 0.03),
                  ),
                ),
              ),
              AnimatedContainer(
                width: selected ? vpW * 0.5 : vpW * 0.85,
                height: selected ? vpH * 0.3 : vpH * 0.6,
                duration: Duration(seconds: 2),
                curve: Curves.easeOutExpo,
                child: Image.asset(
                  'assets/img/Review.png',
                  fit: BoxFit.fill,
                ),
              ),
              AnimatedContainer(
                duration: Duration(seconds: 1),
                child: selected
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: vpW * 0.05, vertical: vpH * 0.05),
                        child: Container(
                          width: vpW * 0.9,
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              hintText: 'Write your feedback here!!',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              suffixIcon: Builder(
                                builder: (context) => IconButton(
                                  icon: Icon(
                                    Icons.send,
                                    color: Color(0xFFFF9C01),
                                  ),
                                  onPressed: () async {
                                    if (_feedback.isNotEmpty) {
                                      // var _user =
                                      //     Provider.of<UserProvider>(context)
                                      //         .getUser;
                                      await FeedbackService()
                                          .postFeedback(_controller.text, true);
                                      setState(() {
                                        _controller.clear();
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                      });
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                        backgroundColor: Color(0xFFFFFFFF),
                                        content: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Thanks for the Feedback!', 
                                            style:TextStyle(fontSize: vpH*0.03, fontWeight: FontWeight.w800, color:Color(0xFFFF9C01),
                                            ),
                                          ),
                                        ),
                                        duration: Duration(seconds: 5),
                                      ));
                                    }
                                  },
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              _feedback = value;
                            },
                            style: TextStyle(
                                fontSize: vpH * 0.03, color: Colors.black),
                            maxLines: 7,
                            maxLength: 1000,
                          ),
                        ))
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
