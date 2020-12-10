import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  YoutubePlayerController _controller;
  var vpH, vpW;
  String videoId;

  @override
  void initState() {
    videoId = YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=3SgDWuwTCrU");
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
      ),
    );
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
        body: SingleChildScrollView(
          child: Container(
            height: vpH,
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Center(
                  child: Container(
                    // height: vpH * 0.4,
                    width: vpW * 0.9,
                    child: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      onReady: () {
                        // _controller.seekTo(Duration(seconds: 0));
                        print('Player is ready.');
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
