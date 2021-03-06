import 'package:flutter/material.dart';
import 'package:mywebapp/manager/LessonDataManager.dart';
import 'package:mywebapp/models/models.dart';

class WidgetUtil {

  static TextStyle style = new TextStyle(fontSize: 12);

  static Widget buildEditableText(String initText,
      void Function(String newText) onChanged) {
    return TextField(
      style: style,
      controller: new TextEditingController(text: initText ?? ''),
      onSubmitted: (text) {
        onChanged(text);
      },
    );
  }

  static Widget buildEditableLongText(String initText,
      void Function(String newText) onChanged) {
    return TextField(
      style: style,
      maxLines: 10,
      controller: new TextEditingController(text: initText ?? ''),
      onSubmitted: (text) {
        onChanged(text);
      },
    );
  }

  static Widget buildListSelector(List<KeyName> list, dynamic selectedKey,
      void Function(KeyName) OnSelected, {double width: 300}) {
    return DropdownButton<KeyName>(
      value: KeyName.findKeyValue(list, selectedKey),
      onChanged: (KeyName sel) {
        OnSelected(sel);
      },
      selectedItemBuilder: (BuildContext context) {
        return list.map<Widget>((KeyName item) {
          return SizedBox(
              width: width,
              child: Align(alignment: Alignment.centerLeft,
                  child: Text(item.value, style: style,)));
        }).toList();
      },
      items: list.map((KeyName item) {
        return DropdownMenuItem<KeyName>(
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

  static Widget buildLessonSelector(BuildContext context, String topicId,
      String selectedLesson, void Function(String) OnSelected
      , {double width: 300}) {
    return FutureBuilder(
        future: LessonDataManager.singleton().loadLessonListByTopic(topicId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<KeyName> list = [];
            KeyName.initList_append(list, snapshot.data as List<KeyName>);
            return buildListSelector(list, selectedLesson, (keyValue) {
              OnSelected(keyValue.key);
            }, width: width);
          } else {
            return Icon(Icons.refresh);
          }
        }
    );
  }


  static Widget buildLevelEnumSelector(LessonLevel selected,
      void Function(LessonLevel) onSelected) {
    return DropdownButton<LessonLevel>(
      value: selected,
      onChanged: (LessonLevel newValue) {
        onSelected(newValue);
      },
      selectedItemBuilder: (BuildContext context) {
        return LessonLevel.values.map<Widget>((LessonLevel item) {
          return SizedBox(
            // width: 300,
              child: Align(alignment: Alignment.centerLeft,
                  child: Text(item.toString(), style: style,)));
        }).toList();
      },
      items: LessonLevel.values.map((e) =>
          DropdownMenuItem<LessonLevel>(
            value: e,
            child: Text(e.toString()),
          )).toList(),
    );
  }


  static String findPublishStage(int publish) {

    publish = publish ?? 0;

    if (publish == 0)
      return 'Draft';
    else if (publish == 1)
      return 'Review';
    else //if(desc.publish  > 1)
      return 'Publish';
  }

  static Widget buildPublisSelector(int selected,
      void Function(int) onSelected) {

    selected= selected?? 0;

    return DropdownButton<int>(
        value: selected,
        onChanged: (int newValue) {
          onSelected(newValue);
        },
        selectedItemBuilder: (BuildContext context) {
          return List.generate(3, (index) => index).map<Widget>((int item) {
            return SizedBox(
              // width: 300,
                child: Align(alignment: Alignment.centerLeft,
                    child: Text(findPublishStage(item), style: style,)));
          }).toList();
        },
        items: List.generate(3, (index) => index).map((int item) {
          return DropdownMenuItem<int>(
              value : item,
              child: Align(alignment: Alignment.centerLeft,
                  child: Text(findPublishStage(item), style: style,)));
        }).toList()
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