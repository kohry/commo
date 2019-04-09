import 'package:flutter/material.dart';

class Privacy extends StatelessWidget {
  const Privacy({
    this.imagePathList,
  }) : super();

  @required
  final List imagePathList;

  @override
  Widget build(BuildContext context) {

    return
      SingleChildScrollView(
          child: Container(

            color: Colors.white,
            alignment: Alignment.centerLeft,

            child:  Column(
              children : <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(15, 20, 15, 20),),
                Text('개인정보 처리방침 v1.0 ',style: TextStyle(fontFamily: 'DoHyeon',fontSize: 10, color: Colors.black54),),
                Text('본앱은 개인정보보호 관련 주요 법률인 『개인정보보호법』, 『정보통신망 이용촉진 및 정보보호 등에 관한 법률』 등 관련 법률과 각종 법규를 준수하며 이와 관련된 고충을 신속하고 원활하게 처리할 수 있도록 하기 위해 다음과 같이 개인정보처리방침을 수립ㆍ공개합니다.',style: TextStyle(fontFamily: 'DoHyeon',fontSize: 10, color: Colors.black54),),
                Text('개인정보 수집항목 및 수집방법	 ',style: TextStyle(fontFamily: 'DoHyeon',fontSize: 10, color: Colors.black54),),
                Text('본 앱은 개인정보를 앱 로그인시 해당 사용자가 가입을 했는지 로그인 계정을 탐지하기 위해 자동적으로 Google Firebase에서 수집하고 있습니다. 다만 추후에 Google Admob등을 통해 광고를 하면, 구글이 자동적으로 개인정보 수집을 할수 있습니다.',style: TextStyle(fontFamily: 'DoHyeon',fontSize: 10, color: Colors.black54),),
                Text('개인정보의 처리목적	',style: TextStyle(fontFamily: 'DoHyeon',fontSize: 10, color: Colors.black54),),
                Text('개인정보는 해당 앱이 Google Play 에 게시되어 해당 앱이 삭제될때까지 별다른 처리는 하지 않습니다.',style: TextStyle(fontFamily: 'DoHyeon',fontSize: 10, color: Colors.black54),),
                Text('개인정보의 처리 및 보유기간',style: TextStyle(fontFamily: 'DoHyeon',fontSize: 10, color: Colors.black54),),
                Text('보유기간은 사용자가 해당 앱이 삭제되어 Firebase에서 사라질때까지 유지합니다.',style: TextStyle(fontFamily: 'DoHyeon',fontSize: 10, color: Colors.black54),),
                Text('개인정보의 제3자 제공',style: TextStyle(fontFamily: 'DoHyeon',fontSize: 10, color: Colors.black54),),
                Text('본 앱은 개인정보를 3자 제공하지 않습니다.',style: TextStyle(fontFamily: 'DoHyeon',fontSize: 10, color: Colors.black54),),
                Text('개인정보 수집방침기간',style: TextStyle(fontFamily: 'DoHyeon',fontSize: 10, color: Colors.black54),),
                Text('2019.04.01 ~ 영구',style: TextStyle(fontFamily: 'DoHyeon',fontSize: 10, color: Colors.black54),),


              ],
            ),

          )

      );



  }


}


