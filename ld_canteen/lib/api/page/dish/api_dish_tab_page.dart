import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/page/dish/api_dish_list_page.dart';
import 'package:ld_canteen/model/category.dart';

class ApiDishTabBarPage extends StatefulWidget {
  @override
  _ApiDishTabBarPageState createState() => _ApiDishTabBarPageState();
}

class _ApiDishTabBarPageState extends State<ApiDishTabBarPage> {

  List<Category> categories = [];

  // 请求菜品分类数据
  void getCategoryList() {
    
    API.getCategoryList((List<Category> categories,String msg){

      setState(() {
        this.categories = categories;
      });

      debugPrint(msg);

    }, (String msg){

      debugPrint(msg);

    });
  }
  
  @override
  void initState() {
    getCategoryList();
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
        title: Text('菜品管理')
      ),
      body: DefaultTabController(
        length: categories.length,
        child: Scaffold(
          appBar: TabBar(
            tabs: categories.map((category){
              return SizedBox(height: 40,child: Center(child: Text('${category.name}',style: TextStyle(color: Colors.black),)));
            }).toList(),
            
          ),
          body: TabBarView(
            children:categories.map((category){
              // return Container(color: Colors.redAccent,child: Center(child: Text('${category.name}',style: TextStyle(color: Colors.black),)));
              return ApiDishListPage(categoryId: category.objectId);
            }).toList(),
          ),
        ),
      )
    );
  }
}