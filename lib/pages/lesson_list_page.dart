import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywebapp/manager/ChannelDataManager.dart';
import 'package:mywebapp/manager/LessonDataManager.dart';
import 'package:mywebapp/manager/TopicDataManager.dart';
import 'package:mywebapp/manager/VideoDataManager.dart';
import 'package:mywebapp/manager/db_manager.dart';
import 'package:mywebapp/models/models.dart';
import 'package:mywebapp/pages/dialog_util.dart';

import 'lesson_detail_page.dart';
import 'video_list_page.dart';
import 'widget_util.dart';

class LessonListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LessonListPageState();
  }
}

class _LessonListPageState extends State<LessonListPage> {
  final List<LessonDesc> lessonList = new List<LessonDesc>();

  int activePage = 0;
  int totalPage = 0;
  int totalCount = 0;
  int countPerPage = 10;
  dynamic where = {};

  String selectedTopicId = '';

  @override
  void initState() {
    super.initState();
    loadCount();
    loadPage();
  }

  Future loadPage() async {
    var list = await LessonDataManager.singleton()
        .loadLessonList(where, activePage, countPerPage);

    lessonList.clear();
    lessonList.addAll(list);

    setState(() {});
  }

  Future loadCount() async {
    int count = await LessonDataManager.singleton().countLesson(where);
    print('loadCount :' + count.toString());
    setState(() {
      totalCount = count;
      totalPage = (count / countPerPage).ceil();
    });
  }

  void _onAddLesson() {
    DialogUtil.showAddLesson(context, selectedTopicId, () {
      setState(() {
        loadPage();
      });
    });
  }

  void _onPrevPage() {
    setState(() {
      activePage = activePage - 1;
      activePage = activePage.clamp(0, totalPage - 1);
      lessonList.clear();
    });

    loadPage();
  }

  void _onNextPage() {
    setState(() {
      activePage = activePage + 1;
      activePage = activePage.clamp(0, totalPage - 1);
      lessonList.clear();
    });

    loadPage();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12,
          elevation: 0.2,
          title: Text('Lesson List'),
          actions: <Widget>[

          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            new SizedBox(height: 10,),
            new FilterSelectorWidget(onFilterChanged),
            // new HeaderSelectWidget(onFilterChanged),
            _buildPageNavigtor(),
            new LessonDataTable(lessonList)
          ],
        )));
  }

  void onFilterChanged(String topic, String channel) {
    where = {};
    activePage = 0;

    selectedTopicId = topic;

    if (topic != null && topic != '') where['mainTopicId'] = topic;
    if (channel != null && channel != '') where['youtubeId'] = channel;

    loadCount();
    loadPage();
  }

  Widget _buildPageNavigtor() {
    return Container(
        child: Row(children: [
      FlatButton(child: Text("Prev"), onPressed: _onPrevPage),
      Text("${activePage + 1}/$totalPage ($totalCount)"),
      FlatButton(child: Text("Next"), onPressed: _onNextPage),
      FlatButton(
        child: Text('레슨 추가'),
        onPressed: _onAddLesson,
      )
    ]));
  }
}

typedef void FilterChanged(String topic, String lesson);

class FilterSelectorWidget extends StatefulWidget {
  final FilterChanged onFilterChanged;

  FilterSelectorWidget(this.onFilterChanged);

  @override
  _FilterSelectorState createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelectorWidget> {
  final List<KeyValue> channelList = [];
  final List<KeyValue> topicList = [];

  String channelSelected = '';
  String topicSelected = '';

  _FilterSelectorState() {}

  @override
  void initState() {
    super.initState();

    loadKeyList();
  }

  Future loadKeyList() async {
    KeyValue.initList(channelList);
    KeyValue.initList(topicList);

    var list = await VideoDataManager.singleton().getUniqueChannels();

    for (var id in list) {
      var ch = ChannelDataManager.singleton().findChannelKeyValue(id);
      channelList.add(ch);
    }

    for (var topic in TopicDataManager.singleton().topicList) {
      var to = TopicDataManager.singleton().findTopicKeyValue(topic.topicId);
      topicList.add(to);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      //  color: Colors.pinkAccent,
        height: 70,
        child: Row(
          children: <Widget>[
            new Container(
        //        color: Colors.cyanAccent,
                width: 400,
                child: new Column(
                  children: <Widget>[
                    Text("Topic"),
                    WidgetUtil.buildListSelector(topicList, topicSelected,
                        (KeyValue sel) {
                      topicSelected = sel.key;
                      widget.onFilterChanged(topicSelected, channelSelected);
                      setState(() {});
                    })
                  ],
                )),
            new Container(
         //       color: Colors.cyanAccent,
                width: 400,
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
          ],
        ));
  }
}

class LessonDataTable extends StatefulWidget {
  final List<LessonDesc> lessonList;

  LessonDataTable(this.lessonList);

  @override
  _LessonDataTableState createState() => _LessonDataTableState();
}

class _LessonDataTableState extends State<LessonDataTable> {
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

  Future updateLesson(LessonDesc desc) async {
    bool success = await LessonDataManager.singleton().updateLesson(desc);
    setState(() {

    });
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
          label: Text('LessonId'),
        ),
        DataColumn(
          label: const SizedBox(width: 100, child: Text('Topic')),
          onSort: (int columnIndex, bool ascending) {
            print('column-sort: $columnIndex $ascending');
          },
        ),
        const DataColumn(
          label: const SizedBox(width: 200, child: Text('Title')),
        ),

        const DataColumn(
          label: Text('Description'),
        ),
        const DataColumn(
          label: Text('난이도'),
        ),
        const DataColumn(
          label: Text('추천'),
        ),

//        const DataColumn(
//          label: Text('Description'),
//          tooltip: '...',
//        ),
      ],
      rows: widget.lessonList.map<DataRow>((LessonDesc desc) {
        // var ch = TopicDataManager.singleton().findChannelKeyValue(desc.channelId);

        return DataRow(
          key: Key(desc.lessonId),
          onSelectChanged: (bool selected) {
            print('row-selected: ${desc.lessonId}');

            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (context) => new LessonDetailPage(desc),
                fullscreenDialog: false));
          },
          cells: <DataCell>[
            DataCell(
              Text(desc.lessonId),
            ),
            DataCell(
              Text(desc.mainTopicId),
            ),
            DataCell(
              WidgetUtil.buildEditableText(desc.title, (text) {
                desc.title = text;
                updateLesson(desc);
              }),
              showEditIcon: true,
            ),
            DataCell(
              WidgetUtil.buildEditableText(desc.description, (text) {
                desc.description = text;
                updateLesson(desc);
              }),
              // showEditIcon: true,
              onTap: () {
                //log.add('cell-tap: ${dessert.calories}');
              },
            ),
            DataCell(
              WidgetUtil.buildLevelEnumSelector(desc.level ?? LessonLevel.Beginnger, (newValue) {
                desc.level = newValue;
                updateLesson(desc);
              })
            ),
            DataCell(
              Text(desc.recommanded !=null ? desc.recommanded.toString() : '0'),
            ),
          ],
        );
      }).toList(),
    );

    return Align(alignment: Alignment.topLeft, child: table);
  }

}
