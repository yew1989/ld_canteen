import 'package:flutter/material.dart';
import 'package:ld_canteen/api/component/public_tool.dart';
import 'package:ld_canteen/page/bannermanage/banner_manage_page.dart';
import 'package:ld_canteen/page/categorymanage/category_manage_page.dart';
import 'package:ld_canteen/page/dishmanage/dish_manage_page.dart';
import 'package:ld_canteen/page/menumanage/menu_show_page.dart';
import 'package:ld_canteen/page/picturemanage/picture_manage_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('力得食堂'),
        ),
        body: ListView(
          children: <Widget>[
            buttonTile('菜单展示窗'),
            buttonTile('菜品管理'),
            buttonTile('菜品分类管理'),
            buttonTile('广告栏管理'),
            buttonTile('素材管理'),
          ],
        ),
      ),
    );
  }
  
  Widget buttonTile(String title) {
    return ListTile(
      title: FlatButton(
      padding: EdgeInsets.all(40),
      child: Text(title,style: TextStyle(color: Colors.white,fontSize: 40)),
      color: Colors.blueAccent,
      onPressed: (){
        if(title == '菜单展示窗'){
          pushToPage(context,MenuShowPage());
        }
        else if(title == '菜品管理') {
          pushToPage(context,DishManagePage());
        }
        else if (title == '菜品分类管理') { 
          pushToPage(context,CategroyManagePage());
        }
        else if(title == '广告栏管理') {
          pushToPage(context,BannerManagePage());
        }
        else if(title == '素材管理') {
          pushToPage(context,PictureManagePage());
        }
      },
    ));
  }
}