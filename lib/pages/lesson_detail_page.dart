import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mywebapp/manager/LessonDataManager.dart';
import 'package:mywebapp/manager/VideoDataManager.dart';
import 'package:mywebapp/manager/youtube_util.dart';
import 'package:mywebapp/models/models.dart';
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
  @override
  void initState() {
    super.initState();
  }

  void onAddVideo() {
    var lessonvideo = new LessonVideo();
    widget.desc.videoListEx.add(lessonvideo);
    setState(() {});
  }

  void updateLesson() async {
    await LessonDataManager.singleton().updateLesson(widget.desc);;
  }


  void onDeleteLesson() {

  }

  void onVideoCommand(LessonVideo video, _VideoCommand cmd) {
    switch (cmd) {
      case _VideoCommand.Delete:
        widget.desc.videoListEx.remove(video);
        break;
      case _VideoCommand.Up:
        {
          int index = widget.desc.videoListEx.indexOf(video);
          if(index > 0){
            var item0 = widget.desc.videoListEx[index-1];
            var item1 = video;

            widget.desc.videoListEx[index-1] = item1;
            widget.desc.videoListEx[index] = item0;
          }
        }
        break;
      case _VideoCommand.Down:
        {
          int index = widget.desc.videoListEx.indexOf(video);

          if(index < (widget.desc.videoListEx.length -1)){
            var item1 = widget.desc.videoListEx[index+1];
            var item0 = video;

            widget.desc.videoListEx[index+1] = item0;
            widget.desc.videoListEx[index] = item1;
          }
        }
        break;
      default:
        break;
    }

    updateLesson();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),

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
              _buildBasicInfoList(),
              Container(
                height: 50,
              ),
              Text('비디오 리스트'),
              _buildAddcommand(),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        NameValueWidget(name: '토픽', edit: Text(widget.desc.mainTopicId)),
        NameValueWidget(name: '레슨 아이디', edit: Text(widget.desc.lessonId)),
        NameValueWidget(
            name: '레슨 이름',
            edit:
                WidgetUtil.buildEditableLongText(widget.desc.title, (newText) {
              widget.desc.title = newText;
            })),
        NameValueWidget(
            name: '레슨 설명',
            h: 3,
            edit: WidgetUtil.buildEditableLongText(widget.desc.description,
                (newText) {
              widget.desc.description = newText;
            })),
      ],
    );
  }

  Widget _buildAddcommand() {
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
            FlatButton(
              child: Text('비디오 영상 추가'),
              onPressed: onAddVideo,
            )
          ],
        ));
  }

  Widget _buildVideoList() {
    if (widget.desc.videoListEx == null)
      widget.desc.videoListEx = new List<LessonVideo>();

    List<Widget> list = [];

    for (int index = 0; index < widget.desc.videoListEx.length; index++) {
      list.add(new VideoItemEditor(index, widget.desc,
          widget.desc.videoListEx[index],
          (item, cmd) {
            onVideoCommand(item, cmd);
          }
      )); // _buildVideoEdit()));
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
  VideoDesc originVideo;

  void initState() {
    super.initState();

    loadOriginVideo();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    loadOriginVideo();
  }

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

  @override
  Widget build(BuildContext context) {
    return _buildVideoItem(widget.video);
  }

  Future updateLesson() async {
    await LessonDataManager.singleton().updateLesson(widget.lesson);
  }

  void showVideoListPage() async {

    final result = await Navigator.of(context).push(new CupertinoPageRoute(
        builder: (context) => new VideoListPage.fromLesson(widget.lesson),
        fullscreenDialog: false));

    if(result !=null && result !='') {
      widget.video.videoKey = result.toString();
      loadOriginVideo();
    }
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
              edit:
                  WidgetUtil.buildEditableText(video.videoKey, (newValue) {
                    widget.video.videoKey = newValue;
                    updateLesson();
                    loadOriginVideo();
                  })),
          NameValueWidget(
              name: '강의 명칭',
              h: 0.6,
              edit:
                  WidgetUtil.buildEditableText(video.title, (newValue) {

                    widget.video.title = newValue;
                    updateLesson();
                  })),
          NameValueWidget(name: '비디오 명칭', h: 2, edit:
          originVideo !=null ? SelectableText(originVideo.title) : Text('Not Found')),
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
                showVideoListPage();
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
