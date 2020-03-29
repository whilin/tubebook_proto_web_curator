import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mywebapp/manager/ChannelDataManager.dart';
import 'package:mywebapp/manager/LessonDataManager.dart';
import 'package:mywebapp/manager/TopicDataManager.dart';
import 'package:mywebapp/manager/VideoDataManager.dart';
import 'package:mywebapp/models/models.dart';
import 'package:mywebapp/pages/video_detail_page.dart';
import '../manager/db_manager.dart';
import 'widget_util.dart';

class VideoListPage extends StatefulWidget {
  LessonDesc selectedLesson;

  VideoListPage();

  VideoListPage.fromLesson(this.selectedLesson);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VideoListPageState();
  }
}

class _VideoListPageState extends State<VideoListPage> {
  List<VideoDesc> videoList = new List<VideoDesc>();

  int activePage = 0;
  int totalPage = 0;
  int totalCount = 0;
  int countPerPage = 10;
  dynamic where = {};

  @override
  void initState() {
    super.initState();
    //loadCount();

    if (widget.selectedLesson != null) {
      where['hintTopic'] = widget.selectedLesson.mainTopicId;
    }

    loadPage();
  }

  Future loadCount() async {
    int count = await VideoDataManager.singleton().countVideoList(where);
    print('loadCount :' + count.toString());
    setState(() {
      totalCount = count;
      totalPage = (count / countPerPage).ceil();
    });
  }

  Future loadPage({int pageDelta = null}) async {
    videoList = [];

    int count = await VideoDataManager.singleton().countVideoList(where);
    print('loadCount :' + count.toString());

    totalCount = count;
    totalPage = (count / countPerPage).ceil();

    if (pageDelta != null) {
      activePage = activePage + pageDelta;
      activePage = activePage.clamp(0, totalPage - 1);
    } else {
      activePage = 0;
    }

    var list = await VideoDataManager.singleton()
        .loadVideoList(where, activePage, countPerPage);

    setState(() {
      videoList = list;
    });
  }

  void _onPrevPage() {
    loadPage(pageDelta: -1);
  }

  void _onNextPage() {
    loadPage(pageDelta: 1);
  }

  void onFilterChanged(String topic, String channel) {
    where = {};
    activePage = 0;

    if (channel != null && channel != "") where['channelId'] = channel;
    if (topic != null && topic != "") where['hintTopic'] = topic;

    loadPage();
  }

  void onBack() {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: onBack,
          ),
          backgroundColor: Colors.black12,
          elevation: 0.2,
          title: Text('Video List'),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                //width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height,
                //color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new SizedBox(
                      height: 10,
                    ),
                    new FilterSelectorWidget(
                        onFilterChanged, widget.selectedLesson),
                    _buildPageNavigtor(),
                    new VideoDataTable(videoList, widget.selectedLesson)
                  ],
                ))));
  }

  Widget _buildPageNavigtor() {
    return Container(
        child: Row(children: [
      FlatButton(child: Text("Prev"), onPressed: _onPrevPage),
      Text("${activePage + 1}/$totalPage ($totalCount)"),
      FlatButton(child: Text("Next"), onPressed: _onNextPage)
    ]));
  }
}

typedef void FilterChanged(String topic, String lesson);

class FilterSelectorWidget extends StatefulWidget {
  final FilterChanged onFilterChanged;
  LessonDesc selectedLesson;

  FilterSelectorWidget(this.onFilterChanged, this.selectedLesson);

  @override
  _FilterSelectorState createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelectorWidget> {
  final List<KeyValue> channelList = [];
  final List<KeyValue> topicList = [];
  final List<KeyValue> lessonList = [];

  static String channelSelected = '';
  static String topicSelected = '';
  static String lessonSelected = '';

  _FilterSelectorState() {}

  @override
  void initState() {
    super.initState();

//
//    if(widget.selectedLesson!=null) {
//      topicSelected = widget.selectedLesson.mainTopicId;
//      lessonSelected = widget.selectedLesson.lessonId;
//    }

    loadKeyList();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    //loadKeyList();
  }

  Future loadKeyList() async {
    KeyValue.initList(channelList);
    KeyValue.initList(topicList);
    KeyValue.initList(lessonList);

    var list = await VideoDataManager.singleton().getUniqueChannels();

    for (var id in list) {
      var ch = ChannelDataManager.singleton().findChannelKeyValue(id);
      channelList.add(ch);
    }

    for (var topic in TopicDataManager.singleton().topicList) {
      var to = TopicDataManager.singleton().findTopicKeyValue(topic.topicId);
      topicList.add(to);
    }

    if (topicSelected != '' || channelSelected != '')
      widget.onFilterChanged(topicSelected, channelSelected);

    setState(() {});
  }

  Future refreshLessonList() async {
    var list = await LessonDataManager.singleton()
        .loadLessonListByTopic(topicSelected);
    KeyValue.initList_append(lessonList, list);

    lessonSelected = '';

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        alignment: Alignment.topLeft,
        //color: Colors.pinkAccent,
        height: 70,
        child: Row(
          children: <Widget>[
            new Container(
                //color: Colors.cyanAccent,
                width: 350,
                child: new Column(
                  children: <Widget>[
                    Text("Channel"),
                    WidgetUtil.buildListSelector(channelList, channelSelected,
                        (KeyValue sel) {
                      channelSelected = sel.key;
                      widget.onFilterChanged(topicSelected, channelSelected);
                      setState(() {});
                    })
                  ],
                )),
            new Container(
                //  color: Colors.cyanAccent,
                width: 350,
                child: new Column(
                  children: <Widget>[
                    Text("Topic"),
                    WidgetUtil.buildListSelector(topicList, topicSelected,
                        (KeyValue sel) {
                      topicSelected = sel.key;
                      refreshLessonList();
                      widget.onFilterChanged(topicSelected, channelSelected);
                      setState(() {});
                    })
                  ],
                )),
            new Container(
                // color: Colors.cyanAccent,
                width: 350,
                child: new Column(
                  children: <Widget>[
                    Text("Lesson"),
                    WidgetUtil.buildListSelector(lessonList, lessonSelected,
                        (KeyValue sel) {
                      lessonSelected = sel.key;
                      widget.onFilterChanged(topicSelected, channelSelected);
                      setState(() {});
                    })
                  ],
                )),
          ],
        ));
  }
}

class VideoDataTable extends StatefulWidget {
  final List<VideoDesc> videoList;

  LessonDesc selectedLesson;

  VideoDataTable(this.videoList, this.selectedLesson);

  @override
  _VideoDataTableState createState() => _VideoDataTableState();
}

class _VideoDataTableState extends State<VideoDataTable> {
  @override
  String get name => 'SliceDataTable';

  final List<String> log = <String>[];
  final List<KeyValue> _topicList = new List<KeyValue>();

  @override
  void initState() {
    super.initState();

    loadKeyList();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Future loadKeyList() async {
    _topicList.clear();
    _topicList.add(new KeyValue('', '-'));
    _topicList.addAll(TopicDataManager.singleton()
        .topicList
        .map((e) => new KeyValue(e.topicId, e.name)));
  }

  Future updateVideo(VideoDesc desc) async {
    bool success = await VideoDataManager.singleton().updateVideo(desc);
    setState(() {});
  }

  void onVideoSelect(VideoDesc desc) {
    if (widget.selectedLesson == null) {
      Navigator.of(context).push(new CupertinoPageRoute(
          builder: (context) => VideoDetialPage(), fullscreenDialog: false));
    } else {
      Navigator.of(context).pop(desc.videoKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildTable(sortColumnIndex: 0, sortAscending: true);
  }

  Widget _buildTable({int sortColumnIndex, bool sortAscending = true}) {
    var table = DataTable(
      headingRowHeight: 60,
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
      showCheckboxColumn: false,
      onSelectAll: (bool value) {
        print('select-all: $value');
      },
      columns: <DataColumn>[
        const DataColumn(
          label: Text('VideoKey'),
        ),
        const DataColumn(
          label: const SizedBox(width: 200, child: Text('Title')),
        ),
        DataColumn(
          label: const SizedBox(width: 100, child: Text('Channel')),
          onSort: (int columnIndex, bool ascending) {
            print('column-sort: $columnIndex $ascending');
          },
        ),

        const DataColumn(

          label: Text('Hint Topic'),
        ),
        const DataColumn(
          label: Text('Hint Lesson'),
        ),
//        const DataColumn(
//          label: Text('Description'),
//          tooltip: '...',
//        ),
      ],
      rows: widget.videoList.map<DataRow>((VideoDesc desc) {
        var ch =
            ChannelDataManager.singleton().findChannelKeyValue(desc.channelId);

        return DataRow(
          key: Key(desc.videoKey),
          onSelectChanged: (bool selected) {
            print('row-selected: ${desc.videoKey}');
            onVideoSelect(desc);
          },
          cells: <DataCell>[
            DataCell(
              Text(desc.videoKey),
            ),
            DataCell(
              Text(desc.title),
             // showEditIcon: true,
            ),
            DataCell(
              SizedBox(width: 100, child: Text(ch.value)),
              // showEditIcon: true,
              onTap: () {
                //log.add('cell-tap: ${dessert.calories}');
              },
            ),
            DataCell(
                SizedBox(
                   // width: 100,
                    child: WidgetUtil.buildListSelector(
                    _topicList, desc.hintTopic, (sel) {
                      desc.hintTopic = sel.key;
                      updateVideo(desc);
                    }))
                //_buildDropdownTopic(desc),
            ),
            DataCell(WidgetUtil.buildLessonSelector(
                context, desc.hintTopic, desc.hintLesson, (selectedLesson) {
              desc.hintLesson = selectedLesson;
              updateVideo(desc);
            })),
          ],
        );
      }).toList(),
    );

    return Align(alignment: Alignment.topLeft, child: table);
  }
/*
  Widget _buildDropdownTopic(VideoDesc desc) {
    return DropdownButton<KeyValue>(
      value: KeyValue.findKeyValue(_topicList, desc.hintTopic),
      onChanged: (KeyValue topic) {
        setState(() {
          desc.hintTopic = topic.key;
          updateVideo(desc);
        });
      },
      selectedItemBuilder: (BuildContext context) {
        return _topicList.map<Widget>((KeyValue item) {
          return Align(alignment: Alignment.center, child: Text(item.value));
        }).toList();
      },
      items: _topicList.map((KeyValue item) {
        return DropdownMenuItem<KeyValue>(
          child: Center(
              child: Text(
            '${item.value}',
            textAlign: TextAlign.right,
          )),
          value: item,
        );
      }).toList(),
    );
  }
 */
}
