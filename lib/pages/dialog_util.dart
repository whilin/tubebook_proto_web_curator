import 'package:flutter/material.dart';
import 'package:mywebapp/manager/ChannelDataManager.dart';
import 'package:mywebapp/manager/LessonDataManager.dart';
import 'package:mywebapp/manager/TopicDataManager.dart';
import 'package:mywebapp/models/models.dart';
import 'package:mywebapp/pages/widget_util.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

class DialogUtil {

  static void showAddTopic(BuildContext context, VoidCallback callback) async {
    String topicId = '';

    String result = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('토픽 추가'),
            content: Container(
                height: 200,
                width: 500,
                child: Column(children: [
                  Text("Input topic id"),
                  TextField(
                    controller: new TextEditingController(text: topicId),
                    onSubmitted: (text) {
                      topicId = text;
                    },
                  )
                ])),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context, "OK");
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context, "Cancel");
                },
              ),
            ],
          );
        });

    if (result == 'OK') {
      TopicDesc newDesc = new TopicDesc(topicId);
      newDesc.topicType = TopicType.Category;
      await TopicDataManager.singleton().insertTopic(newDesc);
    }

    callback();
  }

  static void showAddCuratorTopic(BuildContext context, VoidCallback callback) async {


    String topicId = '';
    String curatorId = '';

    var list = ChannelDataManager.singleton().findCuratorKeyValues();


    String result = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('큐레이션 토픽 추가'),
            content: Container(
                height: 200,
                width: 500,
                child: Column(children: [
                  Text("Select Curator"),

                  WidgetUtil.buildListSelector(list, curatorId, (key) {
                    curatorId =key.key;
                  }),

                  Text("Input topic id"),
                  TextField(
                    controller: new TextEditingController(text: topicId),
                    onSubmitted: (text) {
                      topicId = text;
                    },
                  )
                ])),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context, "OK");
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context, "Cancel");
                },
              ),
            ],
          );
        });

    if (result == 'OK') {
      TopicDesc newDesc = new TopicDesc(topicId);
      newDesc.topicType = TopicType.Curation;
      newDesc.channelId = curatorId;
      await TopicDataManager.singleton().insertTopic(newDesc);
    }

    callback();
  }


  static void showAddChannel(
      BuildContext context, VoidCallback callback) async {
    String channelId = '';

    String result = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('채널 추가'),
            content: Container(
                height: 200,
                width: 500,
                alignment: Alignment.bottomCenter,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Input Youtube channel key"),
                      TextField(
                        controller: new TextEditingController(text: channelId),
                        onSubmitted: (text) {
                          channelId = text;
                        },
                      )
                    ])),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context, "OK");
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context, "Cancel");
                },
              ),
            ],
          );
        });

    if (result == 'OK') {
      ChannelDesc newDesc = new ChannelDesc(channelId);
      newDesc.channelType = ChannelType.Creator;

      await ChannelDataManager.singleton().insertChannel(newDesc);
    }

    callback();
  }


  static void showAddCurator(
      BuildContext context, VoidCallback callback) async {

    String channelId = randomAlphaNumeric(24);
    String channelName = '';

    String result = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('큐레이터 등록'),
            content: Container(
                height: 200,
                width: 500,
                alignment: Alignment.bottomCenter,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
//                      Text("Input Curator Unique ID"),
//                      TextField(
//                        controller: new TextEditingController(text: channelId),
//                        onSubmitted: (text) {
//                          channelId = text;
//                        }),
                      Text(channelId),
                      Container(height: 30,),
                      Text("Input Creator Name"),
                      TextField(
                          controller: new TextEditingController(text: channelName),
                          onSubmitted: (text) {
                            channelName = text;
                          })
                    ])),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context, "OK");
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context, "Cancel");
                },
              ),
            ],
          );
        });

    if (result == 'OK') {

      ChannelDesc newDesc = new ChannelDesc(channelId);
      newDesc.channelType = ChannelType.Curator;
      newDesc.name = channelName;

      await ChannelDataManager.singleton().insertChannel(newDesc);
    }

    callback();
  }


  static void showAddLesson(
      BuildContext context, String topicId, VoidCallback callback) async {

    String lessonId = randomAlphaNumeric(24);
    String catId = topicId;
    String curId = '';
    String title = '';

   // var topic = TopicDataManager.singleton().findTopicKeyValue(topicId);

    var catList = TopicDataManager.singleton().findTopicKeyValuesAtCategory();
    var curatorList = TopicDataManager.singleton().findTopicKeyValuesAtCuration();

    catList.insert(0, new KeyName('', '-'));
    curatorList.insert(0, new KeyName('', '-'));


    String result = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('레슨 추가'),
            content: Container(
                height: 300,
                width: 500,
                child: Column(children: [
                  Text(lessonId),
                  Container(height: 30,),

                  Text("Select Catogory Topic"),
                  WidgetUtil.buildListSelector(catList, catId, (keyName) {
                    catId = keyName.key;
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Select Curator Topic"),
                  WidgetUtil.buildListSelector(curatorList, curId, (keyName) {
                    curId = keyName.key;
                  }),
                 // Text("[${topic.value}]"),

                  SizedBox(
                    height: 10,
                  ),

                  Text('Input Lesson Title'),
                  WidgetUtil.buildEditableText(title, (newText) {
                    title = newText;
                  })

                ])),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context, "OK");
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context, "Cancel");
                },
              ),
            ],
          );
        });

    if (result == 'OK') {
      LessonDesc newDesc = new LessonDesc.gen(catId, lessonId);
      newDesc.subTopicId = curId;
      newDesc.title = title;
      await LessonDataManager.singleton().insertLesson(newDesc);
    }

    callback();
  }

  static void showDeleteLesson(
      BuildContext context, LessonDesc desc, void Function(bool) callback) async {

    String title = '레슨 삭제하기';
    String message = '정말 ${desc.title} 강좌를 삭제하시겠습니까?';

    showDeleteOk(context, title, message, callback);
  }

  static void showDeleteOk(
      BuildContext context, String title, String message, void Function(bool) callback) async {
    String channelId = '';

    String result = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Container(
                height: 200,
                width: 500,
                alignment: Alignment.bottomCenter,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(message),
                    ])),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context, "OK");
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context, "Cancel");
                },
              ),
            ],
          );
        });


    callback(result=="OK");
  }
}
