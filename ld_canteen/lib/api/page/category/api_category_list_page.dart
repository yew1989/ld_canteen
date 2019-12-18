import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/edit_delete_button.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/api/component/public_tool.dart';
import 'package:ld_canteen/api/page/category/api_category_edit_page.dart';
import 'package:ld_canteen/model/category.dart';

class ApiCategoryListPage extends StatefulWidget {
  @override
  _ApiCategoryListPageState createState() => _ApiCategoryListPageState();
}

class _ApiCategoryListPageState extends State<ApiCategoryListPage> {

  
  List<Category> categories = [];

  @override
  void initState() {
    getCategoryList();
    // 监听 ‘REFRESH’ 刷新页面通知
    EventBus().on('REFRESH', (_){
      getCategoryList();
    });
    super.initState();
  }

  @override
  void dispose() {
    // 取消监听 ‘REFRESH’ 刷新页面通知
    EventBus().off('REFRESH');
    super.dispose();
  }

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

  // 删除菜品
  void deleteCategoryAndDishes(Category category) {
    
    // 先删除该菜品分类下的所有菜
    API.deleteDishesByCategoryId(category.objectId, (_){
      
      deleteCategory(category);

    }, (_){});


  }

  // 删除分类
  void deleteCategory(Category category) {
        // 删除分类
    API.deleteCategory(category.objectId, (String msg){

      debugPrint(msg);
      // 刷新列表
      getCategoryList();

    }, (String msg) {

      debugPrint(msg);

    });
  }

  // void 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('菜品分类管理'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              pushToPage(context, ApiCategoryEditPage());
            },
          )
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: categories?.length ?? 0,
          itemBuilder: (BuildContext context,int index) => categoryTile(context,index),
        )
      ),
    );
  }

  Widget categoryTile(BuildContext context,int index) {
    
    var category  = categories[index];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1,horizontal: 2),
      height: 60,
      // color: Colors.white,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Expanded(
              flex: 3,
              child: Center(child: Text('${category.name}',style: TextStyle(color: Colors.black,fontSize: 20))),
            ),
            Expanded(
              flex: 1,
              child: EditAndDeleteButton(
              // 删除菜品
              onDeletePressed: (){
                deleteCategoryAndDishes(category);
              },
              // 编辑菜品
              onEditPressed: (){
                pushToPage(context, ApiCategoryEditPage(category: category));
              }),
            )
          ],
        ),
      ),
    );
  }
}

