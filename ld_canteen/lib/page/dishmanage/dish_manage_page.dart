import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/api/component/public_tool.dart';
import 'package:ld_canteen/model/category.dart';
import 'package:ld_canteen/page/dishmanage/dish_edit_page.dart';
import 'package:ld_canteen/page/dishmanage/dish_list_page.dart';


class DishManagePage extends StatefulWidget {
  @override
  _DishManagePageState createState() => _DishManagePageState();
}

class _DishManagePageState extends State<DishManagePage> with SingleTickerProviderStateMixin{

  //List<Dish> dishList = [];
  List<Category> categoryList = [];

  

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
  
  
  @override
  void initState() {
    getCategoryList();
    EventBus().on('REFRESH', (_) {
      getCategoryList();
    });
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: Scaffold(
        appBar: new AppBar(
          title: Text('菜品管理',style: TextStyle(fontSize: 30),),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_box,size: 30),
              onPressed: () {
                pushToPage(context, DishEditPage());
              }
            )
          ],
        ),
      body: DefaultTabController(
        length: categoryList.length,
        
        child: new Scaffold(
          backgroundColor: Colors.white,
          appBar:
          new TabBar(
            indicatorColor: Colors.blue,
            tabs: categoryList.map((Category category){
              return Container(
                padding: EdgeInsets.fromLTRB(20.0,0.0,20.0,0.0),
                child: new Tab(
                  child: Text('${category.name}',style: TextStyle(color: Colors.black,fontSize: 20))
                )
              );
            }).toList(),
            isScrollable: true,
          ),
          body:
          new TabBarView(
            children: categoryList.map((Category category){
              return new DishListPage(categoryObjectId:category.objectId);
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
