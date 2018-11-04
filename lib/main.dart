import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'second_screen.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Commo',
      home: MyHomePage(),
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
    return Firestore.instance.collection('posts').orderBy("timestamp", descending: true).limit(FETCH_ROW * (_lastRow + 1)).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('컴모 - 커뮤니티 모아보기')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    print("warning");
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }



  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: snapshot.length,
        itemBuilder: (context, i) {
          print("i : " + i.toString());
          final currentRow = (i + 1) ~/ FETCH_ROW;
          if (_lastRow != currentRow)  {
            _lastRow = currentRow;
          }
            print("lastrow : " + _lastRow.toString());
          return _buildListItem(context, snapshot[i]);
        });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.title),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.title),
          trailing: Text(record.site.toString()),
          onTap: () => _launchURL(record.href),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Record {
  final String title;
  final String href;
  final String site;
  final String comment_count;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : title = map['title'],
        href = map['href'],
        site = map['site'],
        comment_count = map['comment_count'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$title:$href>";
}
