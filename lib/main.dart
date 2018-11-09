import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'second_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String AD_MOB_APP_ID = 'ca-app-pub-5637469297137210~5362351240';
const String AD_MOB_TEST_DEVICE = 'test_device_id - run ad then check device logs for value';
const String AD_MOB_AD_ID = 'ca-app-pub-5637469297137210/1323443002';

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

  var _lastRow = 0;
  final FETCH_ROW = 50;
  var stream;

  ScrollController _scrollController = new ScrollController();
  BannerAd _bannerAd;

  static final MobileAdTargetingInfo targetingInfo = new MobileAdTargetingInfo(
    childDirected: false,
    designedForFamilies: false,
    gender: MobileAdGender.unknown, // or MobileAdGender.female, MobileAdGender.unknown
    testDevices: <String>[AD_MOB_TEST_DEVICE],
  );

  BannerAd createBannerAd() {
    return new BannerAd(
      adUnitId: AD_MOB_AD_ID,
      targetingInfo: targetingInfo,
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
  }


  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
//
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-5637469297137210~5362351240');
    _bannerAd = createBannerAd()..load()..show(
      // Positions the banner ad 60 pixels from the bottom of the screen
//      anchorOffset: 3.0,
//      // Banner Position
//      anchorType: AnchorType.bottom,
    );

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
      persistentFooterButtons: fakeBottomButtons,
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

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
//            leading: Icon(Icons.album),
            leading: Image.asset("asset/" + record.site + ".jpg", fit: BoxFit.fitHeight, width: 50.toDouble(),),
            title: Text(record.title, style: TextStyle(fontFamily: 'NotoSansKR', fontWeight: FontWeight.w500),),
            subtitle: Text(record.site + " : " + record.timestamp, style: TextStyle(fontFamily: 'NotoSansKR')),
            onTap: () => _launchURL(record.href),
            trailing: FlatButton(
                child: Text('공유'),
                padding: EdgeInsets.only(bottom: 0.0, top: 0.0, left: 0.0, right: 0.0),
                textTheme: ButtonTextTheme.accent,
                onPressed: () {
                  Share.share(record.title + '\n' + record.href + '\n\n' '컴모 - 커뮤니티 모아보기 앱으로 편하게 보세요! \n https://play.google.com/store/apps/details?id=com.machinelearningkorea.communitymoa');
                },
            ),
            contentPadding: EdgeInsets.only(bottom: 5.0, top: 5.0, left: 10.0, right: 0.0)
          ),

        ],
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
  final String timestamp;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : title = map['title'],
        href = map['href'],
        site = map['site'],
        comment_count = map['comment_count'],
        timestamp = map['timestamp'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$title:$href>";
}
