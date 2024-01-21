import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/screens/playlist.dart';
import 'package:roboclub_flutter/services/tutorial.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import 'package:roboclub_flutter/widgets/tutorial_card.dart';

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var vpH, vpW;
  late List<dynamic> playlist;
  bool _isLoading = true;

  @override
  void initState() {
    TutorialService().fetchTutorials().then((value) {
      playlist = value;
      // print(value);
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: appdrawer(context, page: "Tutorials"),
        appBar: appBar(
          context,
          strTitle: "TUTORIALS",
          isDrawer: true,
          isNotification: false,
          scaffoldKey: _scaffoldKey,
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  height: vpH * 0.9,
                  child: playlist.length == 0
                      ? Center(
                          child: Column(
                            children: [
                              Container(
                                height: vpH * 0.6,
                                width: vpW * 0.7,
                                child: SvgPicture.asset(
                                  'assets/illustrations/playlist.svg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text('About to see Awesome Playlist!')
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: playlist.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlaylistScreen(
                                    videos: playlist[index]['playlist'],
                                  ),
                                ),
                              ),
                              child:
                                  TutorialCard(title: playlist[index]['title']),
                            );
                          },
                        ),
                ),
              ),
      ),
    );
  }
}
