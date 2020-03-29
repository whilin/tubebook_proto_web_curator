import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywebapp/manager/TopicDataManager.dart';
import 'package:mywebapp/manager/db_manager.dart';
import 'package:mywebapp/models/models.dart';
import 'package:mywebapp/pages/topic_detail_dialog.dart';

class TopicListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TopicListPageState();
  }
}

class _TopicListPageState extends State<TopicListPage> {
  List<VideoDesc> videoList = new List<VideoDesc>();

  int activePage = 0;
  int totalPage = 0;
  int totalCount = 0;
  int countPerPage = 10;
  dynamic where = {};

  final List<TopicDesc> _topicList = new List<TopicDesc>();

  @override
  void initState() {
    super.initState();

    _topicList.clear();
    _topicList.addAll(TopicDataManager.singleton().topicList);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    // TODO: implement build
    return GridView.builder(
        primary: true,
        padding: const EdgeInsets.all(20),
//      crossAxisSpacing: 10,
//      mainAxisSpacing: 10,
//      crossAxisCount: 3,
        //semanticChildCount: 3,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
        itemCount: _topicList.length + 1,
        itemBuilder: (context, index) {
          if (index < _topicList.length)
            return getTopicCard(index);
          else
            return getAddCard();
        });
  }

  Widget getTopicCard(int i) {
    return new GestureDetector(
        child: Card(
          color: Colors.green,
            child: Align(
          alignment: Alignment.topLeft,
          child: new Padding(
              padding: EdgeInsets.all(20),
              child: Text(_topicList[i].name,
                  style: TextStyle(fontSize: 20, color: Colors.indigo))),
        )),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return new TopicDetailDialog(topic: _topicList[i]);
              });
        });
  }

  Widget getAddCard() {
    return new GestureDetector(
      child: new Card(
          child: new Icon(
        Icons.add,
        size: 50,
      )),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return new TopicDetailDialog(topic: null);
            });
      },
    );
  }
}
