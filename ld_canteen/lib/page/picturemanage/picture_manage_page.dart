import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/api/component/public_tool.dart';
import 'package:ld_canteen/model/picture.dart';
import 'package:ld_canteen/page/picturemanage/picture_operation_page.dart';
import 'package:ld_canteen/page/picturemanage/picture_uploader.dart';
import 'package:ld_canteen/page/static_style.dart';


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
    EventBus().off('REFRESH');
    super.dispose();
  }
  
  //获取素材库里的图片
  void getPictureList(){
    API.getPictureList((List<PictureBean> pictureBeans,String msg){
      setState(() {
        this.pictureList = pictureBeans;
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
          title: Text('图片管理',style: STATIC_STYLE.appbar),
          backgroundColor: STATIC_STYLE.backgroundColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings_applications,size: 30),
              onPressed: () {
                pushToPage(context, PictureOperationPage(pictureList:pictureList));
              }
            ),
            IconButton(
              icon: Icon(Icons.add_box,size: 30),
              onPressed: () {
                uploadPicture(context);
              }
            )
          ],
          centerTitle: true,
        ),
        body: Container(
          //height: 400,
          child: GridView.count(
            padding: EdgeInsets.all(10.0),
            crossAxisCount: 2,
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
            alignment:AlignmentDirectional.topEnd,
            children:<Widget>[
              Image(image: NetworkImage(pic.url),fit: BoxFit.cover),
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
              ),
            ],
          )
          ;
        } catch (e) {
          print(e);
          //newImageUrl.remove(imageUrl);
        }
      }).toList();
      
      return list;
    }
  }

  // 上传图片
  void uploadPicture(BuildContext context) {
    PictureUploader.uploadPicture(context,(_,msg){
      debugPrint(msg.toString());
      getPictureList();
    },(_){});
  }
  

}