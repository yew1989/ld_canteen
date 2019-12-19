import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/edit_delete_button.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/api/component/public_tool.dart';
import 'package:ld_canteen/model/category.dart';
import 'package:ld_canteen/page/categorymanage/category_edit_page.dart';

class CategroyManagePage extends StatefulWidget {
  @override
  _CategroyManagePageState createState() => _CategroyManagePageState();
}

class _CategroyManagePageState extends State<CategroyManagePage> {

  List<Category> categoryList = [];
  
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
  
  
  @override
  void initState() {
    getCategoryList();
    EventBus().on('REFRESH', (_) {
      getCategoryList();
    });
    super.initState();
    
  }

  int  _getListCount(){
    int dishListCount = categoryList?.length ?? 0;
    return dishListCount + 1;
  }  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: new AppBar(
          title: Text('菜品分类管理',style: TextStyle(fontSize: 30),),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_box,size: 30),
              onPressed: () {
                pushToPage(context, CategoryEditPage());
              }
            )
          ],
        ),
        body: Container(
          child: ListView.builder(
            itemCount: _getListCount(),
            itemBuilder: (BuildContext context,int index) => categoryTile(context,index),
          ),
        ),
      ),
    );
  }

  Widget categoryTile(BuildContext context,int index) {
    
    if (index == 0) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 1,horizontal: 2),
        height: 60,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Expanded(
                flex: 3,
                child: Center(child: Text('菜品类型名称',style: TextStyle(color: Colors.black,fontSize: 20))),
              ),
              Expanded(
                flex: 1,
                child: Center(child: Text('操作',style: TextStyle(color: Colors.black,fontSize: 20))),
              ),
            ],
          ),
        ),
      );
    } else {
      var category  = categoryList[index-1];
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
                // 删除菜品分类
                onDeletePressed: (){
                  deleteCategoryAndDishes(category);
                },
                // 编辑菜品分类
                onEditPressed: (){
                  pushToPage(context, CategoryEditPage(category: category));
                }),
              )
            ],
          ),
        ),
      );
    }
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

}