import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/edit_delete_button.dart';
import 'package:ld_canteen/model/category.dart';

class ApiCategoryPage extends StatefulWidget {
  @override
  _ApiCategoryPageState createState() => _ApiCategoryPageState();
}

class _ApiCategoryPageState extends State<ApiCategoryPage> {

  
  List<Category> categories = [];

  @override
  void initState() {
    requestFirstPage();
    super.initState();
  }

  // 请求菜品分类数据
  void requestFirstPage() {
    
    API.getCategoryList((List<Category> categories,String msg){
      
      setState(() {
        this.categories = categories;
      });

    }, (String msg){

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('菜品分类管理'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){},
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
              child: EditAndDeleteButton(),
            )
          ],
        ),
      ),
    );
  }
}

