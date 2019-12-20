import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/model/banner.dart';

class BannerEditPage extends StatefulWidget {

  final BannerBean banner;
  const BannerEditPage({Key key, this.banner}) : super(key : key);
  @override
  _BannerEditPageState createState() => _BannerEditPageState();
}

class _BannerEditPageState extends State<BannerEditPage> {

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController imageUrlCtrl = TextEditingController();
  List<String> newImageUrl ;

  @override
  void initState() {
    newImageUrl = widget?.banner?.images ?? null;
    EventBus().on('REFRESH', (_) {
      //newImageUrl;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    

    var isAdd = widget.banner == null;
    nameCtrl.text = widget?.banner?.name ?? '';

    return Scaffold(
      appBar: AppBar(
        title: isAdd ? Text('新增广告栏') : Text('编辑广告栏'),
      ),
      body: Container(
        margin: EdgeInsets.all(40),
        child: ListView(
          children: <Widget>[
            Text('广告栏名称:', style: TextStyle(color: Colors.black, fontSize: 30)),
            TextField(
                maxLength: 20,
                maxLines: 1,
                style: TextStyle(color: Colors.black, fontSize: 30),
                controller: nameCtrl,
                decoration: InputDecoration()),
            Text('插入图片:', style: TextStyle(color: Colors.black, fontSize: 30)),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child:TextField(
                  //maxLength: 1000,
                  maxLines: 1,
                  style: TextStyle(color: Colors.black, fontSize: 30),
                  controller: imageUrlCtrl,
                  decoration: InputDecoration()),
                ),
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    padding: EdgeInsets.all(1),
                    child: Text('加载图片',
                      style: TextStyle(color: Colors.white, fontSize: 40)),
                    color: Colors.blueAccent,
                    onPressed: () {
                      setState((){
                        loading();
                      });
                      //imageLoad(imageUrlCtrl.text);
                    }, 
                  )
                ),
              ],
            ),
            Text('图片预览:', style: TextStyle(color: Colors.black, fontSize: 30)),
            Row(
              children: _imagePreview(),
            ),
            FlatButton(
              padding: EdgeInsets.all(10),
              child: Text('确定',
                  style: TextStyle(color: Colors.white, fontSize: 40)),
              color: Colors.blueAccent,
              onPressed: () {
                // 新增
                if (isAdd) {
                  var item = BannerBean(
                      name: nameCtrl.text ?? '',
                      images: newImageUrl);
                  createBanner(item);
                }
                // 更新
                else {
                  var item = widget.banner;
                  item.name = nameCtrl.text ?? '';
                  item.images = newImageUrl;
                  updateBanner(item);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // 更新
  void updateBanner(BannerBean banner) {
    API.updateBanner(
      banner.objectId,
      banner,
      (_, msg) {
        Navigator.of(context).pop();
        // 发送刷新通知
        EventBus().emit('REFRESH');
      },
      (_) {}
    );
  }

  // 新增
  void createBanner(BannerBean banner) {
    API.createBanner(banner, (_, msg) {
      Navigator.of(context).pop();
      // 发送刷新通知
      EventBus().emit('REFRESH');
    }, (_) {},
    );
  }

  List<Widget> _imagePreview(){
    List<Widget> list = [];
    if (newImageUrl == null) {
      //Text('插入图片:', style: TextStyle(color: Colors.black, fontSize: 30));
      list.add(Text('未上传图片！', style: TextStyle(color: Colors.red, fontSize: 30)));
      return list;
    } else {

      return newImageUrl.map((imageUrl){
        try {
          return Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Image(
                    image: NetworkImage(imageUrl),
                  ),
                  Padding(padding: EdgeInsets.all(20),),
                  FlatButton(
                    child: Text('删除',
                    style: TextStyle(color: Colors.white, fontSize: 40)),
                    color: Colors.redAccent,
                    onPressed: () {
                      setState(() {
                        newImageUrl.remove(imageUrl);
                      });
                      //EventBus().emit('REFRESH');
                    },
                  )
                ],
              )
          );
        } catch (e) {
          print(e);
          newImageUrl.remove(imageUrl);
        }
      }).toList();
    }
  }

  void imageLoad(String str){
    try {
      NetworkImage(str);
      newImageUrl.add(str);
      
      print('加载成功');
    } catch (e) {
      print('加载失败:'+e);
    }
    EventBus().emit('REFRESH');
  }
   //http://t10.baidu.com/it/u=875841156,2349147183&fm=173&app=49&f=JPEG?w=640&h=411&s=FF054686585253D419BF9C3E0300D049     

  void loading() async {
      var responseBody;
      var url='http://t10.baidu.com/it/u=875841156,2349147183&fm=173&app=49&f=JPEG?w=640&h=411&s=FF054686585253D419BF9C3E0300D049';
      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == 200) {
        print("OK");
      }else{
        print("error");
      }
   }
}