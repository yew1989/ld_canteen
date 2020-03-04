import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/api/component/public_tool.dart';
import 'package:ld_canteen/model/banner.dart';
import 'package:ld_canteen/page/picturemanage/picture_add_page.dart';
import 'package:ld_canteen/page/static_style.dart';

class BannerEditPage extends StatefulWidget {

  final BannerBean banner;
  const BannerEditPage({Key key, this.banner}) : super(key : key);
  @override
  _BannerEditPageState createState() => _BannerEditPageState();
}

class _BannerEditPageState extends State<BannerEditPage> {

  TextEditingController nameCtrl = TextEditingController();
  List<String> newImageUrl  = [];

  @override
  void initState() {

    final copyBanner = widget?.banner?.copy() ?? null;
    newImageUrl = copyBanner?.images ?? List<String>();
    nameCtrl.text = widget?.banner?.name ?? '';
    EventBus().on('REFRESH_EDIT', (_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    EventBus().off('REFRESH_EDIT');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var isAdd = widget.banner == null;
    return SafeArea(
      child:Scaffold(
        appBar: AppBar(
          title: isAdd ? Text('新增广告栏',style: STATIC_STYLE.appbar,) : Text('编辑广告栏',style: STATIC_STYLE.appbar,),
          backgroundColor: STATIC_STYLE.backgroundColor,
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Text('广告栏名称:', style: STATIC_STYLE.tab),
              TextField(
                  maxLength: 20,
                  maxLines: 1,
                  style: STATIC_STYLE.textField,
                  controller: nameCtrl,
                  decoration: InputDecoration()),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child:Text('图片预览:', style: STATIC_STYLE.textField),
                  ),
                  Expanded(
                    flex: 1,
                    child: FlatButton(
                      padding: EdgeInsets.all(1),
                      child: Text('选择图片',
                        style: STATIC_STYLE.buttonText),
                      color: STATIC_STYLE.backgroundColor,
                      onPressed: () {
                        setState((){
                          pushToPage(context, PictureAddPage(pictureUrlList: newImageUrl));
                        });
                        //imageLoad(imageUrlCtrl.text);
                      }, 
                    )
                  ),
                ],
              ),
              Container(
                height: 400,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  children: _imagePreview(),
                ),
              ),
              //Padding(padding: EdgeInsets.all(20.0),),
            ],
          ),
        ),
        bottomNavigationBar: FlatButton(
          padding: EdgeInsets.all(10),
          child: Text('确定',
              style: STATIC_STYLE.buttonText),
          color: STATIC_STYLE.backgroundColor,
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
    if (newImageUrl.isEmpty) {
      //Text('插入图片:', style: TextStyle(color: Colors.black, fontSize: 30));
      list.add(Container(
            child:Text('未上传图片！', style: TextStyle(color: Colors.red, fontSize: 25))));
      return list;
    } else {
      list = newImageUrl.map((imageUrl){
        try {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment:AlignmentDirectional.topEnd,
                children:<Widget>[
                  Image(image: NetworkImage(imageUrl),fit: BoxFit.cover),
                  Container(),
                  IconButton(
                    icon: Icon(Icons.close,size: 30,color: Colors.red,),
                    onPressed: (){
                      setState(() {
                        newImageUrl.remove(imageUrl);
                      });
                    },
                    //alignment: Alignment.topCenter,
                  ),
                ],
              ),
            ],
          );
        } catch (e) {
          print(e);
          newImageUrl.remove(imageUrl);
        }
      }).toList();

      return list;
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
}