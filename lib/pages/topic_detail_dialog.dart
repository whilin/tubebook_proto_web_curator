import 'package:flutter/material.dart';
import 'package:mywebapp/models/models.dart';

class TopicDetailDialog extends StatelessWidget {
  final TopicDesc topic;

  final TextEditingController
      _textController; // = new TextEditingController(text: topic);
  TopicDetailDialog({
    this.topic,
  }) : _textController = new TextEditingController(text: topic.name);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
          width: 500,
          height: 300,
          color: Colors.white,
          child: topic == null ? _buildAdd(context) : _buildDetail(context)),
    );
  }

  Widget _buildAdd(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: new EdgeInsets.only(bottom: 40), child: Text('새로운 토픽 등록')),
        Container(
            width: 300,
            child: TextField(
                textAlign: TextAlign.center,
                controller: _textController,
                onSubmitted: (String text) {
                  onSubmitText(text);
                  Navigator.of(context).pop(true);
                })),
        ButtonBar(alignment: MainAxisAlignment.center, children: [
          FlatButton(
            child: Text('추가'),
            onPressed: () {
              // onSubmitText(text);
              Navigator.of(context).pop(true);
            },
          )
        ])
      ],
    );
  }

  void onSubmitText(String text) {
    _textController.text;

    //Navigator.of(context).pop(true);
  }

  Widget _buildDetail(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        new Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              '토픽 수정',
              style: TextStyle(fontSize: 20),
            )),
        new Padding(
            padding: EdgeInsets.only(top: 150),
            child: Container(
                width: 300,
                child: TextField(
                    textAlign: TextAlign.center,
                    controller: _textController,
                    onSubmitted: (String text) {
                      onSubmitText(text);
                      Navigator.of(context).pop(true);
                    }))),
        new Padding(
            padding: EdgeInsets.only(top: 230),
            child: ButtonBar(alignment: MainAxisAlignment.center, children: [
              FlatButton(
                child: Text('수정하기'),
                onPressed: () {
                  // onSubmitText(text);
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: Text('닫 기'),
                onPressed: () {
                  // onSubmitText(text);
                  Navigator.of(context).pop(true);
                },
              ),
            ]))
      ],
    );
  }
}
