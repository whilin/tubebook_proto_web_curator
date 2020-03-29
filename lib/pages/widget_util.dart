
import 'package:flutter/material.dart';
import 'package:mywebapp/manager/LessonDataManager.dart';
import 'package:mywebapp/models/models.dart';

class WidgetUtil{

  static TextStyle style = new TextStyle(fontSize: 12);

  static Widget buildEditableText(String initText, void Function(String newText) onChanged) {
    return TextField(
      style: style,
      controller: new TextEditingController(text: initText ?? ''),
      onSubmitted: (text) {
        onChanged(text);
      },
    );
  }

  static Widget buildEditableLongText(String initText, void Function(String newText) onChanged) {
    return TextField(
      style: style,
      maxLines: 10,
      controller: new TextEditingController(text: initText ?? ''),
      onSubmitted: (text) {
        onChanged(text);
      },
    );
  }

  static Widget buildListSelector(
      List<KeyValue> list, String selectedKey, void Function(KeyValue) OnSelected) {

    return DropdownButton<KeyValue>(
      value: KeyValue.findKeyValue(list, selectedKey),
      onChanged: (KeyValue sel) {
        OnSelected(sel);
      },
      selectedItemBuilder: (BuildContext context) {
        return list.map<Widget>((KeyValue item) {
          return SizedBox(
              width: 300,
              child: Align(alignment: Alignment.centerLeft, child: Text(item.value, style: style,)));
        }).toList();
      },
      items: list.map((KeyValue item) {
        return DropdownMenuItem<KeyValue>(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                '${item.value}',
                textAlign: TextAlign.right, style: style,
              )),
          value: item,
        );
      }).toList(),
    );
  }

  static Widget buildLessonSelector(BuildContext context, String topicId, String selectedLesson, void Function(String) OnSelected) {

    return FutureBuilder(
        future: LessonDataManager.singleton().loadLessonListByTopic(topicId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<KeyValue> list= [];
            KeyValue.initList_append(list, snapshot.data as List<KeyValue>);
            return buildListSelector(list, selectedLesson, (keyValue) {
              OnSelected(keyValue.key);
            });
          } else {
            return Icon(Icons.refresh);
          }
        }
    );
  }


  static Widget buildLevelEnumSelector(LessonLevel selected, void Function(LessonLevel) onSelected) {
    return DropdownButton<LessonLevel> (
        value : selected,
        onChanged: (LessonLevel newValue) {
          onSelected(newValue);
        },
        selectedItemBuilder: (BuildContext context) {
          return LessonLevel.values.map<Widget>((LessonLevel item) {
            return SizedBox(
               // width: 300,
                child: Align(alignment: Alignment.centerLeft, child: Text(item.toString(), style: style,)));
          }).toList();
        },
        items: LessonLevel.values.map((e) => DropdownMenuItem<LessonLevel>(
          value: e,
          child: Text(e.toString()),
        )).toList(),
    );
  }
}


class NameValueWidget extends StatelessWidget {
  final String name;
  final Widget edit;
  final double h;

  NameValueWidget({this.name, this.edit, this.h = 1});

  @override
  Widget build(BuildContext context) {
    var row = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 200,
          height: 50 * h,
          alignment: Alignment.centerLeft,
          child: Padding(padding: EdgeInsets.only(left: 10), child: Text(name)),
          // color: Colors.grey,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.grey,
          ),
        ),
        Container(
          width: 400,
          height: 50 * h,
          alignment: Alignment.centerLeft,
          color: Colors.black12,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: edit),
        )
      ],
    );

    return Padding(
        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1), child: row);
  }
}