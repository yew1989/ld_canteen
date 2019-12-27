import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/model/banner.dart';
import 'package:ld_canteen/model/category.dart';
import 'package:ld_canteen/model/menu.dart';

class MenuShowPage extends StatefulWidget {
  final Menu menu;
  const MenuShowPage({Key key, this.menu}) : super(key : key);
  @override
  _MenuShowPageState createState() => _MenuShowPageState();
}

class _MenuShowPageState extends State<MenuShowPage> {

  //选取分类
  var types = [{'name':'选择展示框内容分类','value':'xxxx'},{'name':'菜品类型','value':'category'},{'name':'广告图片','value':'banner'}];

  String _typeValue = 'xxxx';


  List<Category> categoryList = [];
  List<BannerBean> bannerList = [];
  Menu menu;
  String change = '';

  
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
    menu = widget?.menu ?? null ;
    change = widget?.menu?.type ?? '';
    getCategoryList();
    getBannerList();
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
        title: Text('编辑'),
      ),
      
      body:Column(
        children: <Widget>[
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
                      _typeValue = v;
                      change = v;
                    });
                  },
                  value: _typeValue = menu?.type ?? _typeValue,
                  iconSize: 50,
                ),
              ),
              Expanded(
                flex: 1,
                child: _widget(change),
              )
            ],
          ),
        ],
      )
    );
  }

  Widget _widget(String v){
    var items;
    if (v == 'category') {
      items = categoryList;
      return DropdownButton<String>(
      items: items.map((type) {
        return DropdownMenuItem<String>(
          child: Text(
            type['name'],
            style: TextStyle(fontSize: 30),
          ),
          value: type['objectId'],
        );
      }).toList(),
      onChanged: (String v) {
        setState(() {
          menu.type = v;
        });
      },
      value: menu.type == 'category' ? menu.category.objectId : menu.banner.objectId ,
      iconSize: 50,
    );
    }else if (v == 'banner') {
      items = bannerList;
      return DropdownButton<String>(
      items: items.map((type) {
        return DropdownMenuItem<String>(
          child: Text(
            type['name'],
            style: TextStyle(fontSize: 30),
          ),
          value: type['objectId'],
        );
      }).toList(),
      onChanged: (String v) {
        setState(() {
          menu.type = v;
        });
      },
      value: menu.type == 'category' ? menu.category.objectId : menu.banner.objectId ,
      iconSize: 50,
    );
    }

    

  }
  
}