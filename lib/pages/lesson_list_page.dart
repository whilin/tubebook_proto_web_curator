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

  void onFilterChanged(String topic, String subTopic, String channel) {
    where = {};
    activePage = 0;

    selectedTopicId = topic;

    if (topic != null && topic != '') where['mainTopicId'] = topic;
    if (subTopic != null && subTopic != '') where['subTopicId'] = subTopic;

    if (channel != null && channel != '') where['youtuberId'] = channel;

    loadCount();
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

typedef void FilterChanged(String maintopic,String subtopic, String lesson);

class FilterSelectorWidget extends StatefulWidget {
  final FilterChanged onFilterChanged;

  FilterSelectorWidget(this.onFilterChanged);

  @override
  _FilterSelectorState createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelectorWidget> {
  List<KeyName> channelList = [];
  List<KeyName> mainTopicList = [];
  List<KeyName> subTopicList = [];

  String channelSelected = '';
  String mainTopicSelected = '';
  String subTopicSelected = '';

  _FilterSelectorState() {}

  @override
  void initState() {
    super.initState();

    loadKeyList();
  }

  Future loadKeyList() async {
   // KeyName.initList(channelList);
    //KeyName.initList(mainTopicList);

//    var list = await VideoDataManager.singleton().getUniqueChannels();
//
//    for (var id in list) {
//      var ch = ChannelDataManager.singleton().findChannelKeyValue(id);
//      channelList.add(ch);
//    }
//
    channelList = ChannelDataManager.singleton().findChannelKeyValues();

    mainTopicList = TopicDataManager.singleton().findTopicKeyValuesAtCategory();
    subTopicList = TopicDataManager.singleton().findTopicKeyValuesAtCuration();

    mainTopicList.insert(0,new KeyName('', 'none'));
    subTopicList.insert(0,new KeyName('', 'none'));
    channelList.insert(0,new KeyName('', 'none'));

//    for (var topic in TopicDataManager.singleton().topicList) {
//      var to = TopicDataManager.singleton().findTopicKeyValue(topic.topicId);
//      topicList.add(to);
//    }

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
                    Text("Main Topic"),
                    WidgetUtil.buildListSelector(mainTopicList, mainTopicSelected,
                            (KeyName sel) {
                          mainTopicSelected = sel.key;
                          widget.onFilterChanged(mainTopicSelected, subTopicSelected, channelSelected);
                          setState(() {});
                        })
                  ],
                )),
            new Container(
              //        color: Colors.cyanAccent,
                width: 400,
                child: new Column(
                  children: <Widget>[
                    Text("Sub Topic"),
                    WidgetUtil.buildListSelector(subTopicList, subTopicSelected,
                            (KeyName sel) {
                              subTopicSelected = sel.key;
                          widget.onFilterChanged(mainTopicSelected, subTopicSelected, channelSelected);
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
                        (KeyName sel) {
                      channelSelected = sel.key;
                      widget.onFilterChanged(mainTopicSelected, subTopicSelected, channelSelected);
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
  final List<KeyName> _topicList = new List<KeyName>();

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
    _topicList.add(new KeyName('', '-'));
    _topicList.addAll(TopicDataManager.singleton()
        .topicList
        .map((e) => new KeyName(e.topicId, e.name)));
  }

  Future updateLesson(LessonDesc desc) async {
    bool success = await LessonDataManager.singleton().updateLesson(desc);
    setState(() {

    });
  }


  String findChannelName(LessonDesc desc) {
    if(desc.youtuberId !=null)
      return ChannelDataManager.singleton().findChannelKeyValue(desc.youtuberId).value;
    else
      return '';

  }

  String findTopicName(LessonDesc desc) {
    if(desc.mainTopicId !=null)
      return TopicDataManager.singleton().findTopicKeyValue(desc.mainTopicId).value;
    else
      return '';
  }

  String findSubTopicName(LessonDesc desc) {
    if(desc.subTopicId !=null)
      return TopicDataManager.singleton().findTopicKeyValue(desc.subTopicId).value;
    else
      return '';
  }
  String findPublishStage(LessonDesc desc) {
    desc.publish = desc.publish ?? 0;
    if(desc.publish == 0)
        return 'Draft';
    else if(desc.publish ==1)
        return 'Review';
    else //if(desc.publish  > 1)
      return 'Publish';
  }

  void onSelectLesson(LessonDesc desc) {

    Navigator.of(context).push(new CupertinoPageRoute(
        builder: (context) => new LessonDetailPage(desc),
        fullscreenDialog: false));
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
        const DataColumn(
          label: Text('Publish'),
        ),
        DataColumn(
          label: const SizedBox(child: Text('MainTopic')),
          onSort: (int columnIndex, bool ascending) {
           // print('column-sort: $columnIndex $ascending');
          },
        ),
        DataColumn(
          label: const SizedBox(child: Text('SubTopic')),
          onSort: (int columnIndex, bool ascending) {
            // print('column-sort: $columnIndex $ascending');
          },
        ),
        DataColumn(
          label: const SizedBox( child: Text('Channel')),
          onSort: (int columnIndex, bool ascending) {
            // print('column-sort: $columnIndex $ascending');
          },
        ),
        const DataColumn(
          label: const SizedBox(child: Text('Title')),
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

            onSelectLesson(desc);

          },
          cells: <DataCell>[
            DataCell(
              Text(desc.lessonId),
            ),

            DataCell(
              Text(WidgetUtil.findPublishStage(desc.publish))
//
//              WidgetUtil.buildPublisSelector(desc.publish, (newValue) {
//                desc.publish=newValue;
//                updateLesson(desc);
//              })
            ),
            DataCell(
              Text(findTopicName(desc)),
            ),
            DataCell(
              Text(findSubTopicName(desc)),
            ),
            DataCell(
              Text(findChannelName(desc)),
            ),
            DataCell(
              WidgetUtil.buildEditableText(desc.title, (text) {
                desc.title = text;
                updateLesson(desc);
              }),
              showEditIcon: true,
            ),
//            DataCell(
//              WidgetUtil.buildEditableText(desc.description, (text) {
//                desc.description = text;
//                updateLesson(desc);
//              }),
//              // showEditIcon: true,
//              onTap: () {
//                //log.add('cell-tap: ${dessert.calories}');
//              },
//            ),
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
