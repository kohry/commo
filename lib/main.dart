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

  var lastVisible;
  final _dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('컴모 - 커뮤니티 모아보기')),
//      body: _buildBody(context),
      body: _buildList(context),
    );
  }

//  Widget _buildBody(BuildContext context) {
//
//
//    return StreamBuilder<QuerySnapshot>(
//      stream: Firestore.instance.collection('posts').orderBy("timestamp",descending: true).limit(50).snapshots(),
//      builder: (context, snapshot) {
//        if (!snapshot.hasData) return LinearProgressIndicator();
//        lastVisible = snapshot.data.documents.last;
//        return _buildList(context, snapshot.data.documents);
//      },
//    );
//  }

  Widget _buildList(BuildContext context) {
    final _dataList = [];

    return ListView.builder(itemBuilder: (context, i) {
      final index = i ~/ 50; //40개가 넘어가면 +1, +2 이렇게 넘어감
      print("iiiiiiiiiiiiii:" + i.toString());
      print("sss" + _dataList.length.toString());
      if (index >= _dataList.length) {
        final query = Firestore.instance.collection('posts').orderBy('timestamp', descending: true);
        final snapshot = _dataList.length == 0 ? query : query.startAfter(lastVisible);

        final docs = snapshot.limit(50).getDocuments();

        docs.then((s) {
          _dataList.addAll(s.documents);
        });

        return _buildListItem(context, _dataList.elementAt(i));
      }
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



//    return ListView.builder(itemBuilder: (context, i) {
//         final index = i ~/ 50; //40개가 넘어가면 +1, +2 이렇게 넘어감
//         if (index > loadingLength) {
//           final snapshot = Firestore.instance.collection('posts').orderBy("timestamp",descending: true).startAfter(lastVisible).limit(50).getDocuments();
//           snapshot.then((s) => {
//                _dataList.addAll(s.documents);
//                lastVisible = s.documents.last;
//           });
//         } else { //맨처음
//           return _buildListItem(context,snapshot[i]);
//         }
//
//    });
//
//    return ListView(
//      padding: const EdgeInsets.only(top: 20.0),
//      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
//    );
//  }

//  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
//
//    final loadingLength = 0;
//    return ListView.builder(itemBuilder: (context, i) {
//         final index = i ~/ 50; //40개가 넘어가면 +1, +2 이렇게 넘어감
//         if (index > loadingLength) {
//           final snapshot = Firestore.instance.collection('posts').orderBy("timestamp",descending: true).startAfter(lastVisible).limit(50).getDocuments();
//           snapshot.then((s) => {
//                _dataList.addAll(s.documents);
//                lastVisible = s.documents.last;
//           });
//         } else { //맨처음
//           return _buildListItem(context,snapshot[i]);
//         }
//
//    });
//
//    return ListView(
//      padding: const EdgeInsets.only(top: 20.0),
//      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
//    );
//  }



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