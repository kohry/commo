//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:communitymoa/pravacy.dart';
import 'package:cloud_firestore_all/cloud_firestore_all.dart';


const String AD_MOB_APP_ID = 'ca-app-pub-5637469297137210~5362351240';
const String AD_MOB_TEST_DEVICE = 'test_device_id - run ad then check device logs for value';
const String AD_MOB_AD_ID = 'ca-app-pub-5637469297137210/8187324125';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '컴모 - 커뮤니티 모아보기',
      home: MyHomePage(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,

      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {

  final Firestore firestore = firestoreInstance;

  final key = new GlobalKey<ScaffoldState>();

  var _lastRow = 0;
  final FETCH_ROW = 50;
  var stream;

  ScrollController _scrollController = new ScrollController();



  @override
  void initState() {
    super.initState();


    stream = newStream();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        setState( () => stream = newStream() );
      }
    });
  }

  Stream<QuerySnapshot> newStream() {


    return firestoreInstance.collection('posts').orderBy("timestamp", descending: true).limit(FETCH_ROW * (_lastRow + 1)).onSnapshot;
  }

  @override
  Widget build(BuildContext context) {
//
    List<Widget> fakeBottomButtons = new List<Widget>();
    fakeBottomButtons.add(new Container(height:40.0,));

    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: 10.0,
        elevation: 1.0,
        leading: Image.asset("asset/" + "burger.png", fit: BoxFit.scaleDown, height: 2.toDouble(),),
        title : Text('컴모 - 커뮤니티 모아보기', style: TextStyle(fontFamily: 'NotoSansKR', fontWeight: FontWeight.w700),)
      ),
      body: _buildBody(context),
//      persistentFooterButtons: fakeBottomButtons,
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.docs);
      },
    );
  }



  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: snapshot.length,
        itemBuilder: (context, i) {
          final currentRow = (i + 1) ~/ FETCH_ROW;
          if (_lastRow != currentRow && currentRow > _lastRow)  {
            _lastRow = currentRow;
          }
          return _buildListItem(context, snapshot[i]);
        });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
//    final bool alreadySaved = _saved.contains(record);

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Image.asset("asset/" + record.site + ".jpg", fit: BoxFit.fitHeight, width: 50.toDouble(),),
            title: Text(record.title, style: TextStyle(fontFamily: 'NotoSansKR', fontWeight: FontWeight.w500),),
            subtitle: Text(record.site + " : " + record.timestamp, style: TextStyle(fontFamily: 'NotoSansKR')),
            onTap: () => _launchURL(record.href),
            trailing: Row(

              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
            ],),

            contentPadding: EdgeInsets.only(bottom: 5.0, top: 5.0, left: 10.0, right: 0.0)
          ),

        ],
      ),
    );

  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class SavedRecord {
  String title;
  String href;
  String site;
  String timestamp;

  SavedRecord.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        href = map['href'],
        site = map['site'],
        timestamp = map['timestamp'];

}


class Record {
  final String title;
  final String href;
  final String site;
  final String comment_count;
  final String timestamp;
  final DocumentReference reference;

  @override
  bool operator==(other) {
    if (other is Record && other.title == title && other.href == href) return true;
    else return false;
  }

  int get hashCode => title.hashCode + href.hashCode;


  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : title = map['title'],
        href = map['href'],
        site = map['site'],
        comment_count = map['comment_count'],
        timestamp = map['timestamp'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.ref);

  @override
  String toString() => "Record<$title:$href>";
}
