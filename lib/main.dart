import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:convert' show Codec;

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

import 'secondscreen.dart' show SecondScreen;

void main() => runApp(new CoMMoApp());

class CoMMoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '커뮤니티 모아보기',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: PostingBunch(),
    );
  } //build
} // app

class PostingBunchState extends State<PostingBunch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('컴모 - 커뮤니티 모아보기'),
        ),
        body: _buildPost());
  }

  Widget _buildPost() {
    return Center(
      child: FutureBuilder<List<Post>>(
        future: fetchPost("INVEN"),
        // future: fetchPostTest(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // return Text(snapshot.data.toString());
            return _buildList(snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _buildList(List<Post> posts) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          return _buildRow(posts[i]);
        });
  }

  Widget _buildRow(Post post) {
    return new ListTile(
      title: new Text(
        "[" + post.reference + "] " + post.title,
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondScreen(title:post.title))
          );
      },
    );
  }
}

class PostingBunch extends StatefulWidget {
  @override
  PostingBunchState createState() => new PostingBunchState();
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

// 뽐뿌
// Future<List<Post>> fetchPostTest() async {
//   final response = await http.get('http://m.ppomppu.co.kr/new/');

//   if (response.statusCode == 200) {
//     // If the call to the server was successful, parse the JSON
//     var document = parse( response.body );

//     var aa = response.bodyBytes;

//     var list = document.getElementById("mainList").children.first.children;

//     var postList = list.map((element) => Post.fromString(element.text, "뽐뿌","a"));
//     return postList.toList();
//   } else {
//     // throw Exception('Failed to load post');
//     return List();
//   }
// }

// Future<Post> fetchPost() async {
Future<List<Post>> fetchPost(String site) async {
  var url = "http://www.slrclub.com/bbs/zboard.php?id=hot_article";

//뽐뿌같은경우 Encoding이 안맞음
//보배는 이상하게 깨짐 (utf가 meta에 없는것처럼 보임.)

  switch (site) {
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
    case 'FM':
      url = "https://m.fmkorea.com/best";
      break;
    case 'UNIV':
      url = "http://m.humoruniv.com/board/list.html?table=pds";
      break;
    case 'DOGDRIP':
      url = "https://www.dogdrip.net/dogdrip";
      break;
    case 'NATE':
      url = "https://m.pann.nate.com/talk/today/";
      break;
    case 'CLIEN':
      url = "https://m.clien.net/service/group/clien_all?&od=T33";
      break;
    case 'FOMOS':
      url = "http://m.fomos.kr/talk/article_list?bbs_id=1";
      break;
    case 'MLB':
      url = "http://mlbpark.donga.com/mlbpark/b.php?b=bullpen";
      break;
  }

  final response = await http.get(url);

  if (response.statusCode == 200) {
    var document = parse(utf8.decode(response.bodyBytes));

    switch (site) {
      case 'SLR':
        var list =
            document.getElementById("bbs_list").getElementsByClassName("sbj");
        var resultList = <Post>[];
        for (var i = 0; i < list.length; i++) {
          try {
            var post = list[i].getElementsByTagName("a").first.text.trim();
            var reference = "SLR클럽";
            var url = "http://www.slrclub.com/bbs/zboard.php?id=hot_article" +
                list[i].getElementsByTagName("a").first.attributes["href"];
            resultList.add(Post.fromString(post, reference, url));
          } catch (e) {
            print(e.toString());
          }
        }
        return resultList.toList();
        break;

      //TODO: [공지]같은 앞의 태그 없애야함.
      case 'INVEN':
        var list = document
            .getElementById("boardList")
            .getElementsByClassName("articleSubject");
        var resultList = <Post>[];
        for (var i = 0; i < list.length; i++) {
          try {
            var post =
                list[i].getElementsByClassName("title").first.text.trim();
            var reference = "인벤";
            var url = "http://m.inven.co.kr" +
                list[i].getElementsByTagName("a").first.attributes["href"];
            resultList.add(Post.fromString(post, reference, url));
          } catch (e) {
            print(e.toString());
          }
        }
        return resultList.toList();
        break;

      //
      case 'RULIWEB':
        var list = document
            .getElementById("board_list")
            .getElementsByClassName("title");
        var resultList = <Post>[];
        for (var i = 0; i < list.length; i++) {
          try {
            var post = list[i]
                .getElementsByClassName("subject_link")
                .first
                .text
                .trim();
            var reference = "루리웹";
            var url =
                list[i].getElementsByTagName("a").first.attributes["href"];
            resultList.add(Post.fromString(post, reference, url));
          } catch (e) {
            print(e.toString());
          }
        }
        return resultList.toList();
        break;

      //뭔가 몇개가 빠져서 들어오고 있음.
      case 'BOBAE':
        var list = document
            .getElementsByClassName("rank")
            .first
            .getElementsByClassName("info");
        var resultList = <Post>[];
        for (var i = 0; i < list.length; i++) {
          try {
            var post = list[i].getElementsByClassName("cont").first.text.trim();
            var reference = "보배드림";
            var url = "http://m.bobaedream.co.kr/board/new_writing/best" +
                list[i].getElementsByTagName("a").first.attributes["href"];
            resultList.add(Post.fromString(post, reference, url));
          } catch (e) {
            print(e.toString());
          }
        }
        return resultList.toList();
        break;

      //작동안하는듯
      case 'FM':
        var list = document
            .getElementsByClassName("fm_best_widget")
            .first
            .getElementsByClassName("li");
        var resultList = <Post>[];
        for (var i = 0; i < list.length; i++) {
          try {
            var post =
                list[i].getElementsByClassName("read_more").first.text.trim();
            var reference = "FM";
            var url = "https://m.fmkorea.com/best" +
                list[i].getElementsByTagName("a").first.attributes["href"];
            resultList.add(Post.fromString(post, reference, url));
          } catch (e) {
            print(e.toString());
          }
        }
        return resultList.toList();
        break;

      //UTF 문제있음
      case 'UNIV':
        var list = document
            .getElementById("list_body")
            .getElementsByClassName("list_body_href");
        var resultList = <Post>[];
        for (var i = 0; i < list.length; i++) {
          try {
            var post = list[i].getElementsByClassName("li").first.text.trim();
            var reference = "웃긴대학";
            var url = "http://m.humoruniv.com/board/list.html?table=pds" +
                list[i].attributes["href"];
            resultList.add(Post.fromString(post, reference, url));
          } catch (e) {
            print(e.toString());
          }
        }
        return resultList.toList();
        break;

      //비동기식으로 부르는것같음.
      case 'DOGDRIP':
        var list = document
            .getElementsByClassName("board-list")
            .first
            .getElementsByTagName("li");
        var resultList = <Post>[];
        for (var i = 0; i < list.length; i++) {
          try {
            var post =
                list[i].getElementsByClassName("title").first.text.trim();
            var reference = "개드립";
            var url = "https://www.dogdrip.net/dogdrip" +
                list[i]
                    .getElementsByClassName("title")
                    .first
                    .getElementsByTagName("a")
                    .first
                    .attributes["href"];
            resultList.add(Post.fromString(post, reference, url));
          } catch (e) {
            print(e.toString());
          }
        }
        return resultList.toList();
        break;

      //파싱확인 최종 몰라.
      case 'NATE':
        var list = document
            .getElementsByClassName("list")
            .first
            .getElementsByTagName("li");
        var resultList = <Post>[];
        for (var i = 0; i < list.length; i++) {
          try {
            var post = list[i].getElementsByClassName("tit").first.text.trim();
            var reference = "네이트판";
            var url = "https://m.pann.nate.com/talk/today/" +
                list[i].getElementsByTagName("a").first.attributes["href"];
            resultList.add(Post.fromString(post, reference, url));
          } catch (e) {
            print(e.toString());
          }
        }
        return resultList.toList();
        break;

      case 'CLIEN':
        var list = document
            .getElementsByClassName("content_list")
            .first
            .getElementsByClassName("list_item");
        var resultList = <Post>[];
        for (var i = 0; i < list.length; i++) {
          try {
            var post = list[i]
                .getElementsByClassName("list_subject")
                .first
                .text
                .trim();
            var reference = "클리앙";
            var url = "https://m.clien.net/" +
                list[i].getElementsByTagName("a").first.attributes["href"];
            resultList.add(Post.fromString(post, reference, url));
          } catch (e) {
            print(e.toString());
          }
        }
        return resultList.toList();
        break;

      case 'FOMOS':
        var list = document
            .getElementById("contents")
            .getElementsByClassName("ut_item");
        var resultList = <Post>[];
        for (var i = 0; i < list.length; i++) {
          try {
            var post = list[i]
                .getElementsByTagName("a")
                .first
                .text
                .trim()
                .substring(1);
            var reference = "클리앙";
            var url = "http://m.fomos.kr" +
                list[i].getElementsByTagName("a").first.attributes["href"];
            resultList.add(Post.fromString(post, reference, url));
          } catch (e) {
            print(e.toString());
          }
        }
        return resultList.toList();
        break;

      //비동기
      case 'MLB':
        var list = document
            .getElementsByClassName("contents")
            .first
            .getElementsByClassName("items");
        var resultList = <Post>[];
        for (var i = 0; i < list.length; i++) {
          try {
            var post =
                list[i].getElementsByClassName("title").first.text.trim();
            var reference = "MLB파크";
            var url =
                list[i].getElementsByTagName("a").first.attributes["href"];
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
