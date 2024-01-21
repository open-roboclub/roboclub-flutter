import 'package:flutter/material.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerScreen extends StatefulWidget {
  final String title;
  final String url;

  const YoutubePlayerScreen({Key? key, required this.title, required this.url}) : super(key: key);

  @override
  _YoutubePlayerScreenState createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late YoutubePlayerController _controller;
  late String videoId;

  @override
  void initState() {
    videoId = YoutubePlayer.convertUrlToId(widget.url)??"";
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    // var vpW = getViewportWidth(context);
    return SafeArea(
        child: Scaffold(
      appBar: appBar(
        context,
        strTitle: "YouTube Tutorials",
        isDrawer: false,
        isNotification: false,
        scaffoldKey: _scaffoldKey,
      ),
      body: Column(
        children: [
          SizedBox(
            height: vpH * 0.1,
          ),
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            onReady: () {
              // _controller.seekTo(Duration(seconds: 0));

              print('Player is ready.');
            },
          ),
          SizedBox(
            height: vpH * 0.05,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              widget.title,
              textAlign: TextAlign.justify,
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: vpH * 0.025),
            ),
          ),
        ],
      ),
    ));
  }
}
