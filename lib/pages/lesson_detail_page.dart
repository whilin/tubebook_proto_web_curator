import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mywebapp/manager/ChannelDataManager.dart';
import 'package:mywebapp/manager/LessonDataManager.dart';
import 'package:mywebapp/manager/TopicDataManager.dart';
import 'package:mywebapp/manager/VideoDataManager.dart';
import 'package:mywebapp/manager/YoutubeApi.dart';
import 'package:mywebapp/manager/youtube_util.dart';
import 'package:mywebapp/models/models.dart';
import 'package:mywebapp/pages/dialog_util.dart';
import 'package:mywebapp/pages/video_list_page.dart';
import 'package:mywebapp/pages/widget_util.dart';

class LessonDetailPage extends StatefulWidget {
  final LessonDesc desc;

  LessonDetailPage(this.desc);

  @override
  _LessonDetailPageState createState() => _LessonDetailPageState();
}

enum _VideoCommand {
  Delete,
  Up,
  Down,
  Edited,
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  List<KeyName> channelKeys = new List<KeyName>();
  bool dirty = false;

  @override
  void initState() {
    super.initState();

    verifyData();
  }

  void verifyData() {
    widget.desc.recommanded = widget.desc.recommanded ?? 0;
    widget.desc.tags = widget.desc.tags ?? {};
    widget.desc.level = widget.desc.level ?? LessonLevel.Beginnger;

    KeyName.initList_append(
        channelKeys, ChannelDataManager.singleton().findChannelKeyValues());
  }

  void onAddVideoEmpty() {
    var lessonvideo = new LessonVideo();
    widget.desc.videoListEx.add(lessonvideo);
    setState(() {});
  }

  void onAddVideo() async {
    Set<String> result = await Navigator.of(context).push(
        new CupertinoPageRoute(
            builder: (context) => new VideoListPage.fromLesson(widget.desc),
            fullscreenDialog: false));

    if (result != null) {
      for (var key in result) {
        try {
          widget.desc.videoListEx
              .firstWhere((element) => element.videoKey == key);
        } catch (ex) {
          var lessonvideo = new LessonVideo();
          lessonvideo.videoKey = key;
          widget.desc.videoListEx.add(lessonvideo);
        }
      }

      commitLesson();
    }

    setState(() {});
  }

  void setDirty() {
    dirty = true;
    setState(() {});
  }

  void commitLesson() async {
    await LessonDataManager.singleton().updateLesson(widget.desc);
    dirty = false;
    setState(() {});

  }

  void onDeleteLesson() async {
    DialogUtil.showDeleteLesson(context, widget.desc, (ok) {
      if (ok) {
        LessonDataManager.singleton().deleteLesson(widget.desc);
        onBack();
      }
    });
  }

  void onVideoCommand(LessonVideo video, _VideoCommand cmd) {
    switch (cmd) {
      case _VideoCommand.Delete:
        widget.desc.videoListEx.remove(video);
        break;
      case _VideoCommand.Up:
        {
          int index = widget.desc.videoListEx.indexOf(video);
          if (index > 0) {
            var item0 = widget.desc.videoListEx[index - 1];
            var item1 = video;

            widget.desc.videoListEx[index - 1] = item1;
            widget.desc.videoListEx[index] = item0;
          }
        }
        break;
      case _VideoCommand.Down:
        {
          int index = widget.desc.videoListEx.indexOf(video);

          if (index < (widget.desc.videoListEx.length - 1)) {
            var item1 = widget.desc.videoListEx[index + 1];
            var item0 = video;

            widget.desc.videoListEx[index + 1] = item0;
            widget.desc.videoListEx[index] = item1;
          }
        }
        break;
      case _VideoCommand.Edited:
        {

        }
        break;
      default:
        break;
    }

    dirty = true;
    //commitLesson();
    setState(() {});
  }

  void onBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.white,
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: onBack),
          title: Text(widget.desc.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 30,
              ),
              Text('기본 정보'),
              _buildLessonCommand(),
              _buildBasicInfoList(),
              Container(
                height: 50,
              ),
              _buildSaveCommand(),
              Text('비디오 리스트'),
              _buildVideoCommand(),
              _buildVideoList(),
              Container(
                height: 200,
              )
              //   NameValueWidget('레슨명'),
            ],
          ),
        ));
  }

  Widget _buildBasicInfoList() {

    var catTopicKeyValues = TopicDataManager.singleton().findTopicKeyValuesAtCategory();
    var curTopicKeyValues = TopicDataManager.singleton().findTopicKeyValuesAtCuration();

    curTopicKeyValues.insert(0, new KeyName('', 'none'));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        NameValueWidget(
            name: '퍼블리싱 단계',
            h: 1,
            edit:
                WidgetUtil.buildPublisSelector(widget.desc.publish, (newValue) {
              widget.desc.publish = newValue;
              setDirty();
            })),
        NameValueWidget(name: '토픽 (카테고리)',
            edit: //Text(widget.desc.mainTopicId)
            WidgetUtil.buildListSelector(
                catTopicKeyValues, widget.desc.mainTopicId, (newText) {
              widget.desc.mainTopicId = newText.key;
              setDirty();
            })
        ),
        NameValueWidget(name: '토픽 (큐레이션)',
            edit: //Text(widget.desc.mainTopicId)
                WidgetUtil.buildListSelector(
                    curTopicKeyValues, widget.desc.subTopicId, (newText) {
                widget.desc.subTopicId = newText.key;
                setDirty();
                })
        ),
        NameValueWidget(
            name: '큐레이터(채널)',
            edit: WidgetUtil.buildListSelector(
                channelKeys, widget.desc.youtuberId, (newText) {
              widget.desc.youtuberId = newText.key;
              setDirty();
            })),
        NameValueWidget(name: '레슨 아이디', edit: Text(widget.desc.lessonId)),
        NameValueWidget(
            name: '레슨 이름',
            edit:
                WidgetUtil.buildEditableLongText(widget.desc.title, (newText) {
              widget.desc.title = newText;
              setDirty();
            })),
        NameValueWidget(
            name: '레슨 난이도',
            edit:
                WidgetUtil.buildLevelEnumSelector(widget.desc.level, (newText) {
              widget.desc.level = newText;
              setDirty();
            })),
        NameValueWidget(
            name: '추천',
            edit: WidgetUtil.buildEditableLongText(
                widget.desc.recommanded.toString(), (newText) {
              try {
                widget.desc.recommanded = int.parse(newText);
                setDirty();
              } catch (ex) {}
            })),
        NameValueWidget(
            name: '레슨 3줄 설명',
            h: 2,
            edit: WidgetUtil.buildEditableLongText(widget.desc.description,
                (newText) {
              widget.desc.description = newText;
              setDirty();
            })),
        NameValueWidget(
            name: '레슨 상세 설명',
            h: 4,
            edit: WidgetUtil.buildEditableLongText(widget.desc.detailDescription,
                    (newText) {
                  widget.desc.detailDescription = newText;
                  setDirty();
                })),
      ],
    );
  }

  Widget _buildLessonCommand() {
    return Container(
        color: Colors.black12,
        height: 40,
        width: 600,
        child: ButtonBar(
          alignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Text('레슨 삭제'),
              onPressed: onDeleteLesson,
            ),
          ],
        ));
  }

  Widget _buildSaveCommand() {
    if(dirty)
      return Container(
        color: Colors.black12,
        height: 40,
        width: 600,
        child: FlatButton(
              child: Text('수정 사항 저장하기'),
              onPressed: (){
                commitLesson();
              },
            )
        );
    else
      return Container();
  }

  Widget _buildVideoCommand() {
    return Container(
        color: Colors.black12,
        height: 40,
        width: 600,
        child: ButtonBar(
          alignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Text('비디오 선택 추가'),
              onPressed: onAddVideo,
            ),
            FlatButton(
              child: Text('비디오 직접 추가'),
              onPressed: onAddVideoEmpty,
            )
          ],
        ));
  }

  Widget _buildVideoList() {
    if (widget.desc.videoListEx == null)
      widget.desc.videoListEx = new List<LessonVideo>();

    List<Widget> list = [];

    for (int index = 0; index < widget.desc.videoListEx.length; index++) {
      list.add(new VideoItemEditor(
          index, widget.desc, widget.desc.videoListEx[index], (item, cmd) {
        onVideoCommand(item, cmd);
      })); // _buildVideoEdit()));
    }

    return Column(
      children: list,
    );
  }
}

class VideoItemEditor extends StatefulWidget {
  final LessonDesc lesson;
  final LessonVideo video;
  final int videoIndex;
  final void Function(LessonVideo, _VideoCommand) onCommand;

  VideoItemEditor(this.videoIndex, this.lesson, this.video, this.onCommand);

  @override
  _VideoItemEditorState createState() => _VideoItemEditorState();
}

class _VideoItemEditorState extends State<VideoItemEditor> {

  //VideoDesc originVideo;
 // YoutubeVideoData youtubeData;

  //bool dirty;

  void initState() {
    super.initState();

    //loadOriginVideo();
    refreshOriginVideo();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

   // if (originVideo != null && (widget.video.videoKey != originVideo.videoKey))
    //  loadOriginVideo();
    refreshOriginVideo();
  }

/*
  Future loadOriginVideo() async {
    widget.video.title = widget.video.title ?? '';
    widget.video.videoKey = widget.video.videoKey ?? '';

    originVideo = null;
    setState(() {});

    if (widget.video.videoKey != null && widget.video.videoKey != '')
      originVideo =
          await VideoDataManager.singleton().findVideo(widget.video.videoKey);

    setState(() {});
  }


  Future refreshOriginVideo() async {

    var youtube =   await YoutubeApi.singleton().getVieoInfo(widget.video.videoKey);
    youtubeData = youtube;

    //youtube.description;
    //youtube.duration;

    setState(() {});
  }
*/

  Future refreshOriginVideo({bool force = false}) async {
    if(force || (widget.video.yt_duration ==null || widget.video.yt_duration =='')) {

      bool result = await LessonDataManager.singleton().loadVideoInfoFromYoutube(widget.video);
      if(result) {
        //updateLesson();
        setDirty();
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return _buildVideoItem(widget.video);
  }



  void showVideoListPage() async {
    final result = await Navigator.of(context).push(new CupertinoPageRoute(
        builder: (context) => new VideoListPage.fromLesson(widget.lesson),
        fullscreenDialog: false));

    if (result != null && result != '') {
      widget.video.videoKey = result.toString();
      refreshOriginVideo();
    }
  }

//  Future updateLesson() async {
//   // await LessonDataManager.singleton().updateLesson(widget.lesson);
//    widget.onCommand(widget.video, _VideoCommand.Edited);
//  }

  void setDirty() {
    //dirty = true;
    widget.onCommand(widget.video, _VideoCommand.Edited);
  }

  /*
  String getVideoInfo() {
    if(youtubeData ==null)
        return '';

    return "${youtubeData.duration} : ${youtubeData.title}";

  }
  */

  String getVideoInfo() {

    if( widget.video.yt_duration !=null && widget.video.yt_duration !='') {

      return "${widget.video.yt_duration}\n${widget.video.yt_title}\n${widget.video.yt_thumnail_default_url}";

    } else {
      return 'Not Set';
    }
//
//    if(youtubeData ==null)
//      return '';
//    return "${youtubeData.duration} : ${youtubeData.title}";

  }

  Widget _buildVideoItem(LessonVideo video) {
    //VideoDesc video = VideoDataManager.singleton().findVideo(video.videoKey);

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${widget.videoIndex}'),
          NameValueWidget(
              name: '비디오 키',
              h: 0.6,
              edit: WidgetUtil.buildEditableText(video.videoKey, (newValue) {
                widget.video.videoKey = newValue;
                //setDirty();
                refreshOriginVideo();
              })),
          NameValueWidget(
              name: '강의 명칭',
              h: 0.6,
              edit: WidgetUtil.buildEditableText(video.title, (newValue) {
                widget.video.title = newValue;
                setDirty();
              })),
          NameValueWidget(
              name: '오리지널 비디오 정보',
              h: 2,
              edit: SelectableText(getVideoInfo())),
          _buildVideoEdit()
        ]);
  }

  Widget _buildVideoEdit() {
    return Container(
        color: Colors.black12,
        width: 600,
        child: ButtonBar(
          alignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              iconSize: 14,
              icon: Icon(Icons.search),
              onPressed: () {
                //showVideoListPage();
                refreshOriginVideo();
              },
            ),
            IconButton(
              iconSize: 14,
              icon: Icon(Icons.refresh),
              onPressed: () {
                //showVideoListPage();
                refreshOriginVideo(force: true);
              },
            ),
            IconButton(
              iconSize: 14,
              icon: Icon(Icons.arrow_upward),
              onPressed: () {
                widget.onCommand(widget.video, _VideoCommand.Up);
              },
            ),
            IconButton(
              iconSize: 14,
              icon: Icon(Icons.arrow_downward),
              onPressed: () {
                widget.onCommand(widget.video, _VideoCommand.Down);
              },
            ),
            IconButton(
              iconSize: 14,
              icon: Icon(Icons.open_in_browser),
              onPressed: () {
                YoutubeUtil.openVideo(widget.video.videoKey);
              },
            ),
            IconButton(
              iconSize: 14,
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                widget.onCommand(widget.video, _VideoCommand.Delete);
              },
            ),
          ],
        ));
  }
}
