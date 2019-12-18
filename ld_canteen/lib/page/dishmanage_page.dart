import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/model/category.dart';
import 'package:ld_canteen/model/dish.dart';
import 'package:ld_canteen/page/dishmanage/dish_list_page.dart';
import 'package:ld_canteen/page/main.dart';
import 'package:ld_canteen/page/updatedishpage.dart';
import 'package:ld_canteen/page/dart.dart';

class DishManagePage extends StatefulWidget {
  @override
  _DishManagePageState createState() => _DishManagePageState();
}

class _DishManagePageState extends State<DishManagePage> with SingleTickerProviderStateMixin{

  List<Dish> dishList = [];
  List<Category> categoryList = [];

  // 请求菜品数据
  void getDishList() {
    
    API.getDishList((List<Dish> dishes,String msg){

      setState(() {
        this.dishList = dishes;
      });

      debugPrint(msg);

    }, (String msg){

      debugPrint(msg);

    },order: 'sort',//limit:limit,skip:skip
    );
  }

  // 请求菜品分类数据
  void getCategoryList() {
    
    API.getCategoryList((List<Category> categories,String msg){

      setState(() {
        this.categoryList = categories;
      });
      debugPrint(categoryList.length.toString());
      debugPrint(msg);

    }, (String msg){

      debugPrint(msg);

    });
  }
  
  // 删除菜品
  void deleteDish(Dish dish) {

    // 删除分类
    API.deleteDish(dish.objectId, (String msg){

      debugPrint(msg);
      // 刷新列表
      getDishList();

    }, (String msg) {

      debugPrint(msg);

    });
  }

  @override
  void initState() {
    getCategoryList();
    getDishList();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: Scaffold(
        appBar: new AppBar(
          title: Text('菜品管理'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_box,size: 30),
              onPressed: () {

              }
            )
          ],
        ),
      body: DefaultTabController(
        length: categoryList.length,
        
        child: new Scaffold(
          backgroundColor: Colors.blue,
          appBar:
          new TabBar(
            indicatorColor: Colors.white,
            tabs: categoryList.map((Category category){
              return Container(child: new Tab(child: Text('${category.name}',style: TextStyle(color: Colors.white))));
            }).toList(),
            isScrollable: true,
          ),
          body:
          new TabBarView(
            children: categoryList.map((Category category){
              return new DishListPage(dishList:this.dishList);
              //return Container(color: Colors.blueAccent,child: Text('${category.name}'),);
            }).toList(),
          )
        ), 
      ),
    ),
    );
  }


  @override
    void dispose() {
        super.dispose();
  }
}
