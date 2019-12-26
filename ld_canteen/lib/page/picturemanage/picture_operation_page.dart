import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/edit_delete_button.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/model/picture.dart';

class PictureOperationPage extends StatefulWidget {
  final List<PictureBean> pictureList;
  const PictureOperationPage({Key key, this.pictureList}) : super(key : key);
  @override
  _PictureOperationPageState createState() => _PictureOperationPageState();
}

class _PictureOperationPageState extends State<PictureOperationPage> {
  
  List<Map<String,dynamic>> mapList = [];   //图片与是否选中绑定
  List<String> objectIds = [];
  List<PictureBean> pictureBeans = [];
  
  @override
  void initState(){
    _checkLoading();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  void _checkLoading(){
    this.pictureBeans = widget?.pictureList ?? [];
    if(pictureBeans.isNotEmpty){
      pictureBeans.map((PictureBean pic){
        Map<String,dynamic> map = new Map<String, dynamic>();
        map['pictureBean'] = pic;
        map['check'] = false;
        mapList.add(map);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('操作',style: TextStyle(fontSize: 30),),
      ),
      body: Container(
        //height: 400,
        child: GridView.count(
          padding: EdgeInsets.all(10.0),
          crossAxisCount: 5,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: _imagePreview(),
        ),
      ),
      bottomNavigationBar: ButtonBar(
        children: <Widget>[
          FlatButton(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Text('删除',
                  style: TextStyle(color: Colors.white, fontSize: 40)),
              color: Colors.blueAccent,
              onPressed: (){
                showDialog(
                  context:context,
                  child: CupertinoAlertDialog(
                    title:Text('提示'),
                    content:Center(
                      child: Text('是否确定删除该项'),
                    ),
                    actions: <Widget>[
                      CupertinoDialogAction(isDestructiveAction: true,child: Text('确定'),onPressed: (){
                        deleteCheck(objectIds);
                        Navigator.of(context).pop();
                      }),
                      CupertinoDialogAction(child: Text('取消'),onPressed: (){
                        Navigator.of(context).pop();
                      }),
                    ],
                  )
                );
                deleteCheck(objectIds);
              },
          ),
        ],
      ),
    );
  }

  List<Widget> _imagePreview(){
    
    List<Widget> list = [];
    if (this.pictureBeans.isEmpty) {
      //Text('插入图片:', style: TextStyle(color: Colors.black, fontSize: 30));
      list.add(Container(
            child:Text('未上传图片！', style: TextStyle(color: Colors.red, fontSize: 30))));
      return list;
    } else {
      list = this.mapList.map((Map<String,dynamic> pic){
        try {
          return Stack(
            alignment:AlignmentDirectional.topEnd,
            children:<Widget>[
              Image(image: NetworkImage(pic['pictureBean'].url)),
              Container(),
              Checkbox(
                value: pic['check'],
                activeColor: Colors.blue,
                onChanged: (bool val) {
                  this.setState(() {
                    pic['check'] = !pic['check'];
                  });
                },
              ),
            ],
          );
        } catch (e) {
          print(e);
        }
      }).toList();
      return list;
    }
  }

  void deleteCheck(List<String> objectIdList){
    
    API.deleteMultiPictures(objectIdList, (String msg){
      debugPrint(msg);
    }, (String msg){
      debugPrint(msg);
    });
  }

  List<String> selectCheckTrue(){
    return mapList.map((Map<String,dynamic> pic){
      while(pic['check'] == true) {
        objectIds.add(pic['pictureBean'].objectId);
      }
    }).toList();
  }
}