import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/model/dish.dart';
import 'package:ld_canteen/model/menu.dart';
import 'package:ld_canteen/page/menu/menu_list_page.dart';

import '../static_style.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  DateTime date;
  String weekday = '';
  List<Menu> menuList = [];
  PageController _pageController = PageController(initialPage: 1);
  ScrollController _scrollController = new ScrollController();
  AnimationController _animationController;
  int _curIndex = 1;
  Timer _timer;
  bool lastPage = false;

  @override
  void initState() {
    date = DateTime.now();
    weekday = _numToText(date.weekday);
    getMenuList(6, 0); //limit=6,skip=0
    print(date);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //星期  数字转汉字
  String _numToText(int i) {
    switch (i) {
      case 1:
        return '一';
        break;
      case 2:
        return '二';
        break;
      case 3:
        return '三';
        break;
      case 4:
        return '四';
        break;
      case 5:
        return '五';
        break;
      case 6:
        return '六';
        break;
      case 7:
        return '日';
        break;
    }
  }

  // 请求展示列表数据
  void getMenuList(int limit, int skip) {
    API.getMenuList((List<Menu> menus, String msg) {
      setState(() {
        this.menuList = menus;
      });
      debugPrint(msg);
    }, (String msg) {
      debugPrint(msg);
    }, limit: limit, skip: skip);
  }

  Widget girdView(BuildContext context) {
    if(_cardList().length < 6) return Container(child: Center(child: Text('菜单栏个数不满6个')));

    final deviceHeight = MediaQuery.of(context).size.height;
    final statusHeight = MediaQuery.of(context).padding.top;
    final navBarHeight = kToolbarHeight;
    final areaHeight = deviceHeight - statusHeight - navBarHeight;
    final gap = 10.0;
    final gridHeight = (areaHeight - 3 * gap) / 2;
    final gridWidth  = gridHeight * 1.3;

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(height: gridHeight,width: gridWidth,child:_cardList()[0]),
              Container(height: gridHeight,width: gridWidth,child:_cardList()[1]),
              Container(height: gridHeight,width: gridWidth,child:_cardList()[2]),
            ],
          ),
         Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(height: gridHeight,width: gridWidth,child:_cardList()[3]),
              Container(height: gridHeight,width: gridWidth,child:_cardList()[4]),
              Container(height: gridHeight,width: gridWidth,child:_cardList()[5]),
            ],
          ),
        ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('今日菜单', style: TextStyle(fontSize: 30)),
        actions: <Widget>[
          Text(
            '${date.year}年${date.month}月${date.day}日  星期' + weekday,
            style: TextStyle(fontSize: 25),
          )
        ],
      ),
      body: girdView(context),
    );
  }

  List<Widget> _cardList() {
    List<Widget> list = [];
    menuList.map((menu) {
      if (menu.type == 'category') {
        Widget _c = Card(
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                  title: Text(menu.category.name),
                  automaticallyImplyLeading: false),
              body: MenuListPage(
                  categoryObjectId: menu.category.objectId, limit: 8),
            ),
          ),
        );
        list.add(_c);
      } else if (menu.type == 'banner') {
        var length = menu.banner.images.length;
        Widget _b = Card(
          child: Container(
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                if (menu.banner.images != null) {
                  return Image(
                    image: NetworkImage(menu.banner.images[index]),
                    fit: BoxFit.cover,
                  );
                }
              },
              itemCount:
                  menu.banner.images == null ? 0 : menu.banner.images.length,
              autoplay: true,
              autoplayDelay: 5000,
            ),
          ),
        );
        list.add(_b);
      }
    }).toList();

    return list;
  }
}
