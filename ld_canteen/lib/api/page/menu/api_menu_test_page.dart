import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/model/menu.dart';

class ApiMenuTestPage extends StatefulWidget {
  @override
  _ApiMenuTestPageState createState() => _ApiMenuTestPageState();
}

class _ApiMenuTestPageState extends State<ApiMenuTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('菜单管理'),
      ),
      body: ListView(
        children: <Widget>[
          RaisedButton(child: Text('菜单列表'),onPressed:onTapMenuList),
          RaisedButton(child: Text('添加菜单'),onPressed:onTapMenuCreate),
          RaisedButton(child: Text('更改菜单'),onPressed:onTapMenuEdit),
          RaisedButton(child: Text('删除菜单'),onPressed:onTapMenuDelete),
            
        ],
      ),
    );
  }
  
  // 获取 展示栏列表
  void onTapMenuList() {
    API.getMenuList((List<Menu> menus, String msg){

      debugPrint(menus.map((menu) => menu.toJson().toString()).toList().toString());
      debugPrint(msg);

    }, (String msg){
      debugPrint(msg);
    });
  }

  void onTapMenuCreate() {

  }

  void onTapMenuEdit() {

  }

  void onTapMenuDelete() {

  }

}