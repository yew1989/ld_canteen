import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/model/picture.dart';
import 'package:image_picker/image_picker.dart';

class ApiPicturePage extends StatefulWidget {
  @override
  _ApiPicturePageState createState() => _ApiPicturePageState();
}

class _ApiPicturePageState extends State<ApiPicturePage> {

  File image;

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
          RaisedButton(child: Text('添加素材'),onPressed:pickerImage),
          image == null? SizedBox(
            height: 200,
            width: 400,
            child: Center(child: Text('图片未选择'))) : SizedBox(
            height: 200,
            width: 400,
            child: Image.file(image))
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
  void onTapAddPicture(File file) async {

    final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    final filePath = file.uri.toFilePath();
    
    API.uploadPicture(fileName, filePath, (objectId,msg){

      debugPrint(objectId);
      debugPrint(msg);
      onTapPictureList();

    }, (msg){

      debugPrint(msg);

    });
  }

  // 选择相片素材
  void pickerImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.image = image;
    });
    onTapAddPicture(image);
  }

}