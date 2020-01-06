import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/model/dish.dart';
import 'package:ld_canteen/page/static_style.dart';

class MenuListPage extends StatefulWidget {
  final String categoryObjectId;
  final int limit;
  const MenuListPage({Key key, this.categoryObjectId,this.limit}) : super(key : key);
  @override
  _MenuListPageState createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {

  List<Dish> dishList = [];
  String categoryObjectId;

  @override
  void initState() {
    categoryObjectId = widget?.categoryObjectId;
    getDishList(categoryObjectId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int limit = widget?.limit ?? 8;
    int pageNum = (dishList.length + limit -1)~/limit;
    if (dishList != null) {
      return Swiper(
        itemCount: pageNum,
        itemBuilder: (BuildContext context, int index) {
          List<Dish> list = dishList.sublist(index*limit , (index+1)*limit < dishList.length ? index*limit : dishList.length);
          return ListView.builder(
            
            itemBuilder: (BuildContext context, int index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Expanded(
                    flex: 1,
                    child: Center(child: Text('${list[index].name}',style: TextStyle(fontSize: 40))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(child: Text('${list[index].price}',style: TextStyle(fontSize: 40))),
                  ),
                ]
              );
            },
            itemCount: list.length,
          );
        },
        autoplay: true,
        autoplayDelay: 5000,
      );
    }
  }
  
  void getDishList(String categoryObjectId) {
    
    API.getDishList((List<Dish> dishes,String msg){
      this.dishList = dishes;
      debugPrint(msg);
    }, (String msg){
      debugPrint(msg);
    },objectId: categoryObjectId//order: 'sort',//limit:limit,skip:skip
    );
  }
}
