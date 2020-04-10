import 'package:aws_client/aws_client.dart';
import 'package:aws_client/s3.dart';
import 'package:flutter/material.dart';
import 'package:mywebapp/sandbag/topic_list_page.dart';
import 'package:mywebapp/sandbag/mongodb_manager.dart';
import 'package:mywebapp/pages/video_list_page.dart';
import 'package:http_client/console.dart' as http;
import 'manager/db_manager.dart';
import 'pages/channel_list_page.dart';
import 'pages/lesson_list_page.dart';
import 'pages/topic_list_2_page.dart';

Future callAWS() async {
  var httpClient = http.ConsoleClient();
  var credentials =
      new Credentials(accessKey: 'MY_ACCESS_KEY', secretKey: 'MY_SECRET_KEY');
  var aws = new Aws(credentials: credentials, httpClient: httpClient);

  var queue = aws.sqs.queue('https://my-queue-url/number/queue-name');
  await queue.sendMessage('Hello from Dart client!');
  httpClient.close();
}

Future main() async {
  // callAWS();

  await GlobalDataManager.singleton().loadInitializedData();

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo2',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedPage = 1;

  void setPage(int page) {
    setState(() {
      _selectedPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    var w = Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: <Widget>[
            Drawer(
              elevation: 1,
                child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  margin: EdgeInsets.zero,
                  child: Center(
                    child: Container(),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.play_circle_filled),
                  title: Text('Videos'),
                  onTap: () {
                    setPage(0);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.book),
                  title: Text('Lessons'),
                  onTap: () {
                    setPage(1);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Creator'),
                  onTap: () {
                    setPage(2);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.star),
                  title: Text('Topics'),
                  onTap: () {
                    setPage(3);
                  },
                ),
              ],
            )),
            Expanded(
                child: IndexedStack(
              index: _selectedPage,
              children: <Widget>[
                VideoListPage(),
                LessonListPage(),
                ChannelListPage(),
                TopicList2Page()
              ],
            ))
          ],
        ),
      ),
    );

    return w;
  }
}
