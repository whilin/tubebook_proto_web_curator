import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywebapp/manager/ChannelDataManager.dart';
import 'package:mywebapp/manager/VideoDataManager.dart';
import 'package:mywebapp/manager/db_manager.dart';
import 'package:mywebapp/manager/youtube_util.dart';
import 'package:mywebapp/models/models.dart';
import 'package:mywebapp/pages/dialog_util.dart';
import 'package:mywebapp/pages/topic_detail_dialog.dart';

class ChannelListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChannelListPageState();
  }
}

class _ChannelListPageState extends State<ChannelListPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        body: Column(children: [buildAddButton(), ChannelDataTable()]));
  }

  Widget buildAddButton() {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      children: <Widget>[
        FlatButton(child: Text('채널 추가'), onPressed:  showAddChannel)
      ],
    );
  }

  void showAddChannel() {
    DialogUtil.showAddChannel(context, () {
      setState(() {

      });
    });
  }
}

class ChannelDataTable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChannelDataTableState();
  }
}

class _ChannelDataTableState extends State<ChannelDataTable> {
  final List<ChannelDesc> _topicList = new List<ChannelDesc>();

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
    setState(() {});

    await ChannelDataManager.singleton().loadChannelList();
    _topicList.addAll(ChannelDataManager.singleton().channelList);

    setState(() {});
  }

  void deleteTopic(ChannelDesc desc) async {
    await ChannelDataManager.singleton().deleteChannel(desc);
    setState(() {});
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
          label: const SizedBox(width: 200, child: Text('Name')),
        ),

        const DataColumn(
          label: Text('Videos'),
        ),
        const DataColumn(
          label: Text('actions'),
        ),

//        const DataColumn(
//          label: Text('Description'),
//          tooltip: '...',
//        ),
      ],
      rows: _topicList.map<DataRow>((ChannelDesc desc) {
        //var ch = DBManager.singleton().findChannelKeyValue(desc.channelId);

        return DataRow(
          key: Key(desc.channelId),
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
              Text(desc.channelId),
            ),
            DataCell(buildEditableText(desc.name, (text) {
              desc.name = text;
              ChannelDataManager.singleton().updateChannel(desc);
            })),
            DataCell(FutureBuilder(
                future: VideoDataManager.singleton()
                    .countVideoInChannel(desc.channelId),
                builder: (context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData)
                    return Text(snapshot.data.toString());
                  else
                    return Text('loading...');
                })),
            DataCell(
              ButtonBar(
                children : [
                  FlatButton(
                    child: Text('채널 열기'),
                    onPressed: () {
                      YoutubeUtil.openChannel(desc.channelId);
                    },
                  ),
              FlatButton(
                child: Text('삭제'),
                onPressed: () {
                  deleteTopic(desc);
                },
              )]
              ),
            )
          ],
        );
      }).toList(),
    );

    return Align(alignment: Alignment.topLeft, child: table);
  }

  Widget buildEditableText(
      String initText, void Function(String newText) onChanged) {
    return TextField(
      controller: new TextEditingController(text: initText),
      onSubmitted: (text) {
        onChanged(text);
      },
    );
  }
}
