import 'package:url_launcher/url_launcher.dart';

class YoutubeUtil {
  static openChannel(String channelKey) async {
    var url = 'https://www.youtube.com/channel/$channelKey';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void openVideo(String videoKey) async {
    var url = 'https://www.youtube.com/watch?v=$videoKey';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
