import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/api/component/public_tool.dart';
import 'package:ld_canteen/model/menu.dart';
import 'package:ld_canteen/page/menumanage/menu_show_page.dart';
import 'package:ld_canteen/page/static_style.dart';

class MenuManagePage extends StatefulWidget {
  @override
  _MenuManagePageState createState() => _MenuManagePageState();
}

class _MenuManagePageState extends State<MenuManagePage> {
  
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
    EventBus().on('REFRESHLIST', (_) {
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
        title: Text('菜品展示管理',style: STATIC_STYLE.appbar,),
        backgroundColor: STATIC_STYLE.backgroundColor,
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
        color: Color.fromRGBO(241, 241, 241, 1.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Expanded(
                flex: 1,
                child: Center(child: Text('展示栏',style: STATIC_STYLE.listView)),
              ),
              Expanded(
                flex: 1,
                child: Center(child: Text('展示类型',style: STATIC_STYLE.listView)),
              ),
              Expanded(
                flex: 1,
                child: Center(child: Text('详细分类',style: STATIC_STYLE.listView)),
              ),
            ],
          ),
        ),
      );
    } else if(index.isEven){
      var menu  = menuList[index-1];
      //var valueb = dish.isShow;
      return GestureDetector(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 1,horizontal: 2),
          height: 60,
          color: Color.fromRGBO(241, 241, 241, 1.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Expanded(
                  flex: 1,
                  child: Center(child: Text('第${index}格',style: STATIC_STYLE.listView)),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text('${menu.type == null ? '' : (menu.type == "category" ? "菜品类型" : "广告图片")}',
                      style: STATIC_STYLE.listView
                    )
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text('${menu.type == null ? '' : (menu.type == "category" ? (menu?.category.name ?? '') : (menu?.banner.name ?? ''))}',
                      style: STATIC_STYLE.listView
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: (){
          pushToPage(context, MenuShowPage(menu:menu));
        },
      );
    }else{
      var menu  = menuList[index-1];
      //var valueb = dish.isShow;
      return GestureDetector(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 1,horizontal: 2),
          height: 60,
          //color: Color.fromRGBO(241, 241, 241, 1.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Expanded(
                  flex: 1,
                  child: Center(child: Text('第${index}格',style: STATIC_STYLE.listView)),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text('${menu.type == "category" ? "菜品类型" : "广告图片"}',
                      style: STATIC_STYLE.listView
                    )
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text('${(menu.type == "category" ? (menu?.category.name ?? '') : (menu?.banner.name ?? ''))}',
                      style: STATIC_STYLE.listView
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: (){
            pushToPage(context, MenuShowPage(menu:menu));
        }
      );
    }
  }
}