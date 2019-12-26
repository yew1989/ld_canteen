import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/model/banner.dart';
import 'package:ld_canteen/model/category.dart';
import 'package:ld_canteen/model/menu.dart';

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
  List<Category> categoryList = [];
  List<BannerBean> bannerList = [];
  String _typeValue = 'xxxx';

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
  
  // 请求菜品分类数据
  void getCategoryList() {
    API.getCategoryList((List<Category> categories,String msg){
      setState(() {
        this.categoryList = categories;
      });
      debugPrint(msg);
    }, (String msg){
      debugPrint(msg);
    });
  }

  // 请求菜广告栏数据
  void getBannerList() {
    API.getBannerList((List<BannerBean> banners,String msg){
      setState(() {
        this.bannerList = banners;
      });
      debugPrint(msg);
    }, (String msg){
      debugPrint(msg);
    });
  }

  @override
  void initState() {
    getMenuList();
    //getCategoryList();
    //getBannerList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          itemCount: menuList.length,
        )
      )
    );
  }

  Widget _widgetList(BuildContext context, int index){

    return Row(
      children: <Widget>[
        Text('第${index}行'),
        // DropdownButton<String>(
        //   items: types.map((type) {
        //     return DropdownMenuItem<String>(
        //       child: Text(
        //         type['name'],
        //         style: TextStyle(fontSize: 30),
        //       ),
        //       value: type['value'],
        //     );
        //   }).toList(),
        //   onChanged: (String v) {
        //     setState(() {
        //       _typeValue = v;
        //     });
        //   },
        //   value: _typeValue = menuList[index]?.type ?? _typeValue,
        //   iconSize: 50,
        // ),
        // DropdownButton<String>(
        //   items: types.map((type) {
        //     return DropdownMenuItem<String>(
        //       child: Text(
        //         type['name'],
        //         style: TextStyle(fontSize: 30),
        //       ),
        //       value: type['value'],
        //     );
        //   }).toList(),
        //   onChanged: (String category) {
        //     setState(() {
        //       _typeValue = category;
        //     });
        //   },
        //   value: _typeValue,
        //   iconSize: 50,
        // ),
      ],
    );

  }

}