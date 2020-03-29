import 'package:flutter/material.dart';
import 'package:mywebapp/manager/ChannelDataManager.dart';
import 'package:mywebapp/manager/LessonDataManager.dart';
import 'package:mywebapp/manager/TopicDataManager.dart';
import 'package:mywebapp/models/models.dart';
import 'package:mywebapp/pages/widget_util.dart';

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
      await ChannelDataManager.singleton().insertChannel(newDesc);
    }

    callback();
  }

  static void showAddLesson(
      BuildContext context, String topicId, VoidCallback callback) async {
    String lessonId = '';

    var topic = TopicDataManager.singleton().findTopicKeyValue(topicId);

    String result = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('레슨 추가'),
            content: Container(
                height: 200,
                width: 500,
                child: Column(children: [
                  Text("[${topic.value}]"),
                  SizedBox(
                    height: 30,
                  ),
                  // Text('Input LessonId'),
                  WidgetUtil.buildEditableText(lessonId, (newText) {
                    lessonId = newText;
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
      LessonDesc newDesc = new LessonDesc.gen(topicId, lessonId);
      await LessonDataManager.singleton().insertLesson(newDesc);
    }

    callback();
  }
}
