import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

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

  final key = new GlobalKey<ScaffoldState>();

  var _lastRow = 0;
  final FETCH_ROW = 50;
  var stream;
  final Set<Record> _saved = new Set<Record>();   // Add this line.

  ScrollController _scrollController = new ScrollController();
  BannerAd _bannerAd;

  RecordDatabase recordDatabase = RecordDatabase.get();

  static final MobileAdTargetingInfo targetingInfo = new MobileAdTargetingInfo(
    childDirected: false,
    designedForFamilies: false,
    gender: MobileAdGender.unknown, // or MobileAdGender.female, MobileAdGender.unknown
    testDevices: <String>[AD_MOB_TEST_DEVICE],
  );

//  BannerAd createBannerAd() {
//    return new BannerAd(
//      adUnitId: AD_MOB_AD_ID,
//      targetingInfo: targetingInfo,
//      size: AdSize.banner,
//      listener: (MobileAdEvent event) {
//        print("BannerAd event is $event");
//      },
//    );
//  }

  void _pushSaved() {



    Navigator.of(context).push(
      new MaterialPageRoute<void>(   // Add 20 lines from here...
        maintainState: true,
        builder: (BuildContext c) {
          final Iterable<Card> list = _saved.map(
                (Record record) {
                  final bool alreadySaved = _saved.contains(record);
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
                                Container(height: 30.0, width: 40.0,child:FlatButton (
                                  child: new Icon(Icons.share),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.only(bottom: 0.0, top: 0.0, left: 0.0, right: 0.0),
                                  textTheme: ButtonTextTheme.normal,
                                  onPressed: () {
                                    Share.share(record.title + '\n' + record.href + '\n\n' '컴모 - 커뮤니티 모아보기 앱으로 편하게 보세요! \n https://play.google.com/store/apps/details?id=com.machinelearningkorea.communitymoa');
                                  },
                                ),),
                                Container(height: 30.0, width: 60.0,child:FlatButton(
                                  child: new Icon(   // Add the lines from here...
                                    Icons.delete_sweep
                                  ),
                                  padding: EdgeInsets.only(bottom: 0.0, top: 0.0, left: 0.0, right: 0.0),
                                  textTheme: ButtonTextTheme.normal,
                                  onPressed: () {
                                    setState(() {
                                      if (alreadySaved) {
                                        _saved.remove(record);
                                        recordDatabase.deleteRecord(record.title);
                                        print("remove : " + record.title);
                                        key.currentState.showSnackBar(new SnackBar(content: Text("다음부터는 해당하는 즐겨찾기 \n (" + record.title + ") 가 나타나지 않습니다.")));
                                      }
                                    });
                                  },
                                ),),
                              ],),

                            contentPadding: EdgeInsets.only(bottom: 5.0, top: 5.0, left: 10.0, right: 0.0)
                        ),

                      ],
                    ),
                  );
            },
          );
          final List<Widget> divided = ListTile
              .divideTiles(
            context: context,
            tiles: list,
          ).toList();

          //광고 보여주기용 placeholder
//          List<Widget> fakeBottomButtons = new List<Widget>();
//          fakeBottomButtons.add(new Container(height:40.0,));

          return new Scaffold(
            appBar: new AppBar(
              title: Text('즐겨찾기', style: TextStyle(fontFamily: 'NotoSansKR', fontWeight: FontWeight.w700),),
              elevation: 1.0,
            ),
            key: key,
            body: new ListView(children: divided),
//            persistentFooterButtons: fakeBottomButtons,
          );
        },
      ),                           // ... to here.
    );
  }


  @override
  void dispose() {
    _bannerAd?.dispose();
        
    super.dispose();
  }

  Record convertToRecord(SavedRecord savedRecord) {
    return new Record.fromMap({"title" : savedRecord.title, "href" : savedRecord.href, "site" : savedRecord.site, "timestamp" : savedRecord.timestamp, 'comment_count' : '0'});
  }

  SavedRecord convertFromRecord(Record record) {
    return new SavedRecord.fromMap({"title" : record.title, "href" : record.href, "site" : record.site, "timestamp" : record.timestamp});
  }

  @override
  void initState() {
    super.initState();
    
    //시작할때 데이터베이스 로딩해서 record에 담아둔다.
    recordDatabase.init().whenComplete((){
      recordDatabase.getRecords().then((list){
        print(list.toString());
        _saved.addAll(list.map((savedRecord)=> convertToRecord(savedRecord)));
      });
    });

//
//    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-5637469297137210~5362351240');
//    _bannerAd = createBannerAd()..load()..show(
//      // Positions the banner ad 60 pixels from the bottom of the screen
////      anchorOffset: 3.0,
////      // Banner Position
////      anchorType: AnchorType.bottom,
//    );

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
        actions: <Widget>[

          IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: (){
              _scrollController.animateTo(0.0, duration: new Duration(seconds: 1), curve: Curves.ease);
              return setState(() => stream = newStream());
            }
          ),
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        ],
        leading: Image.asset("asset/" + "burger.png", fit: BoxFit.scaleDown, height: 2.toDouble(),),
        title : Text('컴모 - 커뮤니티 모아보기', style: TextStyle(fontFamily: 'NotoSansKR', fontWeight: FontWeight.w700),)
      ),
      body: _buildBody(context),
//      persistentFooterButtons: fakeBottomButtons,
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
          final currentRow = (i + 1) ~/ FETCH_ROW;
          if (_lastRow != currentRow)  {
            _lastRow = currentRow;
          }
          return _buildListItem(context, snapshot[i]);
        });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    final bool alreadySaved = _saved.contains(record);

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
            trailing: Row(

//              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
//              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Container(height: 30.0, width: 40.0,child:FlatButton (
                child: new Icon(Icons.share),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.only(bottom: 0.0, top: 0.0, left: 0.0, right: 0.0),
                textTheme: ButtonTextTheme.normal,
                onPressed: () {
                  Share.share(record.title + '\n' + record.href + '\n\n' '컴모 - 커뮤니티 모아보기 앱으로 편하게 보세요! \n https://play.google.com/store/apps/details?id=com.machinelearningkorea.communitymoa');
                },
              ),),
              Container(height: 30.0, width: 60.0,child:FlatButton(
                child: new Icon(   // Add the lines from here...
                  alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: alreadySaved ? Colors.red : null,
                ),
                padding: EdgeInsets.only(bottom: 0.0, top: 0.0, left: 0.0, right: 0.0),
                textTheme: ButtonTextTheme.normal,
                onPressed: () {
                  setState(() {
                    if (alreadySaved) {
                      _saved.remove(record);
                      recordDatabase.deleteRecord(record.title);
                      print("adding : " + record.title);
                    } else {
                      _saved.add(record);
                      recordDatabase.updateRecord(convertFromRecord(record));
                      print("adding : " + record.title);
                    }
                  });
                },
              ),),
            ],),

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

class RecordDatabase {
  static final RecordDatabase _recordDatabase = new RecordDatabase._internal();

  final String tableName = "SAVED_RECORDS";

  Database db;

  static RecordDatabase get() {
    return _recordDatabase;
  }

  RecordDatabase._internal();

  Future<SavedRecord> getRecord(String id) async{
    var result = await db.rawQuery('SELECT * FROM $tableName WHERE title = "$id"');
    if(result.length == 0) return null;
    return new SavedRecord.fromMap(result[0]);
  }

  Future<List<SavedRecord>> getRecords() async{

    var result = await db.rawQuery('SELECT * FROM $tableName');

    List<SavedRecord> books = [];

    for(Map<String, dynamic> item in result) {
      books.add(new SavedRecord.fromMap(item));
    }
    return books;
  }

  Future updateRecord(SavedRecord savedRecord) async {

    await db.rawInsert(
          'INSERT OR REPLACE INTO '
              '$tableName(title, href, site, timestamp)'
              ' VALUES("${savedRecord.title}", "${savedRecord.href}", "${savedRecord.site}", "${savedRecord.timestamp}")');
//    ' VALUES("1", "2", "3", "4")');
    }

  Future deleteRecord(String title) async {
    await db.rawDelete(
        'DELETE FROM '
            '$tableName'
            ' WHERE title = "${title}"');
  }

  Future init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path +  "de.db";
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              "CREATE TABLE $tableName ("
                  "title STRING PRIMARY KEY,"
                  "href STRING,"
                  "site STRING,"
                  "timestamp STRING"
                  ")");
        });
  }
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
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$title:$href>";
}
