import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/model/banner.dart';
import 'package:ld_canteen/model/category.dart';
import 'package:ld_canteen/model/menu.dart';
import 'package:ld_canteen/page/dishmanage/dish_list_page.dart';

class MenuShowPage extends StatefulWidget {
  final Menu menu;
  const MenuShowPage({Key key, this.menu}) : super(key : key);
  @override
  _MenuShowPageState createState() => _MenuShowPageState();
}

class _MenuShowPageState extends State<MenuShowPage> {

  //选取分类
  var types = [{'name':'选择展示框内容分类','value':'xxxx'},{'name':'菜品类型','value':'category'},{'name':'广告图片','value':'banner'}];

  //String _typeValue = 'xxxx';

  //List<Menu> menuList = [];
  List<Category> categoryList = [];
  List<BannerBean> bannerList = [];
  Menu menu;
  String change = '';
  Category _category = new Category(name: '选择菜品类型',objectId: '1111');
  BannerBean _bannerBean = new BannerBean(name: '选择广告',objectId: '2222');
  String _categoryChange = '';
  String _bannerBeanChange = '';
  
  // 请求菜品分类数据
  void getCategoryList() {
    API.getCategoryList((List<Category> categories,String msg){
      setState(() {
        this.categoryList = categories;
        this.categoryList.insert(0, _category);
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
        this.bannerList.insert(0, _bannerBean);
      });
      debugPrint(msg);
    }, (String msg){
      debugPrint(msg);
    });
  }

  @override
  void initState() {
    this.menu = widget?.menu ?? null ;
    change = widget?.menu?.type ?? '';
    _categoryChange = this.menu.category?.objectId ?? _category.objectId ;
    _bannerBeanChange = this.menu.banner?.objectId ?? _bannerBean.objectId  ;
    getCategoryList();
    getBannerList();
    EventBus().on('REFRESH', (_) {
      _page(change,_categoryChange);
    });
    super.initState();
  }

  @override
  void dispose() {
    EventBus().off('REFRESH');
    super.dispose();
  }

  //更新展览框
  void updateMenu(String categoryId,String bannerId,Menu menu,String type){
    if (type == 'category') {
      API.updateMenu(
        menu.objectId,
        menu,
        (_, msg) {
          Navigator.of(context).pop();
          // 发送刷新通知
          EventBus().emit('REFRESH');
        },
        (_) {},categoryId:categoryId
      );
    }else if (type == 'banner') {
      API.updateMenu(
        menu.objectId,
        menu,
        (_, msg) {
          Navigator.of(context).pop();
          // 发送刷新通知
          EventBus().emit('REFRESH');
        },
        (_) {},bannerId:bannerId
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑'),
      ),
      
      body:Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(15),),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: DropdownButton<String>(
                  items: types.map((type) {
                    return DropdownMenuItem<String>(
                      child: Text(
                        type['name'],
                        style: TextStyle(fontSize: 30),
                      ),
                      value: type['value'],
                    );
                  }).toList(),
                  onChanged: (String v) {
                    setState(() {
                      change = v;
                      _page(change,_categoryChange);
                      // _categoryChange = this.menu.category ?? _category ;
                      // _bannerBeanChange = this.menu.banner ?? _bannerBean  ;
                    });
                  },
                  value: change ,
                  iconSize: 50,
                ),
              ),
              Expanded(
                flex: 1,
                child: _dropdownButton(),
              ),
            ],
          ),
          Expanded(
            flex: 1,
            child: _page(change,_categoryChange),
            //DishListPage(categoryObjectId:_categoryChange),
          )
          
        ],
      ),
       bottomNavigationBar: ButtonBar(
        children: <Widget>[
          
          FlatButton(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Text('确定',
                  style: TextStyle(color: Colors.white, fontSize: 40)),
              color: Colors.blueAccent,
              onPressed: (){
                updateMenu(_categoryChange,_bannerBeanChange,menu,change);
              }
          ),
          Padding(padding: EdgeInsets.all(20),),
        ],
      ),
    );
  }

  Widget _dropdownButton(){
    
    if (change == 'category') {
      
      return DropdownButton<String>(
        items: categoryList.map((category) {
          return DropdownMenuItem<String>(
            child: Text(
              category.name,
              style: TextStyle(fontSize: 30),
            ),
            value: category.objectId,
          );
        }).toList(),
        onChanged: (String v) {
          setState(() {
            _categoryChange= v;
            EventBus().emit('REFRESH_CATEGORYID',_categoryChange);
          });
        },
        value: _categoryChange,
        iconSize: 50,
      );
    }
    else if (change == 'banner') {
      return DropdownButton<String>(
        items: bannerList.map((BannerBean banner) {
          return DropdownMenuItem<String>(
            child: Text(
              banner.name,
              style: TextStyle(fontSize: 30),
            ),
            value: banner.objectId,
          );
        }).toList(),
        onChanged: (String v) {
          setState(() {
            _bannerBeanChange = v;
            //EventBus().emit('REFRESH_CATEGORYID',_bannerBeanChange);
          });
        },
        value: _bannerBeanChange ,
        iconSize: 50,
      );
    }else{
      return null;
    }
  }
  
  Widget _page(String change,String categoryObjectId){
   
      if (change == 'category') {
        return DishListPage(categoryObjectId:_categoryChange);
      }else if (change == 'banner') {
        
      }else{
        return Column();
      }

  }
  
}