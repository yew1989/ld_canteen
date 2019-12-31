import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/model/picture.dart';
import 'package:ld_canteen/page/static_style.dart';

class PictureAddPage extends StatefulWidget {
  final List<String> pictureUrlList;
  
  const PictureAddPage({Key key, this.pictureUrlList}) : super(key : key);
  @override
  _PictureAddPageState createState() => _PictureAddPageState();
}

class _PictureAddPageState extends State<PictureAddPage> {

  List<Map<String,dynamic>> mapList = [];   //图片与是否选中绑定
  List<String> objectIds = [];
  List<PictureBean> pictureList = [];

  @override
  void initState(){
    getPictureList();
    
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //获取素材库里的图片
  void getPictureList(){
    API.getPictureList((List<PictureBean> pictureBeans,String msg){
      setState(() {
        this.pictureList = pictureBeans;
        if(pictureList.isNotEmpty){
          pictureList.map((PictureBean pic){
            Map<String,dynamic> map = new Map<String, dynamic>();
            map['pictureBean'] = pic;
            map['check'] = false;
            mapList.add(map);
          }).toList();
        }
      });
      debugPrint(msg);
    }, (String msg){
      debugPrint(msg);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('选择图片',style: STATIC_STYLE.appbar),
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
      bottomNavigationBar: ButtonBar(
        children: <Widget>[
          FlatButton(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Text('确定',
                  style: STATIC_STYLE.buttonText),
              color: Colors.blueAccent,
              onPressed: (){
                mapList.map((Map<String,dynamic> pic){
                  if(pic['check'] == true) {
                    widget.pictureUrlList.add(pic['pictureBean'].url);
                  }
                }).toList();
                Navigator.of(context).pop(widget.pictureUrlList);
              },
          ),
        ],
      ),
    );
  }

  List<Widget> _imagePreview(){
    
    List<Widget> list = [];
    if (this.pictureList.isEmpty) {
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
              Container(
                height: 20,
                width: 20,
                color: Colors.white,
                child:Checkbox(
                  value: pic['check'],
                  activeColor: Colors.blue,
                  //hoverColor: Colors.white,
                  onChanged: (bool val) {
                    this.setState(() {
                      pic['check'] = !pic['check'];
                    });
                  },
                ),
              )
            ],
          );
        } catch (e) {
          print(e);
        }
      }).toList();
      return list;
    }
  }
}