import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywebapp/manager/ChannelDataManager.dart';
import 'package:mywebapp/manager/LessonDataManager.dart';
import 'package:mywebapp/manager/TopicDataManager.dart';
import 'package:mywebapp/manager/db_manager.dart';
import 'package:mywebapp/models/models.dart';
import 'package:mywebapp/pages/dialog_util.dart';
import 'package:mywebapp/pages/topic_detail_dialog.dart';
import 'widget_util.dart';

class TopicList2Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TopicList2PageState();
  }
}

class _TopicList2PageState extends State<TopicList2Page> {

  void refresh() {
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(body: Column(children: [
      buildAddButton(),
      TopicDataTable()]));
  }

  Widget buildAddButton() {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      children: <Widget>[
        FlatButton(child: Text('카테고리 토픽 추가'), onPressed: (){
          DialogUtil.showAddTopic(context, refresh);
        }),
        FlatButton(child: Text('큐레이이터 토픽 추가'), onPressed: (){
          DialogUtil.showAddCuratorTopic(context, refresh);
        })
      ],
    );
  }

}

class TopicDataTable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TopicDataTableState();
  }
}

class _TopicDataTableState extends State<TopicDataTable> {
  final List<TopicDesc> _topicList = new List<TopicDesc>();

  @override
  void initState() {
    super.initState();

    loadData();
  }


  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    loadData();
  }

  void loadData() async {
    _topicList.clear();
    setState(() {
    });

    await TopicDataManager.singleton().loadTopicList();

    _topicList.addAll(TopicDataManager.singleton().topicList);

    setState(() {
    });
  }

  void deleteTopic(TopicDesc desc) async {
    await TopicDataManager.singleton().deleteTopic(desc);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    var table = DataTable(
      headingRowHeight: 60,
      //sortColumnIndex: sortColumnIndex,
      //sortAscending: sortAscending,
      showCheckboxColumn: false,
      onSelectAll: (bool value) {
        print('select-all: $value');
      },
      columns: <DataColumn>[
        DataColumn(
          label: const SizedBox(width: 100, child: Text('id')),
          onSort: (int columnIndex, bool ascending) {
            print('column-sort: $columnIndex $ascending');
          },
        ),
        const DataColumn(
          label: Text('TopicType'),
        ),
        const DataColumn(
          label: Text('Curator'),
        ),
        const DataColumn(
          label: const SizedBox(width: 200, child: Text('Title')),
        ),

        const DataColumn(
          label: Text('Section'),
        ),
        const DataColumn(
          label: Text('Lesson'),
        ),
        const DataColumn(
          label: Text('actions'),
        ),

//        const DataColumn(
//          label: Text('Description'),
//          tooltip: '...',
//        ),
      ],
      rows: _topicList.map<DataRow>((TopicDesc desc) {
        //var ch = DBManager.singleton().findChannelKeyValue(desc.channelId);

        KeyName curator =null;
       if(desc.topicType == TopicType.Curation)
         curator = ChannelDataManager.singleton().findChannelKeyValue(desc.channelId);

        return DataRow(
          key: Key(desc.topicId),
//
//          onSelectChanged: (bool selected) {
//            print('row-selected: ${desc.videoKey}');
//
//            Navigator.of(context).push(new CupertinoPageRoute(
//                builder: (context) => VideoDetialPage(),
//                fullscreenDialog: false));
//          },
          cells: <DataCell>[
            DataCell(
              Text(desc.topicId),
            ),
            DataCell(
              Text( KeyName.findKeyValue(TopicTypeKeyNameList, desc.topicType).value)
            ),
            DataCell(
                curator != null ? Text(curator.value) : Text('')
            ),

            DataCell(
                WidgetUtil.buildEditableText(desc.name, (text) {
                  desc.name = text;
                  TopicDataManager.singleton().updateTopic(desc);
                })
            ),

            DataCell(
              WidgetUtil.buildEditableText(desc.section, (text){
                desc.section = text;
                TopicDataManager.singleton().updateTopic(desc);
              }),
            ),
            DataCell(
              FutureBuilder(
                future: LessonDataManager.singleton().countLessonInTopic(desc.topicId),
                  builder : (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.hasData) {
                      return Text(snapshot.data.toString());
                    } else {
                      return Text('loading...');
                    }
                  }
              )

            ),
            DataCell(
              FlatButton(child: Text('삭제'), onPressed: (){
                deleteTopic(desc);
              },),
            )
          ],
        );
      }).toList(),
    );

    return Align(alignment: Alignment.topLeft, child: table);
  }

}

