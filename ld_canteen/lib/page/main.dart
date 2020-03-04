import 'package:flutter/material.dart';
import 'package:ld_canteen/api/component/public_tool.dart';
import 'package:ld_canteen/page/bannermanage/banner_manage_page.dart';
import 'package:ld_canteen/page/categorymanage/category_manage_page.dart';
import 'package:ld_canteen/page/dishmanage/dish_manage_page.dart';
import 'package:ld_canteen/page/menu/menu_page.dart';
import 'package:ld_canteen/page/menumanage/menu_manage_page.dart';
import 'package:ld_canteen/page/picturemanage/picture_manage_page.dart';
import 'package:ld_canteen/page/static_style.dart';

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
          backgroundColor: STATIC_STYLE.backgroundColor,
        ),
        body: ListView(
          children: <Widget>[
            buttonTile('菜品分类管理'),
            buttonTile('菜品管理'),
            buttonTile('素材管理'),
            buttonTile('广告栏管理'),
            buttonTile('菜单展示窗'),
            buttonTile('今日菜单'),
          ],
        ),
      ),
    );
  }
  
  Widget buttonTile(String title) {
    return ListTile(
      title: FlatButton(
      padding: EdgeInsets.all(25),
      child: Text(title,style: TextStyle(color: Colors.white,fontSize: 18)),
      color: STATIC_STYLE.backgroundColor,
      onPressed: (){
        if(title == '菜单展示窗'){
          pushToPage(context,MenuManagePage());
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
        else if(title == '今日菜单') {
          pushToPage(context,MenuPage());
        }
      },
    ));
  }
}