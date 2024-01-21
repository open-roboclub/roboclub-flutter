import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roboclub_flutter/helper/custom_icons.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/screens/youtubeplayer.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlaylistScreen extends StatefulWidget {
  final List<dynamic> videos;

  const PlaylistScreen({Key? key, required this.videos}) : super(key: key);
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  var vpH, vpW;
  @override
  void initState() {
    widget.videos.forEach((element) {
      String videoId = YoutubePlayer.convertUrlToId(element['url'])??"";
      element['videoId'] = videoId;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
        appBar: appBar(
          context,
          strTitle: "Playlist",
          isDrawer: false,
          isNotification: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: vpH * 0.9,
            child: ListView.builder(
              itemCount: widget.videos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YoutubePlayerScreen(
                        title: widget.videos[index]["title"],
                        url: widget.videos[index]["url"],
                      ),
                    ),
                  ),
                  child: Container(
                    width: vpW * 0.85,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Container(
                              child: CachedNetworkImage(
                            imageUrl:
                                'https://img.youtube.com/vi/${widget.videos[index]['videoId']}/0.jpg',
                            placeholder: (BuildContext context, String str) {
                              return Container(
                                height: vpH * 0.4,
                                width: vpW * 0.7,
                                child: SvgPicture.asset(
                                  'assets/illustrations/playlist.svg',
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                            fadeInCurve: Curves.easeIn,
                            fadeInDuration: Duration(milliseconds: 500),
                            fit: BoxFit.cover,
                          )),
                          ListTile(
                            tileColor: Colors.grey.withOpacity(0.4),
                            leading: Icon(
                              SocialMedia.youtube,
                              color: Colors.red,
                            ),
                            title: Text(
                              widget.videos[index]['title'],
                              style: TextStyle(color: Colors.black),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => YoutubePlayerScreen(
                                  title: widget.videos[index]["title"],
                                  url: widget.videos[index]["url"],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
