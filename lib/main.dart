import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:convert' show Codec;

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

void main() => runApp(new CoMMoApp());

class CoMMoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '커뮤니티 모아보기',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('컴모 - 커뮤니티 모아보기'),
        ),
        body: Center(
          child: FutureBuilder<List<Post>>(
            future: fetchPost("BOBAE"),
            // future: fetchPostTest(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // return Text(snapshot.data.toString());
                return buildList(snapshot.data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

  Widget buildList(List<Post> posts) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          return buildRow(posts[i]);
        });
  }

  Widget buildRow(Post post) {
    return new ListTile(
      title: new Text(
        "[" + post.reference + "] " + post.title,
      ),
    );
  }

class Post {
  final String title;
  final String reference;
  final String url;

  Post({this.title, this.reference, this.url});

  factory Post.fromString(String title, String reference, String url) {
    return Post(title: title, reference: reference, url: url);
  }
}


class PostingBunchState extends State<PostingBunch> {

  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  final List<Post> _posts = <Post>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('커뮤니티 모아보기'),
        actions: <Widget>[
          // Add 3 lines from here...
          // new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        ], // ... to here.
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index >= _posts.length) {
            // _posts.addAll(generate().take(10));
          }
        });
  }

  Widget _buildRow(Post post) {
    return new ListTile(
      title: new Text(
        "[" + post.reference + "] " + post.title,
        style: _biggerFont,
      ),
    );
  }


}

class PostingBunch extends StatefulWidget {
  @override
  PostingBunchState createState() => new PostingBunchState();
}


// 뽐뿌
Future<List<Post>> fetchPostTest() async {
  final response = await http.get('http://m.ppomppu.co.kr/new/');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var document = parse( response.body );

    var aa = response.bodyBytes;    

    var list = document.getElementById("mainList").children.first.children;

    var postList = list.map((element) => Post.fromString(element.text, "뽐뿌","a"));
    return postList.toList();
  } else {
    // throw Exception('Failed to load post');
    return List();
  }
}

// Future<Post> fetchPost() async {
Future<List<Post>> fetchPost(String site) async {

  var url = "http://www.slrclub.com/bbs/zboard.php?id=hot_article";

  switch(site) {
    case 'SLR':
      url = "http://www.slrclub.com/bbs/zboard.php?id=hot_article";
      break;
    case 'INVEN':
      url = "http://m.inven.co.kr/board/powerbbs.php?come_idx=2097";
      break;
    case 'RULIWEB':
      url = "https://m.ruliweb.com/best";
      break;  
    case 'BOBAE':
      url = "http://m.bobaedream.co.kr/board/new_writing/best";
      break;  
  }
  
  final response = await http.get(url);

  if (response.statusCode == 200) {
    
    var document = parse( response.body );
    
    switch(site) {

      case 'SLR':
        var list = document.getElementById("bbs_list").getElementsByClassName("sbj");
        var resultList = <Post>[];
        for (var i = 0 ; i < list.length ; i++) {
          try {
            var post = list[i].getElementsByTagName("a").first.text;
            var reference = "SLR클럽";
            var url = "http://www.slrclub.com" + list[i].getElementsByTagName("a").first.attributes["href"];
            resultList.add(Post.fromString(post, reference, url));
          } catch (e) {
            print(e.toString());
          }
        }
        return resultList.toList();
        break;        

      //TODO: [공지]같은 앞의 태그 없애야함.
      case 'INVEN':
        var list = document.getElementById("boardList").getElementsByClassName("articleSubject");
        var resultList = <Post>[];
        for (var i = 0 ; i < list.length ; i++) {
          try {
            var post = list[i].getElementsByClassName("title").first.text;
            var reference = "인벤";
            var url = "http://m.inven.co.kr" + list[i].getElementsByTagName("a").first.attributes["href"];
            resultList.add(Post.fromString(post, reference, url));
          } catch (e) {
            print(e.toString());
          }
        }
        return resultList.toList();
        break;

      //
      case 'RULIWEB':
        var list = document.getElementById("board_list").getElementsByClassName("title");
        var resultList = <Post>[];
        for (var i = 0 ; i < list.length ; i++) {
          try {
            var post = list[i].getElementsByClassName("subject_link").first.text;
            var reference = "루리웹";
            var url = list[i].getElementsByTagName("a").first.attributes["href"];
            resultList.add(Post.fromString(post, reference, url));
          } catch (e) {
            print(e.toString());
          }
        }
        return resultList.toList();
        break;

      //
      case 'RULIWEB':
        var list = document.getElementById("board_list").getElementsByClassName("title");
        var resultList = <Post>[];
        for (var i = 0 ; i < list.length ; i++) {
          try {
            var post = list[i].getElementsByClassName("subject_link").first.text;
            var reference = "루리웹";
            var url = list[i].getElementsByTagName("a").first.attributes["href"];
            resultList.add(Post.fromString(post, reference, url));
          } catch (e) {
            print(e.toString());
          }
        }
        return resultList.toList();
        break;

      case 'BOBAE':
        var list = document.getElementsByClassName("rank").first.getElementsByClassName("info");
        var resultList = <Post>[];
        for (var i = 0 ; i < list.length ; i++) {
          try {
            var post = list[i].getElementsByClassName("cont").first.text;
            var reference = "보배드림";
            var url = list[i].getElementsByTagName("a").first.attributes["href"];
            resultList.add(Post.fromString(post, reference, url));
          } catch (e) {
            print(e.toString());
          }
        }
        return resultList.toList();
        break;

      } //end switch




    return List();
  } else {
    return List();
  }
}


String log(Object object) {
  print(object.toString());
}