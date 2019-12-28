import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/api/component/public_tool.dart';
import 'package:ld_canteen/model/banner.dart';
import 'package:ld_canteen/model/category.dart';
import 'package:ld_canteen/model/menu.dart';
import 'package:ld_canteen/page/menumanage/menu_show_page.dart';

class MenuManagePage extends StatefulWidget {
  @override
  _MenuManagePageState createState() => _MenuManagePageState();
}

class _MenuManagePageState extends State<MenuManagePage> {

  // String menuOneId = '5df7626043c2570080d2de2b';
  // String menuTwoId = '5df7626b43c2570080d2de2c';
  // String menuThreeId = '5df7627f0a8a84007f004bc6';
  // String menuFourId = '5df7629243c2570080d2e025';
  // String menuFiveId = '5df7629f0a8a84007f004c68';
  // String menuSixId = '5df762c543c2570080d2e1f5';
  
  var types = [{'name':'选择展示框内容分类','value':'xxxx'},{'name':'菜品类型','value':'category'},{'name':'广告图片','value':'banner'}];
  List<Menu> menuList = [];

  // 请求展示列表数据
  void getMenuList() {
    API.getMenuList((List<Menu> menus, String msg) {
      setState(() {
        this.menuList = menus;
      });
      debugPrint(msg);
    }, (String msg) {
      debugPrint(msg);
    },limit:6,skip: 0
    );
  }

  @override
  void initState() {
    getMenuList();
    EventBus().on('REFRESH', (_) {
      getMenuList();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int  _getListCount(){
    int menuListCount = menuList?.length ?? 0;
    return menuListCount + 1;
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('菜品展示管理'),
      ),
      
      body:Container(
        child:ListView.builder(
          itemBuilder: (BuildContext context, int index)  => _widgetList(context,index),
          itemCount: _getListCount(),
        )
      )
    );
  }

  Widget _widgetList(BuildContext context, int index){

    if (index == 0) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 1,horizontal: 2),
        height: 60,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Expanded(
                flex: 1,
                child: Center(child: Text('展示栏',style: TextStyle(color: Colors.black,fontSize: 20))),
              ),
              Expanded(
                flex: 1,
                child: Center(child: Text('展示类型',style: TextStyle(color: Colors.black,fontSize: 20))),
              ),
              Expanded(
                flex: 1,
                child: Center(child: Text('详细分类',style: TextStyle(color: Colors.black,fontSize: 20))),
              ),
              Expanded(
                flex: 1,
                child: Center(child: Text('操作',style: TextStyle(color: Colors.black,fontSize: 20))),
              ),
            ],
          ),
        ),
      );
    } else {
      var menu  = menuList[index-1];
      //var valueb = dish.isShow;
      return Container(
        margin: EdgeInsets.symmetric(vertical: 1,horizontal: 2),
        height: 60,
        // color: Colors.white,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Expanded(
                flex: 1,
                child: Center(child: Text('第${index}格',style: TextStyle(color: Colors.black,fontSize: 30))),
              ),
              Expanded(
                flex: 1,
                child: Center(child: Text('${menu.type == "category" ? "菜品类型" : "广告图片"}',style: TextStyle(color: Colors.black,fontSize: 30))),
              ),
              Expanded(
                flex: 1,
                child: Center(child: Text('${menu.type == "category" ? (menu.category.name) : (menu.banner.name)}',style: TextStyle(color: Colors.black,fontSize: 30))),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  color: Colors.green,
                  child: Text('编辑',style: TextStyle(color: Colors.white,fontSize: 20)), 
                  onPressed: () {
                    pushToPage(context, MenuShowPage(menu:menu));
                  },
                )
              )
            ],
          ),
        ),
      );
    }
  }

}