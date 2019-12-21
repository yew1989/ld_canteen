import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/model/picture.dart';

class PictureManagePage extends StatefulWidget {
  @override
  _PictureManagePageState createState() => _PictureManagePageState();
}

class _PictureManagePageState extends State<PictureManagePage> {
   List<PictureBean> pictureList = [];

  @override
  void initState() {
    getPictureList();
    EventBus().on('REFRESH', (_) {
      getPictureList();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  //获取素材库里的图片
  void getPictureList(){
    API.getPictureList((List<PictureBean> pictureBean,String msg){
      setState(() {
        this.pictureList = pictureBean;
      });
      debugPrint(msg);
    }, (String msg){
      debugPrint(msg);
    });
  }

  //删除图片
  void deletePicture(PictureBean pictureBean){
    API.deletePicture(pictureBean.objectId,(String msg){
      debugPrint(msg);
      getPictureList();
    }, (String msg){
      debugPrint(msg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: new AppBar(
          title: Text('图片管理',style: TextStyle(fontSize: 30),),
          actions: <Widget>[
            
          ],
        ),
        body: Container(
          //height: 400,
          child: GridView.count(
            crossAxisCount: 5,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: _imagePreview(),
          ),
        ),
      )
    );
  }

  List<Widget> _imagePreview(){
    List<Widget> list = [];
    if (pictureList.isEmpty) {
      //Text('插入图片:', style: TextStyle(color: Colors.black, fontSize: 30));
      list.add(Container(
            child:Text('未上传图片！', style: TextStyle(color: Colors.red, fontSize: 30))));
      return list;
    } else {
      list = pictureList.map((pic){
        try {
          return Stack(
            children:<Widget>[
              Image(image: NetworkImage(pic.url)),
              Container(),
              IconButton(
                icon: Icon(Icons.close,size: 30,color: Colors.red,),
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
                          deletePicture(pic);
                          Navigator.of(context).pop();
                        }),
                        CupertinoDialogAction(child: Text('取消'),onPressed: (){
                          Navigator.of(context).pop();
                        }),
                      ],
                    )
                  );
                },
                //alignment: Alignment.topCenter,
              ),
            ],
          );
        } catch (e) {
          print(e);
          //newImageUrl.remove(imageUrl);
        }
      }).toList();
      
      return list;
    }
  }
}