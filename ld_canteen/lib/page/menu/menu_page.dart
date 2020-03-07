import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/model/menu.dart';
import 'package:ld_canteen/page/menu/menu_list_page.dart';


class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  DateTime date;
  String weekday = '';
  List<Menu> menuList = [];
  bool lastPage = false;

  final List<Color> listColor = [
      Color.fromRGBO(252, 86, 9, 1.0),
      Color.fromRGBO(16, 123, 229, 1.0),
      Color.fromRGBO(26, 193, 65, 1.0),
      Color.fromRGBO(47, 29, 27, 1.0),
      Color.fromRGBO(40, 44, 49, 1.0),
      Color.fromRGBO(252, 86, 9, 1.0),];

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    date = DateTime.now();
    weekday = _numToText(date.weekday);
    getMenuList(6, 0); //limit=6,skip=0
    print(date);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
    ]);
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
    //final gridHeight = (areaHeight - 3 * gap) / 2;
    //final gridWidth  = gridHeight * 1.3;

    final deviceWidth = MediaQuery.of(context).size.width;
    final statusWidth = MediaQuery.of(context).padding.left;
    final areaWidth = deviceWidth - statusWidth;
    final gridWidth = (areaWidth - gap) / 3;
    final gridHeight = gridWidth * 0.6;

    return Container(
      decoration: BoxDecoration(
        image:DecorationImage(
          image: AssetImage('images/bg2.jpg'),
          fit: BoxFit.cover,
        )
      ),
      child:Column(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(height: gridHeight,width: gridWidth,child:_cardList()[3]),
              Container(height: gridHeight,width: gridWidth,child:_cardList()[4]),
              Container(height: gridHeight,width: gridWidth,child:_cardList()[5]),
            ],
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image:DecorationImage(
          image: AssetImage('images/bg2.jpg'),
          fit: BoxFit.cover,
        )
      ),
      child:Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            title: Text('今日菜单', style: TextStyle(fontSize: 20)),
            actions: <Widget>[
              Text(
                '${date.year}年${date.month}月${date.day}日  星期' + weekday,
                style: TextStyle(fontSize: 15),
              )
            ],
            backgroundColor: Color.fromRGBO(40, 44, 49, 1.0),
            centerTitle: true,
          ),
          preferredSize: Size.fromHeight(40.0),
        ),
        body: girdView(context),
      )
    );
  }

  //卡片框内容
  List<Widget> _cardList() {
    List<Widget> list = [];
    menuList.map((menu) {
      if (menu.type == 'category') {
        Widget _c = Card(
          color: Colors.greenAccent,
            child: Scaffold(
              appBar: PreferredSize(
                child: AppBar(
                  centerTitle: true,
                  title: Text(menu?.category?.name ?? '',style: TextStyle(fontSize: 15),),
                  automaticallyImplyLeading: false,
                  backgroundColor: listColor[menu.sort-1],
                ),
                preferredSize: Size.fromHeight(30.0),
              ),
              body: MenuListPage(categoryObjectId: menu.category.objectId, limit: 4),
              // body: Container(color:Colors.indigoAccent),
            ),
        );
        list.add(_c);
      } else if (menu.type == 'banner') {
        if(menu.banner?.images?.length != null || menu.banner?.images?.length != 0){
          var length = menu?.banner?.images?.length;
          Widget _b = Card(
            child: Container(
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  if (menu?.banner?.images != null) {
                    return Image(
                      image: NetworkImage(menu?.banner?.images[index]),
                      fit: BoxFit.cover,
                    );
                  }
                },
                itemCount:menu?.banner?.images == null ? 0 : menu.banner.images.length,
                autoplay: true,
                autoplayDelay: 5000,
              ),
            ),
          );
          list.add(_b);
        }else{
          Widget _b = Card();
          list.add(_b);
        }
      }else{
        Widget _c = Card();
        list.add(_c);
      }
    }).toList();

    return list;
  }
}
