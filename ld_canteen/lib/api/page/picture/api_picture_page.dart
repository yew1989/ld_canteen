import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/model/picture.dart';

class ApiPicturePage extends StatefulWidget {
  @override
  _ApiPicturePageState createState() => _ApiPicturePageState();
}

class _ApiPicturePageState extends State<ApiPicturePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('素材管理'),
      ),
      body: ListView(
        children: <Widget>[
          RaisedButton(child: Text('素材列表'),onPressed:onTapPictureList),
          RaisedButton(child: Text('删除素材'),onPressed:onTapDeletePicture),
          RaisedButton(child: Text('添加素材'),onPressed:onTapAddPicture),
        ],
      ),
    );
  }
  
  // 获取素材列表
  void onTapPictureList() async {
    API.getPictureList((List<PictureBean> pictures,String msg){
      
      debugPrint(pictures.map((pic){
        return pic.toJson();
      }).toList().toString());
      debugPrint(msg);
      debugPrint('素材数量' + pictures.length.toString() );

    }, (String msg){
      
      debugPrint(msg);

    });
  }

  // 删除素材
  void onTapDeletePicture() async {
    API.deletePicture('5dfc81725620710093d86d89', (msg){
      debugPrint(msg);
      onTapPictureList();
    }, (msg){
      debugPrint(msg);
    });
  }

  // 添加素材
  void onTapAddPicture() async {
    
    API.uploadPicture('', '', (objectId,msg){

    }, (msg){

    });
  }
}